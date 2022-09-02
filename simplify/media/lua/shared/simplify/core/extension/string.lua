--[[
**
** String
** - Provide more string utility functions.
**
--]]

local String = getmetatable('')

--[[
**
** Function:
** string array split(string str, string strSeparator = "%s")
** - Split the string using the provided separator.
**
** Parameters:
** str - String to test.
** strSeparator - The separator.
**
** Returns:
** Array of separated string sequence.
**
--]]
String.simplifySplit = function(str, strSeparator)
	if (type(str) ~= "string") then
		error("Argument 'str' is not a string type")
	end
	
	strSeparator = strSeparator or "%s"
	
	local t = {}
	for w in string.gmatch(str, "([^".. strSeparator .. "]+)") do
		table.insert(t, w)
	end
	return t
end

--[[
**
** Function:
** boolean startsWith(string str, string strPrefix)
** - Tests if this string starts with the specified prefix.
**
** Parameters:
** str - String to test.
** strPrefix - The prefix.
**
** Returns:
** True if the character sequence represented by the argument 'strPrefix' is a prefix of the character sequence represented by this string; false otherwise.
** Note also that true will be returned if the argument 'strPrefix' is an empty string.
**
--]]
String.simplifyStartsWith = function(str, strPrefix)
	return (str:sub(1, #strPrefix) == strPrefix)
end

--[[
**
** Function:
** boolean endsWith(string str, string strSuffix)
** - Tests if this string starts with the specified suffix.
**
** Parameters:
** str - String to test.
** strSuffix - The suffix.
**
** Returns:
** True if the character sequence represented by the argument 'strSuffix' is a suffix of the character sequence represented by this string; false otherwise.
** Note also that true will be returned if the argument 'strSuffix' is an empty string.
**
--]]
String.simplifyEndsWith = function(str, strSuffix)
	return (strSuffix == "")
		or (str:sub(-#strSuffix) == strSuffix)
end

--[[
**
** Function:
** table utf8To32(string strUtf8)
** - Convert utf-8 string into utf-32 codepoints.
**
** Parameters:
** strUtf8 - The utf8 string.
**
** Returns:
** Lua table with corresponding unicode codepoints (UTF-32).
**
** References:
** http://lua-users.org/wiki/LuaUnicode
**
--]]
String.simplifyUtf8To32 = function(strUtf8)
	local res, seq, val = {}, 0, nil
	for i=1, #strUtf8 do
		local c = string.byte(strUtf8, i)
		if (seq == 0) then
			table.insert(res, val)
			seq = c < 0x80 and 1
				or c < 0xE0 and 2
				or c < 0xF0 and 3
				or c < 0xF8 and 4
				or error("invalid UTF-8 character sequence")
			val = bit32.band(c, 2^(8-seq) - 1)
		else
			val = bit32.bor(bit32.lshift(val, 6), bit32.band(c, 0x3F))
		end
		seq = seq - 1
	end
	table.insert(res, val)
	table.insert(res, 0)
	return res
end