require "TableEx/EquipAttrBase"

module("Data", package.seeall)
EquipAttrOffLineFactory = class("EquipAttrOffLineFactory")

function EquipAttrOffLineFactory:Init()
    --- 离线表当中是不存在key做标记的，只有数字，所以这里做了一个字段名和ID映射
    self.C_ATTR_PARAM_NAME_MAP = {
        None = 0,
        Type = 1,
        ID = 2,
        Value = 3,
        MaxValue = 4,
        RareValue = 5,
        AttrIdx = 6,
        EquipTextID = 7,
        OverrideType = 8,
        RandomType = 9,
        ParamList = 10,
    }

    self.C_EXTRA_PARAM_VALUE_MAP = {
        None = 0,
        ID = 1,
        Value = 2,
        MaxValue = 3,
        RareValue = 4,
        RandomType = 5,
        Name = 6,
    }
end

---@return ItemAttrData[]
function EquipAttrOffLineFactory:CreateEquipAttrList(id, attrModuleType, attrValueState)
    local targetItem = ItemAttrOffLineData[id]
    if nil == targetItem then
        logError("[EquipAttrOfflineData] equip attr not found, id: " .. tostring(id))
        return {}
    end

    local targetAttrList = targetItem[attrModuleType]
    if nil == targetAttrList then
        return {}
    end

    local ret = {}
    for i = 1, #targetAttrList do
        local attr = self:_createItemAttr(targetAttrList[i], attrValueState)
        table.insert(ret, attr)
    end

    return ret
end

---@param offlineData AttrOfflineExtraParam
---@return ItemAttrExtraParam
function EquipAttrOffLineFactory:_createExtraParam(offlineData, valueState)
    local value = 0
    if GameEnum.EAttrValueState.Normal == valueState then
        value = offlineData[self.C_EXTRA_PARAM_VALUE_MAP.Value]
    elseif GameEnum.EAttrValueState.Max == valueState then
        value = offlineData[self.C_EXTRA_PARAM_VALUE_MAP.MaxValue]
    elseif GameEnum.EAttrValueState.Rare == valueState then
        value = offlineData[self.C_EXTRA_PARAM_VALUE_MAP.RareValue]
    end

    local data = Data.ItemAttrExtraParam.new(offlineData[self.C_EXTRA_PARAM_VALUE_MAP.ID], value, offlineData[self.C_EXTRA_PARAM_VALUE_MAP.RandomType], offlineData[self.C_EXTRA_PARAM_VALUE_MAP.Name])
    return data
end

---@param offlineData AttrOfflineData
---@return ItemAttrData
function EquipAttrOffLineFactory:_createItemAttr(offlineData, valueState)
    local extraParam = {}
    if nil ~= offlineData[self.C_ATTR_PARAM_NAME_MAP.ParamList] then
        for i = 1, #offlineData[self.C_ATTR_PARAM_NAME_MAP.ParamList] do
            local singleData = offlineData[self.C_ATTR_PARAM_NAME_MAP.ParamList][i]
            local singleParam = self:_createExtraParam(singleData, valueState)
            table.insert(extraParam, singleParam)
        end
    end


    local value = 0
    if GameEnum.EAttrValueState.Normal == valueState then
        value = offlineData[self.C_ATTR_PARAM_NAME_MAP.Value]
    elseif GameEnum.EAttrValueState.Max == valueState then
        value = offlineData[self.C_ATTR_PARAM_NAME_MAP.MaxValue]
    elseif GameEnum.EAttrValueState.Rare == valueState then
        value = offlineData[self.C_ATTR_PARAM_NAME_MAP.RareValue]
    end

    ---@type ItemAttrData
    local ret = Data.ItemAttrData.new(offlineData[self.C_ATTR_PARAM_NAME_MAP.Type], offlineData[self.C_ATTR_PARAM_NAME_MAP.ID], value, 0, extraParam)
    ret.RandomType = offlineData[self.C_ATTR_PARAM_NAME_MAP.RandomType]
    ret.OverrideType = offlineData[self.C_ATTR_PARAM_NAME_MAP.OverrideType]
    ret.AttrIdx = offlineData[self.C_ATTR_PARAM_NAME_MAP.AttrIdx]
    ret.EquipTextID = offlineData[self.C_ATTR_PARAM_NAME_MAP.EquipTextID]
    return ret
end