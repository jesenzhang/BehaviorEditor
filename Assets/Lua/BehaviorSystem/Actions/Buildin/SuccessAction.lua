require("BehaviorSystem/BehaviorAction")

SuccessAction = class("SuccessAction",BehaviorAction) 

function SuccessAction:OnUpdate()  
    return TaskStatus.Success;
end

return SuccessAction;