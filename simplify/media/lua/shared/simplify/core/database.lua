local File = require 'simplify/core/io/file.lua'

local Database = {}
Database.Tables = {}
local Tables = Database.Tables
Tables.players = {
	header = {
		"steamID",
		"username",
		"privileges"
	}
}

Database.create = function()
	if (not Database.isTableExists("players")) then
		--
	else
		-- Test read and check if there's a header
	end
end

Database.executeQuery = function(strQuery, tTable)
	
end

Database.createTable = function(strTableName)
	--local
end

Database.isTableExists = function(strTableName)
	local strFilePath = string.format("database/%s/%s.csv" ,getServerName(), strTableName)
	local file = File.getModFileReader(nil, strFilePath)
	if (not file) then
		return false
	else
		file:close()
		return true
	end
end

Database.getTableResult = function(strTable, iSize)
	--getTableResult(strTable, iSize)
	local dbResults = ServerWorldDatabase.instance:getTableResult(strTable)
end

local gameClient = getGameClient()

if (isServer() or not isClient()) then
	local function onGetTableResult(result, rowId, tableName)
		print("Database Debug")
		print("Row Id: " .. rowId)
		if	(result:size() > 0) then
			print("Table Columns")
			local columns = result:get(0):getColumns()
			for i=0, columns:size()-1 do
				print(string.format("Column %d: %s", i, columns:get(i)))
			end
			
			print("Table Result")
			for i=0, result:size()-1 do
				-- DBResult
				print("Row: " .. i+1)
				local dbResult = result:get(i)
				for idCol=0, columns:size()-1 do
					local value = dbResult:getValues():get(columns:get(idCol))
					print("Value: " .. value)
				end
			end
		end
	end
	Events.OnGetTableResult.Add(onGetTableResult)
end

return Database