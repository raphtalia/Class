local Symbols = require(script.Parent.Symbols)

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

    return rawget(self, "_className")[i]
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

function Object:GetExtendedClass()
    return getmetatable(rawget(self, "_className")).__index
end

-- Instance wrapping
function Object:WrapAttribute(attributeName)
    local attributes = rawget(self, "_wrapped").Attributes
    if not table.find(attributes, attributeName) then
        table.insert(attributes, attributeName)
    end
    return self
end

function Object:UnwrapAttribute(attributeName)
    local attributes = rawget(self, "_wrapped").Attributes
    local i = table.find(attributes, attributeName)
    if i then
        table.remove(attributes, i)
    end
    return self
end

function Object:WrapMethod(methodName)
    local methods = rawget(self, "_wrapped").Methods
    if not table.find(methods, methodName) then
        table.insert(methods, methodName)
    end
    return self
end

function Object:UnwrapMethod(methodName)
    local methods = rawget(self, "_wrapped").Methods
    local i = table.find(methods, methodName)
    if i then
        table.remove(methods, i)
    end
    return self
end

function Object:WrapProperty(propertyName)
    local properties = rawget(self, "_wrapped").Properties
    if not table.find(properties, propertyName) then
        table.insert(properties, propertyName)
    end
    return self
end

function Object:UnwrapProperty(propertyName)
    local properties = rawget(self, "_wrapped").Properties
    local i = table.find(properties, propertyName)
    if i then
        table.remove(properties, i)
    end
    return self
end

function Object:WrapEvent(eventName)
    local events = rawget(self, "_wrapped").Events
    if not table.find(events, eventName) then
        table.insert(events, eventName)
    end
    return self
end

function Object:UnwrapEvent(eventName)
    local events = rawget(self, "_wrapped").Events
    local i = table.find(events, eventName)
    if i then
        table.remove(events, i)
    end
    return self
end

function Object:GetWrappedInstance()
    return rawget(self, "_wrappedInstance")
end

function Object:WrapInstance(instance: Instance, wrapOptions)
    rawset(self, "_wrappedInstance", instance)

    if wrapOptions then
        local wrapped = rawget(self, "_wrapped")
        local attributes = wrapOptions[Symbols.Attributes]
        local events = wrapOptions[Symbols.Events]
        local methods = wrapOptions[Symbols.Methods]
        local properties = wrapOptions[Symbols.Properties]

        if attributes then
            wrapped.Attributes = attributes
        end
        if events then
            wrapped.Events = events
        end
        if methods then
            wrapped.Methods = methods
        end
        if properties then
            wrapped.Properties = properties
        end
    end

    return self
end

function Object:UnwrapInstance()
    rawset(self, "_wrappedInstance", nil)
    return self
end

-- Methods for accessing the wrapped instance
function Object:GetAttribute(attributeName: string)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance:GetAttribute(attributeName)
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

function Object:SetAttribute(attributeName: string, value: any)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance:SetAttribute(attributeName, value)
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

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

function Object:SetProperty(propertyName: string, value: any)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        instance[propertyName] = value
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

-- Getting properties & events are identical, separate methods for clarity
function Object:GetProperty(propertyName: string)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance[propertyName]
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

function Object:GetEvent(eventName: string)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance[eventName]
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

function Object:IsA(className: string, noRecursion: boolean)
    if className == nil then
        return false
    end

    if noRecursion then
        return rawget(self, "_className").ClassName == className
    else
        local class = rawget(self, "_className")
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
        _className = class,

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