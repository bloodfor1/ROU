--this file is gen by script
--you can edit this file in custom part

require "ModuleMgr/CommonMsgProcessor"

--lua model
---@module ModuleMgr.DeadDlgMgr
module("ModuleMgr.DeadDlgMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

--lua model end

--lua custom scripts


local l_data = DataMgr:GetData("DeadDlgData")
local coolDownTask = nil

function OnInit()
    coolDownTask = nil
    SetCoolDownTime(0)
    SetForbiddenFlag(false)

    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    --复活之证需求数量
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDT_ROLE_ITEM_REVIVE_TIMES,
        Callback = SetReviveItemNum,
    })
    l_commonData:Init(l_data)
end

function OnReconnected(reconnectData)
    local otherInfos = reconnectData and reconnectData.others_in_view
    RefreshDeadInfoWithOtherInfos(otherInfos)
end

function OnLuaDoEnterScene(doEnterSceneRes)
    RefreshDeadInfoWithOtherInfos(doEnterSceneRes.others_in_view)
end

function RequestRevive(type)
    if l_data.GetHatorId() > 0 then
        logGreen("仇恨没有被清理")
        return
    end
    if l_data.GetCoolDownTime() > 0 then
        logGreen("复活CD没到")
        return
    end
    if l_data.GetForbiddenFlag() then
        logGreen("复活被禁用")
        return
    end
    local l_msgId = Network.Define.Rpc.RoleRevive
    ---@type RoleReviveArg
    local l_sendInfo = GetProtoBufSendTable("RoleReviveArg")
    l_sendInfo.type = type
    l_sendInfo.role_id = MPlayerInfo.UID
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRoleRevive(msg, args)
    ---@type RoleReviveRes
    local l_info = ParseProtoBufToTable("RoleReviveRes", msg)
    if l_info.err ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.err))
    else
        CloseDeadDlg()
        MgrMgr:GetMgr("MainUIMgr").ShowSkill(true)
        --复活成功 如果处于Follow状态 重新开区跟随和战斗AI
        if MPlayerInfo.IsFollowing then
            MPlayerInfo.IsAutoBattle = true
            MPlayerInfo.IsFollowing = true
            MPlayerInfo.IsAutoFollow = true
        end
    end
end

function OnRevive()
    CloseDeadDlg()
    SpecialLogic()
end

function SpecialLogic()
    MgrMgr:GetMgr("InfiniteTowerDungeonMgr").OnRevive()
end

function SetCoolDownTime(time)
    if coolDownTask ~= nil then
        l_data.SetCoolDownTime(0)
        coolDownTask:Stop()
        coolDownTask = nil
    end
    if time > 0 then
        l_data.SetCoolDownTime(time)
        coolDownTask = Timer.New(function()
            time = time - 1
            l_data.SetCoolDownTime(time)
            EventDispatcher:Dispatch(l_data.DEAD_COOL_TIME_CHANGE, tonumber(time))
            if time == 0 then
                coolDownTask:Stop()
                coolDownTask = nil
            end
        end, 1, -1)
        coolDownTask:Start()
        EventDispatcher:Dispatch(l_data.DEAD_COOL_TIME_CHANGE, l_data.GetCoolDownTime())
    else
        l_data.SetCoolDownTime(0)
        EventDispatcher:Dispatch(l_data.DEAD_COOL_TIME_CHANGE, 0)
    end
end

function SetHatorId(hatorId)
    l_data.SetHatorId(hatorId)
    EventDispatcher:Dispatch(l_data.DEAD_HATORID_CHANGE, tonumber(hatorId))
end

function SetForbiddenFlag(flag)
    l_data.SetForbiddenFlag(flag)
    EventDispatcher:Dispatch(l_data.DEAD_FABIDDEN_REVIVE, flag)
end

function SetKillerName(killerName)
    l_data.SetKillerName(killerName)
    --DeadDlgModel.TXTKILLER:Dispatch(Data.onDataChange, l_data.GetTxtKiller())
end

function SetReviveItemNum(_, value)
    l_data.SetReviveInSituNum(tonumber(value))
end

---@param otherInfos UnitAppearance__Array
function RefreshDeadInfoWithOtherInfos(otherInfos)
    local deadInfo
    if otherInfos then
        for _, otherInfo in ipairs(otherInfos) do
            deadInfo = otherInfo.step_sync_info and otherInfo.step_sync_info.dead_info
            if otherInfo.uID == MPlayerInfo.UID then
                SetHatorId(tonumber(deadInfo.hater))
                SetCoolDownTime(0)
                local target = MEntityMgr:GetEntity(otherInfo.uID)
                l_data.SetKillerName(target and target.Name or "")
                break
            end
        end
    end
end

function SetDeadInfo(table, killerUID, coolDownTime, hatorId, ReviveNum)
    --log(killerUID, coolDownTime, hatorId, ReviveNum)
    local _forbiddenRevive = false
    if MPlayerDungeonsInfo.InDungeon then
        local dungeonId = MPlayerDungeonsInfo.DungeonID
        local dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonId)
        if dungeonData.DungeonsType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonAvoid or dungeonData.DungeonsType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonBeach then
            return
        end
        if l_data.CheckIsCountDownReviveDungeonsType(dungeonData.DungeonsType) then
            --todo 工会匹配赛特判，后续有类似需求要统一改成配置，时间有限此次不做处理
            if coolDownTime < 0 then
                local a, leftLife = MPlayerInfo.PlayerDungeonsInfo.LeftLifeCounter:TryGetValue(MPlayerInfo.UID, nil)
                --log(ToString(MPlayerInfo.PlayerDungeonsInfo.LeftLifeCounter))
                if a
                        and dungeonData.DungeonsType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonGuildMatch then
                    --log("CNM",leftLife)
                    if leftLife <= 0 then
                        coolDownTime = -1
                        _forbiddenRevive = true
                    else
                        coolDownTime = dungeonData.AutoReviveTime[0]
                        --log("CNM",coolDownTime)
                    end
                else
                    coolDownTime = dungeonData.AutoReviveTime[0]
                end
            end
            if not MgrMgr:GetMgr("FightEventMgr").IsArenaPreFightOver() then
                ActiveDeadDlg(_forbiddenRevive, coolDownTime, hatorId)
            end
            return
        end
        if coolDownTime < 0 then
            coolDownTime = dungeonData.ManualReviveTime[0] + dungeonData.ManualReviveTime[1] * tonumber(ReviveNum)
            coolDownTime = coolDownTime > dungeonData.ManualReviveTime[2] and dungeonData.ManualReviveTime[2] or coolDownTime
            _forbiddenRevive = not dungeonData.ClientCanRevive
            ActiveDeadDlg(_forbiddenRevive, coolDownTime, hatorId)
        end
    else
        _forbiddenRevive = false
        ActiveDeadDlg(_forbiddenRevive, coolDownTime, hatorId)
    end

    local mkiller = MEntityMgr:GetEntity(killerUID, true)
    local killerName = mkiller ~= nil and mkiller.Name or ""
    local dungeonType = MPlayerDungeonsInfo.InDungeon and TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID).DungeonsType or 0
    if dungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonThemeStory then
        killerName = ""
    end
    l_data.SetKillerName(killerName)

    MgrMgr:GetMgr("SkillControllerMgr").HideSkillController()
    MgrMgr:GetMgr("MoveControllerMgr").HideMoveController()
    MgrMgr:GetMgr("FightAutoMgr").CloseFightAuto()
end

function ActiveDeadDlg(forbiddenRevive, coolDownTime, hatorId)
    UIMgr:ActiveUI(UI.CtrlNames.DeadDlg)
    SetForbiddenFlag(forbiddenRevive)
    SetCoolDownTime(coolDownTime)
    SetHatorId(tonumber(hatorId))
    GlobalEventBus:Dispatch(EventConst.Names.PlayerDead)
end

function OnRoleDeadNtf(msg)
    ---@type RoleDeadNtfData
    local l_info = ParseProtoBufToTable("RoleDeadNtfData", msg)

    --- 表注一下，这边服务器给的类型是uint64 killer_owner_uid
    local ignoreTips = CheckNeedIgnoreTips(l_info.killer_table_id) or CheckNeedIgnoreTips(tonumber(l_info.killer_owner_uid))
    if not ignoreTips then
        MgrMgr:GetMgr("RoleNurturanceMgr").RefreshData(DataMgr:GetData("RoleNurturanceData").REFRESH_TYPE.Death)
    end
end

function CheckNeedIgnoreTips(Id)
    if not Id or Id == 0 then
        return false
    end

    local config = TableUtil.GetEntityTable().GetRowById(Id, true)
    if nil == config then
        return false
    end

    local type = config.UnitTypeLevel
    if type == GameEnum.UnitTypeLevel.Mvp or type == GameEnum.UnitTypeLevel.Mini then
        return true
    end
    return false
end

function CloseDeadDlg()
    UIMgr:DeActiveUI(UI.CtrlNames.DeadDlg, false)
    if UIMgr:IsPanelShowing(UI.CtrlNames.Chat) then
        return
    end
    if MgrMgr:GetMgr("SceneEnterMgr").IsPanelCanShowAtScene(UI.CtrlNames.MainChat) == false then
        return
    end
    if UIMgr:IsActiveUI(UI.CtrlNames.MainChat) then
        UIMgr:ShowUI(UI.CtrlNames.MainChat)
    else
        if game:IsLogout() == false then
            UIMgr:ActiveUI(UI.CtrlNames.MainChat)
        end
    end
end

--lua custom scripts end
return ModuleMgr.DeadDlgMgr