Reverter = class("Reverter",BehaviorDecorator)

function Reverter:OnStart()
    BehaviorTask.OnStart(self)
    self._executionStatus = TaskStatus.InActive; 
end

function Reverter:OnChildExecuted(task,taskStatus) 
    self._executionStatus = taskStatus; 
end 

function Reverter:GetTaskStatus() 
    if self._executionStatus == TaskStatus.Running then 
        return TaskStatus.Running;
    end

    if self._executionStatus == TaskStatus.Failure then 
        return TaskStatus.Success;
    end

    if self._executionStatus == TaskStatus.Success then 
        return TaskStatus.Failure;
    end

    return self._executionStatus; 
end

function Reverter:CanExecute() 
    return self._executionStatus ~= TaskStatus.Failure and self._executionStatus ~= TaskStatus.Success;
end

return Reverter;