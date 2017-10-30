require("BehaviorSystem/Decorator/Repeater") 
require("BehaviorSystem/Decorator/UntilSuccess")
require("BehaviorSystem/Decorator/UntilFailure")
require("BehaviorSystem/Decorator/Reverter")

DecoratorParser = {};

function DecoratorParser.Parse(context,info)
    local node = nil;
    local args = info.args;
    if info.type == BehaviorTree_pb.BehaviorDecorator.REPEATER then        
        node = Repeater.new(context.system); 
        node._loop = args[1].intValue;
        if args[2].strValue ~="" then
            node._forever = context.system:GetVariable(args[2].strValue);
        else
            node._forever = BehaviorSharedBool.new(args[2].boolValue);
        end        
        node._endOnFailure = args[3].boolValue;
    elseif info.type == BehaviorTree_pb.BehaviorDecorator.UNTIL_SUCCESS then        
        node = UntilSuccess.new(context.system);  
    elseif info.type == BehaviorTree_pb.BehaviorDecorator.UNTIL_FAILURE then        
        node = UntilFailure.new(context.system);  
    elseif info.type == BehaviorTree_pb.BehaviorDecorator.REVERTER then        
        node = Reverter.new(context.system); 
    else
        print("Decoratortype not support now ",info.type)
    end

    node.__children = {info.child};

    return node;
end 

return DecoratorParser;