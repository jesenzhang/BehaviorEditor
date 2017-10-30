BehaviorSharedInt = class("BehaviorSharedInt",BehaviorSharedVariable) 

function BehaviorSharedInt:ctor(value)
    self.super.ctor(self,BehaviorSharedVariable.TYPE_INTEGER); 
    self._value = value;
end

function BehaviorSharedInt:GetValue()
    return self._value;
end

return BehaviorSharedInt;