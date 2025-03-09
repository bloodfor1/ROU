-- 附魔继承相关的数据管理
module("ModuleMgr.EnchantInheritMgr", package.seeall)

---@type ItemData
oldEquip = nil

---@type ItemData
newEquip = nil

local l_netMgr = MgrMgr:GetMgr("EnchantInheritNetMgr")
local l_playerEquipFilter = MgrMgr:GetMgr("PlayerItemFilter")
local l_enchantExtractMgr = MgrMgr:GetMgr("EnchantmentExtractMgr")

function OnReconnected()
    UIMgr:DeActiveUI(UI.CtrlNames.Dialog)
    UIMgr:DeActiveUI(UI.CtrlNames.EquipAssistantBG)
end

---@param itemData ItemData
function SetOldEquip(itemData)
    oldEquip = itemData
end

---@param itemData ItemData
function SetNewEquip(itemData)
    newEquip = itemData
end

---@return ItemData
function GetOldEquip()
    return oldEquip
end

---@return ItemData
function GetNewEquip()
    return newEquip
end

--- 获取抚摸继承消耗的材料
---@return ItemTemplateParam[], boolean
function GetMat()
    if nil == oldEquip or nil == newEquip then
        return {}, false
    end

    local attrs = oldEquip:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    if 0 >= #attrs then
        return {}, false
    end

    local highestBuffLv = 0
    for i = 1, #attrs do
        local singleAttr = attrs[i]
        if GameEnum.EItemAttrType.Buff == singleAttr.AttrType then
            local singleBuffConfig = TableUtil.GetBuffTable().GetRowById(singleAttr.AttrID)
            if nil ~= singleBuffConfig then
                if singleBuffConfig.Level > highestBuffLv then
                    highestBuffLv = singleBuffConfig.Level
                end
            end
        end
    end

    if 0 >= highestBuffLv then
        logError("[EnchantInherit] invalid attr state")
        return {}, false
    end

    local l_tableInfo = l_enchantExtractMgr.GetEnchantRebornTableInfo(newEquip)
    if nil == l_tableInfo then
        return {}, false
    end

    local consumeList = nil
    if oldEquip:GetEquipTableLv() == newEquip:GetEquipTableLv()
            and oldEquip.EquipConfig.EquipId == oldEquip.EquipConfig.EquipId then
        consumeList = l_tableInfo.EqualInheritConsume
    else
        consumeList = l_tableInfo.InheritConsume
    end

    local ret = {}
    for i = 0, consumeList.Length - 1 do
        local singleConfig = consumeList[i]
        if singleConfig[0] == highestBuffLv then
            ---@type ItemTemplateParam
            local singleConsumeParam = {
                ID = singleConfig[1],
                RequireCount = singleConfig[2],
                IsShowRequire = true,
                IsShowCount = false
            }

            table.insert(ret, singleConsumeParam)
        end
    end

    return ret, true
end

function GetHintTableText()
    return Common.Utils.Lang("ENCHANT_INHERIT_HINT")
end

-- 获取提示内容
function GetHintText()
    return ""
end

-- 判断是否应该显示属性
-- 属性显示的条件为同时有封魔石和装备
function IsAttrNeeded()
    return nil ~= oldEquip and nil ~= newEquip
end

function ReqInherit()
    if nil == oldEquip then
        local l_str = Lang("ENCHANT_INHERIT_NEED_STONE")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end

    if nil == newEquip then
        local l_str = Lang("ENCHANT_INHERIT_NEED_EQUIP")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end

    local l_stoneUID = oldEquip.UID
    local l_equipUID = newEquip.UID
    local sendReq = function()
        l_netMgr.ReqEnchantInherit(l_equipUID, l_stoneUID)
    end

    if _isEquipEnchanted(newEquip, true) then
        local togType = GameEnum.EDialogToggleType.NoTog
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("C_EQUIP_ENCHANT_OVERRIDE_CONFIRM"), sendReq, nil, nil, togType, "EquipAssistant_DealWithTips", nil, nil, nil, nil, nil, "YES")
    else
        sendReq()
    end
end

--- 获取封魔石列表
---@return ItemData[]
function GetNewEquipTable()
    local ret = nil
    local types = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Bag,
    }

    -- 1 判断当前状态是否有装备
    -- 2 如果没有装备，就获取全量可以附魔的装备
    -- 3 如果有装备，就获取装备等级，装备等级，装备部位，跟据等级和部位来获取过滤指定装备
    if nil == oldEquip then
        local condition = { Cond = l_playerEquipFilter.EquipCanBeEnchanted, Param = true }
        local condition_1 = { Cond = _isEquipShopType, Param = false }
        local conditions = { condition, condition_1 }
        ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    else
        local l_stoneRequireLv = oldEquip:GetEquipTableLv()
        local l_rowEquipTable = oldEquip.EquipConfig
        if nil == l_rowEquipTable then
            logError("[EquipFilter] equip id:" .. l_equipID .. " not found")
            return {}
        end

        local l_stonePart = l_rowEquipTable.EquipId
        local l_condMap = {
            { Cond = l_playerEquipFilter.EquipCanBeEnchanted, Param = true },
            { Cond = l_playerEquipFilter.IsEquipInCertainSlot, Param = l_stonePart },
            { Cond = _isEquipShopType, Param = false },
            { Cond = _isEquipLvAbove, Param = l_stoneRequireLv },
            { Cond = _notUid, Param = oldEquip.UID },
        }

        ret = Data.BagApi:GetItemsByTypesAndConds(types, l_condMap)
    end

    return ret
end

-- 获取封魔石属性
-- 这个地方返回的是服务器数据
---@return ItemAttrData[]
function GetOldEquipAttrs()
    if nil == oldEquip then
        return {}
    end

    local ret = oldEquip:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    return ret
end

-- SelectEquip
-- 这边是继承页面的滚动区域调用的方法，类似一个接口的做法，参数为propInfo
-- 这边会是一个比较复杂的判断
function GetSelectEquips(data)
    return _getEquipsByConditions(data, newEquip)
end

---@param data ItemData[]
---@param stoneInstance ItemData
function _getEquipsByConditions(data, stoneInstance)
    -- 1 如果没有新装备，没有旧装备；显示附魔且含有buff的装备
    -- 2 如果有新装备，没有旧装备；显示满足封新装备部位和等级且满足条件的装备
    -- 3 如果有旧装备，没有新装备，同1
    -- 4 如果有新装备，又有旧装备，同2
    local l_condMap = {}
    table.insert(l_condMap, { cond = _isEquipShopType, param = false })
    table.insert(l_condMap, { cond = _isAbleToEnchant, param = true })
    table.insert(l_condMap, { cond = _equipEnchantAttrCanBeInherited, param = true })
    if nil ~= stoneInstance then
        table.insert(l_condMap, { cond = _isEquipLvBelow, param = stoneInstance:GetEquipTableLv() })
        table.insert(l_condMap, { cond = l_playerEquipFilter.IsEquipInCertainSlot, param = stoneInstance.EquipConfig.EquipId })
    end

    local l_ret = l_playerEquipFilter.FiltrateItemData(data, l_condMap)
    return l_ret
end

function GetNoneEquipText()
    return Common.Utils.Lang("C_NO_SAME_TYPE_EQUIP_FOR_ENCHANT")
end

--- 以下是道具筛选条件 ---
---@param itemData ItemData
function IsEquipShopType(itemData)
    return _isEquipShopType(itemData, nil)
end

---@param itemData ItemData
function IsEquipEnchanted(itemData)
    return _isEquipEnchanted(itemData, true)
end

---@param itemData ItemData
function IsEquipAbleToEnchant(itemData)
    return _isAbleToEnchant(itemData)
end

---@param itemData ItemData
function _isAbleToEnchant(itemData)
    if nil == itemData then
        return false
    end

    if nil == itemData.EquipConfig then
        return false
    end

    return 0 ~= itemData.EquipConfig.EnchantingId
end

---@param itemData ItemData
function _isEquipShopType(itemData, param)
    if nil == itemData then
        return false
    end

    if nil == itemData.EquipConfig then
        return false
    end

    return GameEnum.EEquipSourceType.Shop ~= itemData.EquipConfig.TypeId
end

-- 判断装备是不是被附魔了
---@param itemData ItemData
function _isEquipEnchanted(itemData, param)
    if nil == itemData or nil == param then
        return false
    end

    local attrCount = #itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    local enchanted = 0 < attrCount
    return enchanted == param
end

---@param itemData ItemData
function _isEquipLvAbove(itemData, lv)
    if nil == itemData or nil == lv then
        return false
    end

    local locLv = itemData:GetEquipTableLv()
    return locLv >= lv
end

---@param itemData ItemData
function _isEquipLvBelow(itemData, lv)
    if nil == itemData or nil == lv then
        return false
    end

    local locLv = itemData:GetEquipTableLv()
    return locLv <= lv
end

-- 判断装备是否已经被提炼过
---@param itemData ItemData
function _hasEquipBeenReborn(itemData, param)
    if nil == itemData or nil == param then
        return false
    end

    return itemData.EnchantExtracted == param
end

--- 判断一个装备是否能被附魔
---@param itemData ItemData
function _equipEnchantAttrCanBeInherited(itemData)
    if nil == itemData then
        return false
    end

    local attrs = itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    for i = 1, #attrs do
        local singleAttr = attrs[i]
        if GameEnum.EItemAttrType.Buff == singleAttr.AttrType then
            return true
        end
    end

    return false
end

---@param itemData ItemData
---@param uid uint64
function _notUid(itemData, uid)
    if nil == itemData then
        return false
    end

    local ret = not uint64.equals(itemData.UID, uid)
    return ret
end

return ModuleMgr.EnchantInheritMgr