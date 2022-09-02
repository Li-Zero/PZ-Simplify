require 'simplify/core/extension/table.lua'

local keywords = {}

keywords.Switch = require 'simplify/core/keyword/switch.lua'

return table.freeze(keywords)