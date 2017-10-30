
require("BehaviorSystem/BehaviorAction")

local CheckTarget = class("CheckTarget",BehaviorAction) 

function CheckTarget:OnUpdate()
    if math.random(1,100) < 10 then
        return TaskStatus.Failure;
    end 
    return TaskStatus.Success;
end

return CheckTarget;