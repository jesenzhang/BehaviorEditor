BehaviorSharedString = class("BehaviorSharedString",BehaviorSharedVariable) 

function BehaviorSharedString:ctor(value)
    self.super.ctor(self,BehaviorSharedVariable.TYPE_STRING); 
    self._value = value;
end

function BehaviorSharedString:GetValue()
    return self._value;
end

return BehaviorSharedString;