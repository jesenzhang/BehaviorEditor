require("BehaviorSystem/BehaviorTask")
require("BehaviorSystem/BehaviorTaskGroup")
require("BehaviorSystem/BehaviorComposite")
require("BehaviorSystem/BehaviorConditional")
require("BehaviorSystem/BehaviorDecorator")
require("BehaviorSystem/BehaviorAction")
require("BehaviorSystem/BehaviorSharedVariable")

BehaviorSystem = class("BehaviorSystem",nil)

TaskStatus = {};
TaskStatus.InActive = 0;
TaskStatus.Failure = 1;
TaskStatus.Success = 2; 
TaskStatus.Running = 3;
TaskStatus.Abort = 4;

local stackPool = ObjectPool.new(
    function(...)
        return Stack.new();
    end,
    function(obj)
        obj:Clear();
    end
);

function BehaviorSystem:ctor(parent,name)
    self._parent = parent;
    self._name = name;
    self._root = nil;
    self._nodes = {};
    self._variables = {};
    self._activeStack = LinkedList.new(); 
    self._newStack = LinkedList.new(); 
    self._dirtyStack = LinkedList.new(); 
    self._active = false;
    self._startID = 0;
    self._updateFrames = 0;
    self._endCallback = nil;
    self._logTaskChanges = false;
    self._userData = nil;

    self._debug = DebugHelper.CreateDebugGameObject(nil,self._name);
end
 
 
function BehaviorSystem:SetRoot(node)
    self._root = node;
end

function BehaviorSystem:AddNode(node)
    table.insert(self._nodes,node);
end

function BehaviorSystem:SetVariable(name,variable) 
    self._variables[name] = variable;
end 

function BehaviorSystem:GetVariable(name,variable) 
    return self._variables[name];
end 

function BehaviorSystem:SetVariableValue(name,value)
    local variable = self._variables[name];
    if variable then
        variable:SetValue(value);
        return true;
    end
    return false;
end

function BehaviorSystem:GetVariableValue(name,defaultValue) 
    local variable = self._variables[name];
    if variable then
        return variable:GetValue();
    end
    return defaultValue;
end

function BehaviorSystem:SetUserData(userData)
    self._userData = userData;
end

function BehaviorSystem:GetUserData()
    return self._userData;
end

function BehaviorSystem:GetName()
    return self._name;
end

function BehaviorSystem:SetEndCallback(endCallback)
    self._endCallback = endCallback;
end

function BehaviorSystem:Start()
    log("BehaviorSystem:Start %s",self._name)
    UpdateBeat:Remove(self.Start,self);

    self._debug:SetActive(true);

    self._updateFrames = 0;
    self._startID = self._startID + 1;
    self._active = true;  
    self._endStatus = TaskStatus.InActive;    
    local stack = self:AddStack(true); 
    self:RunTask(self._root,stack);
    if self._active then
        UpdateBeat:Add(self.Update,self);
    else
        self:End(self._endStatus);
    end
end 

function BehaviorSystem:End(endStatus)
    UpdateBeat:Remove(self.Update,self); 

    self._debug:SetActive(false);
    self._active = false;
    self:ClearStack(true);    
    if endStatus then
        if self._endCallback then
            self._endCallback(self,endStatus)
        end
    end
end

function BehaviorSystem:Clean()
    self:Stop();
end

function BehaviorSystem:Stop() 
    UpdateBeat:Remove(self.Start,self); 
    self:End(TaskStatus.Abort);
end 

function BehaviorSystem:Restart()
    log("BehaviorSystem:Restart %s",self._name)
    self:Stop();
    UpdateBeat:Add(self.Start,self);    
end

function BehaviorSystem:Pause()
    self._active = false;
end

function BehaviorSystem:Resume()
    self._active = true;
end

function BehaviorSystem:RunParentTask(task,stack) 
    local children = task:GetChildren();
    if task:CanParallelExecute() then
        if task:CanExecute() then
            for i,child in ipairs(children) do
                local childStack = self:AddStack();
                child:SetTaskIndex(i); 
                task:OnChildStart(i);
                local taskStatus = self:RunTask(child,childStack);
                if not self._active then
                    break;
                end
                if taskStatus == TaskStatus.Running then
                    task:AddParallel(child);
                end
            end
        end
    else        
        while task:CanExecute() do
            local currentChildIndex = task:CurrentChildIndex();
            local child = children[currentChildIndex];
            child:SetTaskIndex(stack,currentChildIndex); 
            task:OnChildStart(currentChildIndex);
            local taskStatus = self:RunTask(child,stack);
            if not self._active or taskStatus == TaskStatus.Running or task:GetTaskStatus() == TaskStatus.Running then
                break;
            end
        end
    end
end

function BehaviorSystem:RunTask(task,stack)
    if self._logTaskChanges then
        --log("run %s",task._name)
    end
    local taskStatus = TaskStatus.InActive;
    if not task:IsInStack(stack) then
        self:PushTask(task,stack);       
    end
    
    if task:IsInstant() then
        if task:IsLeaf() then
            taskStatus = task:OnUpdate();     
        else  
            self:RunParentTask(task,stack);
            taskStatus = task:GetTaskStatus(); 
            if self._logTaskChanges then
                log("RunParentTask %s status=%s",task._name,taskStatus)
            end
        end  
        if taskStatus ~= TaskStatus.Running and task:IsInStack(stack) then
            if self._active then
                self:PopTask(task,taskStatus,task:GetTaskStack(),true,true)
            end
        end
    else 
        taskStatus = TaskStatus.Running;
    end    
    
    return taskStatus;
end

function BehaviorSystem:UpdateTask(task)
    if task:IsLeaf() then
        return task:OnUpdate();
    else
        self:RunParentTask(task,task:GetTaskStack());
    end
    return task:GetTaskStatus();
end

function BehaviorSystem:PushTask(task,stack)  
    if self._logTaskChanges then
        log("push %s",task._name)
    end
    stack:Push(task);  
    task:Reset(false);
    task:Start(self._startID,stack);    
end

local function OnChildTaskPop(task)
    --log("child pop %s",task._name)
    task:Abort(); 
end

function BehaviorSystem:PopTask(task,taskStatus,stack,popChildren,updateParent)
    if self._logTaskChanges then
        log("pop %s",task._name)
    end    

    if popChildren and not task:IsLeaf() then     
        local parallels = task:GetParallels();
        if parallels then 
            local current = parallels:First();
            while current do 
                if self._logTaskChanges then
                    log("pop child %s",current.element.task._name)
                end  
                self:PopTask(current.element.task,TaskStatus.Abort,current.element.stack,true,false);
                current = current.next;
            end
        end
    end 

    if task._taskData.stack ~= stack then
        logError("pop0 error %s -> %s -> %s",task._name,task._taskData.stack,stack) 
    end
    
    local result = stack:PopTo(task,OnChildTaskPop);    
    --local result = stack:Pop();
    if result ~= task then
        logError("pop error %s -> %s",task._name,result) 
    end  
    if stack:Count() == 0 then 
        self:RemoveStack(stack);
    end 
    task:End(taskStatus); 
    if updateParent then
        local parent = task:GetParent();
        if parent then       
            parent:OnChildExecuted(task:GetTaskIndex(),taskStatus);             
            if parent:CanParallelExecute() then
                parent:RemoveParallel(task);
            end
        else
            self:End(taskStatus)
        end  
    end    
end
 
function BehaviorSystem:AddStack(force)
    local stack = stackPool:Get();

    --log("AddStack %s",stack)

    if force then
        self._activeStack:Add(stack);
    else        
        self._newStack:Add(stack);
    end    
    return stack;
end

function BehaviorSystem:RemoveStack(stack,force) 
    --log("RemoveStack %s",stack)
    if force then
        stackPool:Return(stack);
        self._activeStack:Remove(stack);
    else        
        if not self._newStack:Remove(stack) then
            self._dirtyStack:Add(stack);
        end
    end
end

function BehaviorSystem:ReevaluateStack()
    local current = self._newStack:First();
    while current do
        --print("Add",current)
        self._activeStack:Add(current.element);
        current = current.next;
    end

    current = self._dirtyStack:First();
    while current do
        --print("Remove",current)
        self._activeStack:Remove(current.element);
        current = current.next;
    end  
    
    self._newStack:Clear();
    self._dirtyStack:Clear();
end

function BehaviorSystem:ClearStack(abortTask)
    if abortTask then
        local current = self._newStack:First();
        while current do
            local stack = current.element;
            while stack:Count() > 0 do  
                stack:Pop():Abort();
            end
            current = current.next;
        end

        current = self._activeStack:First();
        while current do
            local stack = current.element;
            while stack:Count() > 0 do  
                stack:Pop():Abort();
            end
            current = current.next;
        end
    end

    self._activeStack:Clear();
    self._newStack:Clear();
    self._dirtyStack:Clear();
end 

function BehaviorSystem:Update() 
    if not self._active then return end

    self._updateFrames = self._updateFrames + 1;

    local current = self._activeStack:First();
    while current and self._active do 
        local stack = current.element;
        while stack:Count() > 0 and self._active do 
            local task = stack:Peek();
            local taskStatus = self:UpdateTask(task); 
            if self._active then
                if taskStatus == TaskStatus.Success then
                    self:PopTask(task,taskStatus,stack,true,true); 
                elseif taskStatus == TaskStatus.Failure then
                    self:PopTask(task,taskStatus,stack,true,true); 
                elseif taskStatus == TaskStatus.Running then 
                    break;
                else
                    print("unknown task status ",task._name,taskStatus)
                    break;
                end     
            end                     
        end
        --print(self._activeStack:Count(),current.next)
        current = current.next;
    end
    self:ReevaluateStack();
end

function BehaviorSystem:Clone()
    local bt = BehaviorSystem.new(self._parent,self._name);
    for k,v in pairs(self._variables) do
        bt[k] = v:Clone();
    end
    bt._root = self._root:Clone(bt);
    return bt;
end

return BehaviorSystem;
