If = class("If",BehaviorConditional)
function If:Check()    
    local what = self:GetVariableValue(self._what); 
    return what;
end
return If;