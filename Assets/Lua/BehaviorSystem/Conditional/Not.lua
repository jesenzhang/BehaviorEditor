Not = class("Not",BehaviorConditional)
function Not:Check() 
    local what = self:GetVariableValue(self._what);
    return what ~= self._value;
end
return Not;