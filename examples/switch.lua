require 'simplify.lua'

local switch = Simplify.Keywords.Switch

tSwitch = {}

-- Example One - Without Arguments
do
  tSwitch.Value = tSwitch.Value or {
    [1] = function()
      print("One")
    end,
    [2] = function()
      print("Two")
    end,
    [3] = function()
      print("Three")
    end,
    [4] = function()
      print("Four")
    end,
    [5] = function()
      print("Five")
    end,
    default = function()
      print("Unknown value!")
    end,
  }
  for i=1, 6 do
    switch(i, tSwitch.Value)
  end
end

--Example Two - With Arguments
do
  tSwitch.Var = tSwitch.Var or {
    ["add"] = function(i1, i2)
      print(i1 + i2)
    end,
  }
  switch("add", tSwitch.Var, 5, 10)
end