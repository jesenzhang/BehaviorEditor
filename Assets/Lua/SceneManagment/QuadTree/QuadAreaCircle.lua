require("SceneManagment/QuadTree/QuadArea")

QuadAreaCircle = class("QuadAreaCircle",QuadArea)

function QuadAreaCircle:ctor(x,y,radius,nodebug)
    self.super.ctor(self,QuadArea.AREA_CIRCLE);   
    self.center = {x=x,y=y};
    self:Init(x,y,radius,nodebug);   
end

function QuadAreaCircle:Init(x,y,radius,nodebug)
    self.x = x;
    self.y = y;
    self.center.x = x;
    self.center.y = y;
    self.radius = radius; 
    self.bounds = QuadAreaBox.new(x-radius,y-radius,2*radius,2*radius)

    if not nodebug then
        if not self._debug then
            self._debug = DebugHelper.CreateDebugGameObject(nil,self:ToString())
        end
        self._debug:SetPosition(Vector3.New(x,0,y));
        self._debug:SetName(self:ToString())
    end
end

function QuadAreaCircle:Update(x,y,radius)
    self:Init(x,y,radius);
end

function QuadAreaCircle:ContainsPoint(pos)
    local distance = (self.x - pos.x) * (self.x - pos.x) + (self.y - pos.y) * (self.y - pos.y);
    return distance <= self.radius * self.radius;
end
 
function QuadAreaCircle:InterectCircle(other)
    local distance = (self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y);
    return distance <= (self.radius+other.radius) * (self.radius+other.radius);
end

function QuadAreaCircle:InterectPolygon(area)
    return area:InterectCircle(self);
end

function QuadAreaCircle:ContainsCircle(area)
    local distance = (self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y);
    if distance <= self.radius * self.radius then
        distance = math.sqrt( distance );
        return distance + area.radius <= self.radius;
    end
    return false; 
end

function QuadAreaCircle:GetAreaSize()
    return self.radius * self.radius * math.pi;
end

function QuadAreaCircle:ToString()
    return string.format("Circle-(%f,%f,%f),bounds=%s",self.x,self.y,self.radius,self.bounds:ToSimpleString())
end

return QuadAreaCircle;