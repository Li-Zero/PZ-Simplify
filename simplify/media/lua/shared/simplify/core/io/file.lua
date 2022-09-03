--[[
**
** File
** - Provide utility functions for file reader and file writer.
**
--]]

require 'simplify/core/extension/table.lua'

local Exceptions = require 'simplify/core/exceptions.lua'
local IllegalArgumentException = Exceptions.IllegalArgumentException

local File = {}

--[[
**
** Function:
** BufferedReader getModFileReader(string strModId, string strPath)
** - Creates a file reader for mod file.
**
** Parameters:
** strModId - Mod id.
** strPath - Path of the mod file.
**
** Returns:
** 'BufferedReader' if mod file exists, otherwise 'nil'.
**
--]]
File.getModFileReader = function(strModID, strPath)
	if (strPath == nil) then
		IllegalArgumentException:throw("File#getModFileReader - Argument 'strPath' is nil.")
	elseif (type(strPath) ~= "string") then
		IllegalArgumentException:throw("File#getModFileReader - Argument 'strPath' is not a string type.")
	end
	
	return getModFileReader(strModID, strPath, false)
end

--[[
**
** Function:
** LuaFileWriter getModFileWriter(string strModId, string strPath, boolean bCreate, boolean bAppend)
** - Creates a file writer for mod file.
**
** Parameters:
** strModId - Mod id.
** strPath - Path of the mod file.
** bCreate - If true, creates a new file if the file doesn't exists.
** bAppend - If true, then string will be written to the end of file rather than the beginning.
**
** Returns:
** 'LuaFileWriter' if mod file exists, otherwise 'nil' if createFile is set to false.
**
--]]
File.getModFileWriter = function(strModID, strPath, bCreate, bAppend)
	if (strModID == nil) then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'strModId' is nil.")
	elseif (type(strModID) ~= "string") then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'strModId' is not a string type.")
	end
	
	if (strPath == nil) then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'strPath' is nil.")
	elseif (type(strPath) ~= "string") then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'strPath' is not a string type.")
	elseif (strPath:simplifyEndsWith(".lua")) then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'strPath' is lua file.")
	end
	
	if (bCreate == nil) then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'bCreate' is nil.")
	elseif (type(bCreate) ~= "boolean") then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'bCreate' is not a boolean type.")
	end
	
	if (bAppend == nil) then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'bAppend' is nil.")
	elseif (type(bAppend) ~= "boolean") then
		IllegalArgumentException:throw("File#getModFileWriter - Argument 'bAppend' is not a boolean type.")
	end
	
	local file = getModFileReader(strModID, strPath, false)
	if (not file) and (not bCreate) then
		return nil
	end
	return getModFileWriter(strModID, strPath, bCreate, bAppend)
end

File.getContent = function(fReader)
	local strLine = fReader:readLine()
	if (not strLine) then
		return nil
	end
	local strContent = ""
	repeat
		strContent = strContent .. strLine
		strLine = fReader:readLine()
		if (strLine) then
			strContent = strContent .. '\n'
		end
	until (not strLine)
	fReader:close()
	return strContent
end

File.readLines = function(fReader, func)
	local strLine = fReader:readLine()
	while strLine do
		func(strLine)
		strLine = fReader:readLine()
	end
	fReader:close()
end

return table.freeze(File)