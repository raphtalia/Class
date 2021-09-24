local Class = require(script.Parent)

return function()
    describe("Class", function()
        it("should be able to create classes", function()
            expect(Class()).to.be.a("table")
        end)

        it("should be able to inherit classes", function()
            local classA = Class()
            local classB = Class():Extend(classA)

            function classA:test()
                return 5
            end

            expect(classB).to.be.a("table")
            expect(classB():test()).to.equal(5)

            -- Deep inheritance
            local classC = Class():Extend(classB)
            expect(classC():test()).to.equal(5)
        end)
    end)

    describe("Object", function()
        it("should be able to create objects", function()
            expect(Class()()).to.be.a("table")
        end)

        it("should call init methods", function()
            local class = Class()

            function class:init()
                self.a = 5
            end

            local obj = class()
            expect(obj.a).to.equal(5)

            obj.a = 10

            expect(obj.a).to.equal(10)
        end)

        local instance = Instance.new("Part")
        it("should be able to wrap instances", function()
            expect(function()
                Class()():WrapInstance(instance)
            end).to.be.ok()
        end)

        it("should be able to access RBX attributes", function()
            local obj = Class()():WrapInstance(instance)
            obj:SetAttribute("test", "test")

            expect(obj:GetAttribute("test")).to.equal("test")
        end)

        it("should be able to access RBX properties and events", function()
            expect(Class()():WrapInstance(instance):GetProperty("Name")).to.be.a("string")
            expect(typeof(Class()():WrapInstance(instance):GetEvent("Touched")) == "RBXScriptSignal").to.equal(true)
        end)

        it("should be able to access RBX methods", function()
            expect(Class()():WrapInstance(instance):GetMethod("Clone")).to.be.a("function")
        end)

        it("should be able to class check", function()
            expect(Class()():IsA()).to.equal(false)

            expect(Class("foobar")():IsA("foobar")).to.equal(true)

            local extendedClass = Class("foo"):Extend(Class("bar"))
            expect(extendedClass():IsA("foo")).to.equal(true)
            expect(extendedClass():IsA("bar")).to.equal(true)
            expect(extendedClass():IsA("bar", true)).to.equal(false)
        end)
    end)

    describe("Class module", function()
        local class = Class()
        local extendedClass = Class():Extend(class)
        local object = class()
        local extendedClassObject = extendedClass()

        it("should be able to typecheck classes", function()
            expect(Class.isClass(class)).to.equal(true)
            expect(Class.isClass(extendedClass)).to.equal(true)
            expect(Class.isClass(object)).to.equal(false)
            expect(Class.isClass(extendedClassObject)).to.equal(false)
        end)

        it("should be able to typecheck objects", function()
            expect(Class.isObject(class)).to.equal(false)
            expect(Class.isObject(extendedClass)).to.equal(false)
            expect(Class.isObject(object)).to.equal(true)
            expect(Class.isObject(extendedClassObject)).to.equal(true)
        end)
    end)
end