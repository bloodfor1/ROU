--- 根据TID来创建道具数据的工厂
require "Data/Model/ItemData"
require "Data/Model/ItemAttrData"
module("Data", package.seeall)

ItemDataLocalFactory = class("ItemDataLocalFactory")

local itemAttrModuleType = GameEnum.EItemAttrModuleType

function ItemDataLocalFactory:ctor()
    -- do nothing
end

--- 创建假数据用的，值要提供tid即可
--- 这个接口只是提供一个假的数据结构吗，并且设置好属性数据和表数据，具体需要什么东西外部自己去修改
---@param tid number
---@param ret ItemData
---@return ItemData
function ItemDataLocalFactory:InitWithTid(tid, ret)
    if nil == tid then
        logError("[ItemData] tid got nil, init failed")
        return nil
    end

    ret.TID = tid
    ret.ItemCount = ToInt64(1)
    ret.CreateTime = 0
    self:_initConfigData(ret)
    if nil == ret.ItemConfig then
        logError("[itemLocalFactory] invalid item tid: " .. tostring(tid) .. ", return nil")
        return nil
    end

    ret.AttrSet = self:_createLocalAttrData(ret.ItemConfig, ret.EquipConfig, ret)
    return ret
end

--- 只有本地创建的数据会判断是否需要产生父ID，服务器给的全部是真实ID
---@param itemData ItemData
function ItemDataLocalFactory:_initConfigData(itemData)
    local currentItemID = itemData.TID
    local parentItemID = currentItemID

    ---@type ItemTable
    local itemParentConfig = nil
    ---@type ItemTable
    local itemConfig = TableUtil.GetItemTable().GetRowByItemID(currentItemID, false)
    if nil == itemConfig then
        logError("[ItemLocalFactory] invalid item id: " .. tostring(currentItemID))
        return
    end

    --- 如果发现是套了一层的，这个时候要修正道具本身的tid
    if 0 < itemConfig.ParentID then
        parentItemID = itemConfig.ParentID
        itemParentConfig = itemConfig
        itemConfig = TableUtil.GetItemTable().GetRowByItemID(parentItemID, false)
        itemData.TID = parentItemID
    end

    itemData.ParentItemConfig = itemParentConfig
    itemData.ItemConfig = itemConfig
    itemData.ItemFunctionConfig = TableUtil.GetItemFunctionTable().GetRowByItemId(parentItemID, true)
    itemData.EquipConfig = TableUtil.GetEquipTable().GetRowById(parentItemID, true)
    if nil ~= itemData.ItemConfig then
        itemData.ItemConfigLv = itemData.ItemConfig.LevelLimit[0]
    end
end

---@param itemConfig ItemTable
---@param itemData ItemData
---@param equipConfig EquipTable
---@return table<string, ItemAttrData[]>
function ItemDataLocalFactory:_createLocalAttrData(itemConfig, equipConfig, itemData)
    if nil == itemConfig then
        logError("[ItemData] itemConfig id: " .. tostring(itemData.TID) .. " got nil")
        return {}
    end

    -- 如果是装备，这个时候不可能是卡片
    -- 客户端本地生成的装备属性要默认向下取整
    -- 极品属性会走随机逻辑，常规属性直接读表
    if nil ~= equipConfig then
        local baseAttrSet = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.Base, GameEnum.EAttrValueState.Normal, equipConfig, itemData:GetEquipTableLv())
        local styleAttrSet = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.School, GameEnum.EAttrValueState.Normal, equipConfig, itemData:GetEquipTableLv())
        local baseMaxAttrSet = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.Base, GameEnum.EAttrValueState.Max, equipConfig, itemData:GetEquipTableLv())
        local schoolMaxAttrSet = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.School, GameEnum.EAttrValueState.Max, equipConfig, itemData:GetEquipTableLv())
        --local rareBase = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.Base, GameEnum.EAttrValueState.Rare, equipConfig, itemData:GetEquipTableLv())
        --local rareStyle = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.School, GameEnum.EAttrValueState.Rare, equipConfig, itemData:GetEquipTableLv())
        local ret = {}
        ret[itemAttrModuleType.Base] = { [1] = baseAttrSet }
        ret[itemAttrModuleType.School] = { [1] = styleAttrSet }
        ret[itemAttrModuleType.MaxBase] = { [1] = baseMaxAttrSet }
        ret[itemAttrModuleType.MaxStyle] = { [1] = schoolMaxAttrSet }
        --ret[itemAttrModuleType.RareBase] = { [1] = rareBase }
        --ret[itemAttrModuleType.RareStyle] = { [1] = rareStyle }
        return ret
    end

    -- 如果是卡牌，则要显示属性
    if GameEnum.EItemType.Card == itemConfig.TypeTab then
        local retCardSet = {}
        local cardAttrSet = self:_parseCardItemAttr(itemData.TID)
        retCardSet[itemAttrModuleType.Base] = { [1] = cardAttrSet }
        return retCardSet
    end

    if GameEnum.EItemType.Displacer == itemConfig.TypeTab then
        local retDeviceAttr = {}
        local deviceAttrList, duration = self:_parseDeviceAttr(itemData.TID)
        if nil == deviceAttrList then
            return {}
        end

        itemData.DeviceItemDuration = duration
        retDeviceAttr[itemAttrModuleType.Device] = { [1] = deviceAttrList }
        return retDeviceAttr
    end

    return {}
end

--- 获取卡片作为道具需要显示的属性
---@param tid number
---@return ItemAttrData[]
function ItemDataLocalFactory:_parseCardItemAttr(tid)
    if nil == tid then
        return {}
    end

    local cardTableInfo = TableUtil.GetEquipCardTable().GetRowByID(tid, true)
    if nil == cardTableInfo then
        return {}
    end

    local ret = {}
    for i = 0, cardTableInfo.CardAttributes.Length - 1 do
        local attr = Data.ItemAttrData.new(cardTableInfo.CardAttributes[i][0], cardTableInfo.CardAttributes[i][1], cardTableInfo.CardAttributes[i][2])
        table.insert(ret, attr)
    end

    return ret
end

--- 解析置换器属性
---@return ItemAttrData[], number
function ItemDataLocalFactory:_parseDeviceAttr(id)
    if nil == id then
        logError("[itemLocalFactory] invalid param")
        return nil
    end

    local targetConfig = TableUtil.GetDeviceDetailTable().GetRowByItemID(id, true)
    if nil == targetConfig then
        return nil
    end

    local ret = {}
    local retDuration = targetConfig.Durability
    for i = 0, targetConfig.BuffGroup.Length - 1 do
        local singleBuffID = targetConfig.BuffGroup[i]
        local singleAttr = Data.ItemAttrData.new(GameEnum.EItemAttrType.Buff, singleBuffID, 0, 0, nil)
        table.insert(ret, singleAttr)
    end

    return ret, retDuration
end

return Data.ItemDataLocalFactory