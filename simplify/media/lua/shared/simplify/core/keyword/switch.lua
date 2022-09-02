--[[
**
** Switch
** - Introduce switch statement for better selection control.
**
--]]

require 'simplify/core/extension/table.lua'

local validate = function(t)
	if (not t) then
		error("Switch: Argument is nil", 2)
	elseif (type(t) ~= "table") then
		error("Switch: Argument is not a table", 2)
	end
end

local switch = function(val, t, ...)
	validate(t)
	local args = {...}
	if t[val] then
		if (#args > 0) then
			return t[val](unpack(args))
		else
			return t[val]()
		end
	else
		return t["default"]()
	end
end

return switch