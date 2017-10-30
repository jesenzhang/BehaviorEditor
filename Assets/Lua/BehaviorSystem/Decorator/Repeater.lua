Repeater = class("Repeater",BehaviorDecorator)

function Repeater:OnStart()
    BehaviorTask.OnStart(self)
    self._counter = 0;
    self._childStatus = TaskStatus.InActive; 
end

function Repeater:OnChildExecuted(task,taskStatus) 
    self._childStatus = taskStatus;
    self._counter = self._counter + 1;
end 

function Repeater:GetTaskStatus() 
    if self._endOnFailure and self._childStatus == TaskStatus.Failure then
        return TaskStatus.Failure;
    end
    if self._counter < self._loop or self._forever:GetValue() then 
        return TaskStatus.Running;
    end
    return self._childStatus;
end

function Repeater:CanExecute()
    --log("Repeater:CanExecute %s",self._counter < self._loop);
    return (self._counter < self._loop or self._forever:GetValue()) and (not self._endOnFailure or self._childStatus ~= TaskStatus.Failure) ;
end

return Repeater;