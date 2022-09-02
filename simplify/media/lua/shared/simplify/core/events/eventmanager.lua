require 'simplify/core/extension/table.lua'

local EventManager = {}

local gEvents = Events
local Events = require 'simplify/core/events/events.lua'
local tEvents = Events.get()

local function validateType(oVal, strType)
	if(type(oVal) ~= strType) then
		error("Argument is not " .. strType .. " type.", 2)
	end
end

local function validateEvent(strEvent)
	if (not tEvents[strEvent]) then
		error("Event '" .. strEvent .. "' doesn't exists.")
	end
end

EventManager.addEvent = function(strEvent)
	validateType(strEvent, "string")
	Events.add(strEvent)
end

EventManager.triggerEvent = function(strEvent, ...)
	validateType(strEvent, "string")
	validateEvent(strEvent)
	for i=1, #tEvents[strEvent] do
		tEvents[strEvent][i](unpack({...}))
	end
end

--[[
**
** Base Event Hooks
**
--]]

EventManager.addEvent("OnClientCommand")
EventManager.addEvent("OnServerCommand")

if (not isClient() or isServer()) then
	--print("Simplify Event Manager: Server!")
	local function onClientCommand(module, command, player, args)
		if (not isServer()) then return end
		EventManager.triggerEvent("OnClientCommand", module, command, player, args)
	end
	gEvents.OnClientCommand.Add(onClientCommand)
elseif (not isServer() or isClient()) then
	--print("Simplify Event Manager: Client!")
	local function onServerCommand(module, command, args)
		if (not isClient()) then return end
		EventManager.triggerEvent("OnServerCommand", module, command, args)
	end
	gEvents.OnServerCommand.Add(onServerCommand)
end

return table.freeze(EventManager)