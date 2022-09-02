require 'simplify/core/extension/table.lua'

local Utils = require 'simplify/utils.lua'

local Player = {}

-- Get current client player
Player.getPlayer = getPlayer

-- Get specific local coop players
-- Player 1 ~ 4 (Index 0~3)
Player.getCoopPlayer = function(playerNum)
	return getSpecificPlayer(playerNum)
end

-- Is current client player an admin
-- To-do: return player:isAccessLevel("admin")
Player.isAdmin = function(player)
	return player:isAccessLevel("admin")
end

-- Get all players
-- Player.getPlayers = getOnlinePlayers
-- Dictionary has been removed temporarily.
-- There's loss of information when converting from java to lua strings.
-- You might be able to decode the string into the utf8 string into key based on article provided below.
-- http://lua-users.org/wiki/LuaUnicode
Player.getPlayers = function()
	local jarr = getOnlinePlayers()
	local t = {}
	for i=0, jarr:size()-1 do
		t[i+1] = jarr:get(i)
	end
	return t
end

-- Get list of all factions
Player.getFactions = function()
	return Utils.convertJavaArray(Faction.getFactions())
end

-- Get player faction
Player.getFaction = function(player)
	return Faction.getPlayerFaction(player)
end

-- Get player faction members
-- Return list of faction member username list.
Player.getFactionMembers = function(faction)
	if faction then
		local jarr = faction:getPlayers()
		local t = {}
		t[1] = faction:getOwner()
		for i=0, jarr:size()-1 do
			t[i+2] = jarr:get(i)
		end
		return t
	else
		return nil
	end
end

-- Get player position
Player.getPosition = function(player)
	local vehicle = player:getVehicle()
	if vehicle then
		return { x = vehicle:getX(), y = vehicle:getY(), z = player:getZ() }
		-- return vehicle:getX(), vehicle:getY(), vehicle.getZ()
	else
		return { x = player:getX(), y = player:getY(), z = player:getZ() }
		-- return player:getX(), player:getY(), player.getZ()
	end
end

-- Get player pvp status
-- IsoGameCharacter:getSafety():isEnabled()
Player.isEnabledPVP = function(player)
	return (not (player:getSafety():isEnabled()))
end

-- Get player faction pvp status
-- IsoPlayer#getCoopPVP
-- Boolean
-- Not tested
Player.getFactionPVP = function(player)
	return player:isFactionPvp()
end

-- Get player spotted list
-- IsoPlayer#getSpottedList
-- Stack<IsoMovingObject> spottedList
-- Not tested
Player.getSpottedList = function(player)
	return Utils.convertJavaArray(player:getSpottedList())
end

-- Check if the client player can see the target player
Player.CanSee = function(targetPlayer)
	if not isClient() then return nil end
	local player = Player.getPlayer()
	if player then
		return Player.CanSee(player, targetPlayer)
	else
		return nil
	end
end

-- Check if the player can see the target player
Player.CanSee = function(player, targetPlayer)
	return (player ~= nil)
		and (targetPlayer ~= nil)
		and (player:getCurrentSquare() ~= nil)
		and (targetPlayer:getCurrentSquare() ~= nil)
		and (player:checkCanSeeClient(targetPlayer))
end

-- Get player multiplayer personal text color
Player.getSpeakColor = function(player)
	local color = player:getSpeakColour()
	return { r = color:getRedFloat(), g = color:getGreenFloat(), b = color:getBlueFloat(), a = color:getAlphaFloat() }
end

return table.freeze(Player)