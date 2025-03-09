--lua model
module("ModuleData.LifeProfessionData", package.seeall)
--lua model end

--UI激活对应函数枚举
EUIOpenType = 
{
    LifeProfession = 1,
    LifeProfessionTips = 2,
    LifeProfessionReward = 3,
    LifeProfessionReward_Fish = 4,
    LifeProfessionReward_Tip = 5,
    FishMain = 6,
    FishResult = 7,
}
l_showProduceRewardQueue = nil
local l_lastShowDirectoryClassID = 0 --生活职业手册主界面上一次选中的目录ID
local l_maxProduceNumPerTime = 10 --每次最多生产的个数
--初始化
function Init( ... )
end

--登出重置
function Logout( ... )
    if l_showProduceRewardQueue~=nil then
        l_showProduceRewardQueue:clear()
    end
    l_lastShowDirectoryClassID = 0
end
function SetLastShowDirectoryClassID(classID)
    l_lastShowDirectoryClassID = classID
end
function GetLastShowDirectoryClassID()
    return l_lastShowDirectoryClassID
end
function GetProduceRewardQueue()
    if l_showProduceRewardQueue==nil then
        l_showProduceRewardQueue = Common.queue.LinkedListQueue.create()
    end
    return l_showProduceRewardQueue
end
function ClearProduceRewardQueue()
    if l_showProduceRewardQueue~=nil then
        l_showProduceRewardQueue:clear()
    end
end
function GetMaxProduceNumPerTime() 
     return l_maxProduceNumPerTime
end
return ModuleData.LifeProfessionData