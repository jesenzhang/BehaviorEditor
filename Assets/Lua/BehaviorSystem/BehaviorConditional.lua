BehaviorConditional = class("BehaviorConditional",BehaviorTask) 

function BehaviorConditional:OnUpdate()   
    if self:Check() then
        return TaskStatus.Success;
    end
    return TaskStatus.Failure;
end

return BehaviorConditional;