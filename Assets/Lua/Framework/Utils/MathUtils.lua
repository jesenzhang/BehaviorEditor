
function GetUnityForwardRotation(forward)
    return UnityEngine.Quaternion.LookRotation(forward);
end

function GetForwardAngle(forward)
    local rotation = UnityEngine.Quaternion.LookRotation(forward);
	return rotation.eulerAngles.y * math.pi/180;
end

function Vector3fToUnityVector3(input)
    return Vector3.New(input.x,input.y,input.z);
end

function MultiplyQuaternion(lhs,rhs)
    return UnityEngine.Quaternion.New (lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y, lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z, lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x, lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z)
end 

function MultiplyQuaternionWithVector3(rotation,point)
    local num = rotation.x * 2;
	local num2 = rotation.y * 2;
	local num3 = rotation.z * 2;
	local num4 = rotation.x * num;
	local num5 = rotation.y * num2;
	local num6 = rotation.z * num3;
	local num7 = rotation.x * num2;
	local num8 = rotation.x * num3;
	local num9 = rotation.y * num3;
	local num10 = rotation.w * num;
	local num11 = rotation.w * num2;
	local num12 = rotation.w * num3; 
	local x = (1 - (num5 + num6)) * point.x + (num7 - num12) * point.y + (num8 + num11) * point.z;
	local y = (num7 + num12) * point.x + (1 - (num4 + num6)) * point.y + (num9 - num10) * point.z;
	local z = (num8 - num11) * point.x + (num9 + num10) * point.y + (1 - (num4 + num5)) * point.z;
	return Vector3.New(x,y,z);
end

function insidePolygon(polygon, point)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
            if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes
end

local Vector2Zero = {x=0,y=0};

function interectBoxWithCircle(c,h,p,r)
    local v = Vector2Abs(Vector2Sub(p,c));
    local u = Vector2Max(Vector2Sub(v,h),Vector2Zero);
    return Vector2Dot(u,u) <= r * r;
end

function distanceToPolygon(polygon, point)
    local count = #polygon;
    local minDistance = -1;
    local distance = 0;
    for i=1,count,1 do
        if i == count then
            distance = distanceToLine(polygon[i],polygon[1],point);
        else
            distance = distanceToLine(polygon[i],polygon[i+1],point);
        end
        if minDistance < 0 or distance < minDistance then
            minDistance = distance;
        end
    end
    return minDistance;
end

function distanceToLine(p1,p2,point)
    if p1.y == p2.y then
        return (point.y - p1.y) *  (point.y - p1.y);
    end

    if p1.x == p2.x then
        return (point.x - p1.x) *  (point.x - p1.x);
    end

    local k1 = (p2.y-p1.y)/(p2.x-p1.x); 
    local k2 = -1/k1;
 
    --y1-b=k1*x1 -k1*0
    --b=y1-k1*x1;

    local b1 = p1.y-k1*p1.x;
    local b2 = point.y-k2*point.x;

    --k1*x+b1=k2*x+b2; 
    local x = (b2-b1)/(k1-k2);
    local y = k1*x+b1;

    local t1 = (y - p1.y);
    local t2 = (y - p2.y);

    if t1 * t2 > 0 then
        local d1 = (point.x - p1.x) * (point.x - p1.x) + (point.y - p1.y) * (point.y - p1.y);
        local d2 = (point.x - p2.x) * (point.x - p2.x) + (point.y - p2.y) * (point.y - p2.y);
        return math.min( d1,d2);
    end    

    return (point.x - x) * (point.x - x) + (point.y - y) * (point.y - y);
end

function Vector2Abs(v1)
    return {x=math.abs(v1.x),y=math.abs(v1.y)};
end

function Vector2Max(v1,v2)
    return {x=math.max(v1.x,v2.x),y=math.max(v1.y,v2.y)};
end

function Vector2Add(v1,v2)
    return {x=v1.x+v2.x,y=v1.y+v2.y};
end

function Vector2Sub(v1,v2)
    return {x=v1.x-v2.x,y=v1.y-v2.y};
end

function Vector2Dot(v1,v2)
    return v1.x * v2.x + v1.y*v2.y;
end

function Vector2Multiply(v1,v2)
    return {x=v1.x*v2.x,y=v1.y*v2.y};
end