# Class

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Class)

-- New class constructor
local myClass = Class()

function myClass:init(name)
	local part = Instance.new("Part")

	-- Wraps the object around a Instance
	self:WrapInstance(part)

	-- Returns a property of a wrapped Instance
	print(self:GetProperty("Name"))

	-- Sets a property of a wrapped Instance
	self:SetProperty("Name", name or "")

	-- Sets an attribute of a wrapped Instance
	self:SetAttribute("test", 5)

	-- Returns an event of a wrapped Instance
	self:GetEvent("Touched"):Connect(function()
		print("touched")
	end)

	-- Returns the wrapped Instance
	self:GetWrappedInstance().Parent = workspace
end

function myClass:test()
	return 5
end

-- Class extension
local myExtendedClass = Class():Extend(myClass)
-- Object constructor
local myObject = myExtendedClass("testObject")

print(myObject:test())
-- Returns the value of an attribute of a wrapped Instance
print(myObject:GetAttribute("test"))
```
