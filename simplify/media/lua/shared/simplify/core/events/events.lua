require 'simplify/core/extension/metatable.lua'
require 'simplify/core/extension/table.lua'

local Events = {}
local tEvents = {}
local tAccessor = {}

-- Events[event_name] = function
-- Events[event_name][function] = nil

local function eventsIndex(t, k)
	return tAccessor[k]
end

local function eventsNewIndex(t, k, v)
	assert(tEvents[k], "Event '" .. k .. "' doesn't exists")
	if (not table.containsvalue(tEvents[k], v)) then
		table.insert(tEvents[k], v)
	end
end

local function accessorIndex(t, k)
	return t.__index(k)
end

local function accessorNewIndex(t, k, v)
	assert(type(k) == "function", "Key is not a function")
	assert(v == nil, "Value is not a nil")
	table.removevalue(t.__index, k)
end

local function add(strEvent)
	if (tEvents[strEvent]) then return end
	tEvents[strEvent] = {}
	tAccessor[strEvent] = setmetatable({}, {
		__index = tEvents[strEvent],
		__newindex = accessorNewIndex,
		__simplify = simplifyMetatable(),
	})
end

local function get()
	return tEvents
end

do
	setmetatable(Events, {
		__index = eventsIndex,
		__newindex = eventsNewIndex,
		__simplify = simplifyMetatable(),
		add = add,
		get = get,
	})
end

return Events