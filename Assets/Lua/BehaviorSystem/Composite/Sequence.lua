Sequence = class("Sequence",BehaviorComposite)

function Sequence:OnStart() 
    self._currentChild = 1; 
    self._childStatus = TaskStatus.InActive;
end

function Sequence:OnChildStart(childIndex)
    self._currentChild = self._currentChild + 1;
    self._childStatus = TaskStatus.Running;
end

function Sequence:OnChildExecuted(childIndex,taskStatus)
    self._childStatus = taskStatus;
end

function Sequence:GetTaskStatus()
    return self._childStatus;
end

function Sequence:CurrentChildIndex()
    return self._currentChild;
end

function Sequence:CanExecute() 
    return self._currentChild <= self._childCount and self._childStatus ~=TaskStatus.Failure;
end

return Sequence;