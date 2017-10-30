require("BehaviorSystem/BehaviorAction")

SetVariableAction = class("SetVariableAction",BehaviorAction) 

function SetVariableAction:OnUpdate() 
    if self:SetVariableValue(self._variableName,self._variableValue) then 
        return TaskStatus.Success;
    end
    return TaskStatus.Failure;
end

return SetVariableAction;