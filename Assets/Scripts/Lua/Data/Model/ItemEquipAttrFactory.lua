require "Data/Model/ItemAttrData"
require "Data/Model/ItemAttrExtraParam"
require "Data/Model/EquipAttrOffLineFactory"

--- 这个类是作为静态工厂类使用的，所以只由外部init一次
--- 用来生成道具基础属性的工厂
--- 职责是生成道具有关的 极品 基础属性和流派属性
--- 至于真实属性是否是极品的判断是写在ROItem工厂里的
module("Data", package.seeall)
ItemEquipAttrFactory = class("ItemEquipAttrFactory")

function ItemEquipAttrFactory:ctor()
    -- do nothing
end

function ItemEquipAttrFactory:Init()
    self:_tryInitRateConfig()
    Data.EquipAttrOffLineFactory:Init()
end

---@param equipConfig EquipTable
---@return ItemAttrData[]
function ItemEquipAttrFactory:GetAttr(attrModuleType, attrValueState, equipConfig, equipLv)
    local ret = self:_genAttrListFromOffLineData(attrModuleType, attrValueState, equipConfig.Id)
    return ret
end

--- 根据离线表数据生成装备属性
---@return ItemAttrData[]
function ItemEquipAttrFactory:_genAttrListFromOffLineData(attrModuleType, attrValueState, id)
    local ret = Data.EquipAttrOffLineFactory:CreateEquipAttrList(id, attrModuleType, attrValueState)
    return ret
end

-- todo 现在这个方法已经废弃了
--- 实时生成装备基础属性
---@param equipConfig EquipTable
---@return ItemAttrData[]
function ItemEquipAttrFactory:_genAttrListRealTime(attrModuleType, attrValueState, equipConfig, equipLv)
    local retList = nil
    local changeValueFunc = nil
    if GameEnum.EItemAttrModuleType.Base == attrModuleType then
        retList = self:_parseBaseAttrFromTable(equipConfig)
        changeValueFunc = self._genRandomBase
    elseif GameEnum.EItemAttrModuleType.School == attrModuleType then
        local tempAttr = self:_parseTempEquipAttr(equipConfig)
        retList = self:_parseSchoolAttrFromTable(equipConfig)
        table.ro_insertRange(retList, tempAttr)
        changeValueFunc = self._genRandomStyle
    else
        logError("[ItemAttrFactory] invalid module type: " .. tostring(attrModuleType))
        return {}
    end

    if GameEnum.EAttrValueState.Max == attrValueState then
        changeValueFunc(self, equipLv, false, retList, equipConfig)
    elseif GameEnum.EAttrValueState.Rare == attrValueState then
        changeValueFunc(self, equipLv, true, retList, equipConfig)
    elseif GameEnum.EAttrValueState.Normal == attrValueState then
        -- do nothing
    else
        logError("[ItemAttrFactory] invalid value state: " .. tostring(attrValueState))
    end

    return retList
end

function ItemEquipAttrFactory:_tryInitRateConfig()
    local C_NUM_DEFAULT_OFFSET = 10000
    local baseOffset = MGlobalConfig:GetInt("BaseAttrOffset", C_NUM_DEFAULT_OFFSET)
    local styleOffset = MGlobalConfig:GetInt("StyleAttrOffset", C_NUM_DEFAULT_OFFSET)
    self._baseAttrRateOffset = self:_convertRate(baseOffset)
    self._styleAttrRateOffset = self:_convertRate(styleOffset)
end

--- 属性取比例是在偏移之后的范围取比例
function ItemEquipAttrFactory:_genOffsetRate(rate, offset)
    return offset + rate
end

function ItemEquipAttrFactory:_convertRate(rate)
    --- 表当中填写的是万分比
    local C_MZ_RATE = 0.0001
    return rate * C_MZ_RATE
end

--- 对装备基础属性进行随机
---@param equipConfig EquipTable
---@param rareAttr boolean @是获取稀有还是获取
---@param attrList ItemAttrData[]
function ItemEquipAttrFactory:_genRandomBase(equipLv, rareAttr, attrList, equipConfig)
    local config = self:_getAttrRandPattern(equipLv)
    if nil == config then
        logError("[ItemLocalFactory] invalid equip lv: " .. tostring(equipLv))
        return
    end

    if nil == equipConfig or nil == attrList then
        return
    end

    local weaponID = equipConfig.WeaponId
    local equipType = equipConfig.EquipId
    for i = 1, #attrList do
        local singleAttr = attrList[i]
        if GameEnum.EStyleAttrRandType.Rand == singleAttr.RandomType then
            local maxRate = self:_getSingleBaseRate(equipType, weaponID, singleAttr.AttrID, config, true)
            local runningRate = self:_genOffsetRate(maxRate, self._baseAttrRateOffset)
            if rareAttr then
                local rareRate = self:_getAttrRareRate(equipLv)
                local minConfig = self:_getMinRandPattern(equipLv)
                local minRate = self:_getSingleBaseRate(equipType, weaponID, singleAttr.AttrID, minConfig, false)
                runningRate = self:_getRareRateInDetail(rareRate, maxRate, minRate, self._baseAttrRateOffset)
            end

            singleAttr.AttrValue = math.floor(singleAttr.AttrValue * runningRate)
        end
    end
end

--- 对装备流派属性进行随机
---@param attrList ItemAttrData[]
function ItemEquipAttrFactory:_genRandomStyle(equipLv, isRare, attrList)
    local config = self:_getAttrRandPattern(equipLv)
    if nil == config then
        logError("[ItemLocalFactory] invalid equip lv: " .. tostring(equipLv))
        return
    end

    local maxRate = self:_convertRate(config.EntryAttribute[1])
    local rate = self:_genOffsetRate(maxRate, self._styleAttrRateOffset)
    if isRare then
        local rareRate = self:_getAttrRareRate(equipLv)
        local minConfig = self:_getMinRandPattern(equipLv)
        local minRate = self:_convertRate(minConfig.EntryAttribute[0])
        rate = self:_getRareRateInDetail(rareRate, maxRate, minRate, self._styleAttrRateOffset)
    end

    if nil == attrList then
        return
    end

    for i = 1, #attrList do
        local singleAttr = attrList[i]
        local extraParam = singleAttr.ExtraParam
        if GameEnum.EStyleAttrRandType.Rand == singleAttr.RandomType then
            singleAttr.AttrValue = math.floor(singleAttr.AttrValue * rate)
        end

        if nil ~= extraParam then
            for j = 1, #extraParam do
                local singleParam = extraParam[j]
                if GameEnum.EStyleAttrRandType.Rand == singleParam.randomType then
                    singleParam.value = math.floor(singleParam.value * rate)
                end
            end
        end
    end
end

function ItemEquipAttrFactory:_getRareRateInDetail(rareRate, maxRate, minRate, offset)
    local ret = rareRate * (maxRate - minRate) + offset + minRate
    return ret
end

---@param config EquipReformTable
---@param max boolean
function ItemEquipAttrFactory:_getSingleBaseRate(equipID, weaponID, attrID, config, max)
    if nil == config then
        logError("[ItemLocalFactory] invalid config")
        return 1
    end

    local E_EQUIP_ID_TYPE = GameEnum.EEquipSlotType
    local E_EQUIP_WEAPON_ID_TYPE = GameEnum.EWeaponDetailType
    local C_WEAPON_TYPE_MAP = {
        [E_EQUIP_ID_TYPE.Weapon] = 1,
        [E_EQUIP_ID_TYPE.HeadWear] = 1,
        [E_EQUIP_ID_TYPE.BackGear] = 1,
        [E_EQUIP_ID_TYPE.FaceGear] = 1,
        [E_EQUIP_ID_TYPE.MouthGear] = 1,
        [E_EQUIP_ID_TYPE.Accessory] = 1,
    }

    --- 判断部位
    local C_ARMOR_TYPE_MAP = {
        [E_EQUIP_ID_TYPE.Armor] = 1,
        [E_EQUIP_ID_TYPE.Boot] = 1,
        [E_EQUIP_ID_TYPE.Cape] = 1,
        [E_EQUIP_ID_TYPE.BackUpHand] = 1,
    }

    --- 判断是否是盾牌
    local C_WEAPON_DETAIL_MAP = {
        [E_EQUIP_WEAPON_ID_TYPE.Shield] = 1,
    }

    local valueIdx = 0
    if max then
        valueIdx = 1
    end

    if nil ~= C_WEAPON_TYPE_MAP[equipID] then
        local ret = self:_convertRate(config.WeaponBaseAttributes[valueIdx])
        return ret
    end

    if nil ~= C_ARMOR_TYPE_MAP[equipID] or nil ~= C_WEAPON_DETAIL_MAP[weaponID] then
        if AttrType.ATTR_BASIC_DEF == attrID then
            local ret = self:_convertRate(config.ArmorBaseAttrDef[valueIdx])
            return ret
        elseif AttrType.ATTR_BASIC_MAX_HP == attrID then
            local ret = self:_convertRate(config.ArmorBaseAttrHp[valueIdx])
            return ret
        else
            local ret = self:_convertRate(config.EntryAttribute[valueIdx])
            return ret
        end
    end

    return 0
end

--- 获取最小配置
---@return EquipReformTable
function ItemEquipAttrFactory:_getMinRandPattern(equipLv)
    local equipReformFullTable = TableUtil.GetEquipReformTable().GetTable()
    local E_RAND_TYPE = GameEnum.EEquipAttrRandType
    local ret = nil
    --- 这个值是随便写的
    local minRange = 10000
    for i = 1, #equipReformFullTable do
        ---@type EquipReformTable
        local singleConfig = equipReformFullTable[i]
        local minLv = singleConfig.Level[0]
        local maxLv = singleConfig.Level[1]
        local lvMatch = minLv <= equipLv and maxLv > equipLv
        local reformLvValid = singleConfig.ReformId < minRange
        if E_RAND_TYPE.Static ~= singleConfig.Type and lvMatch and reformLvValid then
            ret = singleConfig
            minRange = singleConfig.ReformId
        end
    end

    return ret
end

--- 获取对应的随机配置
---@return EquipReformTable
function ItemEquipAttrFactory:_getAttrRandPattern(equipLv)
    local equipReformFullTable = TableUtil.GetEquipReformTable().GetTable()
    local E_RAND_TYPE = GameEnum.EEquipAttrRandType
    local ret = nil
    local maxRange = 0
    for i = 1, #equipReformFullTable do
        ---@type EquipReformTable
        local singleConfig = equipReformFullTable[i]
        local minLv = singleConfig.Level[0]
        local maxLv = singleConfig.Level[1]
        local lvMatch = minLv <= equipLv and maxLv > equipLv
        local reformLvValid = singleConfig.ReformId > maxRange
        if E_RAND_TYPE.Static ~= singleConfig.Type and lvMatch and reformLvValid then
            ret = singleConfig
            maxRange = singleConfig.ReformId
        end
    end

    return ret
end

--- 解析临时属性
---@param equipConfig EquipTable
---@return ItemAttrData[]
function ItemEquipAttrFactory:_parseTempEquipAttr(equipConfig)
    if nil == equipConfig then
        return {}
    end

    local ret = {}
    local attrConfigList = string.ro_split(equipConfig.EntryAttributeTwo, '|')
    for i = 1, #attrConfigList do
        local attr = self:_parseStrToAttr(attrConfigList[i])
        local equipTextID = equipConfig.EquipText
        attr.EquipTextID = equipTextID
        attr.AttrIdx = i
        attr.OverrideType = GameEnum.EAttrDescType.EquipTextTwo
        table.insert(ret, attr)
    end

    return ret
end

--- 从表数据中创建基础数据
---@return ItemAttrData[]
function ItemEquipAttrFactory:_parseBaseAttrFromTable(equipConfig)
    if nil == equipConfig then
        return {}
    end

    local ret = {}
    for i = 1, equipConfig.BaseAttributes.Length do
        local singleAttrConf = equipConfig.BaseAttributes[i - 1]
        local type = singleAttrConf[0]
        local id = singleAttrConf[1]
        local val = singleAttrConf[2]
        local randomType = singleAttrConf[3]
        local attr = self:_createItemAttr(type, id, val, 0, nil)
        attr.RandomType = randomType
        attr.AttrIdx = i
        table.insert(ret, attr)
    end

    return ret
end

--- 从表数据中创建特技属性
---@param equipConfig EquipTable
---@return ItemAttrData[]
function ItemEquipAttrFactory:_parseSchoolAttrFromTable(equipConfig)
    if nil == equipConfig then
        return {}
    end

    local ret = {}
    local paramTableList = string.ro_split(equipConfig.EntryAttributeOne, '|')
    for i = 1, #paramTableList do
        local clientData = self:_parseStrToAttr(paramTableList[i])
        clientData.EquipTextID = equipConfig.EquipText
        clientData.AttrIdx = i
        clientData.OverrideType = GameEnum.EAttrDescType.EquipTextOne
        table.insert(ret, clientData)
    end

    return ret
end

--- 获取稀有部分的随机属性
function ItemEquipAttrFactory:_getAttrRareRate(equipLv)
    local lvMatrix = MGlobalConfig:GetVectorSequence("EquipRareValue")
    for i = 0, lvMatrix.Length - 1 do
        local startLv = tonumber(lvMatrix[i][0])
        local endLv = tonumber(lvMatrix[i][1])
        local rate = tonumber(lvMatrix[i][2])
        if startLv <= equipLv and endLv > equipLv then
            return self:_convertRate(rate)
        end
    end

    return 1
end

--- 根据配置得字符串类型来创建道具属性
---@param str string
---@return ItemAttrData
function ItemEquipAttrFactory:_parseStrToAttr(str)
    if nil == str then
        logError("[ItemAttrFactory] invalid param")
        return nil
    end

    local C_MIN_ATTR_STR_LENGTH = 4
    local strList = string.ro_split(str, '=')
    if C_MIN_ATTR_STR_LENGTH > #strList then
        logError("[[ItemAttrFactory] invalid str length: " .. tostring(#strList))
        return nil
    end

    local attrType = tonumber(strList[1])
    if GameEnum.EItemAttrType.Attr == attrType then
        local attrID = tonumber((strList[2]))
        local value = tonumber((strList[3]))
        local randType = tonumber((strList[4]))
        local ret = self:_createItemAttr(attrType, attrID, value, 0, nil)
        ret.RandomType = randType
        return ret
    elseif GameEnum.EItemAttrType.TempAttr == attrType then
        local attrID = self:_getBuffSubAttrID((strList[2]))
        local value = tonumber((strList[3]))
        local randType = tonumber((strList[4]))
        local ret = self:_createItemAttr(attrType, attrID, value, 0, nil)
        ret.RandomType = randType
        return ret
    elseif GameEnum.EItemAttrType.Buff == attrType then
        local attrID = tonumber((strList[2]))
        if C_MIN_ATTR_STR_LENGTH == #strList then
            local value = tonumber((strList[3]))
            local randType = tonumber((strList[4]))
            local ret = self:_createItemAttr(attrType, attrID, value, 0, nil)
            ret.RandomType = randType
            return ret
        else
            local params = {}
            for j = 3, #strList, 3 do
                local strKey = strList[j]
                local paramKey = self:_getBuffSubAttrID(strKey)
                local singleRandomType = tonumber(strList[j + 1])
                local singleParamValue = tonumber(strList[j + 2])
                local paramData = Data.ItemAttrExtraParam.new(paramKey, singleParamValue, singleRandomType, strKey)
                table.insert(params, paramData)
            end

            local ret = self:_createItemAttr(attrType, attrID, 0, 0, nil)
            ret.ExtraParam = params
            return ret
        end
    end

    logError("[ItemAttrFactory] invalid attr type: " .. tostring(attrType))
    return nil
end

--- 通过字符串获取数字ID
function ItemEquipAttrFactory:_getBuffSubAttrID(str)
    local ret = TableUtil.GetEquipMapStringInt().GetRowByParamName(str)
    return ret.Value
end

--- 因为代码提示的原因在这里添加一个函数
---@return ItemAttrData
function ItemEquipAttrFactory:_createItemAttr(type, id, value, tableID, extraParam)
    ---@type ItemAttrData
    local ret = Data.ItemAttrData.new(type, id, value, tableID, extraParam)
    return ret
end

return ItemEquipAttrFactory