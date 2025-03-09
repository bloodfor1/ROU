-- 附魔
---@module ModuleMgr.EnchantMgr
module("ModuleMgr.EnchantMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
EquipEnchantSucceedEvent = "EquipEnchantSucceedEvent"
EquipEnchantReplaceSucceedEvent = "EquipEnchantReplaceSucceedEvent"
local l_enchantInherit = MgrMgr:GetMgr("EnchantInheritMgr")
local l_playerEquipFilter = MgrMgr:GetMgr("PlayerItemFilter")

--可附魔的部位
local _enchantPosition = MGlobalConfig:GetSequenceOrVectorInt("EnchantPosition")

--是否附魔了
---@param itemData ItemData
function IsEnchanted(itemData)
    if nil == itemData then
        return false
    end

    local l_info = itemData.AttrSet[GameEnum.EItemAttrModuleType.Enchant][1]
    return #l_info > 0
end

---@param itemData ItemData
function IsCanEnchantWithPropInfo(itemData)
    local l_equipTableInfo = itemData.EquipConfig
    if l_equipTableInfo == nil then
        return false
    end

    if l_equipTableInfo.EnchantingId == 0 then
        return false
    end

    return true
end

--是否装备附魔属性包含buff
---@param itemData ItemData
function IsEquipEnchantContainBuff(itemData)
    local l_enchantDatas = itemData.AttrSet[GameEnum.EItemAttrModuleType.Enchant][1]
    for i = 1, #l_enchantDatas do
        if GameEnum.EItemAttrType.Buff == l_enchantDatas[i].AttrType then
            return true
        end
    end

    return false
end

--- 获取所有的装备
---@return ItemData[]
function _getAllEquips()
    local types = {
        GameEnum.EBagContainerType.Equip,
    }

    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

--是否身上所有装备的附魔属性都包含buff
function IsAllBodyEquipEnchantContainBuff()
    local l_equips = _getAllEquips()
    for i, equip in pairs(l_equips) do
        if not IsEquipEnchantContainBuff(equip) then
            return false
        end
    end
    return true
end

--是否全身所有装备的附魔属性都包含buff
function IsFullBodyEquipEnchantContainBuff()
    if not MgrMgr:GetMgr("BodyEquipMgr").IsFullEquipOnBody() then
        return false
    end
    return IsAllBodyEquipEnchantContainBuff()
end

--是否身上可附魔部位的装备的附魔属性都包含buff
function IsBodyEquipEnchantContainBuffWithAllCanEnchantPosition()
    local l_equips = MgrMgr:GetMgr("RefineMgr").GetNeedCheckEquipsWithEquipTypes(_enchantPosition)
    if l_equips == nil then
        return false
    end
    for i = 1, #l_equips do
        if IsCanEnchantWithPropInfo(l_equips[i]) then
            if not IsEquipEnchantContainBuff(l_equips[i]) then
                return false
            end
        end
    end
    return true
end

function IsBuffWithEnchantTableInfo(enchantTableInfo)
    local l_propertyType = tonumber(enchantTableInfo.Property[0][0])
    if l_propertyType == MgrMgr:GetMgr("ItemPropertiesMgr").AttrTypeBuff then
        return true
    end

    return false
end

---@param enchantTableInfo EquipEnchantTable
function IsConformProfessionWithEnchantTableInfo(enchantTableInfo)
    if nil == enchantTableInfo then
        logError("[EquipEnchant] enchantTableInfo is nil, plis check")
        return false
    end

    local l_professionMgr = MgrMgr:GetMgr("ProfessionMgr")
    if nil == l_professionMgr then
        logError("[EquipEnchant] Profession Mgr is nil, plis check")
        return false
    end

    local l_playerBaseProfessionId = l_professionMgr.GetBaseProfessionIdWithPlayer()
    if l_playerBaseProfessionId == l_professionMgr.GetNoviceProfessionId() then
        return false
    end

    local l_reTable = {}
    for i = 0, enchantTableInfo.profession.Length - 1 do
        l_reTable[enchantTableInfo.profession[i]] = 1
    end

    return nil ~= l_reTable[l_playerBaseProfessionId]
end

--- 这个地方参数是已经过滤过高级附魔和普通附魔的数据的
---@param previewData EnchantPreviewAttrConfig
function GetPropertyPreviewShowData(previewData)
    local l_propertyMgr = MgrMgr:GetMgr("ItemPropertiesMgr")
    local l_equipEnchantTableInfos = previewData.EquipEnchantTableInfos
    local l_equipTextId = l_equipEnchantTableInfos[1].PropertyDec
    local l_text = l_propertyMgr.GetPropertyNameWithEquipTextId(l_equipTextId)
    local l_count

    l_propertyType = tonumber(l_equipEnchantTableInfos[1].Property[0][0])

    -- 如果是高级附魔中的buff id就去读那个text表，否则去读buff表
    if l_propertyType == l_propertyMgr.AttrTypeBuff then
        if not previewData.IsCommonEnchant then
            l_count = ""
            local l_equipTextTable = TableUtil.GetEquipText().GetRowByID(l_equipTextId, true)
            if l_equipTextTable then
                for i = 0, l_equipTextTable.ActTextOne.Length - 1 do
                    l_count = l_count .. l_equipTextTable.ActTextOne[i]
                end
            end
        else
            local l_buff_id = tonumber(l_equipEnchantTableInfos[1].Property[0][1])
            local l_buff_table_info = TableUtil.GetBuffTable().GetRowById(l_buff_id, false)
            if nil == l_buff_table_info then
                logError("[EnchantMgr] buff id: " .. l_buff_id .. " not found")
                l_count = ""
            else
                l_text = l_buff_table_info.InGameName
                l_count = l_buff_table_info.Description
            end
        end
    else
        local l_minValue = 10000000
        local l_maxValue = -10000000
        local l_randomValue
        local l_PropertyValue
        for i = 1, #l_equipEnchantTableInfos do
            l_randomValue = l_equipEnchantTableInfos[i].RandomType

            --属性的值
            if l_equipEnchantTableInfos[i].Property[0].Length < 3 then
                logError("EquipEnchantTable的属性配错了，id：" .. tostring(l_equipEnchantTableInfos[i].Id))
                return
            end

            if l_equipEnchantTableInfos[i].Property[0].Length == 3 then
                l_PropertyValue = tonumber(l_equipEnchantTableInfos[i].Property[0][2])
            else
                l_PropertyValue = tonumber(l_equipEnchantTableInfos[i].Property[0][3])
            end

            --- 策划想要左闭右开区间，所以最大值最小值都取左边
            for csIdx = 0, l_randomValue.Length - 1 do
                local currentValue = l_randomValue[csIdx][0]
                local currentMaxValue = l_randomValue[csIdx][1]
                if currentValue < l_minValue then
                    l_minValue = currentValue
                end

                if currentValue > l_maxValue then
                    l_maxValue = currentMaxValue
                end
            end
        end

        local l_propertyId = tonumber(l_equipEnchantTableInfos[1].Property[0][1])
        --- 为什么会有-1，因为区间是左闭右开区间，策划要求最大值取不到
        l_count = l_propertyMgr.GetPropertyValueTextWithId(l_propertyId, l_minValue) .. "~" .. l_propertyMgr.GetPropertyValueTextWithId(l_propertyId, l_maxValue - 1)
    end

    local l_isShowRecommendSign = IsConformProfessionWithEnchantTableInfo(l_equipEnchantTableInfos[1])
    return l_text, l_count, l_isShowRecommendSign
end

--附魔
function RequestEquipEnchantCommon(equipUid)
    _requestEquipEnchant(equipUid, 0)
end
function RequestEquipEnchantAdvanced(equipUid)
    _requestEquipEnchant(equipUid, 1)
end
function _requestEquipEnchant(equipUid, type)
    local l_msgId = Network.Define.Rpc.EquipEnchant
    ---@type EquipEnchantArg
    local l_sendInfo = GetProtoBufSendTable("EquipEnchantArg")
    l_sendInfo.item_uid = equipUid
    l_sendInfo.enchant_type = type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--附魔回调
function ReceiveEquipEnchant(msg)
    ---@type EquipEnchantRes
    local l_info = ParseProtoBufToTable("EquipEnchantRes", msg)
    EventDispatcher:Dispatch(EquipEnchantSucceedEvent)
    if l_info.result ~= 0 then
        logError("附魔错误:" .. tostring(l_info.result))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ENCHANT_SUCCEED"))
end

--附魔替换
function RequestConfirmEquipEnchantCommon(equipUid)
    _requestConfirmEquipEnchant(equipUid, 0)
end
function RequestConfirmEquipEnchantAdvanced(equipUid)
    _requestConfirmEquipEnchant(equipUid, 1)
end
function _requestConfirmEquipEnchant(equipUid, type)
    local l_msgId = Network.Define.Rpc.EquipEnchantConfirm
    ---@type EquipEnchantConfirmArg
    local l_sendInfo = GetProtoBufSendTable("EquipEnchantConfirmArg")
    l_sendInfo.item_uid = equipUid
    l_sendInfo.type = type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
--附魔替换回调
function ConfirmEquipEnchant(msg)
    ---@type EquipEnchantConfirmRes
    local l_info = ParseProtoBufToTable("EquipEnchantConfirmRes", msg)

    EventDispatcher:Dispatch(EquipEnchantReplaceSucceedEvent)

    if l_info.result ~= 0 then
        logError("附魔替换错误:" .. tostring(l_info.result))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ENCHANTSAVE_SUCCEED"))
end

--得到装备上附魔属性是buff的个数
---@param itemData ItemData
function GetEnchantBuffCountWithPropInfo(itemData)
    local l_enchantDatas = itemData.AttrSet[GameEnum.EItemAttrModuleType.Enchant][1]
    local l_buffType = MgrMgr:GetMgr("ItemPropertiesMgr").AttrTypeBuff

    local l_count = 0

    local l_entry
    local l_type
    for i = 1, #l_enchantDatas do
        l_entry = l_enchantDatas[i].entrys[1]
        l_type = l_entry.type
        if l_type == l_buffType then
            l_count = l_count + 1
        end
    end
    return l_count
end

--得到全身附魔属性的buff的个数
function GetAllEnchantBuffCount()
    local l_equips = _getAllEquips()
    local l_sum = 0;
    for _, v in pairs(l_equips) do
        l_sum = l_sum + GetEnchantBuffCountWithPropInfo(v)
    end

    return l_sum
end

---@param data ItemData[]
function GetSelectEquips(data)
    local l_condMap = {
        { cond = l_enchantInherit.IsEquipShopType, param = nil },
        { cond = l_playerEquipFilter.EquipDamaged, param = false },
        { cond = l_playerEquipFilter.EquipCanBeEnchanted, param = true },
        { cond = l_playerEquipFilter.EquipEnchantExtracted, param = false },
    }

    local l_ret = l_playerEquipFilter.FiltrateItemData(data, l_condMap)
    return l_ret
end

function GetNoneEquipText()
    return Lang("EquipEnchant_NoneEquipText")
end
--SelectEquip

return ModuleMgr.EnchantMgr