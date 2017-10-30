
require("DebugSystem/DebugGameObject")

DebugHelper = class("DebugHelper",nil)

function DebugHelper.CreateDebugGameObject( parent,name)
    local debug = DebugGameObject.new(parent,name);
    debug:Init();
    return debug;
end

return DebugHelper;