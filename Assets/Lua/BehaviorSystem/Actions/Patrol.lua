require("BehaviorSystem/BehaviorAction")

local Patrol = class("Patrol",BehaviorAction)

function Patrol:OnStart()
    self._updateTime = UnityEngine.Time.time; 
    self:SetVariableValue("Patroling",true)
end

function Patrol:OnUpdate()   

    local naving = self:GetVariableValue("Patroling");

    if not naving then
        return TaskStatus.Success;
    end

    if UnityEngine.Time.time - self._updateTime < 5 then 
        return TaskStatus.Running;
    end 

    if math.random( 1,100) < 90 then
        --self:SetVariableValue("Alive",false)
        return TaskStatus.Running;
    end

    log("Patrol:OnUpdate ")

    self:SetVariableValue("Patroling",false)

    return TaskStatus.Success;
end

return Patrol;