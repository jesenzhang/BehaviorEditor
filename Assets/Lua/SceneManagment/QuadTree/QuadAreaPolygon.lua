require("SceneManagment/QuadTree/QuadArea")

QuadAreaPolygon = class("QuadAreaPolygon",QuadArea)

function QuadAreaPolygon:ctor(areaType,p1,p2,p3,...)
    self.super.ctor(self,areaType);  
    self.points = {p1,p2,p3,...}; 
end

function QuadAreaPolygon:Update(p1,p2,p3,...)
    self.points = {p1,p2,p3,...};  
end

function QuadAreaPolygon:ContainsPoint(pos)
    return insidePolygon(self.points,pos);
end 

function QuadAreaPolygon:ContainsCircle(area)
    if not self:ContainsPoint(area.center) then
        return false;
    end
    local distance = distanceToPolygon(self.points,area.center);
    return distance >= area.radius;
end 

function QuadAreaPolygon:InterectCircle(area)
    local result = false;
    for _,p in ipairs(self.points) do 
        if area:ContainsPoint(p) then
            result = true;
            break;
        end
    end
    if not result then
        result = self:ContainsPoint(area.center);
    end
    if not result then
        local distance = distanceToPolygon(self.points,area.center);
        result = distance <= area.radius;
    end
    return result;
end

function QuadAreaPolygon:InterectPolygon(area)
    local result = false;        
    for _,p in ipairs(area.points) do 
        if self:ContainsPoint(p) then
            result = true;
            break;
        end
    end
    if not result then
         for _,p in ipairs(self.points) do 
            if area:ContainsPoint(p) then
                result = true;
                break;
            end
        end
    end
    return result;
end
 

function QuadAreaPolygon:ToString()
    return "QuadAreaPolygon";
end


return QuadAreaPolygon;