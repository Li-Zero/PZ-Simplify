require 'simplify.lua'

local t = { 1, 2, 3, 3 }

-- Check if table contains key
if table.containskey(t, 2) then
	print("Table contains key '2'")
end

-- Find matching value inside the table
local res = table.containsvalue(t, 3)
for _, v in ipairs(res) do
	print("Index '" .. v ... "' contains value '" .. 3 .. "'")
end

-- Remove matching value from the table
table.removevalue(t, 3)

-- Freeze table
table.freeze(t)

-- Modify frozen table
t[1] = 20 -- Error