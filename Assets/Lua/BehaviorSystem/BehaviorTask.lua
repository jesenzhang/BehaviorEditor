local BehaviorTaskData = class("BehaviorTaskData",nil)

function BehaviorTaskData:ctor(task)  
    self.parallels = nil;
    self.task = task;  
    self:Reset(); 
end

function BehaviorTaskData:Reset()
    self.pushTime  = 0;
    self.stack = nil; 
    self:SetTaskStatus(TaskStatus.InActive);
    self.managed = false;
    self.behaviorID = -1;
    if self.parallels then
        self.parallels:Clear();
    end
end 

function  BehaviorTaskData:SetTaskBehaviorId(behaviorID)
    self.behaviorID = behaviorID;
end

function BehaviorTaskData:SetTaskStatus(status)
    if self.taskStatus ~= status then
        self.taskStatus = status;
        if status == TaskStatus.Success then
            self.task._debug:SetIcon("ExecutionSuccess");
        elseif status == TaskStatus.Failure then
            self.task._debug:SetIcon("ExecutionFailure");
        elseif status == TaskStatus.Running then
            self.task._debug:SetIcon("TaskBorderRunning",DebugGameObject.ICON_LAYOUT_FILL);
        else
            self.task._debug:SetIcon("");
        end
    end
end

function BehaviorTaskData:AddParallel(taskData)
    if self.parallels == nil then
        self.parallels = LinkedList.new();
    end
    taskData.managed = true;
    self.parallels:Add(taskData);
end

function BehaviorTaskData:RemoveParallel(taskData)
    if not taskData.managed then
        return;
    end
    taskData.managed = false;
    if self.parallels then
        self.parallels:Remove(taskData);
    end
end

BehaviorTask = class("BehaviorTask",nil)

function BehaviorTask:ctor(behavior,name)
    self._behavior = behavior;
    self._parent = nil;
    self._name = name;  
    self._instant = true;
    self._debug = DebugHelper.CreateDebugGameObject(behavior._debug,name or "Task");  
    self._debug:SetWatcher(self);
    self._debug:SetActive(false);  
    self._taskData = BehaviorTaskData.new(self);
end

function BehaviorTask:OnStart()   
end

function BehaviorTask:OnUpdate()
    return TaskStatus.Failure;
end

function BehaviorTask:OnAbort() 
end

function BehaviorTask:OnEnd()  
end

function BehaviorTask:OnReset() 
end

function BehaviorTask:IsLeaf()
    return true;
end

function BehaviorTask:SetName(name)
    self._name = name;
    self._debug:SetName(name)
end

function BehaviorTask:SetParent(parent)
    self._parent = parent;
    if parent then
        self._debug:SetParent(parent._debug);
    end
end

function BehaviorTask:GetParent()
    return self._parent;
end

function BehaviorTask:SetInstant(instant)
    self._instant = instant;
end

function BehaviorTask:IsInstant()
    return self._instant;
end

function BehaviorTask:Reset(recursive)
    self._taskData:Reset();
    self:OnReset();
end


function BehaviorTask:Abort()
    self:SetActive(false);
    self._taskData:Reset();
    self:OnAbort();
end

function BehaviorTask:Start(startID,stack)
    self._taskData.stack = stack;
    self._taskData:SetTaskStatus(TaskStatus.Running);
    self._taskData:SetTaskBehaviorId(startID);
    self:SetActive(true);
    self:OnStart();
end

function BehaviorTask:End(taskStatus)
    self:SetActive(false);
    self._taskData:SetTaskStatus(taskStatus);
    self._taskData.stack = nil;
    self:OnEnd();
end

function BehaviorTask:SetActive(active)
    self._debug:SetActive(active);
end

function BehaviorTask:GetVariable(name)
    return self._behavior:GetVariable(name);
end

function BehaviorTask:SetVariable(name,value)
    return self._behavior:SetVariable(name,value);
end

function BehaviorTask:GetVariableValue(name)
    local variable =  self._behavior:GetVariable(name);
    return variable:GetValue();
end

function  BehaviorTask:SetVariableValue(name,value)
    return self._behavior:SetVariableValue(name,value);
end 

function BehaviorTask:SetTaskIndex(index) 
    self._taskData.index = index;
end 

function BehaviorTask:SetTaskStatus(status)
    self._taskData:SetTaskStatus(status);
end 

function BehaviorTask:IsSameBehavior(behaviorID)
    return self._taskData.behaviorID == behaviorID;
end

function BehaviorTask:IsInStack()
    return self._taskData.stack ~= nil;
end

function BehaviorTask:GetTaskIndex()
    return self._taskData.index;
end

function BehaviorTask:GetTaskStack()
    if self._taskData.stack == nil then
        log("GetTaskStack is nil %s",self._name)
    end
    return self._taskData.stack;
end

function BehaviorTask:ClearTaskData()
    self._taskData:Reset();
end 

function BehaviorTask:Clone(behavior)
    local instance = self.class.new(behavior);
    for k,v in pairs(self) do
        if type(v) ~= "table" and type(v) ~= "userdata" then           
            instance[k] = v;
        elseif k ~= "_debug" and k ~= "_parent" and k ~="_children" and k ~= "_behavior"  and k ~= "_taskData" and k ~="class" then
            if v.class == BehaviorSharedBool or v.class == BehaviorSharedFloat or v.class == BehaviorSharedInt or v.class == BehaviorSharedString  or v.class == BehaviorSharedObject then
                if v._name then
                    instance[k] = behavior:GetVariable(v._name);
                else
                    instance[k] = v:Clone();
                end
            else
                print(self.class.__cname,k,v); 
            end
        end
    end
    instance:SetName(self._name);
    return instance;
end

return BehaviorTask,BehaviorTaskData;