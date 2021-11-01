---
title: Examples
---

# Examples

## Example 1

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Class)

-- New class constructor
local myClass = Class("className")

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

-- Class checking with inheritance
print(myObject:IsA("className")) --> true

-- Class checking without inheritance
print(myObject:IsA("className", true)) --> false

print(myObject:test()) --> 5
-- Returns the value of an attribute of a wrapped Instance
print(myObject:GetAttribute("test")) --> 5

-- Calls a method of a wrapped Instance
myObject:GetMethod("Clone")()

-- Typechecking
print(Class.isClass(myClass)) --> true
print(Class.isClass(myExtendedClass)) --> true
print(Class.isClass(myObject)) --> false

print(Class.isObject(myClass)) --> false
print(Class.isObject(myExtendedClass)) --> false
print(Class.isObject(myObject)) --> true

```

## Example 2

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Class = require(ReplicatedStorage.Class)

-- New class constructor
local myClass = Class("className")

function myClass:init(name)
	local part = Instance.new("Part")

	-- Wraps the object around a Instance
	self:WrapInstance(part, {
		[Class.Attributes] = { "Name" },
		[Class.Events] = { "Touched" },
		[Class.Methods] = { "Clone" },
		[Class.Properties] = { "Name"},
	})
end
```
