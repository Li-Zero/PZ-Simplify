--[[
**
** CSV
** - Provides utilities to read / write csv files.
**
--]]

require 'simplify/core/extension/table.lua'
require 'simplify/core/extension/string.lua'

local Exceptions = require 'simplify/core/exceptions'
local RunTimeException = Exceptions.RunTimeException
local IllegalArgumentException = Exceptions.IllegalArgumentException
local File = require 'simplify/core/io/file.lua'

local CSV = {}

local function parseCSVLine(strLine, strSeparator)
	strSeparator = strSeparator or ','
	if (not strLine) then
		return nil
	end
	
	local iPos = 1
	local c = string.sub(strLine, iPos, iPos)
	if (string.sub(strLine, 1, 1) == "") then
		return nil
	end
	
	strSeparator = strSeparator or ','
	local t = {}
	while true do
		c = string.sub(strLine, iPos, iPos)
		if (c == "") then break end
		if (c == '"') then
			local strVal = ""
			repeat
				local iStartPos, iEndPos = string.find(strLine, '^%b""', iPos)
				strVal = strVal .. string.sub(strLine, iStartPos+1, iEndPos-1)
				iPos = iEndPos + 1
				c = string.sub(strLine, iPos, iPos)
				if (c == '"') then strVal = strVal .. '"' end
			until (c ~= '"')
			table.insert(t, strVal)
			iPos = iPos + 1
		else
			local iStartPos, iEndPos = string.find(strLine, strSeparator, iPos)
			if (iStartPos) then
				table.insert(t,string.sub(strLine, iPos,iStartPos-1))
				iPos = iEndPos + 1
			else
				table.insert(t,string.sub(strLine, iPos))
				break
			end
		end
	end
	return t
end

local function parseValues(tValues, strSeparator)
	strSeparator = strSeparator or ','
	local strLine = ""
	for i=1, #tValues do
		local strVal = ""
		local bQuote = false
		local iStartPos = tValues[i]:find('"', 1)
		if (iStartPos) then
			local bCloseQuote = false
			repeat
				iStartPos = tValues[i]:find('"', iStartPos)
				bCloseQuote = not bCloseQuote
			until (not iStartPos)
			if (not bCloseQuote) then
				RunTimeException:throw(string.format("CSV#parseValues - Quoted value is not enclosed. Value: %s", tValues[i]))
			end
			bQuote = true
			strVal = tValues[i]:gsub('(")', '""')
		else
			if (tValues[i]:find(strSeparator, 1)) then bQuote = true end
			strVal = strVal .. tValues[i]	
		end
		if (bQuote) then strVal = '"' .. strVal .. '"' end
		strLine = strLine .. strVal
		if (i < #tValues) then strLine = strLine .. strSeparator end
	end
	return strLine
end

--[[
**
** Function:
** string array readFile(strModId, strFilePath, strSeparator = ";")
** - Read a csv file and returns array consisting of parsed 'CSV' values.
** - The csv lines should be parsed into data.
** - Line starting with '--' will be treated as comment line and ignored.
**
** Parameters:
** strModId - Mod id.
** strFilePath - CSV filepath.
** strSeparator - CSV separator. Default is ";"
**
** Returns:
** Array of 'CSV' values. Each array index contains array of values separated by provided separator.
**
--]]
CSV.readFile = function(strModID, strFilePath, strSeparator, bHeader)
	bHeader = bHeader or false
	
	if (strFilePath == nil) then
		IllegalArgumentException:throw("CSV#readFile - Argument 'strFilePath' is nil.")
	elseif (type(strFilePath) ~= "string") then
		IllegalArgumentException:throw("CSV#readFile - Argument 'strFilePath' is not a string type.")
	end
	
	local file = File.getModFileReader(strModID, strFilePath)
	if (not file) then
		RunTimeException:throw(string.format("CSV#readFile - File not found! Path: '%s'", strFilePath))
	end
	
	strSeparator = strSeparator or ","
	
	local t = {}
	local strLine = file:readLine()
	while strLine do
		if (not strLine:simplifyStartsWith("--")) then
			if (bHeader and not t.header) then
				t.header = parseCSVLine(strLine, strSeparator)
			else
				local values = parseCSVLine(strLine, strSeparator)
				table.insert(t, values)
			end
		end
		strLine = file:readLine()
	end
	file:close()
	return t;
end

--[[
**
** Function:
** void writeFile(strModId, strFilePath, bCreate, bAppend, strSeparator = ";")
** - Write CSV data into a csv file.
**
** Parameters:
** strModId - Mod id.
** strFilePath - CSV filepath.
** bCreate - Create file if it doesn't exists.
** bAppend - If true, the data will be added to the end of file.
** strSeparator - CSV separator. Default is ";"
**
--]]
CSV.writeFile = function(strModID, strFilePath, bCreate, bAppend, tArray, strSeparator, bHeader)
	if (strModID == nil) then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'strModId' is nil.")
	elseif (type(strModID) ~= "string") then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'strModId' is not a string type.")
	end
	
	if (strFilePath == nil) then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'strFilePath' is nil.")
	elseif (type(strFilePath) ~= "string") then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'strFilePath' is not a string type.")
	end
	
	if (bCreate == nil) then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'bCreate' is nil.")
	elseif (type(bCreate) ~= "boolean") then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'bCreate' is not a boolean type.")
	end
	
	if (bAppend == nil) then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'bAppend' is nil.")
	elseif (type(bAppend) ~= "boolean") then
		IllegalArgumentException:throw("CSV#writeFile - Argument 'bAppend' is not a boolean type.")
	end
	
	local file = File.getModFileWriter(strModID, strFilePath, bCreate, bAppend)
	if (not file) and (not bCreate) then
		RunTimeException:throw(string.format("CSV#writeFile - File not found! Path: '%s'", strFilePath))
	end
	
	strSeparator = strSeparator or ";"
	if (bHeader) then file:writeln(parseValues(tArray.header, strSeparator)) end
	for i=1, #tArray do
		local tValues = tArray[i]
		local strLine = ""
		strLine = parseValues(tValues, strSeparator)
		file:writeln(strLine)
	end
	file:close()
end

return table.freeze(CSV)