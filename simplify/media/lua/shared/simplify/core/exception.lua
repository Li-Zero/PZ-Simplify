--[[
**
** Exception
** - Simulate exception class for consistent development process.
** - Only unchecked exceptions are supported at the moment.
** - Checked exceptions require a different UI to display uninterrupted error messages. Otherwise will be interrupted by lua error function call.
** - Call methods using colon syntax ':'.
**
--]]

require 'simplify/core/extension/table.lua'

local Exception = {}
Exception.Type = "SimplifyException"

--[[
**
** Method:
** void derive(string strType)
** - Creates a derived copy of Exception table
**
** Parameters:
** strType - The type of derived exception table.
**
** Returns:
** Derived exception table.
**
--]]
Exception.derive = function(self, strType)
	local t = {}
	setmetatable(t, self)
	self.__index = self
	t.Type = strType
	return t
end

--[[
**
** Method:
** string superclass()
** - Returns the superclass of the exception table
**
** Returns:
** Superclass type string.
**
--]]
Exception.superclass = function(self)
	return self.__index.Type
end

--[[
**
** ** Method:
** void throw(string strMessage)
** - Throws an error.
**
** Parameters:
** strMessage - Error message to be displayed when throwing an error.
**
--]]
Exception.throw = function(self, strMessage)
	error(self.Type .. ": " .. strMessage, 2)
end

--[[
**
** ** Method:
** string msg(string strMessage)
** - Returns error string to be displayed.
**
** Parameters:
** strMessage - Error message to be concatenated with error type.
**
--]]
Exception.msg = function(self, strMessage)
	return string.format("%s: %s", self.Type, strMessage)
end

return Exception