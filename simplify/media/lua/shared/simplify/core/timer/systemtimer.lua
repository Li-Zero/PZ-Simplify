require 'simplify/core/extension/table.lua'

local Timer = {}

local tFunctions = {}

Timer.create = function(iIntervalS, refFunction)
	refFunction = refFunction or nil
	local t = {
		autoReset = false,
		elapsedFunction = refFunction,
		intervalS = iIntervalS,
	}
	t.start = function(self)
		tFunctions[self.elapsedFunction] = {
			properties = self,
			timestamp = os.time(),
		}
	end
	t.stop = function(self)
		tFunctions[self.elapsedFunction] = nil
	end
	return t
end

Timer.remove = function(refFunction)
	tFunctions[refFunction] = nil
end

local function onTick()
	local currentTimestamp = os.time()
	for k, v in pairs(tFunctions) do
		if (os.difftime(currentTimestamp, tFunctions[k].timestamp) >= tFunctions[k].properties.intervalS) then
			tFunctions[k].properties.elapsedFunction()
			if (not tFunctions[k].properties.autoReset) then
				tFunctions[k] = nil
			else
				tFunctions[k].timestamp = os.time()
			end
		end
	end
end
Events.OnTick.Add(onTick)

return table.freeze(Timer)