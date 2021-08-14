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

return function()
    local self = {
        _superclass = nil,
    }

    return setmetatable(self, CLASS_METATABLE)
end