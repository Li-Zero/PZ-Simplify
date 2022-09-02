--[[
**
** Print necessary information
** - Credits to Egor for the LUA version algorithm
** - http://lua-users.org/lists/lua-l/2016-05/msg00297.html
**
--]]
local f, t = function() return function() end end, { nil,
	[false] = "5.1",
	[true] = "5.2",
	[1/'-0'] = "5.3",
	[1] = "LuaJit",
}
local version = t[1] or t[1/0] or t[f()==f()]
print("Simplify: API Information")
print(string.format("LUA Version: %s", version))

local namespace = {}

-- Extensions
require 'simplify/core/extension/require.lua'
require 'simplify/core/extension/metatable.lua'
require 'simplify/core/extension/table.lua'
require 'simplify/core/extension/string.lua'

-- Core Utilities
namespace.Utils = require 'simplify/utils.lua'

-- Exceptions
namespace.Exception = require 'simplify/core/exception.lua' -- Not frozen since it's a derivable table
namespace.Exceptions = require 'simplify/core/exceptions.lua' -- Table not frozen since it's a mutable exception list

-- Keywords
namespace.Keywords = require 'simplify/core/keywords.lua'

-- Base Utility Classes
namespace.HashMap = require 'simplify/core/util/hashmap.lua'

-- Game Utilities
namespace.Math = require 'simplify/core/game/math.lua'
namespace.Player = require 'simplify/core/game/player.lua'

-- I/Os
local io = {}
io.File = require 'simplify/core/io/file.lua'
io.CSV = require 'simplify/core/io/csv.lua'
namespace.io = table.freeze(io)

-- Events
namespace.EventManager = require 'simplify/core/events/eventmanager.lua'
namespace.Events = require 'simplify/core/events/events.lua'

namespace.CommandChannels = require 'simplify/core/commandchannels.lua'

Simplify = table.freeze(namespace)

-- Mod Loader
require 'simplify/core/modloader/server.lua'
require 'simplify/core/modloader/client.lua'