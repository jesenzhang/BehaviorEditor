ParserContext = class("ParserContext",nil)

function ParserContext:ctor()
    self:Reset();
end

function ParserContext:GetNode(id)
    return self.nodes[id];
end

function ParserContext:AddNode(id,value)
    self.nodes[id] = value;
end

function ParserContext:AddAction(id,value)
    self.actions[id] = value;
end

function ParserContext:AddComposite(id,value)
    self.composites[id] = value;
end

function ParserContext:AddConditional(id,value)
    self.conditionals[id] = value;
end

function ParserContext:AddDecorator(id,value)
    self.decorators[id] = value;
end

function ParserContext:Reset()
    self.nodes = {};
    self.actions = {};
    self.composites = {};
    self.conditionals = {};
    self.decorators = {};
end

return ParserContext;