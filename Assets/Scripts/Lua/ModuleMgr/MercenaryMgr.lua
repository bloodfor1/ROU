---@module ModuleMgr.MercenaryMgr
module("ModuleMgr.MercenaryMgr", package.seeall)
require "Common.AttrCalculator"
EventDispatcher = EventDispatcher.new()

--佣兵死亡事件
ON_MERCENARY_DEATH = "ON_MERCENARY_DEATH"
--佣兵出战状态改变
ON_MERCENARY_FIGHT = "ON_MERCENARY_FIGHT"
--佣兵状态改变
ON_MERCENARY_STATUS_CHANGE = "ON_MERCENARY_STATUS_CHANGE"
--佣兵装备升级
ON_MERCENARY_EQUIP_UPGRADE = "ON_MERCENARY_EQUIP_UPGRADE"
--佣兵天赋升级
ON_MERCENARY_TALENT_UPGRADE = "ON_MERCENARY_TALENT_UPGRADE"
--佣兵升级
ON_MERCENARY_LEVEL_UP = "ON_MERCENARY_TALENT_UPGRADE"
--佣兵天赋强化
ON_MERCENARY_TALENT_STRENGTHEN = "ON_MERCENARY_TALENT_STRENGTHEN"
--佣兵装备进阶
ON_MERCENARY_EQUIP_ADVANCE = "ON_MERCENARY_EQUIP_ADVANCE"
-- 佣兵解锁新技能
ON_MERCENARY_NEW_SKILL = "ON_MERCENARY_NEW_SKILL"
-- 佣兵协同/被动状态更新
ON_MERCENARY_FIGHT_UPDATE = "ON_MERCENARY_FIGHT_UPDATE"

--所有的佣兵信息
m_allMercenaryInfo = {}

--是否显示属性变化
m_isAttrChangedShown = true

--佣兵的最大等级
mMercenaryMaxLevel = 0

--佣兵升级物品
mMercenaryLevelUpItems = {}

--佣兵战斗状态 1协同，2被动
mMercenaryFightStatus = 1

-- 佣兵栏位信息
mMercenaryFightGrids = {}

-- 天赋卷轴id
TalentItemId = 3027004

-- 佣兵第二个栏位解锁后，任务接取情况检测
local _isCheckPassed = false

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

--断线重连
function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    if l_roleAllInfo.mercenary_record then
        OnSelectRoleNtf(l_roleAllInfo)
    end
end

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)

    for _, v in pairs(TableUtil.GetMercenaryLevelTable().GetTable()) do
        mMercenaryMaxLevel = math.max(mMercenaryMaxLevel, v.JobLv)
    end
    --初始化所有佣兵信息
    for _, v in pairs(TableUtil.GetMercenaryTable().GetTable()) do
        local l_stage = v.Id % 10
        local l_id = v.Id - l_stage
        if l_stage == 1 then
            m_allMercenaryInfo[l_id] = GetMercenaryInfoFromTable(v.Id)
        end
    end

    -- 初始化佣兵栏位信息
    mMercenaryFightGrids = {}
    local l_limit = MGlobalConfig:GetSequenceOrVectorInt("BattleUnlockLimit")
    for i = 0, l_limit.Length - 1 do
        table.insert(mMercenaryFightGrids, { isLocked = true, lockTask = l_limit[i], isUnOpen = l_limit[i] == -1 })
    end

    local l_items = MGlobalConfig:GetVectorSequence("LevelUpItemCost")
    for i = 0, l_items.Length - 1 do
        mMercenaryLevelUpItems[tonumber(l_items[i][0])] = tonumber(l_items[i][1])
    end
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[MercMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local singleCompareData = singleUpdateData:GetItemCompareData()
        if singleCompareData.count > 0 then
            _clearMercCacheState()
            break
        end
    end

    RefreshRedSign()
end

--- 清除所有佣兵升级状态
function _clearMercCacheState()
    for _, mercenaryInfo in pairs(m_allMercenaryInfo) do
        if mercenaryInfo.isRecruited then
            SetLevelUpRedSignClicked(mercenaryInfo.tableInfo.Id, false)
        end
    end
end

function OnLogout()
    _isCheckPassed = false
    m_allMercenaryInfo = {}
    OnInit()
end

function OnEnterDungeon()
    -- 进入副本切换为协同状态
    local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(MPlayerDungeonsInfo.DungeonID, true)
    if l_sceneRow and l_sceneRow.MerceneryNotAllow == 1 and mMercenaryFightStatus == 2 then
        MgrMgr:GetMgr("MercenaryMgr").ChangeMercenaryFightStatus(1)
    end
end

function OnUpdate()
    for _, mercenaryInfo in pairs(m_allMercenaryInfo) do
        --强化处理
        for _, groupTalentInfo in pairs(mercenaryInfo.talentGroupInfo) do
            if groupTalentInfo.strengthenTimeCountDown > 0 then
                groupTalentInfo.strengthenTimeCountDown = groupTalentInfo.strengthenTimeCountDown - UnityEngine.Time.deltaTime
                if groupTalentInfo.strengthenTimeCountDown < 0 then
                    groupTalentInfo.strengthenTimeCountDown = 0
                    --天赋降级
                    SetTalentLevel(mercenaryInfo.tableInfo.Id, groupTalentInfo.selectedTalentBaseId, -1)
                    RefreshMercenaryUI()
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_TALENT_STRENGTHEN_END", mercenaryInfo.tableInfo.Name))
                end
            end
        end
        --死亡处理
        if mercenaryInfo.reviveTimeCountDown > 0 then
            mercenaryInfo.reviveTimeCountDown = tonumber(mercenaryInfo.reviveTimeCountDown - UnityEngine.Time.deltaTime)
            if mercenaryInfo.reviveTimeCountDown < 0 then
                mercenaryInfo.reviveTimeCountDown = 0
            end
        end
    end
end

--佣兵信息处理
function OnSelectRoleNtf(info)
    local mercenaryRecord = info.mercenary_record
    if not mercenaryRecord then
        return
    end
    -- 佣兵出战状态，协同被动
    mMercenaryFightStatus = mercenaryRecord.fight_status_setted

    -- 佣兵栏位
    for i = 1, mercenaryRecord.fight_num do
        if mMercenaryFightGrids[i] then
            mMercenaryFightGrids[i].isLocked = false
        end
    end

    for i = 1, table.maxn(mercenaryRecord.mercenarys) do
        local l_mercenary = mercenaryRecord.mercenarys[i]
        --处理进阶的佣兵
        if l_mercenary.id % 10 ~= 1 then
            AdvanceMercenary(l_mercenary.id)
        end
        local l_mercenaryInfo = GetMercenaryInfoById(l_mercenary.id)
        if l_mercenaryInfo then
            l_mercenaryInfo.isRecruited = true
            l_mercenaryInfo.outTime = MLuaCommonHelper.Long2Int(l_mercenary.out_time)
            l_mercenaryInfo.level = l_mercenary.base_info.level
            l_mercenaryInfo.exp = l_mercenary.base_info.exp
            l_mercenaryInfo.reviveTimeCountDown = l_mercenary.revive_timestamp - Common.TimeMgr.GetNowTimestamp()
            if l_mercenaryInfo.reviveTimeCountDown < 0 then
                l_mercenaryInfo.reviveTimeCountDown = 0
            end
            l_mercenaryInfo.equipInfo = {}
            l_mercenaryInfo.equipInfoByPos = {}
            for j = 1, table.maxn(l_mercenary.equip_info.equips) do
                local l_equip = l_mercenary.equip_info.equips[j]
                local l_info = GetEquipInfoFromTable(l_equip.id)
                if l_info then
                    l_info.level = l_equip.level
                    l_mercenaryInfo.equipInfo[l_equip.id] = l_info
                    l_mercenaryInfo.equipInfoByPos[l_info.tableInfo.Position] = l_info
                end
            end
            for j = 1, table.maxn(l_mercenary.skill_info.skills) do
                local l_skill = l_mercenary.skill_info.skills[j]
                if l_mercenaryInfo.skillInfo[l_skill.id] then
                    l_mercenaryInfo.skillInfo[l_skill.id].isOption = true
                end
            end
            for j = 1, table.maxn(l_mercenary.talent_info.talents) do
                local l_talent = l_mercenary.talent_info.talents[j]
                local l_talentBaseId = l_talent.id - (l_talent.id % 10)
                local l_talentInfo = l_mercenaryInfo.talentInfo[l_talentBaseId]
                if l_talentInfo then
                    l_mercenaryInfo.talentGroupInfo[l_talentInfo.lockLevel].isStudied = true
                    l_mercenaryInfo.talentGroupInfo[l_talentInfo.lockLevel].selectedTalentBaseId = l_talentBaseId
                    local l_strengthenTime = MGlobalConfig:GetInt("TalentBreakDuration") * 3600 - (MServerTimeMgr.UtcSeconds - l_talent.last_strengthen_timestamp)
                    l_strengthenTime = MLuaCommonHelper.Long2Int(l_strengthenTime)
                    local l_deltaLevel = l_talent.level - l_mercenaryInfo.talentGroupInfo[l_talentInfo.lockLevel].level
                    SetTalentLevel(l_mercenary.id, l_talentBaseId, l_deltaLevel)
                    if l_mercenaryInfo.talentInfo[l_talentBaseId].tableInfo.Sign == 2 then
                        if l_strengthenTime > 0 then
                            l_mercenaryInfo.talentGroupInfo[l_talentInfo.lockLevel].strengthenTimeCountDown = l_strengthenTime
                        else
                            --若天赋处于强化等级则降级
                            SetTalentLevel(l_mercenary.id, l_talentBaseId, -1)
                        end
                    end

                end
            end
        end
    end

    RefreshMercenaryUI()
end

--isAdvance 佣兵升阶，将原数据变成新的佣兵数据
function GetMercenaryInfoFromTable(mercenaryId, isAdvance)
    local l_mercenaryInfo = nil
    local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(mercenaryId)
    if l_mercenaryRow then
        if isAdvance then
            l_mercenaryInfo = GetMercenaryInfoById(mercenaryId)
        else
            l_mercenaryInfo = {}
        end
        l_mercenaryInfo.mercenaryId = mercenaryId
        l_mercenaryInfo.tableInfo = l_mercenaryRow
        --是否已招募
        if not isAdvance then
            l_mercenaryInfo.isRecruited = false

            --出战的时间戳
            l_mercenaryInfo.outTime = 0
            l_mercenaryInfo.level = 1
            l_mercenaryInfo.exp = 0
            l_mercenaryInfo.curHp = 100
            l_mercenaryInfo.maxHp = 100
            l_mercenaryInfo.curSp = 100
            l_mercenaryInfo.maxSp = 100
            l_mercenaryInfo.reviveTimeCountDown = 0
            l_mercenaryInfo.reviveTime = 0
        end
        --阶段
        l_mercenaryInfo.stage = mercenaryId % 10

        --技能信息
        l_mercenaryInfo.skillInfo = {}
        for i = 0, l_mercenaryRow.Skill.Length - 1 do
            local l_skill = l_mercenaryRow.Skill[i]
            local l_skillId = l_skill[0]
            local l_level = l_skill[1]
            local l_isOption = l_skill[2] == 1
            local l_lockLevel = l_skill[3]
            local l_skillRow = TableUtil.GetSkillTable().GetRowById(l_skillId)
            if l_skillRow then
                -- index 用于排序
                l_mercenaryInfo.skillInfo[l_skillId] = { index = i, isOptionSkill = l_isOption, level = l_level, lockLevel = l_lockLevel, isOption = false, tableInfo = l_skillRow }
            end
        end
        if not isAdvance then
            --装备信息
            l_mercenaryInfo.equipInfo = {}
            l_mercenaryInfo.equipInfoByPos = {}
            for i = 0, l_mercenaryRow.Equip.Length - 1 do
                local l_equipId = l_mercenaryRow.Equip[i]
                local l_info = GetEquipInfoFromTable(l_equipId)
                if l_info then
                    l_mercenaryInfo.equipInfo[l_equipId] = l_info
                    l_mercenaryInfo.equipInfoByPos[l_info.tableInfo.Position] = l_info
                end
            end

            --天赋信息
            l_mercenaryInfo.talentInfo = {}
            --相同解锁等级的天赋为一组
            l_mercenaryInfo.talentGroupInfo = {}
            for i = 0, l_mercenaryRow.Talent.Length - 1 do
                local l_talent = l_mercenaryRow.Talent[i]
                local l_lockLevel = l_talent[0]
                local l_talentId = l_talent[1]
                local l_talentRow = TableUtil.GetMercenaryTalentTable().GetRowByID(l_talentId)
                if l_talentRow then
                    local l_talentBaseId = l_talentId - (l_talentId % 10)
                    l_mercenaryInfo.talentInfo[l_talentBaseId] = { lockLevel = l_lockLevel, talentBaseId = l_talentBaseId, tableInfo = l_talentRow }
                    if not l_mercenaryInfo.talentGroupInfo[l_lockLevel] then
                        l_mercenaryInfo.talentGroupInfo[l_lockLevel] = { isStudied = false, level = 1, strengthenTimeCountDown = 0, selectedTalentBaseId = 0, talentIds = {} }
                    end
                    table.insert(l_mercenaryInfo.talentGroupInfo[l_lockLevel].talentIds, l_talentBaseId)
                end
            end

            local l_attrs, l_sixAttrs = GetMercenaryAttrs(mercenaryId, 1, true)
            --属性信息，显示用
            l_mercenaryInfo.attrs = l_attrs
            -- 六维属性
            l_mercenaryInfo.sixAttrs = l_sixAttrs
            l_mercenaryInfo.isAttrsInit = false
            --for _, v in pairs(TableUtil.GetMercenaryAttrInfoTable().GetTable()) do
            --    l_mercenaryInfo.attrs[v.Id] = { value = 0, equipValue = 0, finalValue = 0, equipId = v.EquipId, tableInfo = v }
            --end
        end
    end
    return l_mercenaryInfo
end

--获取佣兵属性
--needExtraAttr，是否需要添加佣兵装备和技能的属性
function GetMercenaryAttrs(mercenaryId, level, needExtraAttr)
    if needExtraAttr == nil then
        needExtraAttr = false
    end
    level = level or 1
    local l_attrs = {}
    local l_sixAttrs = {}
    local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(mercenaryId)
    if l_mercenaryRow then
        local l_allAttrs = Common.AttrCalculator.new()
        --加点属性
        local l_attrRow = TableUtil.GetAttraddRecomTable().GetRowByProfession(level .. "|" .. l_mercenaryRow.Point)
        if l_attrRow then
            l_allAttrs[AttrType.ATTR_BASIC_STR] = l_attrRow.STR
            l_allAttrs[AttrType.ATTR_BASIC_VIT] = l_attrRow.VIT
            l_allAttrs[AttrType.ATTR_BASIC_AGI] = l_attrRow.AGI
            l_allAttrs[AttrType.ATTR_BASIC_INT] = l_attrRow.INT
            l_allAttrs[AttrType.ATTR_BASIC_DEX] = l_attrRow.DEX
            l_allAttrs[AttrType.ATTR_BASIC_LUK] = l_attrRow.LUK
        end
        l_allAttrs[AttrType.ATTR_SPECIAL_BASE_LV] = level
        l_allAttrs[AttrType.ATTR_SPECIAL_JOB] = l_mercenaryRow.Profession
        --基础属性和成长属性
        for i = 0, l_mercenaryRow.BaseAttribute.Length - 1 do
            local l_attrId = l_mercenaryRow.BaseAttribute[i][1]
            local l_attrValue = l_mercenaryRow.BaseAttribute[i][2]
            l_allAttrs[l_attrId] = (l_allAttrs[l_attrId] or 0) + l_attrValue + level * l_mercenaryRow.AttributeGrowth[i]
        end
        --移动速度
        local l_professionRow = TableUtil.GetProfessionTable().GetRowById(l_mercenaryRow.Profession)
        if l_professionRow then
            l_allAttrs[AttrType.ATTR_BASIC_MOVE_SPD] = (l_allAttrs[AttrType.ATTR_BASIC_MOVE_SPD] or 0) + l_professionRow.MoveSpeed * 100
            l_allAttrs[AttrType.ATTR_BASIC_BASE_ASPD] = (l_allAttrs[AttrType.ATTR_BASIC_BASE_ASPD] or 0) + l_professionRow.ASPD
            l_allAttrs[AttrType.ATTR_PERCENT_HATRED] = (l_allAttrs[AttrType.ATTR_PERCENT_HATRED] or 0) + l_professionRow.HatredCount
        end

        if needExtraAttr then
            --装备
            for i = 0, l_mercenaryRow.Equip.Length - 1 do
                local l_equipId = l_mercenaryRow.Equip[i]
                local l_info = GetEquipInfoFromTable(l_equipId)
                if l_info then
                    for _, v in pairs(l_info.attrs) do
                        l_allAttrs[v.attrId] = (l_allAttrs[v.attrId] or 0) + v.baseValue
                    end
                end
            end
            --技能
            for i = 0, l_mercenaryRow.Skill.Length - 1 do
                local l_skill = l_mercenaryRow.Skill[i]
                local l_skillId = l_skill[0]
                local l_level = l_skill[1]
                local l_isOption = l_skill[2] == 1
                local l_skillRow = TableUtil.GetSkillTable().GetRowById(l_skillId)
                if l_skillRow and l_skillRow.IsPassive == 1 then
                    for i = 0, l_skillRow.EffectIDs.Length - 1 do
                        local l_effectRow = TableUtil.GetPassivitySkillEffectTable().GetRowById(l_skillRow.EffectIDs[i])
                        if l_effectRow then
                            for j = 0, l_effectRow.Attr.Length - 1 do
                                local l_attrId = l_effectRow.Attr[j][0]
                                local l_attrValue = l_effectRow.Attr[j][1]
                                l_allAttrs[l_attrId] = (l_allAttrs[l_attrId] or 0) + l_attrValue
                            end
                        end
                    end
                end
            end
        end

        l_allAttrs:CalculateAttribute()

        for _, v in pairs(TableUtil.GetMercenaryAttrInfoTable().GetTable()) do
            local l_value = l_allAttrs:LuaGetAttr(v.Id)
            local l_equipValue = 0
            if v.EquipId ~= -1 then
                l_equipValue = l_allAttrs:LuaGetAttr(v.EquipId)
            end
            local l_finalValue = l_value + l_equipValue
            l_attrs[v.Id] = { value = l_value, equipValue = l_equipValue, equipId = v.EquipId, finalValue = l_finalValue, tableInfo = v }
        end
        l_sixAttrs[AttrType.ATTR_BASIC_STR] = l_allAttrs:LuaGetAttr(AttrType.ATTR_BASIC_STR)
        l_sixAttrs[AttrType.ATTR_BASIC_VIT] = l_allAttrs:LuaGetAttr(AttrType.ATTR_BASIC_VIT)
        l_sixAttrs[AttrType.ATTR_BASIC_AGI] = l_allAttrs:LuaGetAttr(AttrType.ATTR_BASIC_AGI)
        l_sixAttrs[AttrType.ATTR_BASIC_INT] = l_allAttrs:LuaGetAttr(AttrType.ATTR_BASIC_INT)
        l_sixAttrs[AttrType.ATTR_BASIC_DEX] = l_allAttrs:LuaGetAttr(AttrType.ATTR_BASIC_DEX)
        l_sixAttrs[AttrType.ATTR_BASIC_LUK] = l_allAttrs:LuaGetAttr(AttrType.ATTR_BASIC_LUK)
    end
    return l_attrs, l_sixAttrs
end

--从表中获取装备信息
function GetEquipInfoFromTable(equipId)
    local l_info
    local l_equipRow = TableUtil.GetMercenaryEquipTable().GetRowByID(equipId)
    if l_equipRow then
        l_info = { tableInfo = l_equipRow, level = l_equipRow.MinLevel }
        l_info.attrs = {}
        --解析装备属性信息
        for i = 0, l_equipRow.BaseAttribute.Length - 1 do
            local l_attr = {}
            l_attr.attrId = l_equipRow.BaseAttribute[i][1]
            l_attr.baseValue = l_equipRow.BaseAttribute[i][2]
            l_attr.growth = l_equipRow.AttributeGrowth[i] or 0
            table.insert(l_info.attrs, l_attr)
        end
    end
    return l_info
end

--设置佣兵天赋等级
function SetTalentLevel(mercenaryId, talentId, deltaLevel)
    if deltaLevel == 0 then
        return
    end
    local l_talentBaseId = talentId - (talentId % 10)
    local l_mercenaryInfo = GetMercenaryInfoById(mercenaryId)
    if l_mercenaryInfo and l_mercenaryInfo.talentInfo[l_talentBaseId] then
        local l_lockLevel = l_mercenaryInfo.talentInfo[l_talentBaseId].lockLevel
        l_mercenaryInfo.talentGroupInfo[l_lockLevel].level = l_mercenaryInfo.talentGroupInfo[l_lockLevel].level + deltaLevel
        for _, talentId in ipairs(l_mercenaryInfo.talentGroupInfo[l_lockLevel].talentIds) do
            local l_talentRow = TableUtil.GetMercenaryTalentTable().GetRowByID(talentId + l_mercenaryInfo.talentGroupInfo[l_lockLevel].level)
            if l_talentRow then
                l_mercenaryInfo.talentInfo[talentId].tableInfo = l_talentRow
            end
        end
    end
end


--打开佣兵界面
function OpenMercenary(mercenaryId)
    UIMgr:ActiveUI(UI.CtrlNames.Mercenary, function(ctrl)
        ctrl:SelectMercenary(mercenaryId)
    end)
end

--刷新佣兵界面
function RefreshMercenaryUI(funcName, ...)
    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Mercenary)
    if l_ctrl then
        if not funcName then
            l_ctrl:RefreshMercenaryList()
            --l_ctrl:RefreshPanel()
        else
            l_ctrl[funcName](l_ctrl, funcName, ...)
        end
    end
end

--获取属性字符串
function GetMercenaryAttrStr(id, value)
    local l_attrValue = ""
    local adRow = TableUtil.GetAttrDecision().GetRowById(id)
    local attrRow = TableUtil.GetMercenaryAttrInfoTable().GetRowById(id)
    if adRow and attrRow then
        if id == 116 then
            --移动特判
            l_attrValue = StringEx.Format("{0}%", value / 4)
        elseif adRow.TipParaEnum == 1 then
            if attrRow.FloorNum == 1 then
                l_attrValue = StringEx.Format("{0:F2}%", value / 100)
            else
                if value > 0 then
                    l_attrValue = StringEx.Format("{0}%", math.ceil(value / 100))
                else
                    l_attrValue = StringEx.Format("{0}%", math.floor(value / 100))
                end
            end
        else
            l_attrValue = tostring(value)
        end
    end
    return l_attrValue
end

--用于判断佣兵属性变化前后显示是否有差值
function GetMercenaryAttrChangeValue(id, finalvalue, beforevalue)
    local l_finalValue = 0
    local l_beforevalue = 0
    local adRow = TableUtil.GetAttrDecision().GetRowById(id)
    local attrRow = TableUtil.GetMercenaryAttrInfoTable().GetRowById(id)
    if adRow and attrRow then
        if adRow.TipParaEnum == 1 and id ~= 116 then
            --移动特判
            if attrRow.FloorNum == 1 then
                l_finalValue = finalvalue / 100
                l_beforevalue = beforevalue / 100
            else
                l_finalValue = math.ceil(finalvalue / 100)
                l_beforevalue = math.ceil(beforevalue / 100)
            end
        else
            l_finalValue = finalvalue
            l_beforevalue = beforevalue
        end
    end
    return l_finalValue - l_beforevalue
end

function GetAllMercenaryInfo()
    return m_allMercenaryInfo
end

function GetMercenaryInfoById(id)
    return m_allMercenaryInfo[id - (id % 10)]
end

function AdvanceMercenary(advanceId)
    m_allMercenaryInfo[advanceId - (advanceId % 10)] = GetMercenaryInfoFromTable(advanceId, true)
    return m_allMercenaryInfo[advanceId - (advanceId % 10)]
end

--佣兵升级
function RequestUpgrade(mercenaryId, itemId, count)
    ---@type MercenaryRequestUpgradeArgs
    local l_sendInfo = GetProtoBufSendTable("MercenaryRequestUpgradeArgs")
    l_sendInfo.mercenary_id = mercenaryId
    l_sendInfo.item_id = itemId
    l_sendInfo.item_count = count
    Network.Handler.SendRpc(Network.Define.Rpc.MercenaryRequestUpgrade, l_sendInfo)

    m_isAttrChangedShown = false
end


--装备操作
--operation: 1升级，2进阶
--totalCost 为升级需要多少Zeny 默认可以不传 用于快捷付费
--isNotCheck 用于快捷付费 不用传
function EquipOperate(mercenaryId, equipId, count, operation, totalCost, isNotCheck)

    if totalCost and totalCost > 0 then
        local _, l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101, totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101, l_needNum, function()
                EquipOperate(mercenaryId, equipId, count, operation, totalCost, true)
            end)
            return
        end
    end

    ---@type MercenaryEquipUpgradeArgs
    local l_sendInfo = GetProtoBufSendTable("MercenaryEquipUpgradeArgs")
    l_sendInfo.mercenary_id = mercenaryId
    l_sendInfo.equip_id = equipId
    l_sendInfo.count = count
    l_sendInfo.operation = operation
    Network.Handler.SendRpc(Network.Define.Rpc.MercenaryEquipUpgrade, l_sendInfo)

    m_isAttrChangedShown = false
end


--[[
operation:
kMercenaryTalentOperationNone = 0       注释：
kMercenaryTalentOperationStudy = 1      注释：
kMercenaryTalentOperationUpgrade = 2    注释：
kMercenaryTalentOperationStrengthen = 3 注释：
kMercenaryTalentOperationSwitch = 4     注释：
kMercenaryTalentOperationReset = 5      注释：
]]
--天赋操作
function TalentOperate(mercenaryId, talentId, switchId, operation)
    ---@type MercenaryTalentRequestArgs
    local l_sendInfo = GetProtoBufSendTable("MercenaryTalentRequestArgs")
    l_sendInfo.mercenary_id = mercenaryId
    l_sendInfo.talent_id = talentId
    l_sendInfo.switch_to_id = switchId
    l_sendInfo.operation = operation
    Network.Handler.SendRpc(Network.Define.Rpc.MercenaryTalentRequest, l_sendInfo)
end

--天赋切换
function SwitchTalent(mercenaryId, switchId)
    local l_mercenaryInfo = GetMercenaryInfoById(mercenaryId)
    if l_mercenaryInfo then
        local l_lockLevel = l_mercenaryInfo.talentInfo[switchId - (switchId % 10)].lockLevel
        local l_curTalentId = l_mercenaryInfo.talentGroupInfo[l_lockLevel].selectedTalentBaseId + l_mercenaryInfo.talentGroupInfo[l_lockLevel].level
        TalentOperate(mercenaryId, l_curTalentId, switchId, MercenaryTalentOperation.kMercenaryTalentOperationSwitch)
    end
end

--改变出战状态
function ChangeFightState(mercenaryId, isInFight)
    ---@type MercenaryTakeToFightArgs
    local l_sendInfo = GetProtoBufSendTable("MercenaryTakeToFightArgs")
    l_sendInfo.id = mercenaryId
    if isInFight then
        l_sendInfo.operation = 1
    else
        l_sendInfo.operation = 2
    end
    Network.Handler.SendRpc(Network.Define.Rpc.MercenaryTakeToFight, l_sendInfo)
end

--选择可选技能
function ChangeOptionSkillState(mercenaryId, optionSkillId, isSelected)
    ---@type MercenarySkillSlotArgs
    local l_sendInfo = GetProtoBufSendTable("MercenarySkillSlotArgs")
    l_sendInfo.id = mercenaryId
    local l_mercenaryInfo = GetMercenaryInfoById(mercenaryId)
    if l_mercenaryInfo then
        for _, skillInfo in pairs(l_mercenaryInfo.skillInfo) do
            if (skillInfo.tableInfo.Id ~= optionSkillId and skillInfo.isOption) or (skillInfo.tableInfo.Id == optionSkillId and isSelected) then
                local l_skill = l_sendInfo.skills.skills:add()
                l_skill.id = skillInfo.tableInfo.Id
            end
        end
    end
    Network.Handler.SendRpc(Network.Define.Rpc.MercenarySkillSlot, l_sendInfo)
end


--协议处理
function OnMercenarySkillSlot(msg, sendArg)
    ---@type NullRes
    local l_res = ParseProtoBufToTable("NullRes", msg)
    if l_res.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_res.result))
    else
        local l_mercenaryInfo = GetMercenaryInfoById(sendArg.id)
        if l_mercenaryInfo then
            local l_optionSkills = {}
            for _, skill in ipairs(sendArg.skills.skills) do
                l_optionSkills[skill.id] = true
            end
            for _, skillInfo in pairs(l_mercenaryInfo.skillInfo) do
                if l_optionSkills[skillInfo.tableInfo.Id] then
                    if not skillInfo.isOption then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_SKILL_ADD", skillInfo.tableInfo.Name))
                    end
                    skillInfo.isOption = true
                else
                    if skillInfo.isOption then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_SKILL_REMOVE", skillInfo.tableInfo.Name))
                    end
                    skillInfo.isOption = false
                end
            end
            RefreshMercenaryUI()
        end
    end

    --更新佣兵红点
    RefreshRedSign()
end

-- 佣兵技能解锁
function OnMercenarySkillOpenNtf(msg)
    ---@type NewSkillInfo
    local l_res = ParseProtoBufToTable("NewSkillInfo", msg)

    EventDispatcher:Dispatch(ON_MERCENARY_NEW_SKILL, l_res.mercenary_id, l_res.skill_id)
end

--装备更新
function OnMercenaryEquipUpgrade(msg, sendArg)
    m_isAttrChangedShown = true

    ---@type MercenaryEquipUpgradeRes
    local l_res = ParseProtoBufToTable("MercenaryEquipUpgradeRes", msg)
    if l_res.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_res.result))
    else
        local l_mercenaryInfo = GetMercenaryInfoById(sendArg.mercenary_id)
        if l_mercenaryInfo then
            if sendArg.operation == 1 then
                --升级
                local l_equipInfo = l_mercenaryInfo.equipInfo[sendArg.equip_id]
                l_equipInfo.level = l_equipInfo.level + sendArg.count
                if l_equipInfo.tableInfo.AdvancedID == 0 then
                    --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_EQUIP_UPPER_LIMIT"))
                elseif l_equipInfo.level == l_equipInfo.tableInfo.MaxLevel then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_EQUIP_MAX_LEVEL", l_equipInfo.tableInfo.Name))
                    --CommonUI.Dialog.ShowOKDlg(true, nil, Lang("MERCENARY_EQUIP_MAX_LEVEL", l_equipInfo.tableInfo.Name))
                end

                EventDispatcher:Dispatch(ON_MERCENARY_EQUIP_UPGRADE)
            elseif sendArg.operation == 2 then
                --进阶
                local l_advanceEquipId = l_mercenaryInfo.equipInfo[sendArg.equip_id].tableInfo.AdvancedID
                l_mercenaryInfo.equipInfo[sendArg.equip_id] = nil
                local l_info = GetEquipInfoFromTable(l_advanceEquipId)
                if l_info then
                    l_mercenaryInfo.equipInfo[l_advanceEquipId] = l_info
                    l_mercenaryInfo.equipInfoByPos[l_info.tableInfo.Position] = l_info
                end
                EventDispatcher:Dispatch(ON_MERCENARY_EQUIP_ADVANCE)
            end
            RefreshMercenaryUI()
        end
    end

    --更新佣兵红点
    RefreshRedSign()
end

-- gm更新装备
function OnMercenaryEquipInfoNtf(msg)
    ---@type MercenaryEquipsData
    local l_res = ParseProtoBufToTable("MercenaryEquipsData", msg)
    local l_mercenaryInfo = GetMercenaryInfoById(l_res.mercenary_id)
    if l_mercenaryInfo then
        for i = 1, #l_res.equips.equips do
            local l_equip = l_res.equips.equips[i]
            local l_equipInfo = l_mercenaryInfo.equipInfo[l_equip.id]
            if l_equipInfo then
                l_equipInfo.level = l_equip.level
            end
        end
        RefreshMercenaryUI()
        EventDispatcher:Dispatch(ON_MERCENARY_EQUIP_UPGRADE)
    end
end


--天赋更新
function OnMercenaryTalentRequest(msg, sendArg)
    ---@type AutoPairOperateRes
    local l_res = ParseProtoBufToTable("MercenaryTalentRequestRes", msg)
    if l_res.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_res.result))
    else
        local l_mercenaryInfo = GetMercenaryInfoById(sendArg.mercenary_id)
        local l_talentBaseId = sendArg.talent_id - (sendArg.talent_id % 10)
        if l_mercenaryInfo then
            if sendArg.operation == MercenaryTalentOperation.kMercenaryTalentOperationStudy then
                if l_mercenaryInfo.talentInfo[l_talentBaseId] then
                    local l_lockLevel = l_mercenaryInfo.talentInfo[l_talentBaseId].lockLevel
                    l_mercenaryInfo.talentGroupInfo[l_lockLevel].isStudied = true
                    l_mercenaryInfo.talentGroupInfo[l_lockLevel].selectedTalentBaseId = sendArg.talent_id - (sendArg.talent_id % 10)
                end
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_TALENT_STUDY_SUCCEED"))
            elseif sendArg.operation == MercenaryTalentOperation.kMercenaryTalentOperationUpgrade then
                SetTalentLevel(sendArg.mercenary_id, sendArg.talent_id, 1)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_TALENT_UPGRADE_SUCCEED"))

                EventDispatcher:Dispatch(ON_MERCENARY_TALENT_UPGRADE)
            elseif sendArg.operation == MercenaryTalentOperation.kMercenaryTalentOperationSwitch then
                local l_lockLevel = l_mercenaryInfo.talentInfo[l_talentBaseId].lockLevel
                if l_mercenaryInfo.talentInfo[l_talentBaseId] then
                    l_mercenaryInfo.talentGroupInfo[l_lockLevel].selectedTalentBaseId = sendArg.switch_to_id - (sendArg.switch_to_id % 10)
                end
                --如果是强化状态进行降级
                if l_mercenaryInfo.talentGroupInfo[l_lockLevel].strengthenTimeCountDown > 0 then
                    l_mercenaryInfo.talentGroupInfo[l_lockLevel].strengthenTimeCountDown = 0
                    SetTalentLevel(sendArg.mercenary_id, sendArg.talent_id, -1)
                end
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_TALENT_SWITCH_SUCCEED"))
            elseif sendArg.operation == MercenaryTalentOperation.kMercenaryTalentOperationStrengthen then
                --取消当前强化
                for _, groupTalentInfo in pairs(l_mercenaryInfo.talentGroupInfo) do
                    if groupTalentInfo.strengthenTimeCountDown > 0 then
                        groupTalentInfo.strengthenTimeCountDown = 0
                        SetTalentLevel(sendArg.mercenary_id, groupTalentInfo.selectedTalentBaseId, -1)
                        break
                    end
                end

                local l_lockLevel = l_mercenaryInfo.talentInfo[l_talentBaseId].lockLevel
                if l_mercenaryInfo.talentInfo[l_talentBaseId] then
                    SetTalentLevel(sendArg.mercenary_id, sendArg.talent_id, 1)
                    l_mercenaryInfo.talentGroupInfo[l_lockLevel].strengthenTimeCountDown = MGlobalConfig:GetInt("TalentBreakDuration") * 3600
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_TALENT_STRENGTHEN_START", l_mercenaryInfo.tableInfo.Name))
                end

                EventDispatcher:Dispatch(ON_MERCENARY_TALENT_STRENGTHEN)
                --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_TALENT_STRENGHTHEN_SUCCEED"))
            elseif sendArg.operation == MercenaryTalentOperation.kMercenaryTalentOperationReset then
                for _, v in pairs(l_mercenaryInfo.talentGroupInfo) do
                    v.isStudied = false
                    v.level = 1
                    v.strengthenTimeCountDown = 0
                    v.selectedTalentBaseId = 0
                end
                for k, v in pairs(l_mercenaryInfo.talentInfo) do
                    local l_talentRow = TableUtil.GetMercenaryTalentTable().GetRowByID(k + 1)
                    if l_talentRow then
                        v.tableInfo = l_talentRow
                    end
                end
                RefreshMercenaryUI("ResetTalent")
            end
            RefreshMercenaryUI()
        end
    end

    --更新佣兵红点
    RefreshRedSign()
end

--刷新佣兵出战状态
function OnMercenaryTakeToFight(msg, sendArg)
    ---@type NullRes
    local l_res = ParseProtoBufToTable("NullRes", msg)
    if l_res.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_res.result))
        return
    end

    local l_mercenaryInfo = GetMercenaryInfoById(sendArg.id)
    if l_mercenaryInfo then
        if sendArg.operation == 1 then
            l_mercenaryInfo.outTime = Common.TimeMgr.GetNowTimestamp()
        else
            l_mercenaryInfo.outTime = 0
        end
        RefreshMercenaryUI()
    end
    if not MgrMgr:GetMgr("DungeonMgr").IsTempTeamMode then
        EventDispatcher:Dispatch(ON_MERCENARY_FIGHT)
    end

    --清除红点状态
    SetLevelUpRedSignClicked(sendArg.id, false)

    --更新佣兵红点
    RefreshRedSign()
end

--佣兵升级
function OnMercenaryRequestUpgrade(msg, sendArg)
    m_isAttrChangedShown = true
    ---@type AutoPairOperateRes
    local l_res = ParseProtoBufToTable("MercenaryRequestUpgradeRes", msg)
    if l_res.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_res.result))
    else
        local l_mercenaryInfo = GetMercenaryInfoById(sendArg.mercenary_id)
        if l_mercenaryInfo then
            if l_mercenaryInfo.level < l_res.cur_level then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_LEVEL_UP", l_mercenaryInfo.tableInfo.Name, l_res.cur_level))
                EventDispatcher:Dispatch(ON_MERCENARY_LEVEL_UP)

                --清除红点状态
                SetEquipRedSignClicked(sendArg.mercenary_id, false)
            end
            l_mercenaryInfo.level = l_res.cur_level
            l_mercenaryInfo.exp = l_res.cur_exp
            RefreshMercenaryUI()
        end
    end

    --更新佣兵红点
    RefreshRedSign()
end

--佣兵属性变化
function OnMercenaryAttrUpdateNtf(msg)
    ---@type MercenaryAttrUpdateData
    local l_res = ParseProtoBufToTable("MercenaryAttrUpdateData", msg)
    --logError(ToString(l_res))
    for i = 1, table.maxn(l_res.mercenarys) do
        local l_mercenaryInfo = GetMercenaryInfoById(l_res.mercenarys[i].id)
        if l_mercenaryInfo then
            local l_attrs = {}
            for j = 1, table.maxn(l_res.mercenarys[i].attrs) do
                l_attrs[l_res.mercenarys[i].attrs[j].attr_type] = l_res.mercenarys[i].attrs[j].attr_value
            end
            for k, v in pairs(l_mercenaryInfo.attrs) do
                if l_attrs[k] then
                    v.value = l_attrs[k]
                end
                if l_attrs[v.equipId] then
                    v.equipValue = l_attrs[v.equipId]
                end
                local l_beforeValue = v.finalValue
                v.finalValue = v.value + v.equipValue
                --按需求屏蔽
                --if l_mercenaryInfo.isAttrsInit and m_isAttrChangedShown and l_res.source_type ~= 1 then
                --    local l_deltaValue = GetMercenaryAttrChangeValue(k, v.finalValue, l_beforeValue)
                --    local l_attrStr = GetMercenaryAttrStr(k, math.abs(v.finalValue - l_beforeValue))
                --    if l_deltaValue > 0 then
                --        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_ATTR_ADD", l_mercenaryInfo.tableInfo.Name, v.tableInfo.AttrName, l_attrStr))
                --    elseif l_deltaValue < 0 then
                --        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_ATTR_SUB", l_mercenaryInfo.tableInfo.Name, v.tableInfo.AttrName, l_attrStr))
                --    end
                --end
            end
            for k, v in pairs(l_mercenaryInfo.sixAttrs) do
                if l_attrs[k] then
                    l_mercenaryInfo.sixAttrs[k] = l_attrs[k]
                end
            end
            l_mercenaryInfo.isAttrsInit = true
        end
    end
    RefreshMercenaryUI("RefreshAttribute")
end

--佣兵招募
function OnMercenaryRecruitNtf(msg)
    ---@type MercenaryRecruitData
    local l_res = ParseProtoBufToTable("MercenaryRecruitData", msg)
    local l_mercenaryInfo = GetMercenaryInfoById(l_res.mercenary_id)
    if l_mercenaryInfo then
        l_mercenaryInfo.isRecruited = true
        for j = 1, #l_res.default_skills.skills do
            local l_skill = l_res.default_skills.skills[j]
            if l_mercenaryInfo.skillInfo[l_skill.id] then
                l_mercenaryInfo.skillInfo[l_skill.id].isOption = true
            end
        end
    end
    UIMgr:ActiveUI(UI.CtrlNames.MercenaryContract, function(ctrl)
        ctrl:SetData(l_res.mercenary_id)
    end)

    --更新佣兵红点
    RefreshRedSign()
end

--佣兵进阶
function OnMercenaryAdvanceNtf(msg)
    ---@type MercenaryAdvanceData
    local l_res = ParseProtoBufToTable("MercenaryAdvanceData", msg)
    local l_mercenaryInfo = AdvanceMercenary(l_res.after_mercenary_id)

    if l_mercenaryInfo then
        --刷新装备数据
        for j = 1, table.maxn(l_res.equip_info.equips) do
            local l_equip = l_res.equip_info.equips[j]
            local l_info = GetEquipInfoFromTable(l_equip.id)
            if l_info then
                l_info.level = l_equip.level
                l_mercenaryInfo.equipInfo[l_equip.id] = l_info
                l_mercenaryInfo.equipInfoByPos[l_info.tableInfo.Position] = l_info
            end
        end
        --刷新技能数据
        for j = 1, #l_res.skill_info.skills do
            local l_skill = l_res.skill_info.skills[j]
            if l_mercenaryInfo.skillInfo[l_skill.id] then
                l_mercenaryInfo.skillInfo[l_skill.id].isOption = true
            end
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MERCENARY_SKILL_RESET"))
        RefreshMercenaryUI()
    end

    PlayMercenaryAdvanceEffect()

    --更新佣兵红点
    RefreshRedSign()
end

--佣兵进阶特效
function PlayMercenaryAdvanceEffect()
    UIMgr:ActiveUI(UI.CtrlNames.MercenaryAdvanceSucceed, function(ctrl)

    end)
end

function OnMercenaryDeadNtf(msg)
    ---@type MercenaryDeadNtfData
    local l_res = ParseProtoBufToTable("MercenaryDeadNtfData", msg)
    local l_mercenaryInfo = GetMercenaryInfoById(l_res.id)
    if l_mercenaryInfo then
        l_mercenaryInfo.reviveTimeCountDown = l_res.revive_timestamp - Common.TimeMgr.GetNowTimestamp()
        if l_mercenaryInfo.reviveTimeCountDown < 0 then
            l_mercenaryInfo.reviveTimeCountDown = 0
        end
        l_mercenaryInfo.reviveTime = l_res.revive_timestamp
        if not MgrMgr:GetMgr("DungeonMgr").IsTempTeamMode then
            EventDispatcher:Dispatch(ON_MERCENARY_DEATH)

        end
    end
end
function OnMercenaryUidNtf(msg)
    ---@type MercenaryUidNtfData
    local l_res = ParseProtoBufToTable("MercenaryUidNtfData", msg)
    local l_mercenaryInfo = GetMercenaryInfoById(l_res.id)
    if l_mercenaryInfo then
        l_mercenaryInfo.UId = l_res.uid
    end
end

-- 佣兵栏位处理
function OnMercenaryFightNumNtf(msg)
    ---@type FightNumData
    local l_res = ParseProtoBufToTable("FightNumData", msg)
    if mMercenaryFightGrids[l_res.num] then
        mMercenaryFightGrids[l_res.num].isLocked = false
    end
    if l_res.num == 2 then
        UIMgr:ActiveUI(UI.CtrlNames.MercenaryRecommendation)
    end
end

function SetHpSPInfoByTeamInfo(mercenaryId, hpPercent, spPercent)
    GetMercenaryInfoById(mercenaryId).curHp = GetMercenaryInfoById(mercenaryId).maxHp * hpPercent
    GetMercenaryInfoById(mercenaryId).curSp = GetMercenaryInfoById(mercenaryId).maxSp * spPercent
end

function GetMercenaryHpSp(mercenaryUid)
    if not mercenaryUid or mercenaryUid == 0 then
        return 0, 0
    end
    l_entity = MEntityMgr:GetEntity(mercenaryUid)
    if l_entity then
        return l_entity.AttrComp.HP, l_entity.AttrComp.SP
    end
    return 0, 0
end

function SetMercenaryHpInfo(Id, hp, maxhp)
    for _, v in pairs(m_allMercenaryInfo) do
        if v.mercenaryId == Id then
            v.curHp = hp
            v.maxHp = maxhp
        end
    end
    if not MgrMgr:GetMgr("DungeonMgr").IsTempTeamMode then
        EventDispatcher:Dispatch(ON_MERCENARY_STATUS_CHANGE)

    end
end
function SetMercenarySpInfo(Id, sp, maxsp)
    for _, v in pairs(m_allMercenaryInfo) do
        if v.mercenaryId == Id then
            v.curSp = sp
            v.maxSp = maxsp
        end
    end
    if not MgrMgr:GetMgr("DungeonMgr").IsTempTeamMode then
        EventDispatcher:Dispatch(ON_MERCENARY_STATUS_CHANGE)

    end
end
function SetMercenaryLevelInfo(Id, level)
    for _, v in pairs(m_allMercenaryInfo) do
        if v.mercenaryId == Id then
            v.level = level
        end
    end
    if not MgrMgr:GetMgr("DungeonMgr").IsTempTeamMode then
        EventDispatcher:Dispatch(ON_MERCENARY_STATUS_CHANGE)

    end
end

--查找已出战佣兵
function FindFightMercenary()
    local l_fightMercenary = {}
    for _, v in pairs(m_allMercenaryInfo) do
        if v.outTime ~= 0 and v.UId then
            local l_entity = MEntityMgr:GetEntity(v.UId)
            if l_entity then
                v.curHp, v.curSp = GetMercenaryHpSp(v.UId)
            else
                v.curHp = 0
                v.curSp = 0
            end
            table.insert(l_fightMercenary, v)
        end
    end
    return l_fightMercenary
end

--查找自己已出战佣兵数量
function FindFightMercenaryCount()
    local count = 0
    for _, v in pairs(m_allMercenaryInfo) do
        if v.outTime ~= 0 and v.UId then
            count = count + 1
        end
    end
    return count
end

--佣兵是否能出战
function CanMercenaryFight()
    local l_fightNum = 0
    local l_canFightNum = CanTakeMercenaryNumber()
    for _, v in pairs(m_allMercenaryInfo) do
        if v.outTime ~= 0 then
            l_fightNum = l_fightNum + 1
        end
    end
    return l_fightNum < l_canFightNum
end

-- 可携带的佣兵数量
function CanTakeMercenaryNumber()
    local l_canFightNum = 0
    for i = 1, #mMercenaryFightGrids do
        if not mMercenaryFightGrids[i].isLocked then
            l_canFightNum = l_canFightNum + 1
        end
    end
    return l_canFightNum
end

--获取当前已招募的佣兵数量
function GetCurRecruitedNumber()
    local l_recruitedNumber = 0
    for _, v in pairs(m_allMercenaryInfo) do
        if v.isRecruited then
            l_recruitedNumber = l_recruitedNumber + 1
        end
    end
    return l_recruitedNumber
end

-- 是否是推荐的佣兵
function IsMercenaryRecommend(mercenaryId)
    local l_professionRow = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)--实际职业
    if l_professionRow then
        for i = 0, l_professionRow.MercenaryRecommend.Length - 1 do
            if l_professionRow.MercenaryRecommend[i] == mercenaryId then
                return true
            end
        end
    end
    return false
end


--红点检测
--佣兵升级红点检测，返回整数
function CheckLevelUpMethod()
    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Mercenary)
    local l_canLevelUp = false
    if l_ctrl then
        local l_id = l_ctrl:GetSelectedMercenaryId()
        local l_mercenaryInfo = GetMercenaryInfoById(l_id)
        if l_mercenaryInfo and l_mercenaryInfo.outTime ~= 0 then
            l_canLevelUp = CanLevelUp(l_id)
        end
    end
    return l_canLevelUp and 1 or 0
end

--佣兵装备升级红点检测，返回整数
function CheckEquipLevelUpMethod()
    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Mercenary)
    local l_canLevelUp = false
    if l_ctrl then
        local l_id = l_ctrl:GetSelectedMercenaryId()
        local l_mercenaryInfo = GetMercenaryInfoById(l_id)
        if l_mercenaryInfo and l_mercenaryInfo.outTime ~= 0 then
            l_canLevelUp = CanEquipLevelUp(l_id)
        end
    end
    return l_canLevelUp and 1 or 0
end

--佣兵功能红点检测，返回整数
function MercenaryCheck()
    local l_showRedSign = false
    for _, v in pairs(m_allMercenaryInfo) do
        if v.isRecruited and v.outTime ~= 0 then
            l_showRedSign = l_showRedSign or CanLevelUp(v.tableInfo.Id) or CanEquipLevelUp(v.tableInfo.Id) or HasTalentRedSign(v.tableInfo.Id)
            if l_showRedSign then
                break
            end
        end
    end
    return l_showRedSign and 1 or 0
end

--佣兵天赋红点检测，返回整数
function CheckTalentMethod()
    local l_ctrl = UIMgr:GetUI(UI.CtrlNames.Mercenary)
    local l_showRedSign = false
    if l_ctrl then
        local l_id = l_ctrl:GetSelectedMercenaryId()
        local l_mercenaryInfo = GetMercenaryInfoById(l_id)
        if l_mercenaryInfo and l_mercenaryInfo.outTime ~= 0 then
            l_showRedSign = HasTalentRedSign(l_id)
        end
    end
    return l_showRedSign and 1 or 0
end

--佣兵是否可升级
function CanLevelUp(mercenaryId, checkClicked)
    if checkClicked == nil then
        checkClicked = true
    end
    --判断是否点击过
    if IsLevelUpRedSignClicked(mercenaryId) and checkClicked then
        return false
    end
    local l_mercenaryInfo = GetMercenaryInfoById(mercenaryId)
    local l_isLevelSatisfy = false
    local l_hasItem = false
    if l_mercenaryInfo and l_mercenaryInfo.isRecruited then
        local l_maxLevel = l_mercenaryInfo.tableInfo.AdvancedCondition[0]
        if not l_maxLevel or l_maxLevel == 0 then
            l_maxLevel = mMercenaryMaxLevel
        end
        l_isLevelSatisfy = l_mercenaryInfo.level < math.min(l_maxLevel, MPlayerInfo.Lv)
        --是否有升级道具
        local l_items = MGlobalConfig:GetVectorSequence("LevelUpItemCost")
        for i = 0, l_items.Length - 1 do
            local l_itemCount = Data.BagModel:GetBagItemCountByTid(tonumber(l_items[i][0]))
            if l_itemCount > 0 then
                l_hasItem = true
                break
            end
        end
    end
    return l_isLevelSatisfy and l_hasItem
end

--佣兵装备是否可升级
function CanEquipLevelUp(mercenaryId, checkClicked)
    if checkClicked == nil then
        checkClicked = true
    end
    --判断是否点击过
    if IsEquipRedSignClicked(mercenaryId) and checkClicked then
        return false
    end
    local l_mercenaryInfo = GetMercenaryInfoById(mercenaryId)
    local l_canLevelUp = false
    if l_mercenaryInfo then
        for _, v in pairs(l_mercenaryInfo.equipInfo) do
            if CanOneEquipLevelUp(v.tableInfo.ID, v.level, l_mercenaryInfo.level) then
                l_canLevelUp = true
                break
            end
        end
    end
    return l_canLevelUp
end

--佣兵天赋是否有红点
function HasTalentRedSign(mercenaryId)
    local l_mercenaryInfo = GetMercenaryInfoById(mercenaryId)
    local l_hasRedSign = false
    if l_mercenaryInfo then
        for lockLevel, _ in pairs(l_mercenaryInfo.talentGroupInfo) do
            if l_mercenaryInfo.level >= lockLevel and not IsTalentRedSignClicked(l_mercenaryInfo.tableInfo.Id, lockLevel) then
                l_hasRedSign = true
                break
            end
        end
    end
    return l_hasRedSign
end

--某个具体的佣兵装备是否可升级
function CanOneEquipLevelUp(equipId, equipLevel, mercenaryLevel)
    local l_cost = 0
    local l_costRow = TableUtil.GetMercenaryLevelTable().GetRowByJobLv(equipLevel)
    if l_costRow then
        l_cost = l_costRow.EquipExp
    end
    local l_levelMax = 0
    local l_equipRow = TableUtil.GetMercenaryEquipTable().GetRowByID(equipId)
    if l_equipRow then
        l_levelMax = l_equipRow.MaxLevel
    end
    local l_isCostEnough = MLuaCommonHelper.Long2Int(MPlayerInfo.Coin101) > l_cost
    local l_isLevelValid = equipLevel < mercenaryLevel and equipLevel < l_levelMax
    return l_isCostEnough and l_isLevelValid
end

--佣兵升级红点点击处理
function SetLevelUpRedSignClicked(mercenaryId, isClicked)
    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    l_onceSystemMgr.SetOnceState(l_onceSystemMgr.EClientOnceType.MercenaryLevelUpRedSign, mercenaryId, isClicked)

    RefreshRedSign()

    RefreshMercenaryUI()
end

--佣兵升级红点是否被点击
function IsLevelUpRedSignClicked(mercenaryId)
    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    return l_onceSystemMgr.GetOnceState(l_onceSystemMgr.EClientOnceType.MercenaryLevelUpRedSign, mercenaryId)
end

--佣兵装备红点点击处理
function SetEquipRedSignClicked(mercenaryId, isClicked)
    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    l_onceSystemMgr.SetOnceState(l_onceSystemMgr.EClientOnceType.MercenaryEquipRedSign, mercenaryId, isClicked)

    RefreshRedSign()

    RefreshMercenaryUI()
end

--佣兵装备红点是否被点击
function IsEquipRedSignClicked(mercenaryId)
    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    return l_onceSystemMgr.GetOnceState(l_onceSystemMgr.EClientOnceType.MercenaryEquipRedSign, mercenaryId)
end

--佣兵天赋红点点击
function SetTalentRedSignClicked(mercenaryId, lockLevel, isClicked)
    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    l_onceSystemMgr.SetOnceState(l_onceSystemMgr.EClientOnceType.MercenaryTalentRedSign, mercenaryId * 100 + lockLevel, isClicked)

    RefreshRedSign()

    RefreshMercenaryUI()
end

function IsTalentRedSignClicked(mercenaryId, lockLevel)
    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    return l_onceSystemMgr.GetOnceState(l_onceSystemMgr.EClientOnceType.MercenaryTalentRedSign, mercenaryId * 100 + lockLevel)
end

--刷新佣兵相关红点
function RefreshRedSign()
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.MercenaryLevelUp)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.MercenaryInformation)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.MercenaryEquipLevelUp)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Mercenary)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.MercenaryTalent)
end

-- 获取佣兵招募数量
function GetRecruitNum()
    local l_num = 0
    for _, v in pairs(m_allMercenaryInfo) do
        if v.isRecruited then
            l_num = l_num + 1
        end
    end
    return l_num
end

-- 获取当前出战佣兵等级
function GetFightLevels()
    local l_levels = {}
    for _, v in pairs(m_allMercenaryInfo) do
        if v.outTime ~= 0 then
            table.insert(l_levels, v.level)
        end
    end
    return l_levels
end

-- 获取出战佣兵等级区间的装备数量(lvMin, lvMax]
function GetFightEquipNumByLevel()
    local l_levels = {}
    for _, mercenaryInfo in pairs(m_allMercenaryInfo) do
        if mercenaryInfo.outTime ~= 0 then
            for __, equipInfo in pairs(mercenaryInfo.equipInfo) do
                table.insert(l_levels, equipInfo.level)
                if equipInfo.tableInfo.Position == 1 then
                    if mercenaryInfo.equipInfoByPos[4] == nil then
                        table.insert(l_levels, equipInfo.level)
                    end
                end
            end

        end
    end
    return l_levels
end

function OpenMercenaryEquipPanel(mercenayId)

end

local _checkTasks
-- 第二个栏位解锁后，自动领取任务处理，任务没有领取成功的掉线处理
function CheckMercenaryTask()
    -- 每个角色只需检测一次
    if _isCheckPassed then
        return
    end
    _isCheckPassed = true

    if not _checkTasks then
        _checkTasks = {}
        local l_mercenaryIds = MGlobalConfig:GetSequenceOrVectorInt("MercenarySelectedID")
        for i = 0, l_mercenaryIds.Length - 1 do
            local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(l_mercenaryIds[i])
            if l_mercenaryRow then
                table.insert(_checkTasks, l_mercenaryRow.RecruitTask[0])
            end
        end
    end

    if not mMercenaryFightGrids[2] or mMercenaryFightGrids[2].isLocked then
        return
    end

    if GetRecruitNum() >= 2 then
        return
    end

    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_taskGet = false
    for _, taskId in ipairs(_checkTasks) do
        local l_taskStatus, l_taskStep = l_taskMgr.GetTaskStatusAndStep(taskId)
        -- 任务是否已领取过
        if not (l_taskStatus == l_taskMgr.ETaskStatus.NotTake or l_taskStatus == l_taskMgr.ETaskStatus.CanTake) then
            l_taskGet = true
            break
        end
    end
    if not l_taskGet then
        UIMgr:ActiveUI(UI.CtrlNames.MercenaryRecommendation)
    end
end


-- status 1 协同，2 被动
function ChangeMercenaryFightStatus(status)
    ---@type MercenaryTakeToFightArgs
    local l_sendInfo = GetProtoBufSendTable("MercenaryChangeFightStatusArg")
    l_sendInfo.status = status
    Network.Handler.SendRpc(Network.Define.Rpc.MercenaryChangeFightStatus, l_sendInfo)
end

function OnMercenaryChangeFightStatus(msg, sendArg)
    ---@type NullRes
    local l_res = ParseProtoBufToTable("NullRes", msg)
    if l_res.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_res.result))
        return
    end
    mMercenaryFightStatus = sendArg.status

    -- 副本里不弹提示
    if not MPlayerDungeonsInfo.InDungeon then
        if sendArg.status == 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_FIGHT_XIETONG"))
        elseif sendArg.status == 2 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCENARY_FIGHT_BEIDONG"))
        end
    end

    EventDispatcher:Dispatch(ON_MERCENARY_FIGHT_UPDATE)
end


-- 获取佣兵描述
function GetMercenarySomeoneDes(mercenaryId)
    local l_mercenaryName = ""
    local l_mercenaryJob = ""
    local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(mercenaryId)
    if l_mercenaryRow then
        l_mercenaryName = l_mercenaryRow.Name
        local l_jobRow = TableUtil.GetProfessionTable().GetRowById(l_mercenaryRow.Profession)
        if l_jobRow then
            l_mercenaryJob = l_jobRow.Name
        end
    end
    return Lang("MERCENARY_SOMEONE", l_mercenaryJob, l_mercenaryName)
end

return ModuleMgr.MercenaryMgr