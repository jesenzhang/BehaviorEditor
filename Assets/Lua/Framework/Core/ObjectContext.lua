local ManagedArray = require("Framework/Core/ManagedArray")

local ObjectContext = class("ObjectContext",nil)

function ObjectContext:ctor(returner)
    self._returner = returner;
    self._objects = ManagedArray.new();
end

function ObjectContext:AddObject(obj)    
    self._objects:Add(obj,true);
    obj:SetContext(self)
end

function ObjectContext:RemoveObject(obj)
    obj:SetContext(nil)
    self._objects:Remove(obj,obj._reference > 0 );
end

function ObjectContext:ReturnObject(obj)
    if self._returner then
        self._returner(obj);
    end
end

function ObjectContext:Clear()
    for _,obj in ipairs(self._objects.values) do
        obj:SetContext(nil);
        obj:Destroy();
    end
    self._objects:Clear(false);
end

return ObjectContext;