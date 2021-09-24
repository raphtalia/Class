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

    return rawget(self, "_className")[i]
end

function OBJECT_METATABLE:__newindex(i, v)
    rawget(self, "_props")[i] = v
end

function Object:GetExtendedClass()
    return getmetatable(rawget(self, "_className")).__index
end

function Object:GetWrappedInstance()
    return rawget(self, "_wrappedInstance")
end

function Object:WrapInstance(instance: Instance)
    rawset(self, "_wrappedInstance", instance)
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