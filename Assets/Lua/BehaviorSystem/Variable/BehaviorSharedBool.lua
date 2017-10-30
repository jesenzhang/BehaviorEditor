BehaviorSharedBool = class("BehaviorSharedBool",BehaviorSharedVariable) 

function BehaviorSharedBool:ctor(value)
    self.super.ctor(self,BehaviorSharedVariable.TYPE_BOOLEAN); 
    self._value = value;
end

function BehaviorSharedBool:GetValue()
    return self._value;
end

return BehaviorSharedBool;