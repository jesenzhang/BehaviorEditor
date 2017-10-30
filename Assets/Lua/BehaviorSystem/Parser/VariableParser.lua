require("BehaviorSystem/Variable/BehaviorSharedInt")
require("BehaviorSystem/Variable/BehaviorSharedFloat")
require("BehaviorSystem/Variable/BehaviorSharedBool")
require("BehaviorSystem/Variable/BehaviorSharedString")

VariableParser = {};

function VariableParser.Parse(context,info )
    if info.valueType == BehaviorTree_pb.BehaviorValue.INTEGER then
       return BehaviorSharedInt.new(info.intValue);
    elseif info.valueType == BehaviorTree_pb.BehaviorValue.FLOAT then
        return BehaviorSharedFloat.new(info.floatValue); 
    elseif info.valueType == BehaviorTree_pb.BehaviorValue.BOOLEAN then
        return BehaviorSharedBool.new(info.boolValue); 
    elseif info.valueType == BehaviorTree_pb.BehaviorValue.STRING then
        return BehaviorSharedString.new(info.strValue); 
    end
    return nil;
end

return VariableParser;