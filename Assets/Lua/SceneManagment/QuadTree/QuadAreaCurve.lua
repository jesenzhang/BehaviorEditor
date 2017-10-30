require("SceneManagment/QuadTree/QuadArea")

QuadAreaCurve = class("QuadAreaCurve",QuadArea)

local Rad2Deg = 180 / math.pi;

function QuadAreaCurve:ctor(x,y,radius,startAngle,endAngle)
    self.super.ctor(self,QuadArea.AREA_CURVE);   
    self.center = {x=x,y=y};
    self.polygon = QuadAreaPolygon.new(QuadArea.AREA_POLYGON) 
    self:Init(x,y,radius,startAngle,endAngle);   
end

local function GetPositionInAngle(x,y,radius,angle) 
    return {x=x-radius * math.cos(angle),y=y+radius * math.sin(angle)};
end

local DEFAULT_Y = 40;

local function Vector2ToVector3(v)
    return Vector3.New(v.x,DEFAULT_Y,v.y);
end

function QuadAreaCurve:Init(x,y,radius,startAngle,endAngle)
    self.x = x;
    self.y = y;
    self.center.x = x;
    self.center.y = y;
    self.radius = radius; 
    self.startAngle = startAngle;
    self.endAngle = endAngle; 

    local left = GetPositionInAngle(x,y,radius,endAngle);
    local right = GetPositionInAngle(x,y,radius,startAngle);
    local top = GetPositionInAngle(x,y,radius,(startAngle+endAngle)/2);

    self.polygon:Update(self.center,left,top,right);

    if not nodebug then
        if not  self._debug then
            --self._debug = DebugDrawer.DrawCurve(self:ToString(),Vector3.New(x,DEFAULT_Y,y),radius,startAngle * Rad2Deg,endAngle * Rad2Deg);
            --self._debug = DebugDrawer.DrawBox(self:ToString(),Vector3.New(x,DEFAULT_Y,y),Vector2ToVector3(left),Vector2ToVector3(top),Vector2ToVector3(right));
        else
            --self._debug:Update(self:ToString(),Vector3.New(x,DEFAULT_Y,y),radius,startAngle* Rad2Deg,endAngle* Rad2Deg);
            --self._debug:Update(self:ToString(),Vector3.New(x,DEFAULT_Y,y),Vector2ToVector3(left),Vector2ToVector3(top),Vector2ToVector3(right));
        end
    end

end


function QuadAreaCurve:Update(x,y,radius,startAngle,endAngle)
    self:Init(x,y,radius,startAngle,endAngle);
end

function QuadAreaCurve:ContainsPoint(pos)
   return self.polygon:ContainsPoint(pos);
end
 
function QuadAreaCurve:InterectCircle(other)
    return self.polygon:InterectCircle(other);
end

function QuadAreaCurve:InterectPolygon(area)
    return area:InterectCurve(self);
end

function QuadAreaCurve:ContainsCircle(area)
    return self.polygon:ContainsCircle(other);
end

function QuadAreaCurve:GetAreaSize()
    return self.radius * self.radius * math.pi * (self.endAngle - self.startAngle );
end

function QuadAreaCurve:ToString()
    return string.format("Curve-(%f,%f,%f,%f,%f)",self.x,self.y,self.radius,self.startAngle * Rad2Deg,self.endAngle * Rad2Deg)
end

return QuadAreaCurve;