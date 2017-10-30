require("BehaviorSystem/Composite/Sequence")
require("BehaviorSystem/Composite/Selector")
require("BehaviorSystem/Composite/Parallel")

CompositeParser = {};

function CompositeParser.Parse(context,info)
    local node = nil;
    local args = info.args;
    if info.type == BehaviorTree_pb.BehaviorComposite.SEQUENCE then        
        node = Sequence.new(context.system);
    elseif info.type == BehaviorTree_pb.BehaviorComposite.SELECTOR then
        node = Selector.new(context.system);
    elseif info.type == BehaviorTree_pb.BehaviorComposite.PARALLEL then
        node = Parallel.new(context.system);
    else
        print("Compositetype not support now ",info.type)
    end
    node.__children = info.children;
    return node;
end 

return CompositeParser;