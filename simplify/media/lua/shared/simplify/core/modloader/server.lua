local isClientMainMenu = false
if (not isClient() and not isServer()) then
	-- Main menu
	isClientMainMenu = true
end
if (not isClientMainMenu and (not isServer() or isClient())) then
	return
end

local Utils = require 'simplify/utils.lua'
local File = require 'simplify/core/io/file.lua'

local strMessage = "Simplify Mod Loader: "

local function loadFile(strModID, file)
	print(string.format("%sLoading '%s'", strMessage, strModID))
	local strCode = File.getContent(file)
	local f, errorMessage = loadstring(strCode)
	if (not f) then
		error(string.format("\n*****Error Message Start*****\n%s\n*****************************\n", errorMessage))
	end
	return f()
end

-- Grab all activated mods' loader info
do
	-- One time execution
	local mods = getActivatedMods()
	local tActivatedMods = Utils.convertJavaArray(mods)
	for i=1, #tActivatedMods do
		local strModID = tActivatedMods[i]
		local file = File.getModFileReader(strModID, "loader.lua")
		if (file) then
			local loaderInfo = loadFile(strModID, file)
			assert(loaderInfo.branch, "Missing field 'branch'")
			if loaderInfo.sharedRequire then
			
			end
			if loaderInfo.serverRequire then
			
			end
			if loaderInfo.clientRequire then
			
			end
		end
	end
end