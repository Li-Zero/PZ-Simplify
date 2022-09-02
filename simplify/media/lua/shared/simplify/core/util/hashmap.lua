local meta = {}

local function validateKey(strKey)
	if (type(strKey) ~= "string") then
		error("Key is not a string type.")
	end
end

meta.put = function(self, strKey, oValue)
	self.tKeys[strKey] = true
	local oPreviousValue = self.tValues[strKey]
	self.tValues[strKey] = oValue
	return oPreviousValue
end

meta.remove = function(self, strKey)
	self.tKeys[strKey] = nil
	local oValue = self.tValues[strKey]
	self.tValues[strKey] = nil
	return oValue
end

meta.get = function(self, strKey)
	validateKey(strKey)
	if (not self.tKeys[strKey]) then
		error("Key doesn't exists.")
	end
	return self.tValues[strKey]
end

meta.containsKey = function(self, strKey)
	validateKey(strKey)
	return self.tKeys[strKey]
end

meta.__index = function(t, k)
	return t:get(k)
end

meta.__newindex = function(t, k, v)
	error("Please use #put method to insert the key-value pair.")
end

--[[
meta.__pairs = function(t)
	-- Next returns the next index and it's associated value
	return function(t, k)
		local nextKey, _ = next(t.tKeys, k)
		local nextValue = t.tValues[nextKey]
		return nextKey, nextValue
	end, t, nil
end
--]]

local mapSize = function(t)
	return size(t.tKeys)
end

local mapNext = function(t, k)
	local nextKey, _ = next(t.tKeys, k)
	local nextValue = t.tValues[nextKey]
	return nextKey, nextValue
end

local mapPairs = function(t)
	return mapNext, t, nil
end

local mapPairsI = function(t)
	error("Please use #next or #pair methods to iterate.")
end

meta.__simplify = {
	__size = mapSize,
	__next = mapNext,
	__pairs = mapPairs,
	__ipairs = mapPairsI,
}

local HashMap = {}
HashMap.new = function()
	return setmetatable({
		tKeys = {},
		tValues = {},
	}, meta)
end

return table.freeze(HashMap)