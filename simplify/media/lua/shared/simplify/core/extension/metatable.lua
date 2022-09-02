-- Extends global functions to use our metatable functions

-- Get our metatable
local function get(t)
	return t and t.__simplify
end

local lSize = function(t)
	local i = 0
	for _ in pairs(t) do
		i = i + 1
	end
	return i
end
size = function(t)
	local mt = get(t)
	local s = mt and mt.__size or lSize
	return s(t)
end

local gNext = next
next = function(t, k)
	local mt = get(t)
	local n = mt and mt.__next or gNext
	return n(t, k)
end

local gPairs = pairs
pairs = function(t)
	local mt = get(t)
	local p = mt and mt.__pairs or gPairs
	return p(t)
end

local gPairsI = ipairs
ipairs = function(t)
	local mt = get(t)
	local ip = mt and mt.__ipairs or gPairsI
	return ip(t)
end

simplifySize = function(t)
	return size(t.__index)
end

simplifyNext = function(t, k)
	return next(t.__index, k)
end

simplifyPairs = function(t)
	return pairs(t.__index)
end

simplifyPairsI = function(t)
	return ipairs(t.__index)
end

local mtSimplify = {
	__size = simplifySize,
	__next = simplifyNext,
	__pairs = simplifyPairs,
	__ipairs = simplifyPairsI,
}

simplifyMetatable = function()
	return mtSimplify
end