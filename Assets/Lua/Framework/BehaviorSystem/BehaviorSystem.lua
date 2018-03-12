BehaviorAction = require("Framework/BehaviorSystem/BehaviorAction") 

BehaviorSystem = class("BehaviorAction",nil)

TaskStatus = {}
TaskStatus.Inactive = 0;
TaskStatus.Failure = 1;
TaskStatus.Success = 2;
TaskStatus.Running = 3;

return BehaviorSystem;