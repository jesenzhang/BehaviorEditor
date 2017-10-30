PriorityQueue = class("PriorityQueue",LinkedList)

function PriorityQueue:Add(element,priority)
    if self._size == 0 then
        local node = LinkedList.Add(self,element)
        node.priority = priority;
        return node;
    end
    
    local current = self._last;
    while current and current.priority > priority do 
        current = current.prev;
    end

    if current then
        local node = self:AddBefore(current,element);
        node.priority = priority;
        return node;
    end

    return nil;
end

return PriorityQueue;