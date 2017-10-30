UntilFailure = class("UntilFailure",BehaviorDecorator)

function UntilFailure:OnStart()
    BehaviorTask.OnStart(self)
    self._executionStatus = TaskStatus.InActive; 
end

function UntilFailure:OnChildExecuted(task,taskStatus) 
    self._executionStatus = taskStatus; 
end 

function UntilFailure:GetTaskStatus() 
    if self._executionStatus ~= TaskStatus.Failure then 
        return TaskStatus.Running;
    end
    return TaskStatus.Success; 
end

function UntilFailure:CanExecute() 
    return self._executionStatus ~= TaskStatus.Failure;
end

return UntilFailure;