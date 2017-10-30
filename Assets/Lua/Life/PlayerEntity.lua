require("Life/LifeEntity")

PlayerEntity = class("PlayerEntity",LifeEntity)

local objectPool = LifeEntity.CreateObjectPool(PlayerEntity);

function PlayerEntity:GetModelPath(name)
    return "Res/Player/"..name.."/"..name;
end

function PlayerEntity:GetAnimatorPath(name)
    return "Res/Player/"..name.."/Animation/"..name.."_Anim";
end

function PlayerEntity.Create()
    return objectPool:Get();
end

return PlayerEntity;