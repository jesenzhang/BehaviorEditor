UntilSuccess = class("UntilSuccess",BehaviorDecorator)

function UntilSuccess:OnStart()
    BehaviorTask.OnStart(self)
    self._executionStatus = TaskStatus.InActive; 
end

function UntilSuccess:OnChildExecuted(task,taskStatus) 
    self._executionStatus = taskStatus; 
end 

function UntilSuccess:GetTaskStatus() 
    if self._executionStatus ~= TaskStatus.Success then 
        return TaskStatus.Running;
    end
    return TaskStatus.Success; 
end

function UntilSuccess:CanExecute() 
    return self._executionStatus ~= TaskStatus.Success;
end

return UntilSuccess;