

local FindTarget = class("FindTarget",BehaviorAction)

function FindTarget:OnStart() 
end

function FindTarget:OnUpdate()   

    if math.random( 1,100) < 10 then 
        return TaskStatus.Failure;
    end

    log("FindTargetAction:OnUpdate ") 
    return TaskStatus.Success;
end

return FindTarget;