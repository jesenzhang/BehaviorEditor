local Cache = require("Framework/Cache/Cache")

CacheManager = {};

local caches = {};

function CacheManager.GetCache(name,maxSize)
   local cache = Cache.new(10 or maxSize);
   table.insert(caches,cache);
   return cache;
end

function CacheManager.Update()
    for _,cache in ipairs(caches) do 
        cache:Update();
    end
end

function CacheManager.Init()
    UpdateBeat:Add(CacheManager.Update);
end

function CacheManager.Destroy()
    UpdateBeat:Remove(CacheManager.Update);
end

return CacheManager;