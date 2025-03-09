---@module ModuleMgr.SkillLearningMgr
module("ModuleMgr.SkillLearningMgr", package.seeall)
require "Data/Model/PlayerInfoModel"

EventDispatcher = EventDispatcher.new()
MaxManualSlot = MGlobalConfig:GetInt("MaxManualSlot")
MaxAutoSlot = MGlobalConfig:GetInt("MaxAutoSlot")
MaxQueueSlot = MGlobalConfig:GetInt("MaxQueueSlot")
SkillRecommendId = 0
CurPlanId = 1
c = {}
ServerNtfSkillPlan = nil
g_proCacheSdatas = {}                       -- 职业静态数据缓存
---------------------------------网络协议------------------------------
ON_SKILL_POINT_APPLY = "ON_SKILL_POINT_APPLY"
ON_SKILL_SLOT_APPLY = "ON_SKILL_SLOT_APPLY"
ON_SKILL_INFO_UPDATE = "ON_SKILL_INFO_UPDATE" --技能信息更新后需要通知Tip更新
ON_SKILL_RESET = "ON_SKILL_RESET"
ON_SKILL_ENTERSCENE = "ON_SKILL_ENTERSCENE"
ON_SKILL_JOB_AWARD = "ON_SKILL_JOB_AWARD"
ON_SKILL_PLAN_CHANGE = "ON_SKILL_PLAN_CHANGE"

EventType = {
    RemainingPointChange = "RPC",
    UseMaxLevel = "UML"
}

local MultiTalents_SkillMultiRedSign = "MultiTalents_SkillMultiRedSign"
local l_hasNewSkill = false

function OnInit()

    skillData = DataMgr:GetData("SkillData")
    Data.PlayerInfoModel.JOBLV:Add(Data.onDataChange, function()
        DealWithRedSign()
    end, ModuleMgr.SkillLearningMgr)

    local multiTalentMgr = MgrMgr:GetMgr("MultiTalentMgr")
    multiTalentMgr.EventDispatcher:Add(multiTalentMgr.ReceiveOpenMultiTalentEvent, OnOpenMultiTalentEvent)
    multiTalentMgr.EventDispatcher:Add(multiTalentMgr.ReceiveChangeMultiTalentEvent, OnChangeMultiTalentEvent)
    multiTalentMgr.EventDispatcher:Add(multiTalentMgr.ReceiveRenameMultiTalentEvent, OnRenameMultiTalentEvent)

end

function UnInit()

    skillData = nil
    Data.PlayerInfoModel.JOBLV:RemoveObjectAllFunc(Data.onDataChange, ModuleMgr.SkillLearningMgr)

    local multiTalentMgr = MgrMgr:GetMgr("MultiTalentMgr")
    multiTalentMgr.EventDispatcher:RemoveObjectAllFunc(multiTalentMgr.ReceiveOpenMultiTalentEvent, multiTalentMgr)
    multiTalentMgr.EventDispatcher:RemoveObjectAllFunc(multiTalentMgr.ReceiveChangeMultiTalentEvent, multiTalentMgr)
    multiTalentMgr.EventDispatcher:RemoveObjectAllFunc(multiTalentMgr.ReceiveRenameMultiTalentEvent, multiTalentMgr)

end

function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        return
    end
    local buffSkill = l_roleAllInfo and l_roleAllInfo.equip_buff_skill
    if buffSkill then
        buffSkill = ProcessBuffSkills(buffSkill)
        MPlayerInfo:SetBuffSkills(buffSkill.skill_id, buffSkill.skill_lv)
    end
end

function OnLuaDoEnterScene(info)

    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        return
    end
    if info and info.game_role_info then
        local buffSkill = info.game_role_info and info.game_role_info.equip_buff_skill
        if buffSkill then
            buffSkill = ProcessBuffSkills(buffSkill)
            MPlayerInfo:SetBuffSkills(buffSkill.skill_id, buffSkill.skill_lv)
        end
    end
    
end

function OnEnterScene(sceneId)
    EventDispatcher:Dispatch(ON_SKILL_ENTERSCENE)
    OnCloseSlot()
end

--==============================--
--@Description:设置一个技能页签(手动/自动)
--@Date: 2019/5/23
--@Param: [args]
--@Return:
--==============================--
function ApplySkillSlots(skillSlots, forceInit, type, page)

    page = page or 1
    local l_slotIdxs = {}
    local l_skillIDs = {}
    local l_skillLvs = {}
    if skillSlots.slots then
        for i, v in ipairs(skillSlots.slots) do
            l_slotIdxs[i] = (page - 1) * skillData.SlotCount + v.slot - 1
            l_skillIDs[i] = v.skill_id
            l_skillLvs[i] = v.skill_level
        end
    end
    if type == 2 then
        MPlayerInfo:SetAutoSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs, forceInit)
    elseif type == 1 then
        MPlayerInfo:SetSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs, forceInit)
    elseif type == 3 then
        MPlayerInfo:SetQueueSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs, forceInit)
    end
    return l_skillIDs

end

--==============================--
--@Description:应用技能方案
--@Date: 2019/5/23
--@Param: [args]
--@Return:
--==============================--
function ApplySkillPlan(planId)

    local skillIds = {}
    if not planId or not skillData.IsSkillPlanOpen(planId) then
        logError("技能方案id非法 ", planId)
        return skillIds
    end

    local skillPlan = skillData.GetCurSkillPlan(planId)
    local mainSlot1 = {}
    local mainSlot2 = {}
    local autoSlot = {}
    local queueSlot = {}
    for i, v in ipairs(skillPlan.slots) do
        if v.type == 0 or not v.type then
            mainSlot1 = v
        elseif v.type == 1 then
            mainSlot2 = v
        elseif v.type == 2 then
            autoSlot = v
        elseif v.type == 3 then
            queueSlot = v
        end
    end

    local applySkillIds = {}
    if mainSlot1 then
        applySkillIds = ApplySkillSlots(mainSlot1, true, 1, 1)
        --table.mergeArray(skillIds, applySkillIds)
    end
    if mainSlot2 then
        applySkillIds = ApplySkillSlots(mainSlot2, false, 1, 2)
        --table.mergeArray(skillIds, applySkillIds)
    end
    if autoSlot then
        applySkillIds = ApplySkillSlots(autoSlot, true, 2, 1)
        --table.mergeArray(skillIds, applySkillIds)
    end
    if queueSlot then
        applySkillIds = ApplySkillSlots(queueSlot, true, 3, 1)
        --table.mergeArray(skillIds, applySkillIds)
    end

    -- 设置人物技能数据
    return ApplyPlayerSkillInfo(skillPlan.skills)

end

--==============================--
--@Description:设置人物技能数据
--@Date: 2019/5/23
--@Param: [args]
--@Return:
--==============================--
function ApplyPlayerSkillInfo(allSkills)

    local l_skillIDs = {}
    local l_skillLvs = {}
    --遍历ProfessionSkill
    local index = 1
    if allSkills then
        for i, v in ipairs(allSkills) do
            local skillList = v.skill
            for skill_i, skill_v in ipairs(skillList) do
                l_skillIDs[index] = skill_v.skill_id
                l_skillLvs[index] = skill_v.skill_level
                index = index + 1
            end
        end
    end
    MPlayerInfo:SetSkills(l_skillIDs, l_skillLvs, true)
    return l_skillIDs

end

--==============================--
--@Description:登录更新技能数据
--@Date: 2019/1/18
--@Param: [args]
--@Return:
--==============================--
function OnSelectRoleNtf(info)

    local l_info = info.skill
    skillData.InitSkillPlan(l_info.plans)
    CurPlanId = l_info.cur_plan_id + 1

    -- 设置技能槽
    local skillIds = ApplySkillPlan(CurPlanId)

    -- 职业奖励
    if l_info.job_award then
        skillData.InitJobAwardTaked(l_info.job_award)
    end

    local useMaxLevelKey = "SkillSlotUseMaxLevel" .. MPlayerInfo.UID:tostring()
    if PlayerPrefs.HasKey(useMaxLevelKey) then
        skillData.SetUseMaxLevel(PlayerPrefs.GetInt(useMaxLevelKey) == 1)
    else
        skillData.SetUseMaxLevel(true)
        PlayerPrefs.SetInt(useMaxLevelKey, 1)
    end
    EventDispatcher:Dispatch(EventType.UseMaxLevel, skillData.GetUseMaxLevel())

    skillData.UpdateFirstSaveSKill(skillIds)
    UpdateCheckRedPoint()

end

function OnLogout()

    CurPlanId = 0
    skillData.SavedSkillIds = {}
    ServerNtfSkillPlan = nil

end

--设置加点发送消息
function SetSkillPoint(proId, addedSkillPoint)

    local l_msgId = Network.Define.Rpc.SkillPoint
    ---@type SkillPointArg
    local l_sendInfo = GetProtoBufSendTable("SkillPointArg")
    --设置具体的参数

    local proList = skillData.GetProfessionIdList()

    local lastIsBad = false
    local skillPointData
    for _, proId in pairs(proList) do
        if not lastIsBad then
            skillPointData = l_sendInfo.data:add()
        end
        if skillPointData ~= nil then
            --职业Id
            skillPointData.role_type = proId
            lastIsBad = true
            --当前职业的技能
            local proSkillIdVectorSeq = skillData.GetDataFromTable("ProfessionTable", proId).SkillIds
            local skillList = {}
            local l_vecLength = proSkillIdVectorSeq.Length
            for i = 0, l_vecLength - 1 do
                skillList[i + 1] = proSkillIdVectorSeq[i][0]
            end
            local skillIdList = skillData.SortSkill(skillList)
            for index, skillId in pairs(skillIdList) do
                for id, added in pairs(addedSkillPoint) do
                    if skillId == id and added ~= 0 then
                        local preSkillPoint = skillPointData.points:add()
                        preSkillPoint.skill_id = id
                        preSkillPoint.skill_point = added
                        --服务器打点数据 Mx
                        preSkillPoint.skill_operatetype = (SkillRecommendId == 0 or nil) and
                                QualityPointOperateType.QUALITY_POINT_FREE_ASSIGN or
                                QualityPointOperateType.QUALITY_POINT_RECOMMAND_ASSIGN
                        preSkillPoint.skill_recommend_id = SkillRecommendId or 0
                        lastIsBad = false
                    end
                end
            end
        end
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

--设置加点成功
function OnSkillPoint(msg, isUnlock)

    ---@type SkillPointRes
    local l_info = ParseProtoBufToTable("SkillPointRes", msg)
    if l_info.err ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.err))
        return
    end
    l_hasNewSkill = false
    local skillPointDatas = l_info.data
    local newSlots = l_info.learn_skill_slot
    local addedSkillIds = {}
    local newSkillIds = {}
    local upgradeData = {}

    for i, skillPointData in ipairs(skillPointDatas) do
        for i, pointData in ipairs(skillPointData.points) do
            local skill_id = pointData.skill_id
            local skill_point = pointData.skill_point
            -- 非被动
            local skillInfo = MPlayerInfo:GetCurrentSkillInfo(skill_id)
            if skillInfo.id == 0 and skillData.GetDataFromTable("SkillTable", skill_id).SkillAttr ~= -1 then
                l_hasNewSkill = true
            end
            table.insert(upgradeData, { lv = skillInfo.lv, afterLv = skillInfo.lv + skill_point, skillId = skill_id })
            MPlayerInfo:AddSkillPoint(skill_id, skill_point)
            array.addUnique(addedSkillIds, skill_id)
            -- 判断是否是骑士学习到了骑鸟 --韩国cbt版本陈倪要求添加
            if skillData.KnightFirstRiding(skill_id) then
                MgrMgr:GetMgr("VehicleMgr").RequestTakeVehicle(true, true)
            end
        end
    end

    local l_removeAttack = false
    if newSlots then

        local index = 1
        local autoIndex = 1
        local queueIndex = 1
        local l_slotIdxs = {}
        local l_skillIDs = {}
        local l_skillLvs = {}
        local l_queueIdxs = {}
        local l_queueIDs = {}
        local l_queueLvs = {}
        local l_autoSlotIdxs = {}
        local l_autoSkillIDs = {}
        local l_autoSkillLvs = {}
        for k, newSlot in pairs(newSlots) do
            if newSlot.slot then
                if newSlot.slot <= MaxManualSlot then
                    l_slotIdxs[index] = newSlot.slot - 1
                    l_skillIDs[index] = newSlot.skill_id
                    l_skillLvs[index] = newSlot.skill_level
                    index = index + 1
                elseif newSlot.slot <= MaxManualSlot + MaxAutoSlot then
                    if newSlot.skill_id == 0 or skillData.IsHasAI(newSlot.skill_id) then
                        l_autoSlotIdxs[autoIndex] = newSlot.slot - (MaxManualSlot + 1)
                        l_autoSkillIDs[autoIndex] = newSlot.skill_id
                        if not UserDataManager.HasData(MPlayerSetting.FIRST_LEARNING_MAGICSKILL, MPlayerSetting.PLAYER_SETTING_GROUP) then
                            --法师第一次习得远程法术的时候去除普攻
                            if skillData.MageFirstFarSkill(newSlot.skill_id) then
                                l_removeAttack = true
                                UserDataManager.SetDataFromLua(MPlayerSetting.FIRST_LEARNING_MAGICSKILL, MPlayerSetting.PLAYER_SETTING_GROUP, true)
                            end
                        end
                        l_autoSkillLvs[autoIndex] = newSlot.skill_level
                        autoIndex = autoIndex + 1
                    end
                else
                    l_queueIdxs[queueIndex] = newSlot.slot - (MaxManualSlot + MaxAutoSlot + 1)
                    l_queueIDs[queueIndex] = newSlot.skill_id
                    l_queueLvs[queueIndex] = newSlot.skill_level
                    queueIndex = queueIndex + 1
                end
                table.insert(newSkillIds, newSlot.skill_id)
            end
        end
        MPlayerInfo:SetSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs)
        MPlayerInfo:SetAutoSkillSlots(l_autoSlotIdxs, l_autoSkillIDs, l_autoSkillLvs)
        skillData.UpdateFirstSaveSKill(newSkillIds)
        --移除普攻
        if l_removeAttack and not isUnlock then
            RemoveSkillInAuto({ 100001, 100005 })
        end

    end
    --使用的是最高等级的技能就更新技能槽
    if skillData.GetUseMaxLevel() and not isUnlock then
        UpdateMaxLvSkillInSlot(addedSkillIds)
    end

    EventDispatcher:Dispatch(ON_SKILL_POINT_APPLY, upgradeData)
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_ReSetSkill)
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_RefreshSkill)
    local l_skillData = {
        openType = DataMgr:GetData("SkillData").OpenType.SetLevelUpdateData,
        upgrade = upgradeData
    }
    MAudioMgr:Play("event:/UI/SkillPanelAddPointFinish")
    UIMgr:ActiveUI(UI.CtrlNames.SkillLevelUpgrading, l_skillData)

    if l_hasNewSkill then
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SkillLearningSetting)
    end
    UpdateCheckRedPoint()

end

function SyncSkillSlots()

    local l_slotTmpTable = {}
    local l_slotAutoTmpTable = {}
    local l_slotQueueTable = {}
    for i = 1, MPlayerInfo.SkillSlots.Length do
        local skillInfo = MPlayerInfo.SkillSlots[i - 1]
        l_slotTmpTable[i] = skillInfo
    end
    for i = 1, MPlayerInfo.AutoSkillSlots.Length do
        l_slotAutoTmpTable[i] = MPlayerInfo.AutoSkillSlots[i - 1]
    end
    for i = 1, MPlayerInfo.QueueSkillSlot.Length do
        l_slotQueueTable[i] = MPlayerInfo.QueueSkillSlot[i - 1]
    end
    SetSkillSlot(l_slotTmpTable, l_slotAutoTmpTable, l_slotQueueTable)

end

--将技能槽的等级设置为最高等级
function UpdateMaxLvSkillInSlot(skill_ids)

    local l_slotTmpTable = {}
    local l_slotAutoTmpTable = {}
    local l_slotQueueTable = {}
    for i = 1, MPlayerInfo.SkillSlots.Length do
        local skillInfo = MPlayerInfo.SkillSlots[i - 1]
        for j, skill_id in ipairs(skill_ids) do
            if skillInfo.id == skill_id then
                skillInfo.lv = MPlayerInfo:GetCurrentSkillInfo(skill_id).lv
                l_slotTmpTable[i] = skillInfo
            end
        end
    end
    for i = 1, MPlayerInfo.AutoSkillSlots.Length do
        local skillInfo = MPlayerInfo.AutoSkillSlots[i - 1]
        for j, skill_id in ipairs(skill_ids) do
            if skillInfo.id == skill_id then
                skillInfo.lv = MPlayerInfo:GetCurrentSkillInfo(skill_id).lv
                l_slotAutoTmpTable[i] = skillInfo
            end
        end
    end
    for i = 1, MPlayerInfo.QueueSkillSlot.Length do
        local skillInfo = MPlayerInfo.QueueSkillSlot[i - 1]
        for j, skill_id in ipairs(skill_ids) do
            if skillInfo.id == skill_id then
                skillInfo.lv = MPlayerInfo:GetCurrentSkillInfo(skill_id).lv
                l_slotQueueTable[i] = skillInfo
            end
        end
    end
    SetSkillSlot(l_slotTmpTable, l_slotAutoTmpTable, l_slotQueueTable)

end

--设置技能孔发送消息
function SetSkillSlot(manTable, autoTable, queueTable)

    local l_msgId = Network.Define.Rpc.SkillSlot
    ---@type SkillSlotArg
    local l_sendInfo = GetProtoBufSendTable("SkillSlotArg")
    local l_slot_data = l_sendInfo.data
    local k = 1
    for i = 1, skillData.SlotCount do
        k = i
        v = manTable[k]
        if v ~= nil then
            local l_skill_info = v
            --[[if l_skill_info.lv == 0 and l_skill_info.id == skillData.SkillQueueId then
                l_skill_info.lv = 1                 --技能队列等级强行设为1级，不然服务器校验不通过
            end]]
            local l_manual_slot = l_slot_data.manual_slot_1:add()
            l_manual_slot.slot = k
            l_manual_slot.skill_id = l_skill_info.id
            l_manual_slot.skill_level = l_skill_info.lv
        end
    end

    for i = 1, skillData.SlotCount do
        k = i + skillData.SlotCount
        v = manTable[k]
        if v ~= nil then
            local l_skill_info = v
            local l_manual_slot = l_slot_data.manual_slot_2:add()
            l_manual_slot.slot = i
            l_manual_slot.skill_id = l_skill_info.id
            l_manual_slot.skill_level = l_skill_info.lv
        end
    end

    for k, v in pairs(autoTable) do
        local l_skill_info = v
        if v ~= nil then
            local l_auto_slot = l_slot_data.auto_slot:add()
            l_auto_slot.slot = k
            l_auto_slot.skill_id = l_skill_info.id
            l_auto_slot.skill_level = l_skill_info.lv
        end
    end

    for k, v in pairs(queueTable) do
        local l_skill_info = v
        if v ~= nil then
            local l_queue_slot = l_slot_data.manual_slot_3:add()
            l_queue_slot.slot = k
            l_queue_slot.skill_id = l_skill_info.id
            l_queue_slot.skill_level = l_skill_info.lv
        end
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

--设置技能孔成功
function OnSkillSlot(msg)

    ---@type SkillSlotRes
    local l_info = ParseProtoBufToTable("SkillSlotRes", msg)
    if l_info.err ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.err))
        --logError("存在未学习的技能，如果直接通过指令获取的技能（例如治疗和装死）就可能出现该情况")
        return
    end
    local l_skill_slot_data = l_info.data
    local l_manual_slot_data_1 = l_skill_slot_data.manual_slot_1
    local l_manual_slot_data_2 = l_skill_slot_data.manual_slot_2
    local l_manual_slot_data_3 = l_skill_slot_data.manual_slot_3

    local l_slotIdxs, l_skillIDs, l_skillLvs = {}, {}, {}
    for i, v in ipairs(l_manual_slot_data_1) do
        l_slotIdxs[i] = v.slot - 1
        l_skillIDs[i] = v.skill_id
        l_skillLvs[i] = v.skill_level
    end
    MPlayerInfo:SetSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs)

    l_slotIdxs, l_skillIDs, l_skillLvs = {}, {}, {}
    for i, v in ipairs(l_manual_slot_data_2) do
        l_slotIdxs[i] = v.slot - 1 + skillData.SlotCount
        l_skillIDs[i] = v.skill_id
        l_skillLvs[i] = v.skill_level
    end
    MPlayerInfo:SetSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs)

    l_slotIdxs, l_skillIDs, l_skillLvs = {}, {}, {}
    local l_auto_slot_data = l_skill_slot_data.auto_slot
    for i, v in ipairs(l_auto_slot_data) do
        l_slotIdxs[i] = v.slot - 1
        l_skillIDs[i] = v.skill_id
        l_skillLvs[i] = v.skill_level
    end
    MPlayerInfo:SetAutoSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs)

    l_slotIdxs, l_skillIDs, l_skillLvs = {}, {}, {}
    for i, v in ipairs(l_manual_slot_data_3) do
        l_slotIdxs[i] = v.slot - 1
        l_skillIDs[i] = v.skill_id
        l_skillLvs[i] = v.skill_level
    end
    MPlayerInfo:SetQueueSkillSlots(l_slotIdxs, l_skillIDs, l_skillLvs)

    EventDispatcher:Dispatch(ON_SKILL_SLOT_APPLY)
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_RefreshSkill)

end

--从自动栏移除技能
function RemoveSkillInAuto(skillIds)

    local l_slotTmpTable = {}
    local l_slotAutoTmpTable = {}
    local l_slotQueueTable = {}
    for j = 1, MPlayerInfo.SkillSlots.Length do
        l_slotTmpTable[j] = MPlayerInfo.SkillSlots[j - 1]
    end
    for j = 1, MPlayerInfo.QueueSkillSlot.Length do
        l_slotQueueTable[j] = MPlayerInfo.QueueSkillSlot[j - 1]
    end

    for j = 1, MPlayerInfo.AutoSkillSlots.Length do
        for l, skillId in ipairs(skillIds) do
            if MPlayerInfo:GetRootSkillId(MPlayerInfo.AutoSkillSlots[j - 1].id) ~= MPlayerInfo:GetRootSkillId(skillId) then
                l_slotAutoTmpTable[j] = MPlayerInfo.AutoSkillSlots[j - 1]
            else
                l_slotAutoTmpTable[j] = MoonClient.MSkillInfo.New()
                break
            end
        end
    end
    for k, v in pairs(l_slotAutoTmpTable) do
        l_slotAutoTmpTable[k].id = skillData.GetProfessionSkillId(v.id)
    end
    SetSkillSlot(l_slotTmpTable, l_slotAutoTmpTable, l_slotQueueTable)

end

function OnLongClickSkillSlot(luaType, id, obj, lv, alpha)

    if MgrMgr:GetMgr("BeachMgr").IsBeach() then
        MgrMgr:GetMgr("BeachMgr").OnLongClickSkillSlot(id)
        return
    end
    ShowSkillTip(id, obj, lv, alpha)

end

function ShowSkillTip(id, obj, lv, alpha)

    alpha = alpha or 1
    UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
    local l_skillData = {
        openType = DataMgr:GetData("SkillData").OpenType.ShowSkillTip,
        lv = lv,
        obj = obj,
        id = id,
        alpha = alpha
    }
    UIMgr:ActiveUI(UI.CtrlNames.SkillPointTip, l_skillData)

end

function OnUpSkillSlot(luaType, id)

    if MgrMgr:GetMgr("BeachMgr").IsBeach() then
        MgrMgr:GetMgr("BeachMgr").OnUpSkillSlot(id)
    end

end

function OnCloseSlot(luaType)
    UIMgr:DeActiveUI(UI.CtrlNames.SkillPointTip)
end

function SendSkillReset()
    local l_msgId = Network.Define.Rpc.SkillReset
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnResetSkill(msg)
    ---@type NullRes
    local l_info = ParseProtoBufToTable("NullRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    MPlayerInfo:ResetSkills()
    EventDispatcher:Dispatch(ON_SKILL_RESET)
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_ReSetSkill)
    UpdateCheckRedPoint()

end

--任务解锁技能
function OnTaskUnlockSkill(msg)
    MgrMgr:GetMgr("SkillLearningMgr").OnSkillPoint(msg, true)
end

---------------------------------网络协议------------------------------

---------------------------------通用方法------------------------------

--红点检测，是否可以领取职业奖励
function CheckJobAward()

    local ret = 0
    local changeLv = Common.CommonUIFunc.InitProfessionChangeLv()
    local l_proTypeList = skillData.GetProfessionInfo()
    for k, v in pairs(l_proTypeList) do
        if v.proId == 0 then
            break
        end
        local jobRewards = skillData.GetProfessionJobAwards(v.proId)
        if jobRewards then
            local proSdata = skillData.GetDataFromTable("ProfessionTable", v.proId)
            for i, jobReward in ipairs(jobRewards) do
                local realJobLv = (changeLv[proSdata.ProfessionType] or 0) + jobReward.NeedJobLvl
                if MPlayerInfo.JobLv >= realJobLv and (not skillData.JobAwardHasBeenTaked[v.proId] or
                        not array.contains(skillData.JobAwardHasBeenTaked[v.proId], jobReward.NeedJobLvl)) then
                    ret = 1
                end
            end
        end
    end
    return ret

end

--红点检测
function CheckShowPoint(proType)

    if skillData.GetSkillLeftPoint() > 0 then
        return 1
    end
    return 0

end

--红点检测
function CheckSetting()

    if l_hasNewSkill then
        return 1
    end
    return 0

end

function DealWithRedSign()

    if MPlayerInfo.JobLv % 3 == 0 then
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SkillLearningSkill)
    end
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SkillLearningJobAward)

end

function UpdateCheckRedPoint()

    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SkillLearningSkill)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SkillLearningJobAward)

end

--==============================--
--@Description: 打开技能设置面板
--@Date: 2018/9/1
--@Param: [args]
--@Return:
--==============================--
function OnOpenSkillSetting()

    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Skill) then
        local l_skillData = {
            openType = DataMgr:GetData("SkillData").OpenType.OpenSkillSetting
        }
        UIMgr:ActiveUI(UI.CtrlNames.SkillLearning, l_skillData)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_NOT_OPEN_SKILL_TIP"))
    end

end

function OnTriggerAddSkillNtf(msg)
    ---@type SkillInfo
    local l_info = ParseProtoBufToTable("SkillInfo", msg)
    MPlayerInfo:AddMainUISkillSlot(l_info.skill_id, l_info.skill_level)
end

function OnClickSkill(skillId, skillLv)
    GlobalEventBus:Dispatch(EventConst.Names.TaskEventCastSkill, skillId)
end

--把Ctrl的逻辑挪到Mgr方便外部调用
function CanResetSkills()

    if MEntityMgr.PlayerEntity.InBattle then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILLLEARNING_CANNOT_RESET_SKILL_IN_BATTLE"))
        return false
    end
    if MEntityMgr.PlayerEntity.CurrentState == ROGameLibs.StateDefine.kStateSinging then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILLLEARNING_CANNOT_RESET_SKILL_IN_SINGING"))
        return false
    end
    local l_skillList = MPlayerInfo.SkillList
    local l_canReset = false
    for i = 0, l_skillList.Count - 1 do
        local v = l_skillList[i]
        if skillData.NeedSkillPointToLearn(v.id) and v.lv > 0 then
            l_canReset = true
            break
        end
    end
    if l_canReset == false then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SKILLLEARNING_CANNOT_RESET_SKILL_WITHOUT_POINT"))
        return false
    end
    return true

end

--region Buff技能
--==============================--
--@Description:装备/卡片技能全量更新
--@Date: 2018/12/11
--@Param: [args]
--@Return:
--==============================--
---@param info BuffSkill
function OnBuffSkillNtf(info)
    info = ProcessBuffSkills(info)
    MPlayerInfo:SetBuffSkills(info.skill_id, info.skill_lv)
end

--==============================--
--@Description:处理buffskill数据
--@Date: 2018/12/21
--@Param: [args]
--@Return:
--==============================--
function ProcessBuffSkills(info)
    local ret = { skill_id = {}, skill_lv = {} }
    for i = 1, #info.skill_id do
        table.insert(ret.skill_id, info.skill_id[i].value)
        table.insert(ret.skill_lv, info.skill_lv[i].value)
    end

    return ret
end
--endregion

function ResetHasNewSkillFlag()
    l_hasNewSkill = false
end

function GetTotalMaxJob(proId)

    local _, ret = 0
    if not proId then
        _, proId = skillData.CurrentProTypeAndId()
    end
    local sdata = g_proCacheSdatas[proId]
    if not sdata then
        sdata = skillData.GetDataFromTable("ProfessionTable", proId)
        g_proCacheSdatas[proId] = sdata
    end
    if sdata then
        ret = skillData.JobChangeLevel[sdata.ProfessionType + 1] or 0
    end
    return ret

end

function RequestGetJobAward(proId, jobLv)

    local l_msgId = Network.Define.Rpc.GetJobAward
    ---@type GetJobAwardArg
    local l_sendInfo = GetProtoBufSendTable("GetJobAwardArg")
    l_sendInfo.profession_id = proId
    l_sendInfo.level = jobLv
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnReceiveJobReward(msg, sendArg)
    ---@type GetJobAwardRes
    local info = ParseProtoBufToTable("GetJobAwardRes", msg)
    if info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(info.error))
        return
    end

    local takedInfo = skillData.JobAwardHasBeenTaked[sendArg.profession_id]
    if not takedInfo then
        skillData.AddJobAwardTaked(sendArg.profession_id)
        takedInfo = skillData.JobAwardHasBeenTaked[sendArg.profession_id]
    end
    array.addUnique(takedInfo, sendArg.level)
    EventDispatcher:Dispatch(ON_SKILL_JOB_AWARD, sendArg)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SkillLearningJobAward)

end
--endregion

--region 天赋
-- 技能方案总数
function GetSkillPlanCount()

    local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
    local multiDatas = multiMgr.GetMultiTableDataBySystemId(multiMgr.l_skillMultiTalent)
    return #multiDatas

end

function GetCurPage()
    return CurPlanId
end

function GetPageName(index)

    local name = skillData.GetCurSkillPlanName(index)
    if IsEmptyOrNil(name) then
        local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
        local multiDatas = multiMgr.GetMultiTableDataBySystemId(multiMgr.l_skillMultiTalent)
        if multiDatas and index <= #multiDatas then
            name = Lang(multiDatas[index].Name)
        end
    end
    return name

end

function OnSkillPlanChange(msg)
    ---@type SkillPlan
    local info = ParseProtoBufToTable("SkillPlan", msg)
    ServerNtfSkillPlan = info

end

function GetSkillPlanLearnSkillInfos(skillPlan, proId)

    local ret = {}
    local plan = skillPlan
    local fixedList = Common.Functions.ListToTable(MPlayerInfo.FixedSkillIdList)
    local transPath = GetTransPathByProId(proId)
    if plan then
        local allSkills = plan.skills
        --遍历ProfessionSkill
        if allSkills then
            for i, v in ipairs(allSkills) do
                local skillList = v.skill
                for _, skill_v in ipairs(skillList) do
                    if skill_v.skill_level > 0 then
                        local rawId = skillData.GetRootSkillIdByPath(skill_v.skill_id, transPath)
                        local professionSkillId = skillData.GetProfessionSkillId(rawId, transPath)
                        if not array.contains(fixedList, rawId) then
                            table.insert(ret, { skillId = skill_v.skill_id, skillLv = skill_v.skill_level })
                        elseif not array.find(ret, function(t)
                            return t.skillId == professionSkillId
                        end) then
                            table.insert(ret, { skillId = professionSkillId, skillLv = skill_v.skill_level })
                        end
                    end
                end
            end
        end
    end
    return ret

end

function OnOpenMultiTalentEvent(info)

    if info then
        local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
        if info.data.system_id == multiMgr.l_skillMultiTalent then
            skillData.AddSkillPlanId(info.data.plan_id)
        end
    end

end

function OnRenameMultiTalentEvent(info)

    local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
    if info.data.system_id == multiMgr.l_skillMultiTalent then
        skillData.UpdateSkillPlanName(info.data.plan_id, info.new_plan_name)
    end

end

function OnChangeMultiTalentEvent(info)

    local multiMgr = MgrMgr:GetMgr("MultiTalentMgr")
    if ServerNtfSkillPlan and info.data.system_id == multiMgr.l_skillMultiTalent then
        local planId = info.data.plan_id
        skillData.UpdateSkillPlan(planId, ServerNtfSkillPlan)
        local skillIds = ApplySkillPlan(planId)
        ServerNtfSkillPlan = nil
        CurPlanId = planId
        skillData.UpdateFirstSaveSKill(skillIds)
        UpdateCheckRedPoint()
        EventDispatcher:Dispatch(ON_SKILL_PLAN_CHANGE)
    end

end

function CheckSkillMultiTalentRedSignMethod()

    local l_dateStrSave = UserDataManager.GetStringDataOrDef(MultiTalents_SkillMultiRedSign, MPlayerSetting.PLAYER_SETTING_GROUP, "")
    if string.ro_isEmpty(tostring(l_dateStrSave)) then
        return 1
    end
    return 0

end

function HideSkillMultiTalentRedSign()

    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.SkillMultiTalent) then
        return
    end
    UserDataManager.SetDataFromLua(MultiTalents_SkillMultiRedSign, MPlayerSetting.PLAYER_SETTING_GROUP, MultiTalents_SkillMultiRedSign)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SkillMultiTalentRedSign)

end

function GetTransPathByProId(proId)

    local paths = {}
    if proId then
        while proId ~= 0 do
            table.insert(paths, proId)
            local professionSdata = skillData.GetDataFromTable("ProfessionTable", proId)
            if professionSdata then
                proId = professionSdata.ParentProfession
            else
                break
            end
        end
    end
    return paths

end

function RedSignForPro1()

    if skillData.GetProOneId() ~= 0 and skillData.GetProTwoId() == 0 then
        return 1
    end
    return 0

end

function RedSignForPro2()

    if skillData.GetProTwoId() ~= 0 and skillData.GetProThreeId() == 0 then
        return 1
    end
    return 0

end
--endregion
return ModuleMgr.SkillLearningMgr