
require("BehaviorSystem/BehaviorAction")

local Dodge = class("Dodge",BehaviorAction)

function Dodge:OnStart()
    self._updateTime = UnityEngine.Time.time;
    self:SetVariableValue("Hited",false);
    self:SetVariableValue("Dodging",true);
    log("Dodge:OnStart") 
end

function Dodge:OnUpdate()   
    if UnityEngine.Time.time - self._updateTime <= 2 then 
        return TaskStatus.Running;
    end
    log("Dodge:OnUpdate") 
    self:SetVariableValue("Dodging",false);
    return TaskStatus.Success;
end

function Dodge:IsHited()
    return self:GetVariableValue("Hited")
end

return Dodge;