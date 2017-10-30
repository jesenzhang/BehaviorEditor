BehaviorSharedObject = class("BehaviorSharedObject",BehaviorSharedVariable) 

function BehaviorSharedObject:ctor(value)
    self.super.ctor(self,BehaviorSharedVariable.TYPE_OBJECT); 
    self._value = value;
end

function BehaviorSharedObject:GetValue()
    return self._value;
end

return BehaviorSharedObject;