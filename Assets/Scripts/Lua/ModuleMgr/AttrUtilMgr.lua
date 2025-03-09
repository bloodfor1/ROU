-- 属性相关的计算工具
---@module ModuleMgr.AttrUtilMgr
module("ModuleMgr.AttrUtilMgr", package.seeall)

local l_equipEnchantTable = TableUtil.GetEquipEnchantTable()
---@type ModuleMgr.AttrDescUtil
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
--- 显示星的临界值
local C_SHOW_STAR_LIMIT = 0.8
--- 数值对应区间，颜色，是否显示五角星的配置
--- 最后一个是特技的范围区间
---@type table<number, EnchantAttrColorConfig>
local C_ENCHANT_ATTR_COLOR_MAP = {
    [GameEnum.EEnchantAttrQuality.None] = { colorTag = RoColor.Tag.None, isBuff = false },
    [GameEnum.EEnchantAttrQuality.Blue] = { colorTag = RoColor.Tag.Blue, isBuff = false },
    [GameEnum.EEnchantAttrQuality.Purple] = { colorTag = RoColor.Tag.Purple, isBuff = false },
    [GameEnum.EEnchantAttrQuality.Gold] = { colorTag = RoColor.Tag.White, isBuff = true },
}

local C_ATTR_RARE_QUALITY = 3       -- 目前只有3，后面有增加可用离线表

-- 表驱动，获取属性显示数据
-- 这边传过来的数据是{table_id = 1, id = 1, val = 1}
---@param itemAttrData ItemAttrData
function CalcAttrDisplayConf(itemAttrData)
    if nil == itemAttrData then
        logError("[AttrUtil] entry is nil")
        return "", 0, false
    end

    local attrQuality = _getAttrQualityID(itemAttrData.TableID)
    local l_singleConfig = C_ENCHANT_ATTR_COLOR_MAP[attrQuality]
    local attrDesc = attrUtil.GetAttrStr(itemAttrData, l_singleConfig.colorTag)
    local l_coloredName = attrDesc.Name
    local l_valueText = attrDesc.Value
    local showStar = _showStar(itemAttrData.TableID, itemAttrData.AttrValue)
    return l_coloredName, l_valueText, showStar, l_singleConfig.isBuff
end

function EnchantAttrRare(tableID)
    return _getAttrQualityID(tableID) == C_ATTR_RARE_QUALITY
end

--- 判断是否要显示星
---@return boolean
function _showStar(tableID, value)
    if nil == tableID or nil == value then
        return false
    end

    local enchantConfig = l_equipEnchantTable.GetRowById(tableID, false)
    if nil == enchantConfig then
        return false
    end

    if 3 < enchantConfig.Property.Length then
        logError("[EquipEnchantTable] invalid row, table id: " .. tostring(tableID))
        return false
    end

    local maxValue = enchantConfig.Property[0][2]
    if 0 >= maxValue then
        return false
    end

    -- todo 测试代码
    -- logError("value: " .. value .. " max value: " .. maxValue .. " table id: " .. tableID)
    return C_SHOW_STAR_LIMIT <= (value / maxValue)
end

---@return number
function _getAttrQualityID(tableID)
    if GameEnum.ELuaBaseType.Number ~= type(tableID) then
        logError("invalid param")
        return GameEnum.EEnchantAttrQuality.None
    end

    local enchantConfig = l_equipEnchantTable.GetRowById(tableID, false)
    if nil == enchantConfig then
        return GameEnum.EEnchantAttrQuality.None
    end

    return enchantConfig.Quality
end

return ModuleMgr.AttrUtilMgr
