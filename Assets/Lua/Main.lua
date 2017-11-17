
require("Framework/Class")
require("Framework/BehaviorSystem/BehaviorSystem")

function Main()
    print("start app")
end

function log(format,...)
    local msg = string.format(format,...)
    print(msg);
end