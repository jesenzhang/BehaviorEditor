GameScene = class("GameScene",nil)

function GameScene:ctor(name)
    self._name = name;
    self._objectManager = GameObjectManager.new(name,0);
    self._scene = nil;
end

function GameScene:Load(callback)
    local function OnLoadScene(error,name)
        print("OnLoadScene",error,name)
        if error == 0 then
            callback(name,self);
        else
            callback(name,nil);
        end
    end
    local function OnLoadSceneBundle(bundle) 
        if bundle then
            Framework.SceneManager.instance:LoadScene(bundle:Get(),OnLoadScene); 
        else
            callback(name,nil);
        end
    end 
    --ResourceManager.LoadBundle("Scene/"..self._name,OnLoadSceneBundle);
    ResourceManager.LoadScene("Scene/"..self._name,OnLoadScene);    
end

function GameScene:UnLoad()
    self._objectManager:Clear();
end

function GameScene:LoadGameObject(path,callback)
    return self._objectManager:LoadGameObject(path,callback,false);
end

return GameScene;
