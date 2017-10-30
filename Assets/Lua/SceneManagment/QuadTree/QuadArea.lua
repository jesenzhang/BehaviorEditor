QuadArea = class("QuadArea",nil)
QuadArea.AREA_POLYGON = 1;
QuadArea.AREA_CIRCLE = 2; 
QuadArea.AREA_CURVE = 3; 

function QuadArea:ctor(areaType)
    self.areaType = areaType;
end

function QuadArea:ToString()
    return "QuadArea";
end


function QuadArea:Contains(area)
    --GameLog.Log("QuadArea %s Contains %s",self:ToString(),area:ToString())
    if area.areaType == QuadArea.AREA_CIRCLE then
        return self:ContainsPolygon(area.bounds) or self:ContainsCircle(area);
    elseif area.areaType == QuadArea.AREA_POLYGON then
        return self:ContainsPolygon(area);
    elseif area.areaType == QuadArea.AREA_CURVE then
        return self:ContainsCurve(area);
    end
    GameLog.LogError("Contains areatype %s not found %s",area.areaType,area:ToString());
    return false;
end


function QuadArea:Interect(area) 
    if area.areaType == QuadArea.AREA_CIRCLE then
        return self:InterectCircle(area);
    elseif area.areaType == QuadArea.AREA_POLYGON then
        return self:InterectPolygon(area);        
    elseif area.areaType == QuadArea.AREA_CURVE then
        return self:InterectCurve(area);     
    end
    GameLog.LogError("Interect areatype %s not found %s",area.areaType,area:ToString());
    return false;
end


function QuadArea:ContainsPoint(pos)
    return false;
end

function QuadArea:ContainsPolygon(area)
    local result = true;
    for _,p in ipairs(area.points) do
        if not self:ContainsPoint(p) then
            result = false;
            break;
        end
    end
    return result;
end

function QuadArea:ContainsCurve(area)
    return self:ContainsPolygon(area.polygon);
end

function QuadArea:ContainsCircle(area)
    return false;
end

function QuadArea:InterectPolygon(area)
    return false;
end

function QuadArea:InterectCircle(area)
    return false;
end 

function QuadArea:InterectCurve(area)
    return self:InterectPolygon(area.polygon);
end 

function QuadArea:GetAreaSize()
    return 0;
end

function QuadArea:SetNode(node)
    self.node = node;
    if self._debug then
        if node then
           self._debug:SetParent(node._debug);            
        else
           self._debug:SetParent(nil);
        end
    end
end

return QuadArea;