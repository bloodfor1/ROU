---@module ModuleMgr.FightAutoMgr
module("ModuleMgr.FightAutoMgr", package.seeall)

local l_gameEventMgr = MgrProxy:GetGameEventMgr()
local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
GuideForProID =
{
    [2000] = "KnightFirTransferTaskGuide",
    [3000] = "PriestFirTransferTaskGuide",
    [4000] = "WizardFirTransferTaskGuide",
    [5000] = "AssassinFirTransferTaskGuide",
    [6000] = "BlacksmithFirTransferTaskGuide",
    [7000] = "HunterFirTransferTaskGuide"
}
AttackGuideTaskID = 1000090
function CloseFightAuto(luaType)
    --如果跟随中 不取消
    if DataMgr:GetData("TeamData").Isfollowing then
        return
    end

    MPlayerInfo.IsAutoBattle = false;
end

function StartFightAuto(luaType, targetId)
    --如果已经在自动战斗了，并且怪物也一样，那么就什么都不做
    if MPlayerInfo.IsAutoBattle == true and MPlayerInfo.AutoBattleList.Count == 1 and type(targetId) == "number" and MPlayerInfo.AutoBattleList:Contains(targetId) then
        return
    end

    MPlayerInfo.IsAutoBattle = false;
    MPlayerInfo.IsAutoBattle = true;
    if type(targetId) == "number" then
        if not MPlayerInfo.AutoBattleList:Contains(targetId) then
            MPlayerInfo:AddMonsterTarget(targetId)
        end
    elseif targetId.Length ~= nil then
        for i = 0, targetId.Length - 1 do
            if not MPlayerInfo.AutoBattleList:Contains(targetId[i]) then
                MPlayerInfo:AddMonsterTarget(targetId[i])
            end
        end
    elseif type(targetId) == "table" then
        for i = 1, #targetId do
            if not MPlayerInfo.AutoBattleList:Contains(targetId[i]) then
                MPlayerInfo:AddMonsterTarget(targetId[i])
            end
        end
    end

    GlobalEventBus:Dispatch(EventConst.Names.UpdateAutoBattleState, true)
end

-- 自动嗑药描述枚举
local l_eDoseDescType = {
    None = 0,
    NoDose = 1,
    NoHp = 2,
    NoMp = 3,
    AutoDose = 4,
}

-- 自动战斗范围描述枚举
local l_eFightDescType = {
    None = 0,
    Hold = 1,
    HalfScreen = 2,
    FullScreen = 3,
    FullMap = 4,
    Disable = 5,
}

-- 枚举状态对应的描述列表
local L_CONST_DOSE_DESC_MAP = {
    [l_eDoseDescType.NoDose] = Lang("AUTO_FIGHT_NO_DOSE"),
    [l_eDoseDescType.NoHp] = Lang("AUTO_FIGHT_NO_HP_DOSE"),
    [l_eDoseDescType.NoMp] = Lang("AUTO_FIGHT_NO_MP_DOSE"),
    [l_eDoseDescType.AutoDose] = Lang("AUTO_FIGHT_AUTO_DOSE"),
}

-- 自动战斗对应的描述状态
-- 标注一下，这个自动战斗范围的状态在UI代码里面直接用的tog的idx，这里是同步那边的idx
local L_CONST_FIGHT_DESC_MAP = {
    [l_eFightDescType.Hold] = Lang("AUTO_FIGHT_HOLD"),
    [l_eFightDescType.HalfScreen] = Lang("AUTO_FIGHT_HALF_SCREEN"),
    [l_eFightDescType.FullScreen] = Lang("AUTO_FIGHT_FULL_SCREEN"),
    [l_eFightDescType.FullMap] = Lang("AUTO_FIGHT_FULL_MAP"),
    [l_eFightDescType.Disable] = Lang("AUTO_FIGHT_FULL_MAP"),
}

-- 获取自动战斗描述
function GetAutoFightRangeDesc()
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.AutoRangeSetting) then
        return L_CONST_FIGHT_DESC_MAP[l_eFightDescType.Disable]
    end

    local l_ret = L_CONST_FIGHT_DESC_MAP[MPlayerInfo.AutoFightRange]
    if nil == l_ret then
        logError("[AutoFight] state invalid, value: " .. tostring(MPlayerInfo.AutoFightRange))
        return Lang("AUTO_FIGHT_HOLD")
    end

    return l_ret
end

-- 获取自动嗑药描述
function GetAutoDoseDesc()
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.AutoPotionSetting) then
        return L_CONST_DOSE_DESC_MAP[l_eDoseDescType.NoDose]
    end

    if not MPlayerInfo.EnableAutoHpDrag and not MPlayerInfo.EnableAutoMpDrag then
        return L_CONST_DOSE_DESC_MAP[l_eDoseDescType.NoDose]
    elseif MPlayerInfo.EnableAutoHpDrag and not MPlayerInfo.EnableAutoMpDrag then
        return L_CONST_DOSE_DESC_MAP[l_eDoseDescType.NoMp]
    elseif not MPlayerInfo.EnableAutoHpDrag and MPlayerInfo.EnableAutoMpDrag then
        return L_CONST_DOSE_DESC_MAP[l_eDoseDescType.NoHp]
    elseif MPlayerInfo.EnableAutoHpDrag and MPlayerInfo.EnableAutoMpDrag then
        return L_CONST_DOSE_DESC_MAP[l_eDoseDescType.AutoDose]
    else
        logError("[AutoFight] state invalid")
        return Lang("AUTO_FIGHT_NO_DOSE")
    end

    logError("[AutoFight] state invalid")
    return Lang("AUTO_FIGHT_NO_DOSE")
end

function OnSelectRoleNtf(msg)

    local l_autoBattleData = msg.temp_record.auto_battle
    --Common.Functions.DumpTable(msg.temp_record.auto_battle)

    local l_hp_progress = l_autoBattleData.hp_progress
    local l_sp_progress = l_autoBattleData.sp_progress
    local l_is_open_hp = l_autoBattleData.is_open_hp
    local l_is_open_sp = l_autoBattleData.is_open_sp
    local l_hp_item_list = l_autoBattleData.hp_item_list
    local l_sp_item_list = l_autoBattleData.sp_item_list
    local l_is_open_pick_up = l_autoBattleData.is_open_pick_up
    local l_pick_up_progress = l_autoBattleData.pick_up_progress

    MPlayerInfo.EnableAutoHpDrag = l_is_open_hp
    MPlayerInfo.EnableAutoMpDrag = l_is_open_sp
    MPlayerInfo.AutoDragHpPercent = l_hp_progress
    MPlayerInfo.AutoDragMpPercent = l_sp_progress

    for i, v in ipairs(l_hp_item_list) do
        if i > MPlayerInfo.AutoHpDragItemList.Length then
            break
        end
        MPlayerInfo.AutoHpDragItemList[i - 1] = v.value
    end

    for i, v in ipairs(l_sp_item_list) do
        if i > MPlayerInfo.AutoMpDragItemList.Length then
            break
        end
        MPlayerInfo.AutoMpDragItemList[i - 1] = v.value
    end

    MPlayerInfo.EnableAutoPickUp = l_is_open_pick_up
    MPlayerInfo.AutoPickUpPercent = l_pick_up_progress


    --挂机范围相关
    MPlayerInfo.AutoFightType = MoonClient.EAutoFightType.IntToEnum(l_autoBattleData.auto_battle_state)
    MPlayerInfo.AutoFightRangeType = MoonClient.EAutoFightRangeType.IntToEnum(l_autoBattleData.auto_battle_range)
    MPlayerInfo.AutoFightRange = l_autoBattleData.auto_battle_range_num
end

-- 保存是没有回包的
function SaveAutoBattleInfo()
    local l_msgId = Network.Define.Ptc.SaveAutoBattleInfoNtf
    ---@type SaveAutoBattleData
    local l_sendInfo = GetProtoBufSendTable("SaveAutoBattleData")

    l_sendInfo.auto_battle.hp_progress = MPlayerInfo.AutoDragHpPercent
    l_sendInfo.auto_battle.sp_progress = MPlayerInfo.AutoDragMpPercent

    l_sendInfo.auto_battle.is_open_hp = MPlayerInfo.EnableAutoHpDrag
    l_sendInfo.auto_battle.is_open_sp = MPlayerInfo.EnableAutoMpDrag

    for i = 0, MPlayerInfo.AutoHpDragItemList.Length - 1 do
        local l_item = l_sendInfo.auto_battle.hp_item_list:add()
        l_item.value = MPlayerInfo.AutoHpDragItemList[i]
    end

    for i = 0, MPlayerInfo.AutoMpDragItemList.Length - 1 do
        local l_item = l_sendInfo.auto_battle.sp_item_list:add()
        l_item.value = MPlayerInfo.AutoMpDragItemList[i]
    end

    l_sendInfo.auto_battle.is_open_pick_up = MPlayerInfo.EnableAutoPickUp
    l_sendInfo.auto_battle.pick_up_progress = MPlayerInfo.AutoPickUpPercent

    --挂机范围相关
    l_sendInfo.auto_battle.auto_battle_state = MPlayerInfo.AutoFightType:ToInt()
    l_sendInfo.auto_battle.auto_battle_range = MPlayerInfo.AutoFightRangeType:ToInt()
    l_sendInfo.auto_battle.auto_battle_range_num = MPlayerInfo.AutoFightRange

    --Common.Functions.DumpTable(l_sendInfo, "", 5)
    Network.Handler.SendPtc(l_msgId, l_sendInfo)

    -- 保存之后发消息变更状态
    l_gameEventMgr.RaiseEvent(l_gameEventMgr.OnAutoBattleSettingsConfirmed)
end

function CheckGuide()

    CheckAutoBattle()
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_taskData = l_taskMgr.GetTaskData(AttackGuideTaskID)
    if l_taskData and l_taskData.taskStatus == l_taskMgr.ETaskStatus.Taked then
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({"NormalAttack"})
    end

end

function CheckAutoBattle()

    if MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataId.kCDT_AUTO_BATTLE_STATUS) == 1 then
        return
    end
    local l_proId = DataMgr:GetData("SkillData").GetProOneId()
    local l_guideName = GuideForProID[l_proId]

    if l_guideName == nil then
        return
    end

    local l_tutorialIndex = TableUtil.GetTutorialIndexTable().GetRowByID(l_guideName, true)
    if l_tutorialIndex == nil then
        return
    end

    l_tutorialIndex = l_tutorialIndex.StepID
    local l_tutorialConfig = TableUtil.GetTutorialConfigTable().GetRowByID(l_tutorialIndex)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_taskData = l_taskMgr.GetTaskData(l_tutorialConfig.ValueId)
    if l_taskData and l_taskData.taskStatus == l_taskMgr.ETaskStatus.Taked then
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({l_guideName})
    end

end

return ModuleMgr.FightAutoMgr