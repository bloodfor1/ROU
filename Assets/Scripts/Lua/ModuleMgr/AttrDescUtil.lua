--- 集中读取属性的类，没有多余职责，只负责读取属性描述
--- 0扇出，没有对其他模块的调用

---@module ModuleMgr.AttrDescUtil
module("ModuleMgr.AttrDescUtil", package.seeall)

---@class ItemAttrGroup
---@field Name string
---@field Value string
---@field FullValue string @名字和颜色拼在一起
---@field Desc string

local C_CONVERT_VALUE = 0.0001
local C_CONVERT_VALUE_PERCENTAGE = 0.01

local C_ATTR_BASIC_CT_FIXED = 81
local C_ATTR_BASIC_CT_CHANGE = 83
local C_ATTR_BASIC_CD_CHANGE = 85
local C_ATTR_BASIC_GROUP_CD_CHANGE = 101

local E_ATTR_ID_PHYSICAL_DEFENSE = 63
local E_ATTR_ID_MAGIC_DEFENSE = 64

local C_CONVERT_VALUE_ATTR = {
    [C_ATTR_BASIC_CT_FIXED] = 1,
    [C_ATTR_BASIC_CT_CHANGE] = 1,
    [C_ATTR_BASIC_CD_CHANGE] = 1,
    [C_ATTR_BASIC_GROUP_CD_CHANGE] = 1,
}

-- 属性显示方式的枚举
local EAttrShowType = {
    None = -1,
    IntAdd = 0,
    PercentAdd = 1,
    Int = 2,
    Percent = 3,
    Element = 4,
    DividedTenThousandAdd = 5,
}

local C_ELEMENT_NAME_MAP = {
    [0] = Common.Utils.Lang("WU"),
    [1] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_FENG"),
    [2] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DI"),
    [3] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_HUO"),
    [4] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHUI"),
    [5] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_DU"),
    [6] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_SHENG"),
    [7] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_AN"),
    [8] = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MONSTER_YUANSU_NIAN"),
    [9] = Common.Utils.Lang("UnitRace_4"),
}

---@param itemAttr ItemAttrData
---@return ItemAttrGroup
function GetAttrStr(itemAttr, color)
    if nil == itemAttr then
        logError("[AttrUtil] invalid param")
        return nil
    end

    --- 1 判断属性是否需要覆盖。如果不需要覆盖，直接判断是buff还是常规属性
    if not itemAttr:CanOverrideDesc() then
        local ret = _getAttrStr(itemAttr, color)
        return ret
    end

    local ret = _parseSingleStyleAttr(itemAttr, color)
    return ret
end

---@param itemData ItemData
function GetItemSchoolAttrStr(itemData, colorTag)
    if nil == itemData then
        logError("[ItemAttr] itemData got nil")
        return nil
    end

    if nil == itemData.EquipConfig then
        logError("[ItemAttr] itemData EquipConfig got nil")
        return nil
    end

    local attrs = itemData.AttrSet[GameEnum.EItemAttrModuleType.School]
    if nil == attrs or 0 >= #attrs then
        logError("[ItemAttr] item contains no school attr")
        return nil
    end

    local ret = _genStyleAttrStrList(attrs[1], colorTag)
    return ret
end

---@param itemAttrList ItemAttrData[]
---@return string[]
function GenItemSchoolAttrStrList(itemAttrList, colorTag)
    local ret = _genStyleAttrStrList(itemAttrList, colorTag)
    return ret
end

---@param itemAttrList ItemAttrData[]
---@return string[]
function _genStyleAttrStrList(itemAttrList, colorTag)
    local ret = {}
    for i = 1, #itemAttrList do
        local singleGroup = _parseSingleStyleAttr(itemAttrList[i], colorTag)
        table.insert(ret, singleGroup.FullValue)
    end

    return ret
end

--- 解析流派词条属性
---@param itemAttr ItemAttrData
---@return ItemAttrGroup
function _parseSingleStyleAttr(itemAttr, color)
    if nil == itemAttr then
        logError("[AttrUtil] invalid param")
        return ""
    end

    local ret = _getAttrStr(itemAttr, color)
    local C_NOT_OVERRIDE_STR = "Nil"
    local equipTextTable = TableUtil.GetEquipText().GetRowByID(itemAttr.EquipTextID, true)
    if nil == equipTextTable then
        return ret
    end

    local strList = nil
    if GameEnum.EAttrDescType.EquipTextOne == itemAttr.OverrideType then
        strList = equipTextTable.ActTextOne
    elseif GameEnum.EAttrDescType.EquipTextTwo == itemAttr.OverrideType then
        strList = equipTextTable.ActTextTwo
    end

    local idx = itemAttr.AttrIdx
    if idx > strList.Length then
        return ret
    end

    local str = strList[idx - 1]
    if C_NOT_OVERRIDE_STR == str then
        return ret
    end

    if GameEnum.EAttrDescType.EquipTextTwo == itemAttr.OverrideType then
        local value = itemAttr.AttrValue
        local config = TableUtil.GetEquipMapStringInt().GetRowByValue(itemAttr.AttrID)
        if GameEnum.EEquipStrIntMapValueType.Decimal == config.DisplayType then
            value = value * 0.0001
        end

        local valueStr = StringEx.Format(str, value)
        valueStr = GetColorText(valueStr, color)
        ret.FullValue = valueStr
        return ret
    end

    local extraParamList = itemAttr.ExtraParam
    if nil == extraParamList or 0 >= #extraParamList then
        ret.FullValue = GetColorText(str, color)
        return ret
    end

    for i = 1, #extraParamList do
        local singleParam = extraParamList[i]
        local keyStr = singleParam.name
        local index = string.find(str, keyStr)
        if index then
            str = _replaceStrByExtraParam(str, singleParam, index)
        end
    end

    ret.FullValue = GetColorText(str, color)
    return ret
end

--- 替换单个属性字符串
---@param extraParam ItemAttrExtraParam
function _replaceStrByExtraParam(str, extraParam, index)
    if nil == extraParam then
        return str
    end

    --key的长度
    local l_length = string.len(extraParam.name)
    --找到key后面的第二个位置判断是不是百分比数值
    local l_preIndex = index + l_length + 1
    local l_preStr = string.sub(str, l_preIndex, l_preIndex)
    local l_oldStr = ""
    local l_value = extraParam.value
    if l_preStr == "%" then
        l_value = StringEx.Format("{0:F2}", extraParam.value / 100)
        l_oldStr = StringEx.Format("{{{0}}}", extraParam.name)
    else
        l_oldStr = StringEx.Format("{{{0}}}", extraParam.name)
    end

    --替换key为数值
    str = string.gsub(str, l_oldStr, tostring(l_value))
    return str
end

--- 获取属性描述的，返回3个值，属性名，属性值，属性名和属性值拼接在一起的结果
---@param itemAttr ItemAttrData
---@return ItemAttrGroup
function _getAttrStr(itemAttr, color)
    ---@type ItemAttrGroup
    local ret = {
        Name = nil,
        Value = nil,
        Desc = nil,
    }

    if nil == itemAttr then
        logError("[ItemAttr] itemAttr got nil")
        return ret
    end

    if GameEnum.EItemAttrType.Buff == itemAttr.AttrType then
        ---@type BuffTable
        local buffConfig = TableUtil.GetBuffTable().GetRowById(itemAttr.AttrID, false)
        if nil == buffConfig then
            logError("[ItemAttr] invalid buff id: " .. tostring(itemAttr.AttrID))
            return ret
        end

        ret.Name = buffConfig.InGameName
        ret.Desc = buffConfig.Description
        ret.Value = ""
    elseif GameEnum.EItemAttrType.Attr == itemAttr.AttrType then
        ---@type AttrDecision
        local attrTable = TableUtil.GetAttrDecision().GetRowById(itemAttr.AttrID, false)
        if nil == attrTable then
            logError("[ItemAttr] invalid attr id: " .. tostring(itemAttr.AttrID))
            return ret
        end

        ret.Name = attrTable.TipTemplate
        local value = _tryConvert(itemAttr.AttrID, itemAttr.AttrValue)
        ret.Value = _tryGetValue(attrTable.TipParaEnum, value, attrTable.Id)
        ret.Desc = StringEx.Format(attrTable.TipTemplate, ret.Value)
    else
        ret.Name = ""
        ret.Value = ""
        ret.Desc = ""
    end

    ret.FullValue = StringEx.Format(ret.Name, ret.Value)
    if nil ~= color then
        ret.Name = GetColorText(ret.Name, color)
        ret.Value = GetColorText(ret.Value, color)
        ret.FullValue = GetColorText(ret.FullValue, color)
        ret.Desc = GetColorText(ret.Desc, color)
    end

    return ret
end

function _tryConvert(id, value)
    if nil == id or nil == value then
        return 0
    end

    if nil == C_CONVERT_VALUE_ATTR[id] then
        return value
    end

    return value * C_CONVERT_VALUE
end

function _tryGetValue(valueType, value , AttrID)
    if nil == valueType or nil == value then
        return nil
    end

    if EAttrShowType.IntAdd == valueType then
        local ret = tostring(math.floor(value))
        if 0 < value then
            return StringEx.Format("+{0}{1}", ret,_getAttrAdditionalDescription(AttrID,value))
        end

        return ret
    elseif EAttrShowType.Int == valueType then
        return tostring(math.floor(value))
    elseif EAttrShowType.PercentAdd == valueType then
        local val = value * C_CONVERT_VALUE_PERCENTAGE
        if 0 < value then
            return StringEx.Format("+{0:F2}%", val)
        end

        return StringEx.Format("{0:F2}%", val)
    elseif EAttrShowType.Percent == valueType then
        local val = value * C_CONVERT_VALUE_PERCENTAGE
        return StringEx.Format("{0:F2}%", val)
    elseif EAttrShowType.Element == valueType then
        return C_ELEMENT_NAME_MAP[value]
    elseif EAttrShowType.DividedTenThousandAdd == valueType then
        local val = value
        val = val / 1000
        val = math.floor(val)
        val = val / 10
        return StringEx.Format("+{0}", tostring(val))
    else
        return nil
    end
end

function _getAttrAdditionalDescription(attrId,value)
    if attrId == E_ATTR_ID_PHYSICAL_DEFENSE then
        local value = 30000/(value+300) - 100
        value = value - value % 0.1
        return Common.Utils.Lang("AttrDesRefinePhysicalDefense",value)
    elseif attrId == E_ATTR_ID_MAGIC_DEFENSE then
        local value = 15000/(value+150) - 100
        value = value - value % 0.1
        return Common.Utils.Lang("AttrDesRefineMagicDefense",value)
    end
    return ""
end

return ModuleMgr.AttrDescUtil