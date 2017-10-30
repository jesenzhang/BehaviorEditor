require("BehaviorSystem/BehaviorAction")

WaitAction = class("WaitAction",BehaviorAction) 

function WaitAction:OnStart()
    self._startTime = UnityEngine.Time.time;
end

function WaitAction:OnUpdate() 
    if (UnityEngine.Time.time - self._startTime) * 1000 < self._waitTime then
        return TaskStatus.Running;
    end
    return TaskStatus.Success;
end

return WaitAction;