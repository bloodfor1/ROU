---@module ModuleMgr.TowerDefenseMgr
module("ModuleMgr.TowerDefenseMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
ReceiveTowerDefenseMagicPowerNtfEvent = "ReceiveTowerDefenseMagicPowerNtfEvent"
ReceiveTowerDefenseSyncMonsterEvent = "ReceiveTowerDefenseSyncMonsterEvent"
ReceiveTowerDefenseFastNextWaveEvent = "ReceiveTowerDefenseFastNextWaveEvent"
ReceiveTowerDefenseWaveBeginEvent = "ReceiveTowerDefenseWaveBeginEvent"

ReceiveSetTowerDefenseBlessEvent = "ReceiveSetTowerDefenseBlessEvent"
ReceiveGetTowerDefenseWeekAwardEvent = "ReceiveGetTowerDefenseWeekAwardEvent"
ReceiveTowerDefenseEndlessStartNtfEvent = "ReceiveTowerDefenseEndlessStartNtfEvent"

OnEnterSummonCircleEvent = "OnEnterSummonCircleEvent"
OnLeaveSummonCircleEvent = "OnLeaveSummonCircleEvent"
OnCheckTowerDefenseCondition = "OnCheckTowerDefenseCondition" -- 获取双人守卫战的条件
OnCommandSpiritEvent = "OnCommandSpiritEvent"         -- 操作英灵 回血|加速 成功
OnAdminSpiritEvent = "OnAdminSpiritEvent" -- 英灵的等级数量变化

AnimationTemplateFinishEvent = "AnimationTemplateFinishEvent"

GetTowerDefenseAwardEvent = "GetTowerDefenseAwardEvent"

DataName = "TowerDefenseModuleData"
local l_towerDefenseModuleData = DataMgr:GetData("TowerDefenseModuleData")

local _singleWeekCountServerLevel = MGlobalConfig:GetInt("TdNewWeeklySingleLimitServerLv")

eTowerDefenseCountType = {
    SingleToday = "21",
    SingleWeekDefault = "1",
    SingleWeekExtra = "11",
    --服务器等级到了后额外增加的次数
    SingleWeekServerLevel = "4",
    DoubleToday = "22",
    DoubleWeekDefault = "2",
    DoubleWeekExtra = "12",
}

-- 守卫战模式
ETowerDefenseModel = {
    None = 0, -- 初始值
    Single = 1, -- 单人
    Double = 2, -- 双人
}
-- 英灵操作界面显示[管理界面|命令界面]
ETowerDefenseSpiritType = {
    None = 0, -- 初始值
    Admin = 1, -- 管理
    Command = 2, -- 命令
}
-- 当前守卫战的模式
CurrentTDMode = ETowerDefenseModel.None
-- 当前英灵操作界面类型 默认是管理界面
CurrentSpiritType = ETowerDefenseSpiritType.None
-- 英灵数、等级数据 索引为召唤阵id
SpiritSummonData = {}
-- 入口UI是否满足条件数据s
EntraceConditionData = nil
-- 当前UI的召唤阵id
--打开界面赋值
CurrentSummonId = -1
-- 召唤阵的 回复、加速 cd
SummonCommandCDData = {}
-- 当前英灵管理界面选中的item index
CurrentSpiritAdminSelectItemIndex = -1
-- 当前英灵技能界面选中的item index
CurrentSpiritCommandSelectItemIndex = -1

--进入的召唤阵id
--这个是进圈赋值出圈清除
SummonCircleId = -1

local TdMinWavesRequired = MGlobalConfig:GetInt("TdMinWavesRequired")
-- 玩家需达成最小波次
TdCoopModeEntryWaves = MGlobalConfig:GetInt("TdCoopModeEntryWaves")

--玩家最大生命数
TdMaxPlayerLives = MGlobalConfig:GetInt("TdMaxPlayerLives")

local l_currentDeadCount = 0

function GetTreeRootHP()
    local l_tableInfo = TableUtil.GetTdTable().GetRowByID(MPlayerDungeonsInfo.DungeonID, true)

    if l_tableInfo then
        local l_uid = MEntityMgr:GetUUIDByEntityId(l_tableInfo.TreeRootId)
        local l_entity = MEntityMgr:GetEntity(l_uid)
        if l_entity then
            return l_entity.AttrComp.HP, l_entity.AttrComp.MaxHP
        end
    end
    return 0, 0
end

function OnEnterSummonCircle(_, circleId)
    if circleId and circleId.Length > 0 then
        SummonCircleId = (tonumber(circleId[0]))
    end
    EventDispatcher:Dispatch(OnEnterSummonCircleEvent, circleId)
end

function OnLeaveSummonCircle()
    SummonCircleId = -1
    EventDispatcher:Dispatch(OnLeaveSummonCircleEvent)
end

function IsHaveNoneLife()
    return MPlayerDungeonsInfo.PlayerSelfDeadCount >= TdMaxPlayerLives
end

function GetLeftLife()
    local l_leftLife = TdMaxPlayerLives - l_currentDeadCount
    if l_leftLife < 0 then
        l_leftLife = 0
    end
    return l_leftLife
end

function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)
    local l_newGrade = l_info.grade

    local l_time = l_info.pass_time

    local l_currentWave = l_towerDefenseModuleData.GetTotalFinishWaveCount()

    if l_currentWave < TdMinWavesRequired then
        return
    end

    local l_totalWave = l_towerDefenseModuleData.GetMaxWaveCount()

    local l_deedCount = l_towerDefenseModuleData.GetDeadMonsterCount()
    local l_totalCount = l_towerDefenseModuleData.GetTotalMonsterCount()

    local l_ratingText = _getRatingText()

    local l_tdTableData = GetTdRowByDungeonsId(l_info.dungeons_id)

    UIMgr:ActiveUI(UI.CtrlNames.HeroChallengeResult, function()
        local l_ui = UIMgr:GetUI(UI.CtrlNames.HeroChallengeResult)
        if l_ui then
            l_ui:ShowWinTween({
                Title1 = Lang("TD_RESULT_MONSTER_WAVE_TEXT"),
                TitleDescription1 = tostring(l_currentWave) .. "/" .. tostring(l_totalWave),
                Title3 = Lang("TD_RESULT_MONSTER_DESTROY_TEXT"),
                TitleDescription3 = tostring(l_deedCount) .. "/" .. tostring(l_totalCount),
                Title4 = Lang("HeroChallengeResult_DifficultyCoefficientText"),
                TitleDescription4 = string.format("%.1f", l_tdTableData.ScoreFactor),
                TitleDescription5 = l_ratingText,
                IsShowStamp = true,
                StampDescription = l_newGrade,
                PassTime = l_time,
                SkeletonAnimationName = "BATTLE RESULTS"
            })
        end
    end)
end

function _getRatingText()

    local l_ratintId

    local l_finishWaveCount = l_towerDefenseModuleData.GetNormalModeFinishWaveCount()
    if l_finishWaveCount == 0 then
        return nil
    end

    local l_waveData = l_towerDefenseModuleData.GetWaveTableDataWithIndex(l_finishWaveCount)
    if l_waveData == nil then
        logError("没有在表里取到相应波数的数据，打完的波数：" .. tostring(l_finishWaveCount))
        return nil
    else
        l_ratintId = l_waveData.RatingID
    end

    if l_ratintId == nil then
        logError("取到的评语id是空的，打完的波数：" .. tostring(l_finishWaveCount))
        return nil
    end

    local l_TdRatingTableInfo = TableUtil.GetTdRatingTable().GetRowByID(l_ratintId)
    if l_TdRatingTableInfo == nil then
        return false
    end

    return l_TdRatingTableInfo.RatingContent
end

function IsCanGetAward()
    local l_finishWaveCount = l_towerDefenseModuleData.GetNormalModeFinishWaveCount()
    if l_finishWaveCount >= TdMinWavesRequired then
        return true
    end
    return false
end

-- 请求塔防入口UI数据
function ReqCheckTowerDefenseCondition()
    local l_msgId = Network.Define.Rpc.CheckTowerDefenseCondition
    ---@type CheckTowerDefenseConditionArg
    local l_sendInfo = GetProtoBufSendTable("CheckTowerDefenseConditionArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function RspCheckTowerDefenseCondition(msg)
    ---@type CheckTowerDefenseConditionRes
    local l_info = ParseProtoBufToTable("CheckTowerDefenseConditionRes", msg)
    --log(ToString(l_info))
    if l_info.result ~= 0 then
        if l_info.result == ErrorCode.ERR_SYSTEM_NOT_OPEN then
            EntraceConditionData = nil
        else
            EntraceConditionData = { is_open = false, is_single_wave = false, is_has_remain = false }
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
    else
        -- condition 按位取值 目前这个条件只适用于双人守卫战
        EntraceConditionData = {
            is_open = Common.Bit32.And(l_info.condition, 1) > 0, -- 0001(1)表示开放时间是否满足
            is_single_wave = Common.Bit32.And(l_info.condition, 2) > 0, -- 0010(2)表示是否单人里面达到指定成绩
            is_has_remain = Common.Bit32.And(l_info.condition, 4) > 0, -- 0100(4) 表示本周是否有剩余次数
            is_today_remain = Common.Bit32.And(l_info.condition, 8) > 0, -- 1000(4) 表示今天是否有剩余次数
        }
    end
    EventDispatcher:Dispatch(OnCheckTowerDefenseCondition)
end

-- 请求升级|召唤英灵
function ReqAdminSpirit(arg)
    local l_msgId = Network.Define.Rpc.TowerDefenseSummon
    ---@type TowerDefenseSummonArg
    local l_sendInfo = GetProtoBufSendTable("TowerDefenseSummonArg")
    l_sendInfo.summon_id = arg.summon_id
    l_sendInfo.servant_type = arg.servant_type
    l_sendInfo.is_summon = arg.is_summon
    Network.Handler.SendRpc(l_msgId, l_sendInfo, arg)
end

function RspAdminSpirit(msg, _, arg)
    --log("RspAdminSpirit")
    ---@type TowerDefenseSummonRes
    local l_info = ParseProtoBufToTable("TowerDefenseSummonRes", msg)
    --log(ToString(l_info))
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        local l_tdUnitData = GetTdUnitRowById(arg.servant_type)
        if l_tdUnitData then
            if arg.is_summon then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseSummonSpirit", l_tdUnitData.Name))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseLvUpSpirit", l_tdUnitData.Name))
            end
        end
    end
end

-- 请求回复|加速英灵
function ReqCommandSpirit(arg)
    local l_msgId = Network.Define.Rpc.TowerDefenseServant
    ---@type TowerDefenseServantArg
    local l_sendInfo = GetProtoBufSendTable("TowerDefenseServantArg")
    l_sendInfo.summon_id = arg.summon_id
    l_sendInfo.servant_cmd = arg.servant_cmd


    --logGreen("l_sendInfo.summon_id:"..tostring(l_sendInfo.summon_id))
    --logGreen("l_sendInfo.servant_cmd:"..tostring(l_sendInfo.servant_cmd))


    Network.Handler.SendRpc(l_msgId, l_sendInfo, arg)
end

function RspCommandSpirit(msg, _, arg)
    --log("RspCommandSpirit")
    ---@type TowerDefenseServantRes
    local l_info = ParseProtoBufToTable("TowerDefenseServantRes", msg)
    --log(ToString(l_info))
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        --else
        --    if arg.servant_cmd == 1 then
        --        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseReplaySuccess"))
        --    elseif arg.servant_cmd == 2 then
        --        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TowerDefenseSpeedUpSuccess"))
        --    end
    end
end

-- 设置英灵信息 等级 数量 这些
function SetSpiritSummonData(data)
    local l_servantTigger = false -- 英灵数据是否发生改变
    local l_cdTigger = false -- cd时间是否发生改变
    for _, v in ipairs(data) do
        if v.servant_list and #v.servant_list > 0 then
            if SpiritSummonData[v.summon_id] == nil or table.ro_size(SpiritSummonData[v.summon_id]) == 0 then
                SpiritSummonData[v.summon_id] = {}
            end
            for __, servant in ipairs(v.servant_list) do
                SpiritSummonData[v.summon_id][servant.servant_type] = servant
            end
            l_servantTigger = true
        end
        if v.cmd_cd_list and #v.cmd_cd_list > 0 then
            if SummonCommandCDData[v.summon_id] == nil or table.ro_size(SummonCommandCDData[v.summon_id]) == 0 then
                SummonCommandCDData[v.summon_id] = { revive_time = 0, speedup_time = 0 }
            end
            for __, cmdcd in ipairs(v.cmd_cd_list) do
                if cmdcd.cmd == 1 then
                    SummonCommandCDData[v.summon_id].revive_time = tonumber(cmdcd.cmd_timestamp)
                elseif cmdcd.cmd == 2 then
                    SummonCommandCDData[v.summon_id].speedup_time = tonumber(cmdcd.cmd_timestamp)
                end
            end
            l_cdTigger = true
        end
    end
    if l_cdTigger then
        EventDispatcher:Dispatch(OnCommandSpiritEvent)
    end
    if l_servantTigger then
        EventDispatcher:Dispatch(OnAdminSpiritEvent)
    end
end

-- 获取所有召唤阵召唤的英灵数量
function GetSpiritSummonCount()
    if SpiritSummonData == nil then
        return 0
    end
    local l_count = 0
    for _, servants in pairs(SpiritSummonData) do
        for i = 1, #servants do
            l_count = l_count + servants[i].servant_num
        end
    end
    --logGreen("GetSpiritSummonCount:",l_count)
    return l_count
end

-- 获取指定召唤阵召唤的英灵数量
function GetSpiritSummonCountByCommonId(id)
    if SpiritSummonData == nil or SpiritSummonData[id] == nil then
        return 0
    end
    local l_count = 0
    for _, servants in pairs(SpiritSummonData[id]) do
        l_count = l_count + servants.servant_num
    end
    return l_count
end

function ReceiveTowerDefenseMagicPowerNtf(msg)
    ---@type TowerDefenseMagicPowerNtfData
    local l_info = ParseProtoBufToTable("TowerDefenseMagicPowerNtfData", msg)

    l_towerDefenseModuleData.TowerDefenseMagicPowerData = l_info

    if l_info.summon_info and #l_info.summon_info > 0 then
        --log(ToString(l_info))
        SetSpiritSummonData(l_info.summon_info)
    end

    EventDispatcher:Dispatch(ReceiveTowerDefenseMagicPowerNtfEvent)

end

function ReceiveTowerDefenseSyncMonster(msg)
    ---@type TowerDefenseSyncMonsterData
    local l_info = ParseProtoBufToTable("TowerDefenseSyncMonsterData", msg)

    l_towerDefenseModuleData.TowerDefenseSyncMonsterData = l_info

    EventDispatcher:Dispatch(ReceiveTowerDefenseSyncMonsterEvent)
end

--start_or_end 是否是这波开始
--can_fast_next_wave 是否是显示下一波倒计时
function ReceiveTowerDefenseWaveBegin(msg)
    ---@type TowerDefenseWaveBeginData
    local l_info = ParseProtoBufToTable("TowerDefenseWaveBeginData", msg)
    l_towerDefenseModuleData.CurrentWaveData = l_info

    --logGreen("l_info.start_or_end:",l_info.start_or_end)
    --logGreen("l_info.current_wave:",l_info.current_wave)
    --logGreen("l_info.can_fast_next_wave:",l_info.can_fast_next_wave)

    EventDispatcher:Dispatch(ReceiveTowerDefenseWaveBeginEvent)

end

function RequestTowerDefenseFastNextWave()

    local l_msgId = Network.Define.Rpc.TowerDefenseFastNextWave
    ---@type TowerDefenseFastNextWaveArg
    local l_sendInfo = GetProtoBufSendTable("TowerDefenseFastNextWaveArg")

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReceiveTowerDefenseFastNextWave(msg)
    ---@type TowerDefenseFastNextWaveRes
    local l_info = ParseProtoBufToTable("TowerDefenseFastNextWaveRes", msg)

    EventDispatcher:Dispatch(ReceiveTowerDefenseFastNextWaveEvent)
end

function RequestSetTowerDefenseBless(attackId, defenseId)

    local l_msgId = Network.Define.Rpc.SetTowerDefenseBless
    ---@type SetTowerDefenseBlessArg
    local l_sendInfo = GetProtoBufSendTable("SetTowerDefenseBlessArg")

    if attackId == nil then
        attackId = 0
    end

    if defenseId == nil then
        defenseId = 0
    end

    l_sendInfo.attack_id = tonumber(attackId)
    l_sendInfo.defense_id = tonumber(defenseId)

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReceiveSetTowerDefenseBless(msg)
    ---@type SetTowerDefenseBlessRes
    local l_info = ParseProtoBufToTable("SetTowerDefenseBlessRes", msg)

end

function RequestGetTowerDefenseWeekAward(awardId)

    local l_msgId = Network.Define.Rpc.GetTowerDefenseWeekAward
    ---@type GetTowerDefenseWeekAwardArg
    local l_sendInfo = GetProtoBufSendTable("GetTowerDefenseWeekAwardArg")
    l_sendInfo.id = awardId

    --logGreen("l_sendInfo.id:"..tostring(l_sendInfo.id))

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function ReceiveGetTowerDefenseWeekAward(msg)
    ---@type GetTowerDefenseWeekAwardRes
    local l_info = ParseProtoBufToTable("GetTowerDefenseWeekAwardRes", msg)

end

function ReceiveTowerDefenseEndlessStartNtf(msg)
    ---@type TowerDefenseEndlessData
    local l_info = ParseProtoBufToTable("TowerDefenseEndlessData", msg)

    EventDispatcher:Dispatch(ReceiveTowerDefenseEndlessStartNtfEvent)
end
------------------------------------------ 入口界面 ---------------------------------------------------------------------
-- 通过玩家等级&单人|双人 获取当前副本id
function GetDungeonsIDByPlayerLevel(typeid, level)
    local l_tdLvRangeData = TableUtil.GetTdLvRangeTable().GetRowByType(typeid, true)
    if l_tdLvRangeData then
        local l_dungeonsId = l_tdLvRangeData.Dungeons[0][1]
        for i = 0, l_tdLvRangeData.Dungeons.Length - 1 do
            if level >= l_tdLvRangeData.Dungeons[i][0] then
                l_dungeonsId = l_tdLvRangeData.Dungeons[i][1]
            end
        end
        return l_dungeonsId
    else
        logError("TdLvRangeTable表没有取到数据，id： " .. typeid)
    end
    return 0
end

-- 通过dungeonsId 获取DungeonsTable的row data
function GetDungeonsRowByDungeonsId(dungeonsId)
    local l_dungeonsData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonsId, true)
    if l_dungeonsData then
        return l_dungeonsData
    else
        logError("DungeonsTable表没有取到数据，id：" .. dungeonsId)
        return nil
    end
end

-- 通过单人|双人 获取TdLvRangeTable的row data
function GetTdLvRangeRowByModel(typeid)
    local l_tdLvRangeData = TableUtil.GetTdLvRangeTable().GetRowByType(typeid, true)
    if l_tdLvRangeData then
        return l_tdLvRangeData
    else
        logError("TdLvRangeTable表没有取到数据，id：" .. typeid)
        return nil
    end
end

-- 通过dungeonsId 获取TdTable的row data
function GetTdRowByDungeonsId(dungeonsId)
    local l_tdData = TableUtil.GetTdTable().GetRowByID(dungeonsId, true)
    if l_tdData then
        return l_tdData
    else
        logError("TdTable表没有取到数据，id：" .. dungeonsId)
        return nil
    end
end

-- 通过Id 获取TdUnitTable的row data
function GetTdUnitRowById(id)
    local l_tdUnitData = TableUtil.GetTdUnitTable().GetRowByID(id, true)
    if l_tdUnitData then
        return l_tdUnitData
    else
        logError("TdUnitTable表没有取到数据，id：" .. id)
        return nil
    end
end

-- 通过Id 获取TdOrderTable的row data
function GetTdOrderRowById(id)
    local l_tdOrderData = TableUtil.GetTdOrderTable().GetRowByID(id, true)
    if l_tdOrderData then
        return l_tdOrderData
    else
        logError("TdOrderTable表没有取到数据，id：" .. id)
        return nil
    end
end

-- 通过Id 获取EntityTable的row data
function GetEntityRowById(id)
    local l_entityData = TableUtil.GetEntityTable().GetRowById(id, true)
    if l_entityData then
        return l_entityData
    else
        logError("EntityTable表没有取到数据，id：" .. id)
        return nil
    end
end

-- 通过Id 获取PresentTable的row data
function GetPresentRowById(id)
    local l_presentData = TableUtil.GetPresentTable().GetRowById(id, true)
    if l_presentData then
        return l_presentData
    else
        logError("PresentTable表没有取到数据，id：" .. id)
        return nil
    end
end

-- 通过 回复|加速类型 获取cd时间
function GetSpiritCDTimeByType(type, summon_id)
    if SummonCommandCDData[summon_id] == nil then
        return -1
    end
    local l_tdOrderData = GetTdOrderRowById(type)
    if l_tdOrderData then
        if type == 1 then
            if SummonCommandCDData[summon_id].revive_time == 0 then
                return -1
            end
            return l_tdOrderData.CoolDown - (Common.TimeMgr.GetNowTimestamp() - SummonCommandCDData[summon_id].revive_time)
        elseif type == 2 then
            if SummonCommandCDData[summon_id].speedup_time == 0 then
                return -1
            end
            return l_tdOrderData.CoolDown - (Common.TimeMgr.GetNowTimestamp() - SummonCommandCDData[summon_id].speedup_time)
        end
    end
    return -1
end

------------------------------------------ 入口界面 ---------------------------------------------------------------------
function OpenTowerDefenseSpirit(_, command, args)
    if command and command.Length > 0 then
        CurrentSummonId = (tonumber(command[0]))
        UIMgr:ActiveUI(UI.CtrlNames.TowerDefenseSpirit)
        --UIMgr:ActiveUI(UI.CtrlNames.TowerDefenseSpirit, function(l_ui)
        --    if CurrentSpiritType == ETowerDefenseSpiritType.Admin
        --        or CurrentSpiritType == ETowerDefenseSpiritType.None then
        --        l_ui:SelectOneHandler(UI.HandlerNames.TowerDefenseSpiritAdmin)
        --    else
        --        l_ui:SelectOneHandler(UI.HandlerNames.TowerDefenseSpiritCommand)
        --    end
        --end)
    end
end

function OpenTowerDefenseEntrance()
    ReqCheckTowerDefenseCondition()
    UIMgr:ActiveUI(UI.CtrlNames.TowerDefenseEntrance)
end

function ClearAllData()
    l_towerDefenseModuleData.ClearAllData()
    CurrentTDMode = ETowerDefenseModel.None
    CurrentSpiritType = ETowerDefenseSpiritType.None
    SpiritSummonData = {}
    EntraceConditionData = nil
    CurrentSummonId = -1
    SummonCommandCDData = {}
    l_currentDeadCount = 0

    CurrentSpiritAdminSelectItemIndex = -1
    CurrentSpiritCommandSelectItemIndex = -1

    SummonCircleId = -1
end

function GetCountLimitData()
    local l_countData = MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[MgrMgr:GetMgr("LimitBuyMgr").g_limitType.TOWER_DEFENSE_LIMIT]
    if l_countData == nil then
        logError("[TowerDefenseMgr GetCountLimitData]没有找到次数 @陈华")
        return nil
    end
    local singleToday = l_countData[eTowerDefenseCountType.SingleToday]
    local singleWeekDefault = l_countData[eTowerDefenseCountType.SingleWeekDefault]
    local singleWeekExtra = l_countData[eTowerDefenseCountType.SingleWeekExtra]
    local singleWeekServerLevel = l_countData[eTowerDefenseCountType.SingleWeekServerLevel]
    local doubleToday = l_countData[eTowerDefenseCountType.DoubleToday]
    local doubleWeekDefault = l_countData[eTowerDefenseCountType.DoubleWeekDefault]
    local doubleWeekExtra = l_countData[eTowerDefenseCountType.DoubleWeekExtra]
    if singleToday == nil or singleWeekDefault == nil or singleWeekExtra == nil or singleWeekServerLevel == nil or
            doubleToday == nil or doubleWeekDefault == nil or doubleWeekExtra == nil then
        logError("[TowerDefenseMgr GetCountLimitData]没有找到次数 @陈华")
        return nil
    end

    local weekCount = math.max(tonumber(singleWeekDefault.count + singleWeekExtra.count), 0)
    local weekLimit = singleWeekDefault.limt + singleWeekExtra.limt

    if IsReachAddTimeServerLevel() then
        if singleWeekServerLevel.count > 0 then
            weekCount = weekCount + singleWeekServerLevel.count
        end
        if singleWeekServerLevel.limt > 0 then
            weekLimit = weekLimit + singleWeekServerLevel.limt
        end
    end

    local arg = {
        single = {
            weekCount = weekCount,
            weekLimt = weekLimit,
            todayCount = math.max(singleToday.count, 0),
            todayLimt = singleToday.limt,
        },
        double = {
            weekCount = math.max(tonumber(doubleWeekDefault.count + doubleWeekExtra.count), 0),
            weekLimt = doubleWeekDefault.limt + doubleWeekExtra.limt,
            todayCount = math.max(doubleToday.count, 0),
            todayLimt = doubleToday.limt,
        },
    }
    return arg
end

function IsReachAddTimeServerLevel()
    return MgrMgr:GetMgr("RoleInfoMgr").GetServerLevel() >= _singleWeekCountServerLevel
end

function _showHUD()

    local l_leftLife = GetLeftLife()

    MgrMgr:GetMgr("DungeonMgr").ShowLifeHUD(1, l_leftLife)


end

--任务奖励
--Key的低32位是任务类型
--Value 高32位标记是否领奖，低32位是进度
--高32位每一位对应id的个位
function _onAwardChange(id, value)
    local l_type, l_sign = tonumber(id)
    if l_type == nil then
        l_type = 0
    end
    l_type = tonumber(l_type)

    local l_progress, l_isGetAward = tonumber(value)
    if l_isGetAward == nil then
        l_isGetAward = 0
    end
    l_isGetAward = tonumber(l_isGetAward)

    if l_progress == nil then
        l_progress = 0
    end
    l_progress = tonumber(l_progress)

    --logGreen("l_isGetAward:" .. tostring(l_isGetAward))
    --logGreen("l_progress:" .. tostring(l_progress))

    l_towerDefenseModuleData.SetIsGetAwardWithType(l_type, l_isGetAward)
    l_towerDefenseModuleData.SetAwardTaskProgress(l_type, l_progress)

    EventDispatcher:Dispatch(ReceiveGetTowerDefenseWeekAwardEvent)

end

--祝福的Value高32位是攻击id，低32位是技能id
function _onBlessChange(id, value)
    local l_defenseBlessSkillId, l_attackBlessSkillId = tonumber(value)

    if l_attackBlessSkillId == nil then
        l_attackBlessSkillId = 0
    end
    l_attackBlessSkillId = tonumber(l_attackBlessSkillId)

    if l_defenseBlessSkillId == nil then
        l_defenseBlessSkillId = 0
    end
    l_defenseBlessSkillId = tonumber(l_defenseBlessSkillId)

    l_towerDefenseModuleData.SetAttackBlessSkillId(l_attackBlessSkillId)
    l_towerDefenseModuleData.SetDefenseBlessSkillId(l_defenseBlessSkillId)

    EventDispatcher:Dispatch(ReceiveSetTowerDefenseBlessEvent)
end

function OnLogout()
    ClearAllData()
end

function OnEnterScene(sceneId)

    l_currentDeadCount = MPlayerDungeonsInfo.PlayerSelfDeadCount

    local l_dungeonsType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")

    if l_dungeonsType == l_dungeonMgr.DungeonType.TowerDefenseSingle or l_dungeonsType == l_dungeonMgr.DungeonType.TowerDefenseDouble then

        _showHUD()

        GlobalEventBus:Add(EventConst.Names.PlayerDead,
                function(self)

                    l_currentDeadCount = l_currentDeadCount + 1
                    _showHUD()

                end,
                ModuleMgr.TowerDefenseMgr)
    end
end

function OnLeaveScene()
    ClearAllData()
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.PlayerDead, ModuleMgr.TowerDefenseMgr)
    MgrMgr:GetMgr("DungeonMgr").HideLifeHUD()
end

function OnInit()

    local l_TableInfos = TableUtil.GetTdQuestTable().GetTable()
    local keys = {}
    for i = 1, #l_TableInfos do
        keys[l_TableInfos[i].Type] = true
    end

    -- 通用数据协议处理称号
    ---@type CommonMsgProcessor
    local l_commonDataAward = Common.CommonMsgProcessor.new()
    local l_awardDatas = {}

    for key, v in pairs(keys) do
        local l_data = {}
        l_data.ModuleEnum = CommondataType.kCDT_TD_DUNGEON
        l_data.DetailDataEnum = key
        l_data.Callback = _onAwardChange
        table.insert(l_awardDatas, l_data)
    end

    l_commonDataAward:Init(l_awardDatas)

    local l_commonDataBless = Common.CommonMsgProcessor.new()
    local l_blessDatas = {}
    local l_data = {}
    l_data.ModuleEnum = CommondataType.kCDT_NORMAL
    l_data.DetailDataEnum = CommondataId.kCDI_TD_BLESS
    l_data.Callback = _onBlessChange
    table.insert(l_blessDatas, l_data)
    l_commonDataBless:Init(l_blessDatas)
end

manaRandom = 50

return ModuleMgr.TowerDefenseMgr
