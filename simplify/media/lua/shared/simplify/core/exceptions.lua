--[[
**
** Derived Exceptions
** - Base exceptions should be registered below.
**
--]]

local Exception = require 'simplify/core/exception.lua'
local Exceptions = {}

Exceptions.RunTimeException = Exception:derive("RunTimeException")
local RunTimeException = Exceptions.RunTimeException

Exceptions.IllegalArgumentException = RunTimeException:derive("IllegalArgumentException")
Exceptions.IllegalStateException = RunTimeException:derive("IllegalStateException")
Exceptions.IndexOutOfBoundsException = RunTimeException:derive("IndexOutOfBoundsException")

return Exceptions