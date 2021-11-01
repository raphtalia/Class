local Symbols = require(script.Symbols)
local Object = require(script.Object)

--[=[
    @class Class
    Template for creating objects.
]=]
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

--[=[
    @within Class
    @param ... any?
    @return Object
    Returns a new object from the class.
]=]
function CLASS_METATABLE:__call(...)
    local object = Object(self)

    if self.init then
        self.init(object, ...)
    end

    return object
end

--[=[
    @within Class
    @param class Class
    @return Class
    Inherits methods from a superclass. Overwrites the current superclass if
    one is already set.
]=]
function Class:Extend(class)
    if type(class) == "table" then
        rawset(self, "_superclass", class)
        return self
    else
        error("Class must be a table", 2)
    end
end

--[=[
    @within Class
    @return Class?
    Returns the superclass set previously by `Class:Extend()`.
]=]
function Class:GetExtendedClass()
    return rawget(self, "_superclass")
end

--[=[
    @class Classes
    Entry-point for the class library.
]=]
local ClassModule = {}
ClassModule.__index = ClassModule

--[=[
    @within Classes
    @param className string? -- The name of the class.
    @return Class
    Symbol representing Roblox properties.
]=]
function ClassModule:__call(className: string?)
    local class = {
        _superclass = nil,

        ClassName = className,
    }

    return setmetatable(class, CLASS_METATABLE)
end

--[=[
    @within Classes
    @prop Attributes Attributes
    Symbol representing Roblox attributes.
]=]
ClassModule.Attributes = Symbols.Attributes

--[=[
    @within Classes
    @prop Events Events
    Symbol representing Roblox events.
]=]
ClassModule.Events = Symbols.Events

--[=[
    @within Classes
    @prop Methods Methods
    Symbol representing Roblox methods.
]=]
ClassModule.Methods = Symbols.Methods

--[=[
    @within Classes
    @prop Properties Properties
    Symbol representing Roblox properties.
]=]
ClassModule.Properties = Symbols.Properties

--[=[
    @within Classes
    @param class Class
    @return boolean
    Returns if the given input is a class created using this library.
]=]
function ClassModule.isClass(class: any): boolean
    if type(class) == "table" then
        if getmetatable(class) == CLASS_METATABLE then
            return true
        end
    end
    return false
end

--[=[
    @within Classes
    @function isObject
    @param object Object
    @return boolean
    Returns if the given input is a object created using this library.
]=]
ClassModule.isObject = Object.isObject

return setmetatable(ClassModule, ClassModule)
