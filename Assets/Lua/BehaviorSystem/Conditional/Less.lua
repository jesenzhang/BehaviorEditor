Less = class("Less",BehaviorConditional)
function Less:Check() 
    local what = self:GetVariableValue(self._what);
    return what < self._value;
end
return Less;