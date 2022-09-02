require 'simplify/core/extension/string.lua'

local Utils = require 'simplify/utils.lua'
local HashMap = require 'simplify/core/util/hashmap.lua'
local File = require 'simplify/core/io/file.lua'

local tActivatedMods = {}
local mapLoadedLua = HashMap.new()

local function getFileName(strFilePath)
	return strFilePath:gmatch("[^\/]*\.*[^\n]$")
end

local strMessage = "Simplify Require: "
local strErrorArgumentFormat = strMessage .. "Argument '%s' %s."
local function validateFilePath(strFilePath)
	if (strFilePath == nil) then
		error(string.format(strErrorArgumentFormat, "strFilePath", "is nil"))
	elseif (type(strFilePath) ~= "string") then
		error(string.format(strErrorArgumentFormat, "strFilePath", "is not a string type"))
	end
end

local function requireFile(strRequireFilePath, file)
	print(string.format("%sLoading '%s'", strMessage, strRequireFilePath))
	local strCode = File.getContent(file)
	local strFileName = getFileName(strRequireFilePath)
	print("File Name: " .. strFileName)
	local f, errorMessage = loadstring(strCode, strFileName)
	if (not f) then
		error(string.format("\n*****Error Message Start*****\n%s\n*****************************\n", errorMessage))
	end
	local v = f()
	mapLoadedLua:put(strRequireFilePath, v)
	return v
end

-- To improve the require further, we will look through cache/lua/server_world for lua files
local gRequire = _G.require
require = function(strRequireFilePath)
	validateFilePath(strRequireFilePath)
	
	if (not strRequireFilePath:simplifyEndsWith(".lua")) then
		strRequireFilePath = strRequireFilePath .. ".lua"
	end
	
	if (mapLoadedLua:containsKey(strRequireFilePath)) then
		return mapLoadedLua:get(strRequireFilePath)
	end
	
	-- Cache lua
	do
		local strFilePath = string.format("%s/%s", getServerName(), strRequireFilePath)
		local file = getFileInput(strFilePath)
		if (file) then
			return requireFile(strRequireFilePath, file)
		end
	end
	
	-- Activated mods
	do
		local mods = getActivatedMods()
		-- Cache
		if (mods:size() ~= #tActivatedMods) then
			tActivatedMods = Utils.convertJavaArray(mods)
		end
		for i=1, #tActivatedMods do
			local strModID = tActivatedMods[i]
			local file = File.getModFileReader(strModID, strRequireFilePath)
			if (file) then
				return requireFile(strRequireFilePath, file)
			end
		end
	end
	
	-- Default require
	return gRequire(strRequireFilePath)
end