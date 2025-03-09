---@module ModuleMgr.RefineMgr
module("ModuleMgr.RefineMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
ReceiveEquipRefineAttachLuckyEvent = "ReceiveEquipRefineAttachLuckyEvent"
ReceiveEquipRepairEvent = "ReceiveEquipRepairEvent"
ReceiveEquipRefineUpgradeEvent = "ReceiveEquipRefineUpgradeEvent"

local refineSuccessVoiceId = MGlobalConfig:GetInt("RefineVoiceSuccess")
local refineFailVoiceId = MGlobalConfig:GetInt("RefineVoiceFail")
local _refineUpgradeSuccessEffect = MGlobalConfig:GetInt("RefineUpgradeSuccessEffect")
local _refineUpgradeFailEffect = MGlobalConfig:GetInt("RefineUpgradeFailEffect")

--可精炼的部位
local _refinePosition = MGlobalConfig:GetSequenceOrVectorInt("RefinePosition")

local _safeLevelCfg = MGlobalConfig:GetSequenceOrVectorInt("RefineTipsLevel")

function OnReconnected(msg)
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnRefineReconnected)
end

function GetSafeTxtLevel(curLevel)
    local index = -1
    for i = 0, _safeLevelCfg.Length - 1 do
        if curLevel < _safeLevelCfg[i] then
            index = i + 1
            break
        end
    end
    if index == 1 then
        return -1                           -- 不在配置区间( < 3)
    elseif index < 0 then
        return _safeLevelCfg[_safeLevelCfg.Length - 1]  -- 不在配置区间( > 15)
    else
        return _safeLevelCfg[index - 1]
    end
end

--获取精炼表数据
function GetEquipRefineTable(position, refineLevel)
    local equipRefineTable = TableUtil.GetEquipRefineTable().GetTable()
    for i = 1, #equipRefineTable do
        local tableData = equipRefineTable[i]
        if tableData.RefineLevel == refineLevel and tableData.Position == position then
            return tableData
        end
    end

    logError("EquipRefineTable没有找到表数据position：" .. tostring(position) .. "  refineLevel:" .. tostring(refineLevel))
    return nil
end

---@param itemData ItemData
function GetRefineLevel(itemData)
    if itemData == nil then
        return 0
    end

    return itemData.RefineLv
end

--是否可精炼，0为可精炼
function IsCanRefine(equipTableInfo)
    return equipTableInfo.Refine == 0
end

---@param itemData ItemData
function IsCanRefineWithPropInfo(itemData)
    local l_equipTableInfo = itemData.EquipConfig
    if l_equipTableInfo == nil then
        return false
    end

    return 0 == l_equipTableInfo.Refine
end

---@param itemData ItemData
function IsDisrepair(itemData)
    if itemData == nil then
        return false
    end

    return itemData.Damaged
end

---@param itemData ItemData
function GetRefineMaxLevel(itemData)
    local equipTableInfo = itemData.EquipConfig
    local l_refineMaxLevel = equipTableInfo.RefineMaxLv
    return l_refineMaxLevel
end

--是否身上可精炼部位的装备都精炼致目标等级,不包括饰品
function IsBodyEquipRefineLevelWithAllCanRefinePosition(l_t_Level)
    if l_t_Level < 0 then
        return false;
    end

    local l_equips = GetNeedCheckEquipsWithEquipTypesWithoutOrnaments(_refinePosition)

    if l_equips == nil then
        return false
    end

    for i = 1, #l_equips do
        if IsCanRefineWithPropInfo(l_equips[i]) then
            if l_equips[i].RefineLv < l_t_Level then
                return false
            end
        end

    end

    return true
end

--根据全局表的配置，取相应的身上的装备，不符合规则返回nil
function GetNeedCheckEquipsWithEquipTypes(equipTypes)
    local l_equips = {}
    local l_equipType
    local l_propInfo
    for i = 1, equipTypes.Length do
        l_equipType = equipTypes[i - 1]
        l_propInfo = MgrMgr:GetMgr("BodyEquipMgr").GetBodyEquipWithEquipPart(l_equipType)

        --如果是副武器
        if l_equipType == 2 then

            --判断副武器是否需要加入处理列表
            local l_mainWeapon = MgrMgr:GetMgr("BodyEquipMgr").GetBodyEquipWithServerEnum(EquipPos.MAIN_WEAPON)
            if MgrMgr:GetMgr("ForgeMgr").IsNeedDealWithSecondaryWeapon(l_mainWeapon) then
                if l_propInfo == nil then
                    return nil
                end
                table.insert(l_equips, l_propInfo)
            end
        else

            if l_propInfo == nil then
                return nil
            end
            table.insert(l_equips, l_propInfo)
        end

        --判断饰品二号
        if l_equipType == 6 then
            local l_otherOrnament = MgrMgr:GetMgr("BodyEquipMgr").GetBodyEquipWithServerEnum(EquipPos.ORNAMENT2)
            if l_otherOrnament == nil then
                return nil
            end

            table.insert(l_equips, l_otherOrnament)
        end
    end

    return l_equips
end

--根据全局表的配置，取相应的身上的装备不包括饰品，不符合规则返回nil
function GetNeedCheckEquipsWithEquipTypesWithoutOrnaments(equipTypes)
    local l_equips = {}

    local l_equipType
    local l_propInfo
    for i = 1, equipTypes.Length do
        l_equipType = equipTypes[i - 1]
        l_propInfo = MgrMgr:GetMgr("BodyEquipMgr").GetBodyEquipWithEquipPart(l_equipType)
        --如果是副武器
        if l_equipType == 2 then
            --判断副武器是否需要加入处理列表
            local l_mainWeapon = MgrMgr:GetMgr("BodyEquipMgr").GetBodyEquipWithServerEnum(EquipPos.MAIN_WEAPON)
            if MgrMgr:GetMgr("ForgeMgr").IsNeedDealWithSecondaryWeapon(l_mainWeapon) then
                if l_propInfo == nil then
                    return nil
                end

                table.insert(l_equips, l_propInfo)
            end
            --跳过饰品判断
        elseif l_equipType ~= 6 then
            if l_propInfo == nil then
                return nil
            end

            table.insert(l_equips, l_propInfo)
        end
    end

    return l_equips
end

--精炼
function RequestEquipRefineUpgrade(equipUid, additional)
    local l_msgId = Network.Define.Rpc.EquipRefineUpgrade
    ---@type EquipRefineUpgradeArg
    local l_sendInfo = GetProtoBufSendTable("EquipRefineUpgradeArg")
    l_sendInfo.item_uid = equipUid
    local type = 0
    if additional ~= nil then

        type = additional
    end

    l_sendInfo.additional_type = type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

---@param itemData ItemData
---@return RefineAttrParam[], RefineAttrParam[]
function GenItemRefineCompareData(itemData)
    if nil == itemData then
        return {}, {}
    end

    local currentRefineLv = itemData.RefineLv
    local nextLv = currentRefineLv + 1
    local currentRefineConfig = _getTargetRefineConfig(itemData, currentRefineLv)
    local nextLvRefineConfig = _getTargetRefineConfig(itemData, nextLv)

    ---@type RefineAttrParam[]
    local currentAttrs = _parseRefineAttrsFromConfig(currentRefineConfig)
    ---@type RefineAttrParam[]
    local nextLvAttrs = _parseRefineAttrsFromConfig(nextLvRefineConfig)
    return currentAttrs, nextLvAttrs
end

---@param currentRefineConfig EquipRefineTable
---@return RefineAttrParam[]
function GetAttrDescByRefineConfig(currentRefineConfig)
    local currentAttrs = _parseRefineAttrsFromConfig(currentRefineConfig)
    return currentAttrs
end

---@param itemData ItemData
---@return EquipRefineTable
function _getTargetRefineConfig(itemData, refineLv)
    if nil == itemData then
        return nil
    end

    if nil == itemData.EquipConfig then
        logError("[RefineMgr] invalid item, id: " .. tostring(itemData.TID))
        return nil
    end

    local refineFullTable = TableUtil.GetEquipRefineTable().GetTable()
    if nil == refineFullTable then
        logError("[RefineMgr] refine table got nil")
        return nil
    end

    for i = 1, #refineFullTable do
        local singleConfig = refineFullTable[i]
        if singleConfig.Position == itemData.EquipConfig.RefineBaseAttributes
                and singleConfig.RefineLevel == refineLv then
            return singleConfig
        end
    end

    return nil
end

---@param refineConfig EquipRefineTable
---@return RefineAttrParam[]
function _parseRefineAttrsFromConfig(refineConfig)
    if nil == refineConfig then
        return {}
    end

    ---@type RefineAttrParam[]
    local ret = {}
    local attrs = refineConfig.RefineAttr
    for i = 0, attrs.Length - 1 do
        local singleAttr = attrs[i]
        local attrID = singleAttr[1]
        local attrValue = singleAttr[2]
        local attrName, attrValueStr = _parseSingeAttr(attrID, attrValue)

        ---@type RefineAttrParam
        local singleRefineAttr = {
            name = attrName,
            value = attrValueStr,
            desc = refineConfig.AttrTips[i]
        }

        table.insert(ret, singleRefineAttr)
    end

    return ret
end

---@return string, string
function _parseSingeAttr(id, value)
    local attrValue = TableUtil.GetAttrDecision().GetRowById(id, true)
    if nil == attrValue then
        return { name = "Nil" }
    end

    local showType = attrValue.TipParaEnum
    local propertyName = StringEx.Format(attrValue.TipTemplate, "")
    local currentCount = 0
    if 0 ~= value and showType == MgrMgr:GetMgr("ItemPropertiesMgr").AttrShowTypePercentAdd then
        currentCount = MgrMgr:GetMgr("ItemPropertiesMgr").GetPercentFormat(value)
    else
        currentCount = value
    end

    return propertyName, tostring(currentCount)
end

--精炼回调
function ReceiveEquipRefineUpgrade(msg)
    ---@type EquipRefineUpgradeRes
    local l_info = ParseProtoBufToTable("EquipRefineUpgradeRes", msg)
    if l_info.result == 0 then
        local tips
        local l_audioInfo
        local l_effectId
        if l_info.type == 1 then
            tips = Common.Utils.Lang("Refine_Succeed")
            l_audioInfo = refineSuccessVoiceId
            l_effectId = _refineUpgradeSuccessEffect
        else
            if l_info.type == 2 then
                tips = Common.Utils.Lang("Refine_Failed")
            elseif l_info.type == 3 then
                tips = Common.Utils.Lang("Refine_FailedLevelOff")
            elseif l_info.type == 4 then
                tips = Common.Utils.Lang("Refine_FailedDamage")
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFINE_ERROR_TYPE") .. tostring(l_info.type))
            end

            l_audioInfo = refineFailVoiceId
            l_effectId = _refineUpgradeFailEffect
        end

        MAudioMgr:Play(l_audioInfo)
        local l_npcEntity = MNpcMgr:FindNpcInViewport(MgrMgr:GetMgr("NpcMgr").CurrentNpcId)
        if l_npcEntity then
            MgrMgr:GetMgr("TransmissionMgr").ShowEffectWithPlayerEntity(l_npcEntity, l_effectId, MLayer.ID_NPC_DEPTH)
        end

        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tips)
        MgrMgr:GetMgr("ChatMgr").SendSystemInfo(DataMgr:GetData("ChatData").EChannelSys.Private, tips)
        EventDispatcher:Dispatch(ReceiveEquipRefineUpgradeEvent)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--修复装备
function RequestEquipRepair(equipUid)
    local l_msgId = Network.Define.Rpc.EquipRefineRepair
    ---@type EquipRefineRepairArg
    local l_sendInfo = GetProtoBufSendTable("EquipRefineRepairArg")
    l_sendInfo.item_uid = equipUid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--修复装备回调
function ReceiveEquipRepair(msg)
    ---@type EquipRefineRepairRes
    local l_info = ParseProtoBufToTable("EquipRefineRepairRes", msg)
    if l_info.result == 0 then
        EventDispatcher:Dispatch(ReceiveEquipRepairEvent)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("EQUIP_REPAIR_SUCESS"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--SelectEquip
---@param data ItemData[]
function GetSelectEquips(data)
    local equips = {}
    for i = 1, #data do
        local equipTableInfo = data[i].EquipConfig
        --可精炼
        if IsCanRefine(equipTableInfo) then
            table.insert(equips, data[i])
        end
    end
    return equips
end

function GetNoneEquipText()
    return Lang("NOREFINEEQUIP")
end

function IsShowSelectBg()
    return true
end

function GetSelectEquipShowType()
    return MgrMgr:GetMgr("SelectEquipMgr").eSelectEquipShowType.Refine
end

--SelectEquip
return RefineMgr