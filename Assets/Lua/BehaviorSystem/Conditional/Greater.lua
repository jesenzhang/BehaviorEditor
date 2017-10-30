Greater = class("Greater",BehaviorConditional)

function Greater:Check() 
    local what = self:GetVariableValue(self._what);
    return what > self._value;
end

return Greater;