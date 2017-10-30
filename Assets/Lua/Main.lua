--主入口函数。从这里开始lua逻辑
require("Framework/Core/Class")
require("Framework/framework")
require("Proto/BehaviorTree_pb") 

require("Life/PlayerEntity")
require("Life/NPCEntity")
 
local function OnLoadBehaviorData(error,data)
	if data then 
		local btree = BehaviorTree_pb.BehaviorTree();
		btree:ParseFromString(data)	
		local behaviorSystem = BehaviorSystemParser.Parse(nil,btree);
		behaviorSystem:SetEndCallback(function(system,status)
			log("btree %s end with %s",system:GetName(),status)
			--system:Start();
		end
		); 
		behaviorSystem:Start(); 
	end	 
end

local player = nil; 

local function OnSceneLoaded(name,scene)
	print("OnSceneLoaded",name,scene);
	local equipInfo = {model="ZYcha_luoli"};
	local playerInfo = {name="hello",equipInfo=equipInfo};
	player = PlayerEntity.Create();
	player:Init(playerInfo);
	player:GetEquipment():PlayAction("Denglu"); 
end 

function Main()					
	print("logic start") 
	CacheManager.Init();
	ResourceManager.Init();	
	GameApplication.Init(); 

	GameApplication.LoadGameScene("Scene_4",OnSceneLoaded); 

	--ResourceManager.LoadData("BehaviorTree_CritterAI.bytes",OnLoadBehaviorData);	 
end

function Main2()
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
	GameApplication.Destroy();
	ResourceManager.Destroy();		
	CacheManager.Destroy();
end