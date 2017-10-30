ValueParser = {};

function ValueParser.Parse(info )
    if info.valueType == BehaviorTree_pb.BehaviorValue.INTEGER then
       return info.intValue;
    elseif info.valueType == BehaviorTree_pb.BehaviorValue.FLOAT then
        return info.floatValue; 
    elseif info.valueType == BehaviorTree_pb.BehaviorValue.BOOLEAN then
        return info.boolValue; 
    elseif info.valueType == BehaviorTree_pb.BehaviorValue.STRING then
        return info.strValue; 
    end
    return nil;
end

return ValueParser;