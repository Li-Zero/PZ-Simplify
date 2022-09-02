require 'simplify/core/extension/table.lua'

local Math = {}

-- Clamp the value within the range
Math.clamp = function(value, minValue, maxValue)
	if value < minValue then
		return minValue, true
	elseif value > maxValue then
		return maxValue, true
	end
	return value, false
end

-- Check if the value is inside the range
Math.isInsideRange = function(value, minValue, maxValue)
	if value >= minValue and value <= maxValue then
		return true
	else
		return false
	end
end

return table.freeze(Math)