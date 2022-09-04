require 'simplify/core/extension/table.lua'

local EventManager = require 'simplify/core/events/eventmanager.lua'
local Events = require 'simplify/core/events/events.lua'

local CommandChannels = {
	Server = {},
	Client = {},
}

-- Internal tables for processing
local tServerMods = {}
local tClientMods = {}

--CommandChannels.Server[strModID][strCommand] = function(oPlayer, tArgs)

-- Server / Client Table
local function serverIndex(t, k)
	if (not tServerMods[k]) then tServerMods[k] = {} end
	return tServerMods[k]
end

local function serverNewIndex(t, k, v)
	tServerMods[k] = v
end

local function clientIndex(t, k)
	if (not tClientMods[k]) then
		tClientMods[k] = {}
	end
	return tClientMods[k]
end

local function clientNewIndex(t, k, v)
	tClientMods[k] = v
end

do
	setmetatable(CommandChannels.Server, {
		__metatable = "simplify server command channel table",
		__index = serverIndex,
		__newindex = serverNewIndex,
		__simplify = simplifyMetatable(),
	})
	
	setmetatable(CommandChannels.Client, {
		__metatable = "simplify client command channel table",
		__index = clientIndex,
		__newindex = clientNewIndex,
		__simplify = simplifyMetatable(),
	})
end

Events.OnClientCommand = function(module, command, player, args)
	if (not tServerMods[module]) then return end
	
	if (tServerMods[module][command]) then
		tServerMods[module][command](player, args)
	else
		tServerMods[module]["default"](command, player, args)
	end
end

Events.OnServerCommand = function(module, command, args)
	if (not tClientMods[module]) then return end
	
	if (tClientMods[module][command]) then
		tClientMods[module][command](args)
	else
		tClientMods[module]["default"](command, args)
	end
end

return table.freeze(CommandChannels)