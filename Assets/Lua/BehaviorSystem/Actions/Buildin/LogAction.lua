require("BehaviorSystem/BehaviorAction")

LogAction = class("LogAction",BehaviorAction) 

function LogAction:OnUpdate() 
    log(self._message:GetValue());
    return TaskStatus.Success;
end

return LogAction;