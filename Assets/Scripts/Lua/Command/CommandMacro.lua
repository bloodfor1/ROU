module("CommandMacro", package.seeall)

CurrentBlock = nil

--------------------------宏------------------------------

--获取玩家名
function PlayerName()
    return MEntityMgr.PlayerEntity.Name
end

function PlayerUID()
    return MEntityMgr.PlayerEntity.UID
end

function PlayerLv()
    return MPlayerInfo.Lv
end

function PlayerJobLv()
    return MPlayerInfo.JobLv
end

function SceneId()
    return MScene.SceneID
end

--获取当前NPCID
function NPCId()
    return MgrMgr:GetMgr("NpcMgr").GetCurrentNpcId()
end

--获取当前NPC的uuid
function NPCUuid()
    local l_npcId = MgrMgr:GetMgr("NpcMgr").GetCurrentNpcId()
    local l_npc = MNpcMgr:FindNpcInViewport(l_npcId)
    if not l_npc then
        return 0
    end
    return l_npc.UID
end

--获取当前NPC名
function NPCName()
    return MgrMgr:GetMgr("NpcMgr").GetCurrentNpcName()
end

--当前温度
function CurrentTemperature()
    return MoonClient.MEnvironWeatherGM.CurTemperature
end

--时尚评分-获取当前主题
function FashionGetTheme()
    return DataMgr:GetData("FashionData").JournalTheme
end

--时尚评分-获取当前分数
function FashionGetPoint()
    return DataMgr:GetData("FashionData").CurPoint
end

--时尚评分-获取最高分數
function FashionGetMaxPoint()
    return DataMgr:GetData("FashionData").MaxPoint
end

--时尚评分-获取最高分數
function FashionGetTheoryMaxPoint()
    local l_themeRow = TableUtil.GetFashionThemeTable().GetRowByID(FashionGetTheme())
    if l_themeRow then
        return l_themeRow.HighestScore
    end
    return 0
end

--时尚评分-获取评分次数
function FashionGetCount()
    return DataMgr:GetData("FashionData").GradeCount
end
--时尚评分-判断是否变身、变身不允许拍照
function FashionTransfiguredJud()
    if MEntityMgr.PlayerEntity ~= nil then
        return MEntityMgr.PlayerEntity.IsTransfigured
    end
    return true
end

function FashionJud()

    if FashionTransfiguredJud() then
        return 1
    end

    if not CheckSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.FashionRating) then
        return 2
    end
    return 0
end

--获取纹章的数量
function GetGadCount()
    return MgrMgr:GetMgr("ThemePartyMgr").GetTotalMeadlNum()
end

--获取纹章兑换主题币的个数
function GetGadExchangeCoinCount()
    return MgrMgr:GetMgr("ThemePartyMgr").GetExchangeMedalNum()
end

function IsActivityOpend(activityId)
    return MgrMgr:GetMgr("DailyTaskMgr").IsActivityOpend(activityId)
end

function IsActivityInOpenDay(activityId)
    return MgrMgr:GetMgr("DailyTaskMgr").IsActivityInOpenDay(activityId) 
end

--------------------------宏------------------------------

function SetBlock(block)
    CurrentBlock = block
end

-------------------------常用Lua方法-----------------------

--确认任务是否完成
function CheckTaskFinished(taskId)
    return MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(taskId)
end

function CheckTaskStatus(taskId, taskStatus, taskStep)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_taskStatus, l_taskStep = l_taskMgr.GetTaskStatusAndStep(taskId)
    if l_taskStatus ~= taskStatus then
        return false
    end

    if l_taskStatus == l_taskMgr.ETaskStatus.Taked then
        return taskStep == l_taskStep
    end

    return true
end

function CheckSystemOpen(id)
    local l_isOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(id)
    return l_isOpen
end
--迷宫判断是否已完成过钥匙房
--未通关钥匙房 return 0 --第一次通关的钥匙房 return 1 --第二次通关的钥匙房 return 2
function HasPassKeyRoomInMaze()
    return MgrMgr:GetMgr("MazeDungeonMgr").HasPassKeyRoom()
end

function ShowOpenDinnerWishDialog()
    MgrMgr:GetMgr("GuildDinnerMgr").ShowOpenDinnerWishDialog()
end

-- 检测节日签到活动是不是开放着
function CheckActivityCheckInOpen()
    return MgrMgr:GetMgr("ActivityCheckInMgr").IsActivityOpen()
end

-- 检测狩猎场是否开放
function CheckHuntIsOpen()
    return MgrMgr:GetMgr("FestivalMgr").IsActivityOpenByType(EnmBackstageDetailType.EnmBackstageDetailTypeHuntField)
end

--检测是否在舞会中
function CheckIsInThemeParty()
    if MgrMgr:GetMgr("ThemePartyMgr").l_themePartyEnumClientState == nil or
            MgrMgr:GetMgr("ThemePartyMgr").l_themePartyEnumClientState == ThemePartyClientState.kPartyStateNone then
        return false
    end
    return true
end
--检测是否为周末宴会开放日
function CheckIsInGuildWeekCookOpenDay()
    local l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    return l_dailyTaskMgr.IsActivityInOpenDay(l_dailyTaskMgr.g_ActivityType.activity_GuildCookWeek)
end
-------------------------回调函数--------------------------

function TestCallback()
    logGreen("asdasdasdasd")
end

function IsDelegateOpen(systemId)
    return MgrMgr:GetMgr("OpenSystemMgr").IsDelegateOpen(systemId)
end

function WorldPveSceneNames()
    return MgrMgr:GetMgr("WorldPveMgr").GetWorldPveSceneNames()
end

function IsInDungeonTarget(id, step)
    return MgrMgr:GetMgr("DungeonTargetMgr").IsInDungeonTarget(id, step)
end

function GetFlagVal(flagKey, flagType)
    require("Command.CommandConst")
    local l_commandConst = Command.CommandConst
    local l_instance = l_commandConst.GetCommandInstance("addflagvar")
    return l_instance:GetFlagVal(flagKey, flagType)
end

function WorldEventSystemOpened()
    return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.WorldPve)
end

return CommandMacro