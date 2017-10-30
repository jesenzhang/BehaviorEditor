local ManagedGameObject = require("Framework/Core/ManagedGameObject")

local ObjectContext = require("Framework/Core/ObjectContext")

GameObjectManager = class("GameObjectManager",nil) 

function GameObjectManager:ctor(name,maxPool) 
    self._name = name;
    self._pools = CacheManager.GetCache("pools",maxPool); 
    self._objects = ObjectContext.new(function(obj)
        self:ReturnGameObject(obj);
    end);
end

function GameObjectManager:LoadGameObject(path,callback,isGlobal)
    local pool = self._pools:Get(path)
    if pool then
        local obj = pool:Get();
        if obj then
            callback(obj);
            return;
        end
    end
    local function OnLoadPrefab(prefab)
        if prefab then
            local go = UnityEngine.GameObject.Instantiate (prefab:Get()); 
            local obj = ManagedGameObject.Create(path,go,prefab);
            obj:SetGlobal(isGlobal);
            self._objects:AddObject(obj);
            callback(obj);
        else
            callback(nil);
        end
    end
    ResourceManager.LoadObject(path,OnLoadPrefab);    
end

function GameObjectManager:ReturnGameObject(obj)
    if obj:IsNull() then return end
    
    local path = obj.name;
    local pool = self._pools:Get(path);
    if pool == nil then
        pool = ObjectPool.new();
        self._pools:Put(path,pool);
    end
    obj:SetActive(false);
    if pool:Return(obj) then
        obj:SetGlobal(true);
        obj:SetParent(nil);
    else
        obj:Destroy();
    end
end

function GameObjectManager:Clear()
    print("GameObjectManager:Clear",self._name)
    self._pools:Clear(); 
    self._objects:Clear();
end

return GameObjectManager;