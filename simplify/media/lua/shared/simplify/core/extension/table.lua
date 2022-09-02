require 'simplify/core/extension/metatable.lua'

local tReadOnly = setmetatable({}, {
	__mode = "k", -- Weak Keys
})

local function moveall(t1, t2)
	for k, v in pairs(t1) do
		t2[k] = v
		t1[k] = nil
	end
	return t2
end

local function freezeError(_, _, _)
	error("Attempts to modify a frozen table")
end

local function isfrozen(t)
	return tReadOnly[t]
end

local function freeze(t)
	-- Move values to new table and preserve the original table address
	local tIndex = moveall(t, {})
	-- Set metatable
	t = setmetatable(t,{
		__metatable = "frozen table",
		__index = tIndex,
		__newindex = freezeError,
		__simplify = simplifyMetatable()
	})
	tReadOnly[t] = true
	return t
end

local gRawSet = _G.rawset
rawset = function(t, k, v)
	if (isfrozen(t)) then
		freezeError()
	end
	return gRawSet(t, k, v)
end

local function containskey(t, k)
	for key, _ in pairs(t) do
		if (key == k) then return true end
	end
	return false
end

local function containsvalue(t, v)
	local res = nil
	for key, value in pairs(t) do
		if (value == v) then
			if (not res) then res = {} end
			table.insert(res, key)
		end
	end
	return res
end

local function removevalue(t, v)
	local res = nil
	for i=1, #t do
		if (t[i] == v) then
			table.remove(t, i)
			
			if (not res) then res = {} end
			table.insert(res, i)
		end
	end
	return res
end

local table = table
table.moveall = moveall
table.isfrozen = isfrozen
table.freeze = freeze
table.removevalue = removevalue
table.containskey = containskey
table.containsvalue = containsvalue