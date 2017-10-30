local BehaviorData = require "Data/BehaviorData"; 

BehaviorAI = class("BehaviorAI",nil)



function BehaviorAI:ctor(name)
    self._behavior = BehaviorData.GetBehaviorTree(name); 
    self._active = false;
    self._started = false;
end

function BehaviorAI:Reset()
    if self._active then
        self._behavior:Restart();
    end
end

function BehaviorAI:Clean()
    self._behavior:Stop();
end

function BehaviorAI:SetAIFreeze(freeze)
    self:SetActive(not freeze);
end

function BehaviorAI:SetActive(active)
    if self._active == active then return end
    self._active = active;

    if active then
        if not self._started then
            self._behavior:Start();
            self._started = true;
        else
            self._behavior:Resume();
        end
    else
        self._behavior:Pause(); 
    end
end

function BehaviorAI:SetLife(life)
    self._behavior:SetUserData(life);
end

function BehaviorAI:BeAttacked(attacker)
    self._behavior:SetVariableValue("Hited",true);
    self._behavior:SetVariable("Hiter",attacker);
end

return BehaviorAI;
