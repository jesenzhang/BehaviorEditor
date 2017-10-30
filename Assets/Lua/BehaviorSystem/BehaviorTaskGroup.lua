BehaviorTaskGroup = class("BehaviorTaskGroup",BehaviorTask)

function BehaviorTaskGroup:ctor(parent,name)
    BehaviorTask.ctor(self,parent,name);
    self._children = {}; 
    self._childCount = 0;
end

function BehaviorTaskGroup:CanParallelExecute()
    return false;
end

function BehaviorTaskGroup:OnChildExecuted(index,taskStatus) 
end

function BehaviorTaskGroup:OnChildStart(index) 
end

function BehaviorTaskGroup:CanExecute()
    return true;
end

function BehaviorTaskGroup:IsLeaf()
    return false;
end

function BehaviorTaskGroup:AddChild(child)
    child:SetParent(self);
    table.insert( self._children, child)   
    self._childCount = self._childCount + 1; 
end

function BehaviorTaskGroup:GetChildren()
    return self._children;
end

function BehaviorTaskGroup:CurrentChildIndex()
    return 1;
end

function BehaviorTaskGroup:Reset(recursive)
    if recursive then
        for i,child in ipairs(self._children) do 
            child:Reset(recursive);
        end
    end
    BehaviorTask.Reset(self,recursive);    
end

function BehaviorTaskGroup:GetParallels()
    return self._taskData.parallels;
end

function BehaviorTaskGroup:AddParallel(task)
    self._taskData:AddParallel(task._taskData);
end

function BehaviorTaskGroup:RemoveParallel(task)
    self._taskData:RemoveParallel(task._taskData);
end

function BehaviorTaskGroup:Clone(behavior)
    local instance = BehaviorTask.Clone(self,behavior);
    instance._childCount = 0;
    for k,v in ipairs(self._children) do
        local child = v:Clone(behavior);
        instance:AddChild(child);
    end
    return instance;
end

return BehaviorTaskGroup;