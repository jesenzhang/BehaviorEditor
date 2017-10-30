require("BehaviorSystem/Actions/Buildin/WaitAction")
require("BehaviorSystem/Actions/Buildin/LogAction")
require("BehaviorSystem/Actions/Buildin/SetVariableAction")
require("BehaviorSystem/Actions/Buildin/FailureAction")
require("BehaviorSystem/Actions/Buildin/SuccessAction")
require("BehaviorSystem/Actions/Buildin/RandomSuccessAction") 

ActionParser = {};

function ActionParser.Parse(context,info)
    local node = nil;
    local args = info.args;
    if info.type == BehaviorTree_pb.BehaviorAction.SCRIPT then 
        if args[1].strValue ~="" then    
            local creator = require("BehaviorSystem/Actions/"..args[1].strValue);
            node = creator.new(context.system);
        else
            logError("error action");
        end
    elseif info.type == BehaviorTree_pb.BehaviorAction.WAIT then
        node = WaitAction.new(context.system);
        node._waitTime = args[1].intValue;
    elseif info.type == BehaviorTree_pb.BehaviorAction.LOG then
        node = LogAction.new(context.system); 
        if args[1].boolValue then    
            node._message = context.system:GetVariable(args[1].strValue);   
        else            
            node._message = BehaviorSharedString.new(args[1].strValue);
        end          

    elseif info.type == BehaviorTree_pb.BehaviorAction.SET_VARIABLE then
        node = SetVariableAction.new(context.system); 
        node._variableName = args[1].strValue;
        node._variableValue = ValueParser.Parse(args[2]);
    elseif info.type == BehaviorTree_pb.BehaviorAction.RETURN_FAILURE then
        node = FailureAction.new(context.system); 
    elseif info.type == BehaviorTree_pb.BehaviorAction.RETURN_SUCCESS then
        node = SuccessAction.new(context.system); 
    elseif info.type == BehaviorTree_pb.BehaviorAction.RANDOM_SUCCESS then
        node = RandomSuccessAction.new(context.system); 
        node._percent = args[1].intValue;
    else
        print("actiontype not support now ",info.type)
    end
    return node;
end 

return ActionParser;