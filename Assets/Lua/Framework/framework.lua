require("Framework/Container/container")
require("Framework/Core/ObjectPool")
require("Framework/Utils/MathUtils")
require("Framework/Cache/CacheManager")
require("Framework/Resource/ResourceManager")
require("Framework/Resource/GameObjectManager")
require("DebugSystem/DebugHelper")
require("BehaviorSystem/BehaviorSystem")
require("BehaviorSystem/Parser/BehaviorSystemParser"); 
require("SceneManagment/SceneManagmentHelper")
require("Framework/GameScene")
require("Framework/GameApplication")

function log( format,... ) 
    Debugger.Log(format,...);
end

function logError( format,... )
    Debugger.LogError(format,...);
end

--TaskStatus = BehaviorDesigner.Runtime.Tasks.TaskStatus;