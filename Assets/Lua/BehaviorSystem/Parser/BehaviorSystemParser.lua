require("BehaviorSystem/Parser/ActionParser");
require("BehaviorSystem/Parser/CompositeParser");
require("BehaviorSystem/Parser/ConditionalParser");
require("BehaviorSystem/Parser/DecoratorParser");
require("BehaviorSystem/Parser/NodeParser");
require("BehaviorSystem/Parser/ValueParser");
require("BehaviorSystem/Parser/VariableParser");
require("BehaviorSystem/Parser/ParserContext");

BehaviorSystemParser = {};

function BehaviorSystemParser.Parse(context,info)

    if context == nil then
        context = ParserContext.new();
    end

    local system =  BehaviorSystem.new(nil,info.name);
    context.system = system; 

    for i,variableInfo in ipairs(info.variables) do       
        local variable =  VariableParser.Parse(context,variableInfo);        
        if variable then
            print("variable",variableInfo.name,variable:GetValue())
            variable:SetName(variableInfo.name);
            system:SetVariable(variableInfo.name,variable);
        end
    end
 
    for i,actionInfo in ipairs(info.actions) do
        --print("action",actionInfo.id,actionInfo.type)
        local action = ActionParser.Parse(context,actionInfo);
        if action then
            context:AddAction(actionInfo.id,action);
        end
    end

    for i,compositeInfo in ipairs(info.composites) do
        --print("composite",compositeInfo.id,compositeInfo.type)
        local composite = CompositeParser.Parse(context,compositeInfo);
        if composite then
            context:AddComposite(compositeInfo.id,composite);
        end
    end

    for i,conditionalInfo in ipairs(info.conditionals) do
        --print("conditional",conditionalInfo.id,conditionalInfo.compare)
        local conditional = ConditionalParser.Parse(context,conditionalInfo);
        if conditional then
            context:AddConditional(conditionalInfo.id,conditional);
        end
    end

    for i,decoratorInfo in ipairs(info.decorators) do
        --print("decorator",decoratorInfo.id,decoratorInfo.type)
        local decorator = DecoratorParser.Parse(context,decoratorInfo);
        if decorator then
            context:AddDecorator(decoratorInfo.id,decorator);
        end
    end

    for i,nodeInfo in ipairs(info.nodes) do
        print("node",nodeInfo.id,nodeInfo.name,nodeInfo.behaviorID)
        local node = NodeParser.Parse(context,nodeInfo);
        if node then
            context:AddNode(nodeInfo.id,node);
            system:AddNode(node);
        end  
    end
    
    for i,node in pairs(context.nodes) do  
        NodeParser.Init(context,node);
    end

    system:SetRoot(context.nodes[0]);

    return system;
end

return BehaviorSystemParser;