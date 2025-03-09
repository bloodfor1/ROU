require "ModuleMgr/QuickUseMgr"

---@module ModuleMgr.ProfessionMgr
module("ModuleMgr.ProfessionMgr", package.seeall)

-------------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--职业变化
ON_PROFESSION_CHANGE = "ON_PROFESSION_CHANGE"

--初心者的职业id
function GetNoviceProfessionId()
    return 1000
end

function GetBaseProfessionIdWithPlayer()

    return GetBaseProfessionIdWithProfessionId(MPlayerInfo.ProfessionId)
end

--根据职业id取基础的职业id
function GetBaseProfessionIdWithProfessionId(professionId)

    local l_noviceProfessionId = GetNoviceProfessionId()

    local l_playerParentProfession

    local l_currentProfessionId=professionId
    for i = 1, 5 do
        l_playerParentProfession = GetParentProfessionIdWithProfessionId(l_currentProfessionId)
        if l_playerParentProfession == l_noviceProfessionId then
            return l_currentProfessionId
        else
            l_currentProfessionId=l_playerParentProfession
        end
    end
    return nil
end

--取自己的父职业id
function GetParentProfessionIdWithPlayer()
    return GetParentProfessionIdWithProfessionId(MPlayerInfo.ProfessionId)
end

--根据职业id取这个职业的父职业id
function GetParentProfessionIdWithProfessionId(professionId)
    local l_noviceProfessionId = GetNoviceProfessionId()
    if professionId == nil then
        logError("传的数据是空的")
        return l_noviceProfessionId
    end

    if professionId == 0 then
        logError("传的数据是0")
        return l_noviceProfessionId
    end

    if professionId == l_noviceProfessionId then
        return l_noviceProfessionId
    end

    local l_professionTableInfo = TableUtil.GetProfessionTable().GetRowById(professionId, true)
    if l_professionTableInfo == nil then
        return l_noviceProfessionId
    end

    return l_professionTableInfo.ParentProfession

end

function RequestTransferProfession(roleType)
    local l_msgId = Network.Define.Rpc.TransferProfession
    ---@type TransferArg
    local l_sendInfo = GetProtoBufSendTable("TransferArg")
    l_sendInfo.role_type = roleType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function TransferProfession(roleType)
    local newId = roleType
    MPlayerInfo.ProID = roleType
    MgrMgr:GetMgr("CrashReportMgr").SetPlayerInfo()

    local newProfession = TableUtil.GetProfessionTable().GetRowById(newId)
    local transform = newProfession.ParentTransfromSkills
    for i = 0, transform.Count - 1 do
        local oldSkillId = transform:get_Item(i, 0)
        local newSkillId = transform:get_Item(i, 1)
        local oldSkillInfo = MPlayerInfo:GetCurrentSkillInfo(oldSkillId)
        MPlayerInfo:AddSkillPoint(newSkillId, oldSkillInfo.lv)
    end

    local slotIdxs = {}
    local skillIDs = {}
    local skillLvs = {}
    local index = 1
    for i = 0, MPlayerInfo.SkillSlots.Length - 1 do
        local currentSkillInfo = MPlayerInfo.SkillSlots[i]
        if currentSkillInfo.id ~= 0 then
            for j = 0, transform.Count - 1 do
                local oldSkillId = transform:get_Item(j, 0)
                local newSkillId = transform:get_Item(j, 1)
                if oldSkillId == currentSkillInfo.id then
                    slotIdxs[index] = i
                    skillIDs[index] = newSkillId
                    skillLvs[index] = currentSkillInfo.lv
                    index = index + 1
                end
            end
        end
    end
    MPlayerInfo:SetSkillSlots(slotIdxs, skillIDs, skillLvs)
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_RefreshSkill)

    slotIdxs = {}
    skillIDs = {}
    skillLvs = {}
    index = 1
    for i = 0, MPlayerInfo.AutoSkillSlots.Length - 1 do
        local currentSkillInfo = MPlayerInfo.AutoSkillSlots[i]
        if currentSkillInfo.id ~= 0 then
            for j = 0, transform.Count - 1 do
                local oldSkillId = transform:get_Item(j, 0)
                local newSkillId = transform:get_Item(j, 1)
                if oldSkillId == currentSkillInfo.id then
                    slotIdxs[index] = i
                    skillIDs[index] = newSkillId
                    skillLvs[index] = currentSkillInfo.lv
                    index = index + 1
                end
            end
        end
    end
    MPlayerInfo:SetAutoSkillSlots(slotIdxs, skillIDs, skillLvs)

    slotIdxs = {}
    skillIDs = {}
    skillLvs = {}
    index = 1
    for i = 0, MPlayerInfo.QueueSkillSlot.Length - 1 do
        local currentSkillInfo = MPlayerInfo.QueueSkillSlot[i]
        if currentSkillInfo.id ~= 0 then
            for j = 0, transform.Count - 1 do
                local oldSkillId = transform:get_Item(j, 0)
                local newSkillId = transform:get_Item(j, 1)
                if oldSkillId == currentSkillInfo.id then
                    slotIdxs[index] = i
                    skillIDs[index] = newSkillId
                    skillLvs[index] = currentSkillInfo.lv
                    index = index + 1
                end
            end
        end
    end
    MPlayerInfo:SetQueueSkillSlots(slotIdxs, skillIDs, skillLvs)

    MPlayerInfo:RefreshAllSkillToSkillMap()

    local l_mainRoleUI = UIMgr:GetUI(UI.CtrlNames.MainRoleInfo)
    if l_mainRoleUI then
        l_mainRoleUI:OnProfessionChange()
    end

    local l_VehicleUI = UIMgr:GetUI(UI.CtrlNames.Vehicle)
    if l_VehicleUI then
        l_VehicleUI:VehiclePanelRefresh()
    end

    MgrProxy:GetQuickUseMgr().OnTransfer()
    MgrMgr:GetMgr("MedalMgr").ReInintGloaryData()
    MgrMgr:GetMgr("ForgeMgr").OnLevelOrProfessionChange()

    local entity = MEntityMgr:GetEntity(MPlayerInfo.UID, true)
    local changed = entity:ChangeProfressionId(roleType)

    local l_extraData = { ignoreLimit = true }
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.StatusPoint, l_extraData)
    MgrMgr:GetMgr("VehicleInfoMgr").OnTransferProfession()
    local redSignKeys = {
        eRedSignKey.RedSignProHint1,
        eRedSignKey.RedSignProHint2,
        eRedSignKey.RedSignPro1,
        eRedSignKey.RedSignPro2,
    }
    for i = 1, #redSignKeys do
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(redSignKeys[i])
    end
    MgrMgr:GetMgr("RedSignCheckMgr").OnTransferProfession()

    EventDispatcher:Dispatch(ON_PROFESSION_CHANGE)
    MPlayerSetting:SetDefaultCommonAttack()

end

function OnTransferProfessionPtc(msg)
    ---@type TransferProfessionData
    local l_info = ParseProtoBufToTable("TransferProfessionData", msg)
    TransferProfession(l_info.role_type)
end

PROFESSIONTYPE = {
    ZERO = 0,
    ONE = 1,
    TWO = 2,
    THREE = 3
}

--根据职业Id获取是几转 返回 -1 0 1 2 3 -1代表错误 0代表初心者 1代表1转职业
function GetProfessionType(professionId)
    local l_professionTable = TableUtil.GetProfessionTable().GetRowById(professionId)
    if l_professionTable then
        return l_professionTable.ProfessionType
    end
    return PROFESSIONTYPE.ZERO
end

-- gm转职也有ptc推送
function OnRequestTransferProfession(msg)
end