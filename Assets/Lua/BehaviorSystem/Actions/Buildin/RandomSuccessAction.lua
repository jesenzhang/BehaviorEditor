require("BehaviorSystem/BehaviorAction")

RandomSuccessAction = class("RandomSuccessAction",BehaviorAction) 

function RandomSuccessAction:OnUpdate() 
    local result = math.random( 1, 100); 
    --print("RandomSuccessAction:OnUpdate",result,self._percent)
    if result <= self._percent then        
        return TaskStatus.Success;
    end
    return TaskStatus.Failure;
end

return RandomSuccessAction;