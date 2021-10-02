local Symbols = require(script.Symbols)
local Object = require(script.Object)

local Class = {}
local CLASS_METATABLE = {}

function CLASS_METATABLE:__index(i)
    local v

    v = Class[i]
    if v then
        return v
    end

    v = rawget(self, i)
    if v then
        return v
    end

    local superclass = rawget(self, "_superclass")
    if superclass then
        return superclass[i]
    end
end

function CLASS_METATABLE:__call(...)
    local object = Object(self)

    if self.init then
        self.init(object, ...)
    end

    return object
end

function Class:Extend(class)
    if type(class) == "table" then
        rawset(self, "_superclass", class)
        return self
    else
        error("Class must be a table", 2)
    end
end

local ClassModule = {}
ClassModule.__index = ClassModule

function ClassModule:__call(className: string?)
    local class = {
        _superclass = nil,

        ClassName = className,
    }

    return setmetatable(class, CLASS_METATABLE)
end

ClassModule.Attributes = Symbols.Attributes
ClassModule.Events = Symbols.Events
ClassModule.Methods = Symbols.Methods
ClassModule.Properties = Symbols.Properties

function ClassModule.isClass(class: any): boolean
    if type(class) == "table" then
        if getmetatable(class) == CLASS_METATABLE then
            return true
        end
    end
    return false
end

-- Forwards the isObject() method
ClassModule.isObject = Object.isObject

return setmetatable(ClassModule, ClassModule)