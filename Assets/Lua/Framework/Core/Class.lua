function class(classname,super)  
    local cls;
    if super then
        cls = {};
        setmetatable(cls, {__index=super})
        cls.super = super;
    else
        cls = {ctor=function() end}
    end
    cls.__index = cls;
    cls.__cname = classname;
    cls.__tostring = function() return classname end   

    function cls.new(...)
        local instance = setmetatable({},cls);
        instance.class = cls;        
        instance:ctor(...);
        return instance;
    end 
    return cls;
end