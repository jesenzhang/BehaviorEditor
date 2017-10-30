Selector = class("Selector",BehaviorComposite)


function Selector:OnStart() 
    self._currentChild = 1; 
    self._childStatus = TaskStatus.InActive;
end

function Selector:OnChildStart(childIndex)
    self._currentChild = self._currentChild + 1;
    self._childStatus = TaskStatus.Running;
end

function Selector:OnChildExecuted(childIndex,taskStatus)
    self._childStatus = taskStatus;
end

function Selector:GetTaskStatus()
    return self._childStatus;
end

function Selector:CurrentChildIndex()
    return self._currentChild;
end

function Selector:CanExecute()
    return self._currentChild <= self._childCount and self._childStatus ~=TaskStatus.Success;
end

return Selector;