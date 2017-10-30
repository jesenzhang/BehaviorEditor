
local ObjectPool = require("Framework/Core/ObjectPool")
local ManagedObject = require("Framework/Core/ManagedObject")

local ManagedGameObject = class("ManagedGameObject",ManagedObject)  

local objectPool = ObjectPool.new(
    function(name,obj,...)
        return ManagedGameObject.new(name,obj,...)
    end,
    function(self)
        self:OnReset();
    end,
    function(self,name,obj,...)
        self:Set(name,obj,...)
    end
);

function ManagedGameObject:SetActive(active)
    if self.obj then
        self.obj:SetActive(false);
    end
end

function ManagedGameObject:SetParent(parent)
    if self.obj then
        if parent then
            self.obj.transform:SetParent(parent.transform);
        else
            self.obj.transform:SetParent(nil);
        end        
    end
end

function ManagedGameObject:SetGlobal(global)
    if self._global ~= global then
        self._global = global;
        if global then
            UnityEngine.GameObject.DontDestroyOnLoad (self.obj);
        end
    end
end

function ManagedGameObject:ToString()
    return "Assets://"..self.name;
end

function ManagedGameObject.Create(name,obj,...) 
    return objectPool:Get(name,obj,...);
end

return ManagedGameObject;
