require("Life/LifeEntity")

NPCEntity = class("NPCEntity",LifeEntity) 

local objectPool = LifeEntity.CreateObjectPool(NPCEntity);

function NPCEntity:GetModelPath(name)
    return "Res/NPC/"..name.."/"..name;
end

function NPCEntity:GetAnimatorPath(name)
    return "Res/NPC/"..name.."/Animation/"..name.."_Anim";
end

return NPCEntity;