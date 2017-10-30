
require("SceneManagment/QuadTree/QuadTree")

SceneManagment = class("SceneManagment",nil) 

local _current = nil;

function SceneManagment.Current()
    return _current;
end

function SceneManagment.NewScene( worldBounds,visibleSize,maxCharactor)
    _current = SceneManagment.new(worldBounds,visibleSize,maxCharactor);
    return _current;
end

function SceneManagment:ctor(worldBounds,visibleSize,maxCharactor)
    self._worldBounds = worldBounds;
    self._visibleSize = visibleSize;
    self._maxVisibleCount = maxCharactor;
    self._charactors = {};
    self._visiableNode = {};
    self._idGenerator = 0;    
    local worldSize = math.max(worldBounds.size.x,worldBounds.size.z);
    self._tree = QuadTree.new(worldBounds.center.x-worldSize/2,worldBounds.center.z-worldSize/2,worldSize,worldSize,visibleSize*2);
end

function SceneManagment:Init(center)
    self._dirty = true;
    self._centerArea = QuadAreaCircle.new(center.x,center.z,self._visibleSize); 
end

function SceneManagment:Start()
    self._started = true;
    LateUpdateBeat:Add(self.Update,self);
    for id,node in pairs(self._charactors) do 
        if node then
            node.data:SetActive(false)
        end
    end
end

function SceneManagment:Destroy()
    LateUpdateBeat:Remove(self.Update,self);
    self._charactors = {};
    self._tree:Clear();
end

function SceneManagment:UpdateCenter(center) 
    self._dirty = true;
    self._centerArea:Update(center.x,center.z,self._visibleSize)
end

function SceneManagment:AddCharactor(charactor)
    charactor.__charactorid = self:ObtainCharactorID();    

    self._dirty = true;

    local pos = charactor:GetPos();
    local width = charactor:GetWidth();

    local node = QuadAreaCircle.new(pos.x,pos.z,width/2)
    node.data = charactor;
    node._debug:SetName(charactor:GetLifeName());
    node.dirty = false;

    if self._tree:Insert(node) and self._started then
        --charactor:SetActive(false);
    end
    
    self._charactors[charactor.__charactorid] = node; 
end

function SceneManagment:RemoveCharactor(charactor)
    local node = self._charactors[charactor.__charactorid];
    if node then
        self._tree:Remove(node);
        self._charactors[charactor.__charactorid] = nil;
    end    
end

function SceneManagment:UpdateCharactor(charactor)
    local node = self._charactors[charactor.__charactorid];
    if node then 
        node.dirty = true;
        local pos = charactor:GetPos();
        local width = charactor:GetWidth();
        node:Init(pos.x,pos.z,width/2);  
        node._debug:SetName(charactor:GetLifeName()..".-"..node:ToString());
        self._tree:Update(node); 
        self._dirty = true;
    end   
end

function SceneManagment:FindCharactorsWithArea(queryArea,filter,sorter)
    local charactors = {};
    local result = self._tree:Query(queryArea,filter);
    for _,item in ipairs(result) do 
        table.insert( charactors,item.data);
    end
    if sorter then
        charactors = sorter:sort(charactors);
    end
    return charactors;
end

function SceneManagment:FindCharactors(pos,radius,filter,sorter)
    local circle = QuadAreaCircle.new(pos.x,pos.z,radius,true);
    return self:FindCharactorsWithArea(circle,filter,sorter);
end
 

function SceneManagment:ObtainCharactorID()
    if self._idGenerator > 1000000 then
        self._idGenerator = 0;
    end
    self._idGenerator = self._idGenerator + 1;
    return self._idGenerator;
end

function SceneManagment:Update()
    if self._dirty then
        --[[for id,node in pairs(self._charactors) do 
            if node then
                if node.dirty then 
                    self._tree:Update(node); 
                end
            end
        end]]

        if false then    
            local visibleNodes = self._tree:Query(self._centerArea);
            --GameLog.Log("SceneManagment:Update visibleNodes=%s",#(visibleNodes));            
            for _,node in ipairs(visibleNodes) do 
                node.visible = true;
                self._visiableNode[node.data.__charactorid] = node;
                node.data:SetActive(true)
            end
            for id,node in pairs(self._visiableNode) do
                if node then
                    if not node.visible then
                        node.data:SetActive(false)
                        self._visiableNode[id] = nil;
                    end
                    node.visible = false;        
                end   
            end 
        end

        self._dirty = false;
    end
end

return SceneManagment;