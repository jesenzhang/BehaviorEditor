local CacheObject = require("Framework/Cache/CacheObject") 

local cachePool = ObjectPool.new(
    function(key,obj)
        return CacheObject.new(key,obj);
    end,
    function(obj)
        obj:Reset();
    end);

local Cache = class("Cache",nil)

function Cache:ctor(maxSize)
    self._cache = {};
    self._queue = LinkedList.new();
    self._maxSize = maxSize;
end

function Cache:Put(key,obj)
    local cacheObj,isNew = cachePool:Get(key,obj);
    if not isNew then
        cacheObj:Update(key,obj);
        self._queue:SetLast(cacheObj._node); 
    else
        cacheObj._node = self._queue:Add(cacheObj)
    end
    self._cache[key] = cacheObj;
end

function Cache:Remove(key)
    local cacheObj = self._cache[key];
    if cacheObj then
        cachePool:Return(cacheObj);
        self._cache[key] = nil;
        self._queue:RemoveAt(cacheObj._node)
    end    
end

function Cache:Get(key)
    local cacheObj = self._cache[key];
    if cacheObj then
        self._queue:SetLast(cacheObj._node);
        return cacheObj:Get();
    end
    return nil;
end

function Cache:Clear(unused)
    for k,v in pairs(self._cache) do 
        cachePool:Return(v);
    end
    self._cache = {};
end

function Cache:Update()
    if self._queue:Count() > self._maxSize then
        local first = self._queue:First();
        self:Remove(first.element._name);
    end
end

return Cache;