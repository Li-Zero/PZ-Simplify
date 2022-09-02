require 'simplify/core/extension/table.lua'

local Utils = {}

Utils.convertJavaArray = function(jarr)
	local arr = {}
	for i=0, jarr:size()-1 do
		arr[i+1] = jarr:get(i)
	end
	return arr
end

return table.freeze(Utils)