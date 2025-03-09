--- 根据PB数据Item创建itemData的工厂
require "Data/Model/ItemData"
require "Data/Model/ItemAttrData"
module("Data", package.seeall)

ItemDataItemPBFactory = class("ItemDataItemPBFactory")

local itemAttrModuleType = GameEnum.EItemAttrModuleType
local C_NUMBER_PERCENTAGE_VALUE = 0.01

function ItemDataItemPBFactory:ctor()
    -- do nothing
end

--- 重构前的道具协议，由于绝大多数协议目前没有替换成新的数据，所以保留这个接口
---@param itemPbData Item
---@param ret ItemData
---@return ItemData
function ItemDataItemPBFactory:Init(itemPbData, ret)
    if nil == itemPbData then
        logError("[ItemData] pb data param got nil, init failed")
        return
    end

    ret.UID = itemPbData.uid
    ret.TID = itemPbData.ItemID
    ret.IsBind = itemPbData.is_bind
    ret.ItemCount = ToInt64(itemPbData.ItemCount)
    ret.Price = ToInt64(itemPbData.avg_price)
    ret.CreateTime = itemPbData.create_time
    if nil == itemPbData.extra_data then
        ret.GuildRedPacketValue = 0
    else
        ret.GuildRedPacketValue = itemPbData.extra_data.value32
    end

    self:_initConfigData(ret)
    if nil == ret.ItemConfig then
        logError("[itemLocalFactory] fatal error, real item create failed, tid: " .. tostring(ret.TID) .. ", return nil")
        return nil
    end

    ret.Damaged = self:_getDamageData(itemPbData)
    ret.AttrSet = self:_createClientData(itemPbData, ret)
    return ret
end

---@param itemData ItemData
function ItemDataItemPBFactory:_initConfigData(itemData)
    itemData.ItemConfig = TableUtil.GetItemTable().GetRowByItemID(itemData.TID, false)
    itemData.ItemFunctionConfig = TableUtil.GetItemFunctionTable().GetRowByItemId(itemData.TID, true)
    itemData.EquipConfig = TableUtil.GetEquipTable().GetRowById(itemData.TID, true)
    if nil ~= itemData.ItemConfig then
        itemData.ItemConfigLv = itemData.ItemConfig.LevelLimit[0]
    end
end

---@param itemPbData Item
---@return boolean
function ItemDataItemPBFactory:_getDamageData(itemPbData)
    if nil == itemPbData or nil == itemPbData.equip_component then
        return false
    end

    return itemPbData.equip_component.is_disrepair
end

--- 内部方法，为道具创建属性映射表
--- 为什么要转一层：因为服务器的PB数据不是所有数据客户端都需要
--- 服务器数据格式不统一，不好处理，在这个类当中把格式统一一下，外部直接调用，不再需要外部进行转换
---@param itemPbData Item
---@param itemData ItemData
---@return table<number, ItemAttrData[][]>
function ItemDataItemPBFactory:_createClientData(itemPbData, itemData)
    if nil == itemPbData then
        return {}
    end

    if nil == itemData.EquipConfig then
        itemData.DeviceItemDuration = itemPbData.device_component.dura
        return self:_createItemAttrSet(itemPbData)
    else
        itemData.DeviceItemDuration = itemPbData.equip_component.device_info.dura
        itemData.RefineLv = itemPbData.equip_component.refine_info.level
        itemData.RefineSealLv = itemPbData.equip_component.refine_info.seal_level
        itemData.RefineUnlockExp = itemPbData.equip_component.refine_info.cur_unlock_exp
        itemData.EnchantExtracted = itemPbData.equip_component.enchant_info.has_reborn
        local enchantTimesNormal = itemPbData.equip_component.enchant_info.junior_record.enchant_times
        local enchantTimesHigh = itemPbData.equip_component.enchant_info.senior_record.enchant_times
        itemData.EnchantTimesTotal = enchantTimesNormal + enchantTimesHigh
        local additionalRate = itemPbData.equip_component.refine_info.attached_success_pro
        if nil ~= additionalRate then
            itemData.RefineAdditionalRate = additionalRate * C_NUMBER_PERCENTAGE_VALUE
        end

        return self:_createEquipAttrSet(itemPbData.equip_component, itemData)
    end
end

--- 如果是道具，这个时候没有equipComp，但是这个道具可能是封魔石或者是置换器，也是有属性
--- 如果是卡片，同样也需要显示属性
---@param itemPbData Item
---@return table<string, ItemAttrData[]>
function ItemDataItemPBFactory:_createItemAttrSet(itemPbData)
    local deviceAttrSet = self:_parseItemDeviceInfoData(itemPbData.device_component)
    local enchantAttrSet = self:_parseItemEnchantInfoData(itemPbData.reborn_info)
    local cardAttrSet = self:_parseCardItemAttr(itemPbData.ItemID)

    local ret = {}
    ret[itemAttrModuleType.Enchant] = { [1] = enchantAttrSet }
    ret[itemAttrModuleType.Device] = { [1] = deviceAttrSet }
    ret[itemAttrModuleType.Base] = { [1] = cardAttrSet }
    return ret
end

--- 如果是装备，这个时候是有equipComp的，就直接从这个数据当中获取，不再从给道具的数据中获取
---@param equipComp EquipComponent
---@param itemData ItemData
---@return table<string, ItemAttrData[]>
function ItemDataItemPBFactory:_createEquipAttrSet(equipComp, itemData)
    local deviceAttrSet = self:_parseEquipDeviceInfo(equipComp.device_info)
    local enchantAttrSet, enchantCacheAttr, enchantCacheHighAttr = self:_parseEquipEnchantInfoData(equipComp.enchant_info)
    local baseAttrSet = self:_parseBaseAttrInfo(equipComp)
    local schoolAttrSet = self:_parsePlayerSchoolAttrInfo(equipComp)
    local holeDataSet = self:_parseCardHoleInfo(equipComp.hole_info, itemData.EquipConfig)
    --- 策划说精炼的position匹配这个RefineBaseAttributes
    local refineAttrSet = self:_parseRefineInfo(equipComp.refine_info.level, itemData.EquipConfig.RefineBaseAttributes)

    local ret = {}
    ret[itemAttrModuleType.Enchant] = { [1] = enchantAttrSet }
    ret[itemAttrModuleType.EnchantCache] = { [1] = enchantCacheAttr }
    ret[itemAttrModuleType.EnchantCacheHigh] = { [1] = enchantCacheHighAttr }
    ret[itemAttrModuleType.Device] = { [1] = deviceAttrSet }
    ret[itemAttrModuleType.Base] = { [1] = baseAttrSet }
    ret[itemAttrModuleType.School] = { [1] = schoolAttrSet }
    ret[itemAttrModuleType.Refine] = { [1] = refineAttrSet }
    ret[itemAttrModuleType.Hole] = {}
    ret[itemAttrModuleType.HoleCache] = {}
    ret[itemAttrModuleType.Card] = {}
    ret[itemAttrModuleType.CardAttr] = {}

    for i = 1, #holeDataSet do
        ret[itemAttrModuleType.Card][i] = holeDataSet[i].Card
        ret[itemAttrModuleType.CardAttr][i] = holeDataSet[i].CardAttr
        ret[itemAttrModuleType.Hole][i] = holeDataSet[i].HoleAttr
        ret[itemAttrModuleType.HoleCache][i] = holeDataSet[i].HoleCacheAttr
    end

    return ret
end

---@param deviceInfo DeviceComponent
---@return ItemAttrData[]
function ItemDataItemPBFactory:_parseItemDeviceInfoData(deviceInfo)
    if nil == deviceInfo then
        logError("[ItemData] DeviceInfo info got nil, please check")
        return {}
    end

    local ret = {}
    local entries = deviceInfo.entrys
    for i = 1, #entries do
        local singleAttr = entries[i]
        local attr = Data.ItemAttrData.new(singleAttr.type, singleAttr.id, singleAttr.val)
        table.insert(ret, attr)
    end

    return ret
end

--- 道具用的解析数据，封魔石
---@param enchantInfo RebornInfo
---@return ItemAttrData[]
function ItemDataItemPBFactory:_parseItemEnchantInfoData(enchantInfo)
    if nil == enchantInfo then
        logError("[ItemData] Enchant info got nil, please check")
        return {}
    end

    return self:_filtrateEnchantAttr(enchantInfo.entrys)
end

--- 获取卡片作为道具需要显示的属性
---@param tid number
---@return ItemAttrData[]
function ItemDataItemPBFactory:_parseCardItemAttr(tid)
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

---@param deviceInfo DeviceInfo
---@return ItemAttrData[]
function ItemDataItemPBFactory:_parseEquipDeviceInfo(deviceInfo)
    if nil == deviceInfo then
        logError("[ItemData] DeviceInfo info got nil, please check")
        return {}
    end

    local ret = {}
    local attrBlock = deviceInfo.attr_block
    for i = 1, #attrBlock do
        local singleBlock = attrBlock[i]
        for j = 1, #singleBlock.attr_list do
            local singleAttrData = singleBlock.attr_list[j]
            local singleAttr = Data.ItemAttrData.new(singleAttrData.type, singleAttrData.id, singleAttrData.val)
            table.insert(ret, singleAttr)
        end
    end

    return ret
end

--- 装备用的解析数据
---@param enchantInfo EnchantInfo
---@return ItemAttrData[], ItemAttrData[], ItemAttrData[]
function ItemDataItemPBFactory:_parseEquipEnchantInfoData(enchantInfo)
    if nil == enchantInfo then
        logError("[ItemData] Enchant info got nil, please check")
        return {}
    end

    local enchantData = self:_filtrateEnchantAttr(enchantInfo.entrys)
    local enchantCacheData = self:_filtrateEnchantAttr(enchantInfo.cache_entrys)
    local enchantCacheHighData = self:_filtrateEnchantAttr(enchantInfo.cache_entrys_high)
    return enchantData, enchantCacheData, enchantCacheHighData
end

--- 解析基础属性数据
--- 这个数据是PB的数据，不能用来创建假数据
---@param equipComp EquipComponent
---@return ItemAttrData[]
function ItemDataItemPBFactory:_parseBaseAttrInfo(equipComp)
    if nil == equipComp then
        logError("[ItemData] equip Comp got nil")
        return {}
    end

    local baseAttr = equipComp.basic_attr.attr_block
    local ret = {}
    for i = 1, #baseAttr do
        for j = 1, #baseAttr[i].attr_list do
            local singleAttr = baseAttr[i].attr_list[j]
            local realAttr = Data.ItemAttrData.new(singleAttr.type, singleAttr.id, singleAttr.val)
            table.insert(ret, realAttr)
        end
    end

    return ret
end

--- 解析流派数据
---@param equipComp EquipComponent
---@return ItemAttrData[]
function ItemDataItemPBFactory:_parsePlayerSchoolAttrInfo(equipComp)
    if nil == equipComp then
        logError("[ItemData] equip Comp got nil")
        return {}
    end

    local baseAttr = equipComp.entry_attr.attr_block
    local ret = {}
    for i = 1, #baseAttr do
        for j = 1, #baseAttr[i].attr_list do
            local singleAttr = baseAttr[i].attr_list[j]
            local realAttr = Data.ItemAttrData.new(singleAttr.type, singleAttr.id, singleAttr.val, nil, singleAttr.extra_param)
            table.insert(ret, realAttr)
        end
    end

    return ret
end

--- 附魔属性因为颜色的关系，tableID是需要的
---@param entryBlock EnchantEntryBlock[]
---@return ItemAttrData[]
function ItemDataItemPBFactory:_filtrateEnchantAttr(entryBlock)
    if nil == entryBlock then
        logError("[ItemData] entry data got nil")
        return {}
    end

    local ret = {}
    for i = 1, #entryBlock do
        local singleAttr = entryBlock[i]
        if 0 ~= singleAttr.table_id then
            local attr = Data.ItemAttrData.new(
                    singleAttr.entrys[1].type,
                    singleAttr.entrys[1].id,
                    singleAttr.entrys[1].val,
                    singleAttr.table_id)
            table.insert(ret, attr)
        end
    end

    return ret
end

--- 解析打洞和插卡属性数据
--- 这个地方返回的是3组数据 打洞显示数据，打洞缓存属性数据，卡片数据
---@param cardHoleInfo HoleInfo
---@param equipConfig EquipTable
---@return HoleDataSet[]
function ItemDataItemPBFactory:_parseCardHoleInfo(cardHoleInfo, equipConfig)
    --- 这个判断常规情况是不会进来的
    if nil == cardHoleInfo then
        local emptyData = {
            HoleAttr = {},
            HoleCacheAttr = {},
            Card = {},
            CardAttr = {},
        }

        local ret = {}
        for i = 1, equipConfig.HoleNum do
            table.insert(ret, emptyData)
        end

        return ret
    end

    local ret = {}
    for i = 1, equipConfig.HoleNum do
        local holeAttrs = {}
        local cacheAttrs = {}
        local holeInfo = cardHoleInfo.open_hole[i]
        if nil == holeInfo then
            local data = {
                HoleAttr = {},
                HoleCacheAttr = {},
                Card = {},
                CardAttr = {}
            }

            table.insert(ret, data)
        else
            local cardAttrSet = self:_parseCardItemAttr(holeInfo.card_id)
            local cardAttrData = nil
            if 0 < #cardAttrSet then
                cardAttrData = Data.ItemAttrData.new(GameEnum.EItemAttrType.Card, holeInfo.card_id, 0, holeInfo.table_id)
            end

            for j = 1, #holeInfo.entrys do
                local singleEntryAttr = holeInfo.entrys[j]
                local singleEntry = Data.ItemAttrData.new(singleEntryAttr.type, singleEntryAttr.id, singleEntryAttr.val, holeInfo.table_id)
                table.insert(holeAttrs, singleEntry)
            end

            for k = 1, #holeInfo.cache_entrys do
                local singleEntryAttr = holeInfo.cache_entrys[k]
                local singleEntry = Data.ItemAttrData.new(singleEntryAttr.type, singleEntryAttr.id, singleEntryAttr.val, holeInfo.cache_table_id)
                table.insert(cacheAttrs, singleEntry)
            end

            local cardTable = nil
            if nil == cardAttrData then
                cardTable = {}
            else
                cardTable = { cardAttrData }
            end

            ---@class HoleDataSet
            local data = {
                HoleAttr = holeAttrs,
                HoleCacheAttr = cacheAttrs,
                Card = cardTable,
                CardAttr = cardAttrSet
            }

            table.insert(ret, data)
        end
    end

    return ret
end

--- 解析精炼的数据
--- 精炼服务器是不传递参数的，精炼的属性完全是靠读表获取的
---@param refineLv number
---@param equipPos number
---@return ItemAttrData[]
function ItemDataItemPBFactory:_parseRefineInfo(refineLv, equipPos)
    if nil == refineLv or nil == equipPos then
        return {}
    end

    local equipRefineTable = TableUtil.GetEquipRefineTable().GetTable()
    local ret = {}
    for i = 1, #equipRefineTable do
        local tableData = equipRefineTable[i]
        if refineLv == tableData.RefineLevel and equipPos == tableData.Position then
            local refineAttrData = tableData.RefineAttr
            for j = 0, refineAttrData.Length - 1 do
                local attrData = Data.ItemAttrData.new(refineAttrData[j][0], refineAttrData[j][1], refineAttrData[j][2])
                table.insert(ret, attrData)
            end

            return ret
        end
    end

    return {}
end

return Data.ItemDataItemPBFactory