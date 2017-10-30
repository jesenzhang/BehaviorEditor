require("BehaviorSystem/BehaviorAction")

local StopGotoTarget = class("StopGotoTarget",BehaviorAction)

function StopGotoTarget:OnStart()  
end

function StopGotoTarget:OnUpdate()   
    log("StopGotoTarget:OnUpdate ") 
    self:SetVariableValue("Naving",false)
    return TaskStatus.Success;
end

return StopGotoTarget;