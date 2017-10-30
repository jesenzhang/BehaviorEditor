Parallel = class("Parallel",BehaviorComposite)
 

function Parallel:OnStart() 
    self._currentChild = 1;
    self._childStatus = {};
    for i=1,self._childCount,1 do 
        self._childStatus[i] = TaskStatus.InActive;
    end
end

function Parallel:OnChildStart(childIndex)
    self._currentChild = self._currentChild + 1;
    self._childStatus[childIndex] = TaskStatus.Running;
end

function Parallel:OnChildExecuted(childIndex,taskStatus)  
    self._childStatus[childIndex] = taskStatus; 
end

function Parallel:GetTaskStatus()
    local failureCount = 0;
    local successCount = 0;
    for index,status in ipairs(self._childStatus) do 
        if status == TaskStatus.Failure then
            failureCount = failureCount + 1;
        elseif status == TaskStatus.Success then
            successCount = successCount + 1;
        end
    end
    if failureCount > 0 then
        return TaskStatus.Failure;
    end
    if successCount == self._childCount then
        return TaskStatus.Success;
    end
    return TaskStatus.Running;
end

function Parallel:CurrentChildIndex()
    return self._currentChild;
end

function Parallel:CanExecute()
    return self._currentChild <= self._childCount;
end

function Parallel:CanParallelExecute()
    return true;
end

return Parallel;