require("Life/Equipment")

LifeEntity = class("LifeEntity",nil)

function LifeEntity:ctor()
    self._name = nil;
    self._equipment = Equipment.new(self);
end

function LifeEntity:Reset()
    self._equipment:Reset();
end

function LifeEntity:Init(lifeInfo)
    self._go = UnityEngine.GameObject.New(lifeInfo.name);
    self._equipment:Init(lifeInfo.equipInfo);   
end

function LifeEntity:Destroy()
    self._equipment:Destroy();
    UnityEngine.GameObject.Destroy(self._go);
    self._go = nil;
end

function LifeEntity:GetEquipment()
    return self._equipment;
end

function LifeEntity:GetPos()
    return self._go.transform.position;
end

function LifeEntity:GetWidth()
    return 1;
end

function LifeEntity.CreateObjectPool(creater)
    local objectPool = ObjectPool.new(
        function()
            return creater.new();
        end,
        function(obj)
            obj:Reset();
        end
    );
    return objectPool;
end

return LifeEntity;