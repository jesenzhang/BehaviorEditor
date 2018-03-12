local BehaviorAction = class("BehaviorAction",nil)

function BehaviorAction:ctor(behavior)
    self._behavior = behavior;
end

function BehaviorAction:OnStart() 
end

function BehaviorAction:OnEnd() 
end

function BehaviorAction:OnUpdate() 
end

function BehaviorAction:GetVariableValue(name)
    return self._behavior:GetVariable(name):GetValue();
end

function BehaviorAction:SetVariableValue(name,value)
    self._behavior:SetVariableValue(name,value);
end

return BehaviorAction;