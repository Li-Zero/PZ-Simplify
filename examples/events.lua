require 'simplify.lua'

local Events = Simplify.Events

-- Only two events are supported for now.
-- 'OnClientCommand' and 'OnServerCommand'

-- Adding Hooks
-- Assigning function to an event will insert the function into internal table.concat
-- Meaning that you can add events by assigning new function to the same event key.
-- Duplicates will not be added.

-- Hook 1
Events.OnClientCommand = function(module, command, player, args)
	print("Hook 1")
end

-- Hook 2
local f = function(module, command, player, args)
	print("Hook 2")
end
Events.OnClientCommand = f

-- Removing Hooks (Require function reference)
Events.OnClientCommand[f] = nil