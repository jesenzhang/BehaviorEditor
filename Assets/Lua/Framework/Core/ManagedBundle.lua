
local ObjectPool = require("Framework/Core/ObjectPool")
local ManagedObject = require("Framework/Core/ManagedObject")
local ManagedBundle = class("ManagedBundle",ManagedObject) 

local objectPool = ObjectPool.new(
    function(name,obj,...)
        return ManagedBundle.new(name,obj,...)
    end,
    function(self)
        self:OnReset();
    end,
    function(self,name,obj,...)
        self:Set(name,obj,...)
    end
);

function ManagedBundle:OnDestroy()
    if self.obj then        
        print("destroy bundle ",self.name)
        self.obj:Unload(false); 
        self.obj = nil; 
    end
end

function ManagedBundle:ToString()
    return "Bundle://"..self.name;
end

function ManagedBundle.Create(name,obj,...) 
    return objectPool:Get(name,obj,...);
end

return ManagedBundle;
