local PlayActionCommand = class("PlayActionCommand",nil)

function PlayActionCommand:ctor(action,crossTime) 
    self._action = action;
    self._crossTime = crossTime;
end

function PlayActionCommand:Execute(equip) 
    if self._crossTime and self._crossTime > 0 then
        equip._animator:CrossFade(self._action,self._crossTime)
    else
        equip._animator:Play(self._action);        
    end
end

function PlayActionCommand.Create(action,crossTime)
    return PlayActionCommand.new(action,crossTime);
end

return PlayActionCommand;