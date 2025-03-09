---@module ModuleMgr.InfiniteTowerDungeonMgr
module("ModuleMgr.InfiniteTowerDungeonMgr", package.seeall)

require "Common/CommonCountDownUtil"

EventDispatcher = EventDispatcher.new()

-- ui点击状态修改
ON_SELECT_TOWER = "ON_SELECT_TOWER"

ENDLESS_TOWER_JUMP_TIP = "ENDLESS_TOWER_JUMP_TIP"

G_RESULT_OP_TYPE = {
    StageStart = "StageStart",
    StageFinish = "StageFinish",
    StageJumpTo = "StageJumpTo",
    StageFailed = "StageFailed"
}

--已通关的层数
g_saveTowerLevel = 0
--当前层
g_currentTowerLevel = 0
--通关结算动画
g_gameObject = nil

-- 5层为一块
g_towerBlockSplit = 5

g_hasGetReward = {}

g_historyMaxTowerLevel = 0

g_timer = nil

l_jumpServerLv = 9999

l_waitToShowItem = {}

local l_jumpCacheStartTime = 0

local l_countDownUtil = Common.CommonCountDownUtil.new()

local CountDownType = {
    ToJump = 0, -- 进入下1(或n)层
    JumpStart = 1, -- 跳层倒计时开始
    JumpReset = 2, -- 跳层倒计时重置
    Clear = 3, -- 本层Clear,用于显示跳层信息
}

function OnInit()
    local configLine = TableUtil.GetGlobalTable().GetRowByName("EndlessTowerJumpLv")
    if nil == configLine then
        l_jumpServerLv = 0
        return
    end

    l_jumpServerLv = tonumber(configLine.Value)
end

--初始化当前层数
function SetTowerInfo(info)
    if type(info) == "number" then
        g_saveTowerLevel = info
    else
        g_saveTowerLevel = info.dungeons.tower.max_pass_floor
    end
end

--选择层数
function OnSelectLevel(level)
    if level - 1 > g_saveTowerLevel then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("INFINITE_TOWER_LOCK"))
        return
    end
    GotoLevel(level)
end

--进入无限塔
function GotoLevel(lv)
    local l_dungeonId = TableUtil.GetEndlessTowerTable().GetRowByID(lv).DungeonsID:get_Item(0, 1)
    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_dungeonId, 0, 0)
    g_currentTowerLevel = lv
end

--结算
function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)
    MgrMgr:GetMgr("TipsMgr").ClearImportantNotice()
    local l_dungeons_id = l_info.dungeons_id
    local l_towerLevel = 0
    if l_info.status == DungeonsResultStatus.kResultVictory then
        local l_table = TableUtil.GetEndlessTowerTable().GetTable()
        for lv, row in ipairs(l_table) do
            if row.DungeonsID:get_Item(0, 1) == l_dungeons_id then
                g_currentTowerLevel = row.ID
                l_towerLevel = row.ID
                if g_saveTowerLevel < row.ID then
                    g_saveTowerLevel = row.ID
                end
                if g_historyMaxTowerLevel < row.ID then
                    g_historyMaxTowerLevel = row.ID
                end
                break
            end
        end
        local l_towerInfo = TableUtil.GetEndlessTowerTable().GetRowByID(l_towerLevel)
        --是BOSS先不显示倒计时
        if l_towerInfo.IsBossFloor then
            UIMgr:ActiveUI(UI.CtrlNames.InfinityTowerResult, { opType = G_RESULT_OP_TYPE.StageFinish })
        end
    else
        local time = MGlobalConfig:GetFloat("PveSceneTransitionTime")
        g_timer = Timer.New(function()
            time = time - 1
            MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(Lang("DUNGEON_WAIT_FOR_RESET_LEVEL", time + 1), 1)
            if time == 0 then
                g_timer:Stop()
                g_timer = nil
            end
        end, 1, -1)
        g_timer:Start()

        if IsJumpOpen() then
            MgrMgr:GetMgr("CordFireMgr").l_eventDispatcher:Dispatch(MgrMgr:GetMgr("CordFireMgr").SIG_CORDFIRE_PAUSE)
        end
        -- 无尽塔只有成功和失败，else里全部处理失败情况
        UIMgr:ActiveUI(UI.CtrlNames.InfinityTowerResult, { opType = G_RESULT_OP_TYPE.StageFailed })
    end
end

--服务端通知倒计时
function TowerStartCountdown(msg)
    ---@type TowerStartCountdownData
    local l_info = ParseProtoBufToTable("TowerStartCountdownData", msg)
    if l_info.type == CountDownType.ToJump then
        if not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
            local l_nextTowerLevel = l_info.jump_dungeon_id
            if l_nextTowerLevel <= TableUtil.GetEndlessTowerTable().GetTableSize() then
                local l_table = TableUtil.GetEndlessTowerTable().GetRowByID(l_nextTowerLevel)
                if l_table ~= nil and l_table.IsSave == 1 and g_currentTowerLevel == g_saveTowerLevel then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("INFINITE_TOWER_UPDATE_LEVEL", l_nextTowerLevel))
                end
            end
        end
        if not MLuaCommonHelper.IsNull(g_gameObject) then
            MResLoader:DestroyObj(g_gameObject)
            g_gameObject = nil
        end
        ShowLoopTodoByTime(l_info.duration)

        local nextFloorInfo = _getEndlessTableCfgByDungeonsID(l_info.jump_dungeon_id)
        if nextFloorInfo and nextFloorInfo.IsBossFloor then
            UIMgr:ActiveUI(UI.CtrlNames.BattleTips, function(ctrl)
                ctrl:SetContent(Lang("InfiniteTowerBossNotify"))
            end)
        end
    elseif l_info.type == CountDownType.JumpStart then
        if IsJumpOpen() then
            l_jumpCacheStartTime =  Common.TimeMgr.GetNowTimestamp() - l_info.duration
            local endlessTowerJumpCfg = TableUtil.GetEndlessTowerJumpTable().GetRowByID(MPlayerInfo.PlayerDungeonsInfo.DungeonID)
            UIMgr:ActiveUI(UI.CtrlNames.CordFire, { openType = MgrMgr:GetMgr("CordFireMgr").OpenType.CountDown, curTime = l_info.duration, totalTime = endlessTowerJumpCfg.TargetTime5 })
        end
    elseif l_info.type == CountDownType.JumpReset then
        if IsJumpOpen() then
            l_jumpCacheStartTime = 0
            MgrMgr:GetMgr("CordFireMgr").l_eventDispatcher:Dispatch(MgrMgr:GetMgr("CordFireMgr").SIG_CORDFIRE_PAUSE)
        end
    elseif l_info.type == CountDownType.Clear then
        MgrMgr:GetMgr("CordFireMgr").l_eventDispatcher:Dispatch(MgrMgr:GetMgr("CordFireMgr").SIG_CORDFIRE_PAUSE)
        local endlessTowerJumpCfg = TableUtil.GetEndlessTowerJumpTable().GetRowByID(MPlayerInfo.PlayerDungeonsInfo.DungeonID)
        local jumpSuccess = l_info.duration <= endlessTowerJumpCfg.TargetTime5
        if not IsJumpOpen() or not jumpSuccess then
            NtfShowWaitToShowItem()
        else
            local curFloorInfo = GetFloorInfo()
            local nextFloorInfo = _getEndlessTableCfgByDungeonsID(l_info.jump_dungeon_id)
            local jumpNum = nextFloorInfo.ID - curFloorInfo.ID
            -- 先掷骰子，再播跳层成功动画，再弹奖励
            UIMgr:ActiveUI(UI.CtrlNames.Dice, {
                data = _getDiceImgListByJumpFloor(jumpNum,nextFloorInfo.IsBossFloor),
                desc = Common.Utils.Lang("ENDLESSTOWER_JUMP_DICE_TIP"),
                closeCallBack = function()
                    UIMgr:ActiveUI(UI.CtrlNames.InfinityTowerResult,
                            {
                                opType = G_RESULT_OP_TYPE.StageJumpTo,
                                data = {
                                    param1 = nextFloorInfo.ID,
                                    callback = function()
                                        NtfShowWaitToShowItem()
                                    end
                                }
                            })
                end
            })
        end
    end
end

-- 清空倒计时tips回调
function _clearCountDown()
    MgrMgr:GetMgr("TipsMgr").ClearImportantNotice()
end

function _showCountDown(paramTable)
    if nil == paramTable then
        logError("[CountDownUtil] util returns nil param")
        return
    end

    local l_timeLeft = paramTable.totalTime - paramTable.elapsedTime
    local l_endlessTowerTable = TableUtil.GetEndlessTowerTable().GetTable()
    l_islastLevel = g_currentTowerLevel == #l_endlessTowerTable
    local l_localKey = l_islastLevel and "DUNGEON_WAIT_FOR_QUIT" or "DUNGEON_WAIT_FOR_NEXT_LEVEL"
    local l_duration = 1
    MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(Lang(l_localKey, l_timeLeft), l_duration)
end

function _getDiceImgListByJumpFloor(jumpNum,IsBossFloor)
    local mgr = MgrMgr:GetMgr("DiceMgr")
    local result = {
        imgList = {
            [1] = mgr.ImgNames.Dice[1],
            [2] = mgr.ImgNames.Dice[2],
            [3] = mgr.ImgNames.Dice[3],
            [4] = mgr.ImgNames.Dice[4],
            [5] = IsBossFloor and mgr.ImgNames.boss or mgr.ImgNames.Dice[jumpNum],
            [6] = mgr.ImgNames.Dice[6],
        },
        atlas = mgr.ImgNames.Atlas
    }
    return result
end

function AddWaitToShowItem(id, count)
    local tb = {
        id = id,
        count = count
    }
    table.insert(l_waitToShowItem, tb)
end

function NtfShowWaitToShowItem()
    count = #l_waitToShowItem
    if count == 0 then
        return
    end
    for i = 1, count do
        local item = l_waitToShowItem[i]
        local l_opt = {
            itemId = item.id,
            itemOpts = { num = item.count, icon = { size = 18, width = 1.4 } },
        }
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
    end
    l_waitToShowItem = {}
end

function OnUpdate()
    l_countDownUtil:OnUpdate()
end

--副本挑战成功倒计时
function ShowLoopTodoByTime(time)
    local l_param = {
        totalTime = time,
        interval = 1,
        callback = _showCountDown,
        callbackSelf = nil,
        clearCallback = _clearCountDown,
        clearCallbackSelf = nil,
    }

    l_countDownUtil:Init(l_param)
    l_countDownUtil:Start()
end

--幸运玩家播放特效
function TowerLuckyPlayer(msg)
    ---@type TowerLuckyData
    local l_info = ParseProtoBufToTable("TowerLuckyData", msg)
    for i = 1, #l_info.role_id do
        MgrMgr:GetMgr("TransmissionMgr").ShowEffectWithPlayerUid(l_info.role_id[i].value, 122101)
    end
end

--刷新层数据
function OnNotifyTowerRefresh(msg)
    ---@type TowerRecord
    local l_info = ParseProtoBufToTable("TowerRecord", msg)
    g_saveTowerLevel = l_info.max_pass_floor
end

local l_leaveFlag = false
function OnLeaveScene()
    l_leaveFlag = true
    --是无限塔
    local playerDungeonInfo = MPlayerInfo.PlayerDungeonsInfo
    if playerDungeonInfo and playerDungeonInfo.InDungeon and playerDungeonInfo.DungeonType == 3 then
        l_jumpCacheStartTime = 0
    end

    if l_countDownUtil:IsRunning() then
        l_countDownUtil:Stop()
    end
end

-- 进入无限塔判断boss层
function OnEnterScene(sceneId)
    -- 对于直断线重连的限制
    if not l_leaveFlag then
        return
    end

    -- 有数据
    if not MPlayerInfo.PlayerDungeonsInfo then
        return
    end
    -- 在副本中
    if not MPlayerInfo.PlayerDungeonsInfo.InDungeon then
        return
    end

    -- 是无限塔
    if MPlayerInfo.PlayerDungeonsInfo.DungeonType ~= 3 then
        return
    end

    local l_curDungeonId = MPlayerInfo.PlayerDungeonsInfo.DungeonID
    if l_curDungeonId <= 0 then
        return
    end

    local timer = Timer.New(function()
        if MPlayerInfo.PlayerDungeonsInfo.LeftMonster <= 0 then
            return
        end

        local floorinfo = GetFloorInfo()
        if floorinfo ~= nil and floorinfo.IsBossFloor then
            UIMgr:ActiveUI(UI.CtrlNames.InfinityTowerResult, { opType = G_RESULT_OP_TYPE.StageStart })
        end
    end)

    if IsJumpOpen() then
        OnRefreshCordFire()
        if UserDataManager.GetStringDataOrDef(ENDLESS_TOWER_JUMP_TIP, MPlayerSetting.PLAYER_SETTING_GROUP, "") == "" then
            CommonUI.Dialog.ShowOKDlg(true, Common.Utils.Lang("ENDLESSTOWER_JUMP_RULE_TITLE"), Common.Utils.Lang("ENDLESSTOWER_JUMP_RULE"), function()
                UserDataManager.SetDataFromLua(ENDLESS_TOWER_JUMP_TIP, MPlayerSetting.PLAYER_SETTING_GROUP, "Done")
                timer:Start()
            end, 10)
        else
            timer:Start()
        end
    end
end

--确认一个场景是否是无限塔场景
function CheckIsInfiniteTower(targetScene)
    local l_sceneId = targetScene or MScene.SceneID
    local l_DungonTable = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_sceneId,true)
    if l_DungonTable ~= nil then
        return l_DungonTable.DungeonsType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonTower
    end
    return false
end

function GetFloorInfo()
    local l_curDungeonId = MPlayerInfo.PlayerDungeonsInfo.DungeonID
    if l_curDungeonId <= 0 then
        return nil
    end
    return _getEndlessTableCfgByDungeonsID(l_curDungeonId)
end

function _getEndlessTableCfgByDungeonsID(dunID)
    local l_towerTable = TableUtil.GetEndlessTowerTable().GetTable()
    for i, v in ipairs(l_towerTable) do
        local ID = v.DungeonsID:get_Item(0, 1)
        if ID == dunID then
            return v
        end
    end
    return nil
end

function RequestTowerDungeonsAward(dungeonsId)
    -- logRed(dungeonsId)
    if g_hasGetReward[dungeonsId] then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("HAS_GET_AWARD"))
        return
    end
    local l_msgId = Network.Define.Rpc.TowerDungeonsAward
    ---@type TowerDungeonsAwardArg
    local l_sendInfo = GetProtoBufSendTable("TowerDungeonsAwardArg")
    l_sendInfo.dungeons_id = dungeonsId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取无限塔奖励
function OnTowerDungeonsAward(msg)
    ---@type TowerDungeonsAwardRes
    local l_info = ParseProtoBufToTable("TowerDungeonsAwardRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    -- logRed(l_info.dungeons_id)
    g_hasGetReward[l_info.dungeons_id] = true
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.TowerReward)
end

function GetLevelIsLeft(id)
    local l_table = TableUtil.GetEndlessTowerTable().GetTable()
    local l_save_count = 0
    for lv, row in ipairs(l_table) do
        if row.IsSave == 1 then
            l_save_count = l_save_count + 1
        end
        if row.ID == id then
            break
        end
    end

    return (l_save_count % 2 == 1)
end

function GetSavedLevel()
    local l_table = TableUtil.GetEndlessTowerTable().GetTable()
    local l_result = 0
    for lv, row in ipairs(l_table) do
        if row.IsSave == 1 and g_saveTowerLevel >= lv then
            l_result = lv
        end
    end
    return l_result
end

function IsCleared(id)
    return g_saveTowerLevel >= id
end

function IsHistoryCleared(id)
    return g_historyMaxTowerLevel >= id
end

function HasGetReward(lv)
    local l_row = TableUtil.GetEndlessTowerTable().GetRowByID(lv)
    return g_hasGetReward[l_row.DungeonsID[0][1]]
end

function OnSelectRoleNtf(l_info)
    --DumpTable(l_info, "111", 6)
    SetTowerInfo(l_info)
    local l_towerRecord = l_info.dungeons.tower
    g_hasGetReward = {}
    for i = 1, #l_towerRecord.award_dungeon_ids do
        local lv = l_towerRecord.award_dungeon_ids[i].value
        g_hasGetReward[lv] = lv
        --logRed("lv", lv)
    end
    --logRed("l_towerRecord.history_max_pass_floor", l_towerRecord.history_max_pass_floor)
    g_historyMaxTowerLevel = l_towerRecord.history_max_pass_floor
end

-- 跳层功能是否开启
function IsJumpOpen()
    return (MPlayerInfo.ServerLevel or 0) >= l_jumpServerLv
end

-- 还有多少首通奖励未领取
function CheckRewardTake()

    local l_result = {}
    local l_table = TableUtil.GetEndlessTowerTable().GetTable()
    for lv, row in pairs(l_table) do
        if row.FirstArrivalReward ~= 0 then
            local l_rewardItemList = MgrMgr:GetMgr("AwardPreviewMgr").GetAllItemByAwardId(row.FirstArrivalReward)
            if 0 == #l_rewardItemList then
                logError("[无限塔] EndlessTowerTable ID: " .. tostring(lv) .. "奖励配置为空")
            end
            l_result[lv] = l_rewardItemList
        end
    end
    local l_awardSum = 0
    for lv, item in pairs(l_result) do
        if (not HasGetReward(lv)) and IsHistoryCleared(lv) then
            l_awardSum = l_awardSum + 1
        end
    end
    return l_awardSum

end

function OnRevive()
    -- 无限塔死亡后，需要重置绳子特效
    local PlayerDunInfo = MPlayerInfo.PlayerDungeonsInfo
    if IsJumpOpen() and PlayerDunInfo and PlayerDunInfo.InDungeon and PlayerDunInfo.DungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonTower then
        OnRefreshCordFire()
    end
end

function OnRefreshCordFire()
    if l_jumpCacheStartTime == 0 then
        UIMgr:ActiveUI(UI.CtrlNames.CordFire, { openType = MgrMgr:GetMgr("CordFireMgr").OpenType.Open })
    else
        local endlessTowerJumpCfg = TableUtil.GetEndlessTowerJumpTable().GetRowByID(MPlayerInfo.PlayerDungeonsInfo.DungeonID)
        UIMgr:ActiveUI(UI.CtrlNames.CordFire, { openType = MgrMgr:GetMgr("CordFireMgr").OpenType.CountDown, curTime = Common.TimeMgr.GetNowTimestamp() - l_jumpCacheStartTime , totalTime = endlessTowerJumpCfg.TargetTime5 })
    end
end

----------------------------UI事件-----------------------------
function ShowInfiniteTowerReward(luaType)
    UIMgr:ActiveUI(UI.CtrlNames.TowerReward)
end

function OnSelectTower(id)
    EventDispatcher:Dispatch(ON_SELECT_TOWER, id)
end
----------------------------UI事件-----------------------------

return ModuleMgr.InfiniteTowerDungeonMgr