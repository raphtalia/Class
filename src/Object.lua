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

    return rawget(self, "_class")[i]
end

function OBJECT_METATABLE:__newindex(i, v)
    rawget(self, "_props")[i] = v
end

function Object:GetExtendedClass()
    return getmetatable(rawget(self, "_class")).__index
end

function Object:GetWrappedInstance()
    return rawget(self, "_wrappedInstance")
end

function Object:WrapInstance(instance)
    rawset(self, "_wrappedInstance", instance)
    return self
end

function Object:UnwrapInstance()
    rawset(self, "_wrappedInstance", nil)
    return self
end

-- Methods for accessing the wrapped instance
function Object:GetAttribute(attributeName)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance:GetAttribute(attributeName)
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

function Object:SetAttribute(attributeName, value)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance:SetAttribute(attributeName, value)
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

function Object:GetMethod(methodName)
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

function Object:SetProperty(propertyName, value)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        instance[propertyName] = value
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

-- Getting properties & events are identical, separate methods for clarity
function Object:GetProperty(propertyName)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance[propertyName]
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

function Object:GetEvent(eventName)
    local instance = rawget(self, "_wrappedInstance")
    if instance then
        return instance[eventName]
    else
        error("Attempt to access attribute of an object that has not been wrapped", 2)
    end
end

return function(class)
    local self = {
        _class = class,

        _props = {},

        _wrappedInstance = nil,
        _wrappedMethods = {},
    }

    return setmetatable(self, OBJECT_METATABLE)
end