require("Framework/Resource/GameObjectManager")

GameApplication = class("GameApplication",nil)

local _current = nil;

function GameApplication:ctor() 
    self._objectManager = GameObjectManager.new("Application",20);
    self._currentScene = nil;
end

function GameApplication:Init(firstSceneName)
    self:LoadScene(firstSceneName);
end

function GameApplication:LoadScene(name,callback)
    if self._currentScene then
        self._currentScene:UnLoad();
        self._currentScene = nil;
    end
    self._currentScene = GameScene.new(name);
    self._currentScene:Load(callback);
    ResourceManager.Clear(true);
    return self._currentScene;
end

function GameApplication.CurrentScene()
    return _current._currentScene;
end

function GameApplication.LoadGameScene(name,callback)
    return _current:LoadScene(name,callback);
end

function GameApplication.LoadGameObject(path,callback)
    return _current._objectManager:LoadGameObject(path,callback,true);
end

function GameApplication.Current()    
    return _current;
end 

function GameApplication.Init()
    _current = GameApplication.new();
    _current._currentScene = GameScene.new("logo");
end

function GameApplication.Destroy()
    _current = nil;
end

return GameApplication;
