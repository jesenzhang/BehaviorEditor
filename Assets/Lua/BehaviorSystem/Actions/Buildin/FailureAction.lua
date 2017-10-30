require("BehaviorSystem/BehaviorAction")

FailureAction = class("FailureAction",BehaviorAction) 

function FailureAction:OnUpdate()  
    return TaskStatus.Failure;
end

return FailureAction;