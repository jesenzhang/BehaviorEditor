BehaviorSharedFloat = class("BehaviorSharedFloat",BehaviorSharedVariable) 

function BehaviorSharedFloat:ctor(value)
    self.super.ctor(self,BehaviorSharedVariable.TYPE_FLOAT); 
    self._value = value;
end

function BehaviorSharedFloat:GetValue()
    return self._value;
end

return BehaviorSharedFloat;