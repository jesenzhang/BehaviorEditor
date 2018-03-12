

local StopPatrol = class("StopPatrol",BehaviorAction)

function StopPatrol:OnStart()  
end

function StopPatrol:OnUpdate()   
    log("StopPatrol:OnUpdate ") 
    self:SetVariableValue("Patroling",false)
    return TaskStatus.Success;
end

return StopPatrol;