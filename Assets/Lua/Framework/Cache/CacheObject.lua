local CacheObject = class("CacheObject",nil)

function CacheObject:ctor(name,obj)
    self._name = name;
    self._obj = obj;
    self._activeTime = UnityEngine.Time.time;
    if self._obj and self._obj.Retain then
        self._obj:Retain();
    end
end

function CacheObject:Update(name,obj)
    self._name = name;
    if self._obj ~= obj then
        if self._obj and self._obj.Release then
            self._obj:Release();
        end
        self._obj = obj;
        if self._obj and self._obj.Retain then
            self._obj:Retain();
        end
    end
    self._activeTime = UnityEngine.Time.time;
end

function CacheObject:Reset()
    if self._obj and self._obj.Release then
        self._obj:Release();
    end
    self._name = nil;
    self._obj = nil;
    self._activeTime = 0;
end

function CacheObject:Get()
    self._activeTime = UnityEngine.Time.time;
    return self._obj;
end

function CacheObject:IsUnused()
    if self._obj and self._obj._reference then
        return self._obj._reference == 1;
    end
    return false;
end

return CacheObject;
 