
local ObjectPool = require("Framework/Core/ObjectPool")
local ManagedObject = require("Framework/Core/ManagedObject")
local ManagedAssetObject = class("ManagedAssetObject",ManagedObject) 

local objectPool = ObjectPool.new(
    function(name,obj,...)
        return ManagedAssetObject.new(name,obj,...)
    end,
    function(self)
        self:OnReset();
    end,
    function(self,name,obj,...)
        self:Set(name,obj,...)
    end
);
 
function ManagedAssetObject:OnDestroy()
    if self.obj then        
        print("destroy assetobject ",self.name)
        UnityEngine.Object.DestroyImmediate(self.obj,true);        
        self.obj = nil; 
    end
end

function ManagedAssetObject:ToString()
    return "Assets://"..self.name;
end

function ManagedAssetObject.Create(name,obj,...) 
    return objectPool:Get(name,obj,...);
end

return ManagedAssetObject;
