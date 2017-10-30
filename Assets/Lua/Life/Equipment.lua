local CommandDirector = require("Life/Commands/CommandDirector")
local PlayActionCommand = require("Life/Commands/PlayActionCommand")

Equipment = class("Equipment",nil) 

function Equipment:ctor(life)
    self._life = life;
    self._commands = CommandDirector.new();
end

function Equipment:Reset()
    self._go = nil;
    self._animator = nil;
    self._commands:Clear();
end

function Equipment:Init(equipInfo)
    self:LoadModel(equipInfo.model);
end 

function Equipment:Destroy()
    self:UnloadModel();
end 

function Equipment:PlayAction(action,crossFade)
    local command = PlayActionCommand.Create(action,crossFade);
    if self._animator then
        command:Execute(self);
    else
        self._commands:Push(command);
    end
end

function Equipment:ExecuteCommands()
    self._commands:Execute(self);
end

function Equipment:LoadModel(name)
    self._go = nil;
    self._animator = nil;
    local controller = nil;

    local function OnLoadFinish()
        self._animator = self._go:Get():GetComponent(typeof(UnityEngine.Animator));
        self._go:AddRefer(controller);
        self._animator.runtimeAnimatorController = controller:Get();
        self:ExecuteCommands();
    end
    
    local function OnLoadGameObject(obj) 
        self._go = obj;
        self._go:SetParent(self._life._go);  
        if controller then
            OnLoadFinish();	
        end
    end
    
    local function OnLoadAnimatorController(obj) 
        controller = obj;
        if self._go then
            OnLoadFinish();
        end
    end

    local modelPath = self._life:GetModelPath(name);
    local animatorPath = self._life:GetAnimatorPath(name);

    GameApplication.CurrentScene():LoadGameObject(modelPath,OnLoadGameObject);
	ResourceManager.LoadObject(animatorPath,OnLoadAnimatorController);
end

function Equipment:UnloadModel()
    self._animator.runtimeAnimatorController = nil;
    self._animator = nil;
    self._go:Return(); 
    self._go = nil;    
end

return Equipment;