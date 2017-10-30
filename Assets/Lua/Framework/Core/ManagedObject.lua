local ManagedArray = require("Framework/Core/ManagedArray")

local ObjectPool = require("Framework/Core/ObjectPool")

local ManagedObject = class("ManagedObject",nil)

local objectPool = ObjectPool.new(
    function(name,obj,...)
        return ManagedObject.new(name,obj,...)
    end,
    function(self)
        self:OnReset();
    end,
    function(self,name,obj,...)
        self:Set(name,obj,...)
    end
);

local idGenerator = 0;

function ManagedObject:ctor(name,obj,...)
    idGenerator = idGenerator + 1;
    self._id = idGenerator;
    self._refers = ManagedArray.new();
    self:Set(name,obj,...)
end  

function ManagedObject:Retain()    
    self._reference = self._reference + 1;
    --print("Retain ",self._id,self:ToString(),self._reference)
end

function ManagedObject:Release()    
    self._reference = self._reference - 1;
    --print("Release ",self._id,self:ToString(),self._reference)
    if self.obj and self._reference <= 0 then        
        self:Destroy();        
    end
end 

function ManagedObject:Set(name,obj,...)
    self.name = name;
    self.obj = obj;
    self._reference = 0;
    self._refers:Set(...);
end

function ManagedObject:AddRefer(refer) 
    self._refers:Add(refer);
end

function ManagedObject:SetContext(context)
    self._context = context;
end

function ManagedObject:Get()
    return self.obj;
end

function ManagedObject:Return()
    if self._context then
        self._context:ReturnObject(self);
    end
end 

function ManagedObject:OnDestroy()
    if self.obj then        
        print("Destroy ",self:ToString())
        UnityEngine.Object.Destroy(self.obj);        
        self.obj = nil;        
    end
end

function ManagedObject:Destroy()
    if self.obj then
        self:OnDestroy();
        self.obj = nil;
    end
    if self._context then
        self._context:RemoveObject(self);
        self._context = nil;
    end
    self.name = nil;
    self.obj = nil;
    self._reference = 0;
    self._refers:Clear();
    objectPool:Return(self);
end

function ManagedObject:OnReset()
    self.name = nil;
    self.obj = nil;
    self._reference = 0;
    self._refers:Clear();
    self._context = nil;
end

function ManagedObject:IsNull()
    return self.obj == nil;
end

function ManagedObject:ToString()
    return self.name;
end

function ManagedObject.Create(name,obj,...)
    return objectPool:Get(name,obj,...); 
end

return ManagedObject;
