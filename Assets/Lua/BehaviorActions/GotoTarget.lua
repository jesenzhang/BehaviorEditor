

local GotoTarget = class("GotoTarget",BehaviorAction)

function GotoTarget:OnStart()
    self._updateTime = UnityEngine.Time.time;
    log("GotoTarget:OnStart ") 
    self:SetVariableValue("Naving",true)
    self._distance = math.random( 20,50)
end

function GotoTarget:UpdateDistance()
    --log("GotoTarget:OnUpdate %s",self._behavior._updateFrames,self._distance) 
    self._distance = self._distance - 0.1;
    return self._distance > 2;
end

function GotoTarget:OnUpdate() 
    local naving = self:GetVariableValue("Naving");

    if naving then
        if self:UpdateDistance() then
            return TaskStatus.Running;
        end        
    else
        return TaskStatus.Failure;
    end

    log("GotoTarget:OnUpdate cost %s",UnityEngine.Time.time-self._updateTime) 

    self:SetVariableValue("Naving",false);

    return TaskStatus.Success;
end 

return GotoTarget;