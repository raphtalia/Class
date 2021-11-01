"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[273],{25304:function(e,n,t){t.r(n),t.d(n,{frontMatter:function(){return c},contentTitle:function(){return o},metadata:function(){return p},toc:function(){return i},default:function(){return u}});var a=t(87462),s=t(63366),l=(t(67294),t(3905)),r=["components"],c={title:"Examples"},o="Examples",p={unversionedId:"Examples",id:"Examples",isDocsHomePage:!1,title:"Examples",description:"Example 1",source:"@site/docs/Examples.md",sourceDirName:".",slug:"/Examples",permalink:"/Class/docs/Examples",editUrl:"https://github.com/raphtalia/Class/edit/main/docs/Examples.md",tags:[],version:"current",frontMatter:{title:"Examples"},sidebar:"defaultSidebar",previous:{title:"Intro",permalink:"/Class/docs/intro"}},i=[{value:"Example 1",id:"example-1",children:[]},{value:"Example 2",id:"example-2",children:[]}],m={toc:i};function u(e){var n=e.components,t=(0,s.Z)(e,r);return(0,l.kt)("wrapper",(0,a.Z)({},m,t,{components:n,mdxType:"MDXLayout"}),(0,l.kt)("h1",{id:"examples"},"Examples"),(0,l.kt)("h2",{id:"example-1"},"Example 1"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local ReplicatedStorage = game:GetService("ReplicatedStorage")\nlocal Class = require(ReplicatedStorage.Class)\n\n-- New class constructor\nlocal myClass = Class("className")\n\nfunction myClass:init(name)\n    local part = Instance.new("Part")\n\n    -- Wraps the object around a Instance\n    self:WrapInstance(part)\n\n    -- Returns a property of a wrapped Instance\n    print(self:GetProperty("Name"))\n\n    -- Sets a property of a wrapped Instance\n    self:SetProperty("Name", name or "")\n\n    -- Sets an attribute of a wrapped Instance\n    self:SetAttribute("test", 5)\n\n    -- Returns an event of a wrapped Instance\n    self:GetEvent("Touched"):Connect(function()\n        print("touched")\n    end)\n\n    -- Returns the wrapped Instance\n    self:GetWrappedInstance().Parent = workspace\nend\n\nfunction myClass:test()\n    return 5\nend\n\n-- Class extension\nlocal myExtendedClass = Class():Extend(myClass)\n-- Object constructor\nlocal myObject = myExtendedClass("testObject")\n\n-- Class checking with inheritance\nprint(myObject:IsA("className")) --\x3e true\n\n-- Class checking without inheritance\nprint(myObject:IsA("className", true)) --\x3e false\n\nprint(myObject:test()) --\x3e 5\n-- Returns the value of an attribute of a wrapped Instance\nprint(myObject:GetAttribute("test")) --\x3e 5\n\n-- Calls a method of a wrapped Instance\nmyObject:GetMethod("Clone")()\n\n-- Typechecking\nprint(Class.isClass(myClass)) --\x3e true\nprint(Class.isClass(myExtendedClass)) --\x3e true\nprint(Class.isClass(myObject)) --\x3e false\n\nprint(Class.isObject(myClass)) --\x3e false\nprint(Class.isObject(myExtendedClass)) --\x3e false\nprint(Class.isObject(myObject)) --\x3e true\n\n')),(0,l.kt)("h2",{id:"example-2"},"Example 2"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local ReplicatedStorage = game:GetService("ReplicatedStorage")\nlocal Class = require(ReplicatedStorage.Class)\n\n-- New class constructor\nlocal myClass = Class("className")\n\nfunction myClass:init(name)\n    local part = Instance.new("Part")\n\n    -- Wraps the object around a Instance\n    self:WrapInstance(part, {\n        [Class.Attributes] = { "Name" },\n        [Class.Events] = { "Touched" },\n        [Class.Methods] = { "Clone" },\n        [Class.Properties] = { "Name"},\n    })\nend\n')))}u.isMDXComponent=!0}}]);