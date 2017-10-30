require("SceneManagment/QuadTree/QuadAreaCircle")
require("SceneManagment/QuadTree/QuadAreaBox")
require("SceneManagment/QuadTree/QuadAreaCurve")


QuadTreeNode = class("QuadTreeNode",nil)

function QuadTreeNode:ctor(parent,id,x,y,width,height,threadhold) 
    self._parent = parent;
    self._id = id;
    self._contents = {};
    self._nodes = nil;
    self._threadhold = threadhold or 2;
    self._area = QuadAreaBox.new(x,y,width,height);
    local parentdebug = nil;
    if parent then
        parentdebug = parent._debug;
    end
    self._debug = DebugHelper.CreateDebugGameObject(parentdebug,self:ToString())
    self._debug:SetPosition(Vector3(x+width/2,0,y+height/2));
    self._debug:SetSize(Vector3(width,100,height));
end

function QuadTreeNode:GetParent()
    return self._parent;
end

function QuadTreeNode:IsEmpty()
    return self._nodes == nil and #(self._contents) == 0
end

function QuadTreeNode:ToString()
    return string.format("Node-%d-%s",self._id,self._area:ToString());
end

function QuadTreeNode:Insert(item)
    --GameLog.Log("QuadTreeNode:Insert %s to %s ",item:ToString(),self._area:ToString())
    if not self._area:Contains(item) then
        return false;
    end
    if self._nodes == nil then
        self:CreateNodes();
    end
    if self._nodes then
        for _,node in ipairs(self._nodes) do
            if node._area:Contains(item) then
                return node:Insert(item);
            end
        end
    end    
    item:SetNode(self);
    table.insert( self._contents,item);
    return true;
end

function QuadTreeNode:CreateNodes()
    if self._area.width * self._area.height < self._threadhold then
        return;
    end

    local halfWidth = self._area.width / 2;
    local halfHeight = self._area.height / 2; 

    local node1 = self._tree:CreateNode(self,self._area.x,self._area.y, halfWidth,halfHeight);
    local node2 = self._tree:CreateNode(self,self._area.x,self._area.y + halfHeight, halfWidth,halfHeight);
    local node3 = self._tree:CreateNode(self,self._area.x+halfWidth,self._area.y+halfHeight, halfWidth,halfHeight);
    local node4 = self._tree:CreateNode(self,self._area.x+halfWidth,self._area.y, halfWidth,halfHeight);
 
    self._nodes = {};

    table.insert(self._nodes,node1);
    table.insert(self._nodes,node2);
    table.insert(self._nodes,node3);
    table.insert(self._nodes,node4);
end

function QuadTreeNode:RemoveContent(item)
    for k,v in ipairs(self._contents) do
        if v == item then
            table.remove(self._contents,k);
            item:SetNode(nil);
            return true;
        end
    end
    return false;
end

function QuadTreeNode:Remove(item) 
    if not self._area:Contains(item) then
        return false;
    end
    if self:RemoveContent(item) then
        return true;
    end
    if self._nodes then
        for _,node in ipairs(self._nodes) do
            if node._area:Contains(item) then
                return node:Remove(item);
            end
        end
    end  

    return false;  
end
 
function QuadTreeNode:GetAllChildContents(filter,result) 
    for _,content in ipairs(self._contents) do 
        if not filter or filter:filter(content) then
            table.insert(result,content);
        end
    end
    if self._nodes then
        for _,node in ipairs(self._nodes) do
            node:GetAllChildContents(filter,result);
        end
    end
    return result;
end

function QuadTreeNode:Clear()
    self._nodes = nil;
    self._contents = {};
end

function QuadTreeNode:Query(area,filter,result) 
    for _,content in ipairs(self._contents) do 
        if area:Interect(content) then
            if not filter or filter:filter(content) then
                table.insert(result,content);
            end
        else
            --GameLog.LogError("%s content not Interect %s",content:ToString(),area:ToString())
        end
    end
 
    if self._nodes then
        for _,node in ipairs(self._nodes) do
            if not node:IsEmpty() then                
                if node._area:Contains(area) then   
                    --GameLog.LogError("%s contains %s",node:ToString(),area:ToString())                 
                    node:Query(area,filter,result);
                    break;
                elseif area:Contains(node._area) then
                    --GameLog.LogError("%s contains2 %s",node:ToString(),area:ToString())
                    node:GetAllChildContents(filter,result); 
                elseif node._area:Interect(area) then
                    --GameLog.LogError("%s Interect %s",node:ToString(),area:ToString())
                    node:Query(area,filter,result);
                else
                    --GameLog.Log("%s not Interect %s",node:ToString(),area:ToString())
                end                
            end
        end
    end
end

QuadTree = class("QuadTree",nil)

function QuadTree:ctor(x,y,width,height,threadhold) 
    self._idGenerator = 0;
    self._root = self:CreateNode(nil,x,y,width,height);
    self._debug = DebugHelper.CreateDebugGameObject(nil,"QuadTree");
    self._root._debug:SetParent(self._debug);
    self._threadhold = threadhold * threadhold;
end

function QuadTree:CreateNode(parent,x,y,width,height)
    local node = QuadTreeNode.new(parent,self:GenerateID(),x,y,width,height,self._threadhold);
    node._tree = self;
    return node;
end

function QuadTree:GenerateID()
    self._idGenerator = self._idGenerator + 1;
    return self._idGenerator;
end

function QuadTree:Insert(item)
    return self._root:Insert(item);
end

function QuadTree:Remove(item)
    return self._root:Remove(item)
end
 
function QuadTree:Update(item)
    local success = false;
    local node = item.node;  
    if node._area:Contains(item) then
        if not node:IsEmpty() and node._area:GetAreaSize() > self._threadhold * 4 then
            node:RemoveContent(item);
            success = node:Insert(item);
            --GameLog.LogError("Update item")
            if not success then
                GameLog.LogError("insert %s into %s error",item:ToString(),node:ToString())
            end
        else
            success = true; 
        end
        node.dirty = false;
        return success;
    end 
    --GameLog.LogError("Update item")
    node:RemoveContent(item);
    node = node:GetParent();    
    while node do
        --GameLog.LogError("try insert %s into %s error",item:ToString(),node:ToString())
        if node._area:Contains(item) then
            success = node:Insert(item);
            if not success then
                GameLog.LogError("insert %s into %s error",item:ToString(),node:ToString())
            end
            node.dirty = false;
            break;
        end
        node = node:GetParent();
    end
    if node == nil then
        GameLog.LogError("item %s update error %s",item.data:GetLifeName(),item:ToString())
    end
    return success;
end

function QuadTree:Clear()
    self._root:Clear();
end

function QuadTree:Query(area,filter)
    local result = {};
    self._root:Query(area,filter,result);
    return result;
end

function QuadTree:QueryByCircle(pos,radius,filter)
    local circle = QuadAreaCircle.new(pos.x,pos.y,radius);
    return self:Query(circle,filter);
end 

return QuadTree;