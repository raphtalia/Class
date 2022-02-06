local Symbols = require(script.Parent.Symbols)

--[=[
    @class Object
    Table with properties and methods determined by its class. Indexes can be
    read and written to access properties.

    ```lua
    local Car = Class("Car")

    --[[
        The method init() is special because it is called immediately after an
        object is created and before the object is returned.
    ]]
    function Car:init(wheels, doors)
        self.Wheels = wheels or 4
        self.Doors = doors or 4
        self.Speed = 0
    end

    function Car:Accelerate()
        self.Speed += 1
    end

    function Car:Decelerate()
        self.Speed -= 1
    end

    function Car:Brake()
        self.Speed = 0
    end

    local car = Car(4, 2)
    print(car.Wheels) -- 4
    print(car.Doors) -- 2
    print(car.Speed) -- 0
    ```
]=]
local Object = {}
local OBJECT_METATABLE = {}

function OBJECT_METATABLE:__index(i)
    local v

    v = Object[i]
    if v then
        return v
    end

    v = rawget(self, "_props")[i]
    if v ~= nil then
        return v
    end

    local wrapped = rawget(self, "_wrapped")
    if table.find(wrapped.Attributes, i) then
        return self:GetAttribute(i)
    elseif table.find(wrapped.Events, i) then
        return self:GetEvent(i)
    elseif table.find(wrapped.Methods, i) then
        return self:GetMethod(i)
    elseif table.find(wrapped.Properties, i) then
        return self:GetProperty(i)
    end

    return rawget(self, "_class")[i]
end

function OBJECT_METATABLE:__newindex(i, v)
    local wrapped = rawget(self, "_wrapped")
    if table.find(wrapped.Attributes, i) then
        return self:SetAttribute(i, v)
    elseif table.find(wrapped.Properties, i) then
        return self:SetProperty(i, v)
    end

    rawget(self, "_props")[i] = v
end

--[=[
    @within Object
    @return Class
    Returns the class this object was created from.
]=]
function Object:GetClass()
    return rawget(self, "_class")
end

-- Instance wrapping
--[=[
    @within Object
    @param attributeName string
    @return Object
    Wraps a Roblox attribute.
]=]
function Object:WrapAttribute(attributeName)
    local attributes = rawget(self, "_wrapped").Attributes
    if not table.find(attributes, attributeName) then
        table.insert(attributes, attributeName)
    end
    return self
end

--[=[
    @within Object
    @param attributeName string
    @return Object
    Unwraps a Roblox attribute.
]=]
function Object:UnwrapAttribute(attributeName)
    local attributes = rawget(self, "_wrapped").Attributes
    local i = table.find(attributes, attributeName)
    if i then
        table.remove(attributes, i)
    end
    return self
end

--[=[
    @within Object
    @param methodName string
    @return Object
    Wraps a Roblox method.
]=]
function Object:WrapMethod(methodName)
    local methods = rawget(self, "_wrapped").Methods
    if not table.find(methods, methodName) then
        table.insert(methods, methodName)
    end
    return self
end

--[=[
    @within Object
    @param methodName string
    @return Object
    Unwraps a Roblox method.
]=]
function Object:UnwrapMethod(methodName)
    local methods = rawget(self, "_wrapped").Methods
    local i = table.find(methods, methodName)
    if i then
        table.remove(methods, i)
    end
    return self
end

--[=[
    @within Object
    @param propertyName string
    @return Object
    Wraps a Roblox property.
]=]
function Object:WrapProperty(propertyName)
    local properties = rawget(self, "_wrapped").Properties
    if not table.find(properties, propertyName) then
        table.insert(properties, propertyName)
    end
    return self
end

--[=[
    @within Object
    @param propertyName string
    @return Object
    Unwraps a Roblox property.
]=]
function Object:UnwrapProperty(propertyName)
    local properties = rawget(self, "_wrapped").Properties
    local i = table.find(properties, propertyName)
    if i then
        table.remove(properties, i)
    end
    return self
end

--[=[
    @within Object
    @param eventName string
    @return Object
    Wraps a Roblox event.
]=]
function Object:WrapEvent(eventName)
    local events = rawget(self, "_wrapped").Events
    if not table.find(events, eventName) then
        table.insert(events, eventName)
    end
    return self
end

--[=[
    @within Object
    @param eventName string
    @return Object
    Unwraps a Roblox event.
]=]
function Object:UnwrapEvent(eventName)
    local events = rawget(self, "_wrapped").Events
    local i = table.find(events, eventName)
    if i then
        table.remove(events, i)
    end
    return self
end

--[=[
    @within Object
    @return Instance
    Returns the wrapped Roblox Instance set previous by
    `Object:WrapInstance()`.
]=]
function Object:GetWrappedInstance()
    return rawget(self, "_wrappedInstance")
end

--[=[
    @within Object
    @param instance Instance
    @param wrapOptions WrapOptions
    @return Object
    Wraps a Roblox Instance. When an instance is wrapped any wrapped
    attributes, methods, properties, and events can be indexed as if they were
    the object's own properties.

    ```lua
    local myClass = Class("className")

    function myClass:init()
        local part = Instance.new("Part")
        self:WrapInstance(part, {
            [Class.Properties] = { "Name" }
        })
    end

    print(myClass().Name) --> Part
    ```
]=]
function Object:WrapInstance(instance: Instance, wrapOptions)
    rawset(self, "_wrappedInstance", instance)

    if wrapOptions then
        local wrapped = rawget(self, "_wrapped")
        local attributes = wrapOptions[Symbols.Attributes]
        local events = wrapOptions[Symbols.Events]
        local methods = wrapOptions[Symbols.Methods]
        local properties = wrapOptions[Symbols.Properties]

        if attributes then
            wrapped.Attributes = {}

            for key, value in pairs(attributes) do
                local keyType = type(key)

                if keyType == "string" then
                    instance:SetAttribute(key, value)

                    table.insert(wrapped.Attributes, key)
                elseif keyType == "number" then
                    table.insert(wrapped.Attributes, value)
                end
            end
        end
        if events then
            wrapped.Events = events
        end
        if methods then
            wrapped.Methods = methods
        end
        if properties then
            wrapped.Properties = {}

            for key, value in pairs(properties) do
                local keyType = type(key)

                if keyType == "string" then
                    instance[key] = value

                    table.insert(wrapped.Properties, key)
                elseif keyType == "number" then
                    table.insert(wrapped.Properties, value)
                end
            end
        end
    end

    return self
end

--[=[
    @within Object
    @return Object
    Unwraps a Roblox Instance.
]=]
function Object:UnwrapInstance()
    rawset(self, "_wrappedInstance", nil)
    return self
end

-- Methods for accessing the wrapped instance
--[=[
    @within Object
    @param attributeName string
    @return any
    Returns an attribute on the wrapped Instance.
]=]
function Object:GetAttribute(attributeName: string)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance:GetAttribute(attributeName)
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

--[=[
    @within Object
    @param attributeName string
    @param value any
    Sets an attribute on the wrapped Instance.
]=]
function Object:SetAttribute(attributeName: string, value: any)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance:SetAttribute(attributeName, value)
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

--[=[
    @within Object
    @param methodName string
    @return function
    Returns a method on the wrapped Instance.
]=]
function Object:GetMethod(methodName: string)
    local wrappedMethods = rawget(self, "_wrappedMethods")
    local wrappedMethod = wrappedMethods[methodName]

    if not wrappedMethod then
        wrappedMethod = function(...)
            local instance = rawget(self, "_wrappedInstance")
            return instance[methodName](instance, ...)
        end

        wrappedMethods[methodName] = wrappedMethod
    end

    return wrappedMethod
end

--[=[
    @within Object
    @param propertyName string
    Sets a property on the wrapped Instance.
]=]
function Object:SetProperty(propertyName: string, value: any)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        instance[propertyName] = value
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

-- Getting properties & events are identical, separate methods for clarity
--[=[
    @within Object
    @param propertyName string
    @return any
    Returns a property on the wrapped Instance.
]=]
function Object:GetProperty(propertyName: string)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance[propertyName]
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

--[=[
    @within Object
    @param eventName string
    @return RBXScriptSignal
    Returns a event on the wrapped Instance.
]=]
function Object:GetEvent(eventName: string)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance[eventName]
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

--[=[
    @within Object
    @param className string
    @param noRecursion boolean -- If true, ignores superclasses.
    @return boolean
    Behaves the same as Roblox's `Instance:IsA()` method.
]=]
function Object:IsA(className: string, noRecursion: boolean)
    if className == nil then
        return false
    end

    if noRecursion then
        return rawget(self, "_class").ClassName == className
    else
        local class = rawget(self, "_class")
        while true do
            if class.ClassName == className then
                return true
            else
                class = class._superclass
                if not class then
                    return false
                end
            end
        end
    end
end

local ObjectModule = {}
ObjectModule.__index = ObjectModule

function ObjectModule:__call(class)
    local object = {
        _class = class,

        _props = {},

        _wrappedInstance = nil,
        _wrappedMethods = {},
        _wrapped = {
            Attributes = {},
            Methods = {},
            Properties = {},
            Events = {},
        },
    }

    return setmetatable(object, OBJECT_METATABLE)
end

function ObjectModule.isObject(object: any): boolean
    if type(object) == "table" then
        if getmetatable(object) == OBJECT_METATABLE then
            return true
        end
    end
    return false
end

return setmetatable(ObjectModule, ObjectModule)
