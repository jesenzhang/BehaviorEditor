local CommandDirector = class("CommandDirector",nil)

function CommandDirector:ctor()
    self._commands = {}; 
end

function CommandDirector:Push(command)
    table.insert( self._commands, command);
end

function CommandDirector:Execute(context)
    for i,command in ipairs(self._commands) do
        command:Execute(context);
    end
    self._commands = {};
end 

function  CommandDirector:Clear()
    self._commands = {};
end

return CommandDirector;