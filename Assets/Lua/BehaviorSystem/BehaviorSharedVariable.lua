BehaviorSharedVariable = class("BehaviorSharedVariable",nil)

BehaviorSharedVariable.TYPE_INTEGER = 0;
BehaviorSharedVariable.TYPE_FLOAT = 1;
BehaviorSharedVariable.TYPE_BOOLEAN = 2;
BehaviorSharedVariable.TYPE_STRING = 3;
BehaviorSharedVariable.TYPE_OBJECT = 4;


function BehaviorSharedVariable:ctor(type)
    self._type =  type;
    self._value = nil;
    self._name = nil;
end

function BehaviorSharedVariable:GetType()
    return self._type;
end

function BehaviorSharedVariable:GetValue()
    return self._value;
end

function BehaviorSharedVariable:SetValue(value)
    if type(self._value) == type(value) then
        self._value = value;
    else
        logError("BehaviorSharedVariable:SetValue error %s->%s",self._value,value)
    end    
end

function BehaviorSharedVariable:SetName(name)
    self._name = name;
end

function BehaviorSharedVariable:Clone()
    local instance = self.class.new();
    for k,v in pairs(self) do
        instance[k] = v;
    end
    return instance;
end

return BehaviorSharedVariable;