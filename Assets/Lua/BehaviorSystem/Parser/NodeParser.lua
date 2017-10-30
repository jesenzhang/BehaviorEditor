NodeParser = {};

function NodeParser.Parse(context,info)
    local node = nil;
    if info.type == BehaviorTree_pb.BehaviorNode.ACTION then 
        node = context.actions[info.behaviorID];
        node:SetName(info.name);
        node:SetInstant(info.instant);
    elseif info.type == BehaviorTree_pb.BehaviorNode.COMPOSITE then 
        node = context.composites[info.behaviorID];
        node:SetName(info.name); 
        node:SetInstant(info.instant);
    elseif info.type == BehaviorTree_pb.BehaviorNode.CONDITIONAL then 
        node = context.conditionals[info.behaviorID];
        node:SetName(info.name); 
        node:SetInstant(info.instant);
    elseif info.type == BehaviorTree_pb.BehaviorNode.DECORATOR then 
        node = context.decorators[info.behaviorID];
        node:SetName(info.name); 
        node:SetInstant(info.instant);
    elseif info.type == BehaviorTree_pb.BehaviorNode.EXTERNAL_TREE then
        print("nodetype not support now ",info.type)
    else
        print("nodetype not support now ",info.type)
    end
    return node;
end

function NodeParser.Init(context,node) 
    if node.__children then
        for _,id in ipairs(node.__children) do 
            local child = context:GetNode(id);
            node:AddChild(child);
        end
        node.__children = nil;
    end
end

return NodeParser;