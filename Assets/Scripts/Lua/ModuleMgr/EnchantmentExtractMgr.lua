---@module ModuleMgr.EnchantmentExtractMgr
module("ModuleMgr.EnchantmentExtractMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
OnReceiveExtractDataEvent = "OnReceiveExtractDataEvent"
ExtractSucceedEvent = "ExtractSucceedEvent"

---@type ItemData
cacheData = nil

local strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")

-- 对应表中的字段
local l_ePropertyType = {
    None = 0,
    PerfectWeapon = 1,
    PerfectOtherEquip = 2,
    NormalWeapon = 3,
    NormalOther = 4,
}

--- 消耗潜规则，饰品走武器
local C_PERFECT_EXTRACT_EQUIP_TYPE_MAP = {
    [GameEnum.EEquipSlotType.Weapon] = 1,
    [GameEnum.EEquipSlotType.Accessory] = 1,
}

local l_tableEnchantReborn = TableUtil.GetEnchantReborn()

--- 从global表当中获取数据
local function _parseDataFromTable(key, valueStruct, valueType)
    local tableStr = TableUtil.GetGlobalTable().GetRowByName(key, false).Value
    local ret = strParseMgr.ParseValue(tableStr, valueStruct, valueType)
    return ret
end

-- 普通提炼和完美提炼对应的结果ID
local resultIDTable = {
    currencyID = _parseDataFromTable("BaseRebornItemShow", GameEnum.EStrParseType.Value, GameEnum.ELuaBaseType.Number),
}

function OnInit()
    -- do nothing
end

---@return ItemData
function GetCacheData()
    return cacheData
end

---@param data ItemData
function SetCacheData(data)
    cacheData = data
end

function GetExpends(propInfo)
    local l_ret = _getExtractExpends(propInfo)
    return l_ret
end

-- 获取完美提炼的消耗
---@param itemData ItemData
function _getExtractExpends(itemData)
    if nil == itemData then
        return {}
    end

    local l_equipTableConfig = itemData.EquipConfig
    local l_lv = itemData:GetEquipTableLv()
    local l_tablePropertyType = nil
    if nil ~= C_PERFECT_EXTRACT_EQUIP_TYPE_MAP[l_equipTableConfig.EquipId] then
        l_tablePropertyType = l_ePropertyType.NormalWeapon
    else
        l_tablePropertyType = l_ePropertyType.NormalOther
    end

    local enchantAttrGrade = itemData.EnchantGrade
    local l_ret = _getEnchantRebornConsume(l_lv, enchantAttrGrade, l_tablePropertyType)
    if nil == l_ret then
        return {}
    end

    local l_retPerfectTable = { l_ret }
    return l_retPerfectTable
end

-- 表当中的ID是按照区间分配的，这个方法是取ID用的
function _getEquipLvInTable(equipLv)
    local L_CONST_MZ_ENCHANT_TABLE_ID = 10
    local l_midValue = math.floor((equipLv + 9) / L_CONST_MZ_ENCHANT_TABLE_ID)
    if 0 >= l_midValue then
        logError("[EnchantExtract] invalid lv: " .. equipLv)
        return L_CONST_MZ_ENCHANT_TABLE_ID
    end

    local l_ret = l_midValue * L_CONST_MZ_ENCHANT_TABLE_ID
    return l_ret
end

-- 最后一个参数是字段类型
function _getEnchantRebornConsume(equipLv, grade, propertyType)
    local l_equipTableID = _getEquipLvInTable(equipLv)
    local l_enchantRebornConfig = l_tableEnchantReborn.GetRowByEquipLv(l_equipTableID, false)
    if nil == l_enchantRebornConfig then
        logError("[EnchantExtract] EquipLv: " .. equipLv .. " config not found")
        return {}
    end

    local l_consumeData = nil
    if l_ePropertyType.PerfectOtherEquip == propertyType then
        l_consumeData = l_enchantRebornConfig.PerfectOtherConsume
    elseif l_ePropertyType.PerfectWeapon == propertyType then
        l_consumeData = l_enchantRebornConfig.PerfectWeaponConsume
    elseif l_ePropertyType.NormalWeapon == propertyType then
        l_consumeData = l_enchantRebornConfig.WeaponConsume
    elseif l_ePropertyType.NormalOther == propertyType then
        l_consumeData = l_enchantRebornConfig.OtherConsume
    else
        logError("[EnchantExtract] property type: " .. propertyType .. " type invalid")
        l_consumeData = nil
    end

    local ret = _getMat(l_consumeData, grade)
    return ret
end

-- 获取消耗的情况
-- scoreConfig = {{grade, id, count}}
---@return ItemTemplateParam
function _getMat(scoreConfig, grade)
    if nil == scoreConfig or nil == grade then
        logError(tostring(scoreConfig))
        logError(tostring(grade))
        logError("[EnchantExtract] params got nil")
        return nil
    end

    -- 这里因为是从CS那边过来的表，所以编号是从0开始的
    -- 反过来读表，获取数据，为了处理溢出的情况
    local l_startIdx = scoreConfig.Length - 1
    for i = 0, l_startIdx do
        local l_config = scoreConfig[i]
        if grade == l_config[0] then
            ---@type ItemTemplateParam
            local l_ret = {
                ID = l_config[1],
                RequireCount = l_config[2],
                IsShowRequire = true,
                IsShowCount = false,
            }

            return l_ret
        end
    end

    return nil
end

-- 只是去表中的数据
---@param itemData ItemData
---@return EnchantReborn
function GetEnchantRebornTableInfo(itemData)
    if nil == itemData then
        return nil
    end

    local l_level = itemData:GetEquipTableLv()
    local l_enchantId = _getEquipLvInTable(l_level)
    local l_table = TableUtil.GetEnchantReborn().GetRowByEquipLv(l_enchantId, false)
    return l_table
end

-- 获取结果装备，用于显示
-- 这个方法创建的是假的背包数据
function CreateResultPropData()
    local propID = resultIDTable.currencyID
    local ret = Data.BagModel:CreateItemWithTid(propID)
    return ret
end

--SelectEquip
---@param data ItemData[]
function GetSelectEquips(data)
    local equips = {}
    for i = 1, #data do
        if _itemEnchanted(data[i]) then
            table.insert(equips, data[i])
        end
    end

    return equips
end

function GetNoneEquipText()
    return Lang("NOENCHANTEXTRACTEQUIP")
end

---@param itemData ItemData
function _itemEnchanted(itemData)
    if nil == itemData then
        return false
    end

    local attrs = itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    local ret = 0 < #attrs
    return ret
end

function RequestEquipEnchantRebornPreview(uid)
    local l_msgId = Network.Define.Rpc.EquipEnchantRebornPreview
    ---@type EquipEnchantRebornPreviewArg
    local l_sendInfo = GetProtoBufSendTable("EquipEnchantRebornPreviewArg")
    l_sendInfo.item_uid = uid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ReceiveEquipEnchantRebornPreview(msg)
    ---@type EquipEnchantRebornPreviewRes
    local l_info = ParseProtoBufToTable("EquipEnchantRebornPreviewRes", msg)
    local items = l_info.return_items
    if 0 ~= l_info.result then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    EventDispatcher:Dispatch(OnReceiveExtractDataEvent, items)
end

function RequestEquipEnchantReborn(uid)
    local l_msgId = Network.Define.Rpc.EquipEnchantReborn
    ---@type EquipEnchantRebornArg
    local l_sendInfo = GetProtoBufSendTable("EquipEnchantRebornArg")
    l_sendInfo.item_uid = uid
    Network.Handler.SendRpc(l_msgId, l_sendInfo, uid)
end

function ReceiveEquipEnchantReborn(msg, uid)
    ---@type EquipEnchantRebornRes
    local l_info = ParseProtoBufToTable("EquipEnchantRebornRes", msg)
    local result = l_info.result
    if result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(result))
        return
    end

    local content = Common.Utils.Lang("C_ENCHANT_EXTRACT_DONE")
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(content)
    EventDispatcher:Dispatch(ExtractSucceedEvent)
end

return ModuleMgr.EnchantmentExtractMgr