require("SceneManagment/QuadTree/QuadAreaPolygon")

QuadAreaBox = class("QuadAreaBox",QuadAreaPolygon)

function QuadAreaBox:ctor(x,y,width,height)    
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height; 

    local p1 = {x=x,y=y};
    local p2 = {x=x+width,y=y};
    local p3 = {x=x+width,y=y+height};
    local p4 = {x=x,y=y+height}; 

    self.areaType = QuadArea.AREA_POLYGON;
    self.points = {p1,p2,p3,p4};
    self.center = {x=x+width/2,y=y+height/2};
end

function QuadAreaBox:ContainsPoint(pos)
    return self.x<=pos.x and self.y<=pos.y and self.x+self.width>=pos.x and self.y+self.height>=pos.y;
end

function QuadAreaBox:InterectCircle(area)
    local c = self.center;
    local h = {x=self.width/2,y=self.height/2};
    return interectBoxWithCircle(c,h,area.center,area.radius);
end

function QuadAreaBox:GetAreaSize()
    return self.width*self.height;
end

function QuadAreaBox:ToString() 
    return string.format( "Rect(%f,%f,%f,%f)",self.x,self.y,self.x+self.width,self.y+self.height )
end

function QuadAreaBox:ToSimpleString() 
    return string.format( "(%f,%f,%f,%f)",self.x,self.y,self.x+self.width,self.y+self.height )
end

return QuadAreaBox;