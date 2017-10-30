SceneManagmentHelper = class("SceneManagmentHelper",nil)

local SCENE_UPDATE = true;

function SceneManagmentHelper.AddCharactor(charactor)
    charactor:SyncPos();
    SceneManagment.Current():AddCharactor(charactor);
end

function SceneManagmentHelper.RemoveCharactor(charactor)
    SceneManagment.Current():RemoveCharactor(charactor);
end

function SceneManagmentHelper.SetCenterCharactor(charactor)
    charactor:SyncPos();
    SceneManagment.Current():Init(charactor:GetPos());
end

function SceneManagmentHelper.UpdateCharactor(charactor) 
    charactor:SyncPos();
    if charactor:IsSelf() then
        SceneManagment.Current():UpdateCenter(charactor:GetPos()); 
    end
    if SCENE_UPDATE then
        SceneManagment.Current():UpdateCharactor(charactor);
    end
end

function SceneManagmentHelper.FindCharactors(pos,radius,filterFunc,sortFunc)
    return SceneManagment.Current():FindCharactors(pos,radius,filterFunc,sortFunc);
end

function SceneManagmentHelper.FindCharactorsWithArea(area,filterFunc,sortFunc)
    return SceneManagment.Current():FindCharactorsWithArea(area,filterFunc,sortFunc);
end

function SceneManagmentHelper.GetSceneBounds()
    local minX = 10000;
    local minZ = 10000;
    local maxX = -10000;
    local maxZ = -10000;

   local renderers = UnityEngine.GameObject.FindObjectsOfType(typeof(UnityEngine.MeshRenderer));

   for i=0,renderers.Length-1,1 do 
        local renderer = renderers[i];
        local min = renderer.bounds.min;
        local max = renderer.bounds.max;
        if min.x < minX then
            minX = min.x;
        end
        if max.x > maxX then
            maxX = max.x;
        end
        if min.z < minZ then
            minZ = min.z;
        end
        if max.z > maxZ then
            maxZ = max.z;
        end
   end

   local sizeX = maxX - minX;
   local sizeZ = maxZ - minZ;

   GameLog.LogError("SceneBounds %f,%f,%f,%f",minX,minZ,sizeX,sizeZ)

   return UnityEngine.Bounds.New(Vector3(minX + sizeX/2,0,minZ + sizeZ / 2),Vector3(sizeX,0,sizeZ))
end

function SceneManagmentHelper.CreateSceneManagment(visibleSize,maxCharactor)
    require("SceneManagment/SceneManagment")
    local worldBounds = SceneManagmentHelper.GetSceneBounds();
    local scene = SceneManagment.NewScene(worldBounds,visibleSize or 50,maxCharactor or 10);
    if SCENE_UPDATE then
        scene:Start();
    end
end

return SceneManagmentHelper;