require 'simplify.lua'

local CommandChannels = Simplify.CommandChannels

local modID = "test"
local command = "ReceiveTestCommand"

local onTestCommand1 = function(player, args)
	print("Received Client Test Command")
	sendServerCommand(modID, command, player, {})
end

local onTestCommand2 = function(args)
	print("Received Server Test Command")
end

-- Set Command Hooks
CommandChannels.Server[modID][command] = onTestCommand1
CommandChannels.Client[modID][command] = onTestCommand2

sendClientCommand(modID, command, {})

-- Remove Command Hooks
CommandChannels.Server[modID][command] = nil
CommandChannels.Client[modID][command] = nil