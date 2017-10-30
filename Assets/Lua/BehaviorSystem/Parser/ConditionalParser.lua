require("BehaviorSystem/Conditional/Equal")
require("BehaviorSystem/Conditional/Not")
require("BehaviorSystem/Conditional/If")
require("BehaviorSystem/Conditional/Greater")
require("BehaviorSystem/Conditional/Less")

ConditionalParser = {};

function ConditionalParser.Parse(context,info)
    local node = nil;
    local args = info.args;
    if info.compare == BehaviorTree_pb.BehaviorConditional.EQUAL then        
        node = Equal.new(context.system);         
    elseif info.compare == BehaviorTree_pb.BehaviorConditional.NOT_EQUAL then        
        node = Not.new(context.system);
    elseif info.compare == BehaviorTree_pb.BehaviorConditional.GREATER then
        node = Greater.new(context.system);
    elseif info.compare == BehaviorTree_pb.BehaviorConditional.LESS then
        node = Less.new(context.system);
    elseif info.compare == BehaviorTree_pb.BehaviorConditional.IF then
        node = If.new(context.system);
    elseif info.compare == BehaviorTree_pb.BehaviorConditional.IF_NOT then
        node = Not.new(context.system);
    else
        print("Conditionaltype not support now ",info.compare)
    end
    if node then
        node._what = info.name;
        node._value = ValueParser.Parse(info.value);
    end
    return node;
end 

return ConditionalParser;