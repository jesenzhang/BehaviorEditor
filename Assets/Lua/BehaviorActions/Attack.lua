
local Attack = class("Attack",BehaviorAction)

function Attack:OnStart()
    self._updateTime = UnityEngine.Time.time;
    log("Attack:OnStart ")  
end

function Attack:OnUpdate()
    if UnityEngine.Time.time - self._updateTime < 1 then
        return TaskStatus.Running;
    end 
    return TaskStatus.Success;
end

return Attack;