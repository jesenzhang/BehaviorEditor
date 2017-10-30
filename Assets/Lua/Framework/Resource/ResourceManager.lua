local ManagedBundle = require("Framework/Core/ManagedBundle")
local ManagedAssetObject = require("Framework/Core/ManagedAssetObject")

ResourceManager = class("ResourceManager",nil)

--local DEFAULT_SEARCH_PATH = UnityEngine.Application.dataPath .. "/../Export"; 

local DEFAULT_SEARCH_PATH = "D:/dev/Update_IOS/Res"

local searchPaths = {};

local bundles = nil;

local objects = nil;
 
function ResourceManager.LoadData(path,callback)
    local fullpath = searchPaths[1].."/"..path;
    Framework.BytesManager.instance:LoadData(fullpath,callback);
    return true;
end

function ResourceManager.LoadBundle(path,callback) 
    local obj = bundles:Get(path);
    if obj then
        if not obj:IsNull() then
            callback(obj)
            return;
        else
            obj:Reset();
        end
        return;
    end
    local function OnLoadResource(error,bundle)
        if bundle then
            local obj = ManagedBundle.Create(path,bundle);
            bundles:Put(path,obj);
            callback(obj);
        else
            callback(nil);
        end        
    end 
    print("LoadAssetBundle ",path)
    local fullpath = searchPaths[1].."/"..path;
    Framework.AssetBundleManager.instance:LoadAssetBundle(fullpath,OnLoadResource);
    return true;
end 

function ResourceManager.LoadObject(path,callback)    
    local obj = objects:Get(path);
    if obj then
        if not obj:IsNull() then
            callback(obj)
            return;
        else
            obj:Reset();
        end
    end
    local function OnLoadBundle(bundle)
        if bundle then
            local function OnLoadObject(error,object)
                if object then
                    local obj =  ManagedAssetObject.Create(path,object,bundle); 
                    objects:Put(path,obj);
                    callback(obj);
                else 
                    callback(nil);
                end
            end
            print("LoadObject ",path)
            Framework.AssetObjectManager.instance:LoadObject(bundle:Get(),OnLoadObject);
        else
            callback(nil);        
        end
    end    
    ResourceManager.LoadBundle(path,OnLoadBundle)
end

function ResourceManager.LoadScene(path,callback) 
    local fullpath = searchPaths[1].."/"..path;
    Framework.SceneManager.instance:LoadSceneByName(fullpath,callback); 
end
 
function ResourceManager.Clear(unused)
    objects:Clear(unused);
    bundles:Clear(unused);  
end 

function ResourceManager.Init()
    print("ResourceManager.Init ",DEFAULT_SEARCH_PATH)
    searchPaths = {DEFAULT_SEARCH_PATH}; 
    bundles = CacheManager.GetCache("bundles");
    objects = CacheManager.GetCache("assetobjects");
end

function ResourceManager.Destroy()
    searchPaths = nil;    
    objects:Clear();
    bundles:Clear();
end

function ResourceManager.AddSearchPath(path)
    table.insert( searchPaths, path );
end

function ResourceManager.ClearSearchPath(resetDefault)
    if resetDefault then
        searchPaths = {DEFAULT_SEARCH_PATH};
    else
        searchPaths = {};
    end    
end

return ResourceManager;
