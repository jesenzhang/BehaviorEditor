local ManagedArray = class("ManagedArray",nil)

function ManagedArray:ctor(...)
    self:Set(...)
end

function ManagedArray:Set(...)
    self._array = {...};
    self._size = #(self._array);
    self.values = self._array;
    for i,v in ipairs(self._array) do
        v:Retain();
    end
end

function ManagedArray:Count()
    return self._size;
end

function ManagedArray:Get(index)
    return self._array[index];
end

function ManagedArray:Add(element,retain)
    if retain then
        element:Retain();
    end
    self._size = self._size + 1;    
    table.insert(self._array,element)
end  

function ManagedArray:Remove(element,release)
    for i,v in ipairs(self._array) do
        if v == element then
            table.remove(self._array,i);
            self._size = self._size - 1;
            if release then
                element:Release();
            end
            break;
        end
    end
end

function ManagedArray:Clear(release)
    if self._size == 0 then return end
    
    if release then
        for i,v in ipairs(self._array) do
            v:Release();
        end
    end
    
    self._array = {};
    self.values = self._array;
    self._size = 0;
end

return ManagedArray;