Equal = class("Equal",BehaviorConditional)

function Equal:Check() 
    local what = self:GetVariableValue(self._what);
    return  what == self._value;
end

return Equal;