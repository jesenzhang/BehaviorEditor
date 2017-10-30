ObjectPool = class("ObjectPool",nil)

function ObjectPool:ctor(creator,reseter,updater)
    self._poolSize = 1;
    self._maxSize = 10;
    self._creator = creator;
    self._reseter = reseter;
    self._updater = updater;
    self._pool = {};
end 

function ObjectPool:Init(poolSize,...)
    self._poolSize = poolSize;
    for i=1,self._poolSize,1 do 
        table.insert(self._pool,self:CreateObject(...));
    end
end

function ObjectPool:CreateObject(...)
    return self._creator(...);
end

function ObjectPool:Get(...)
    local count = #(self._pool);
    if count < 1 then
        if self._creator then
            return self:CreateObject(...),true;
        end
        return nil,false;
    end
    local obj = self._pool[count];
    table.remove( self._pool,count);
    if self._updater then
        self._updater(obj,...)
    end
    return obj,false;
end

function ObjectPool:GetMany(num,...)
    local result = {};
    local count = #(self._pool);

    if num <= count then
        for i=1,num,1 do 
            local obj = self._pool[#(self._pool)];
            table.remove( self._pool);
            if self._updater then
                self._updater(obj,...)
            end
            table.insert( result,obj);
        end
    else
        result = self._pool;
        self._pool = {};
        for i=count+1,num,1 do 
            local obj = self:CreateObject(...);
            table.insert( result,obj);
        end
    end

    return obj;
end

function ObjectPool:Return(obj)
    if self._reseter then
        self._reseter(obj);
    end
    if #(self._pool) <= self._maxSize then
        table.insert( self._pool,obj);
        return true;
    end
    return false;
end

return ObjectPool;