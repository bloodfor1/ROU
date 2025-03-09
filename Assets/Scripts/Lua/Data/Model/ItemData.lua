--- 道具数据
--- 客户端定义的道具数据，用于取代原有的数据
--- 不再使用服务器PB数据，这样如果PB数据发生修改，客户端只需要调整转移协议的部分即可
--- 属性数据是分页的，为了应对多个孔的问题，装备孔如果有属性表示已经开孔，否则表示未开孔

module("Data", package.seeall)

---@class ItemData
ItemData = class("ItemData")

--- 除了这个类当中定义的字段和方法以外，外界不可以随意添加
C_VALID_NAME_MAP = {
    ["AttrSet"] = 1,
    ["ParentItemConfig"] = 1,
    ["ItemConfig"] = 1,
    ["EquipConfig"] = 1,
    ["ItemFunctionConfig"] = 1,
}

C_DEFAULT_SLOT_ID = -1

function newIndex(table, key, value)
    if not C_VALID_NAME_MAP[key] then
        error("[ItemData] try to newindex key: " .. tostring(key) .. " value: " .. tostring(value))
        return
    end

    rawset(table, key, value)
end

function index(table, key)
    local ret = rawget(table, key)
    if nil ~= ret then
        return ret
    end

    ret = rawget(table.class, key)
    if nil ~= ret then
        return ret
    end

    if C_VALID_NAME_MAP[key] then
        return nil
    end

    error("[ItemData] try to index key: " .. tostring(key))
    return nil
end

---数据列表
---@return ItemData
function ItemData:ctor()
    local mt = getmetatable(self)
    mt.__newindex = nil
    mt.__index = nil

    self.UID = 0
    self.TID = 0
    ---@type int64
    self.ItemCount = ToInt64(0)
    --- 平均价格
    ---@type int64
    self.Price = ToInt64(0)
    self.EnchantGrade = 0
    self.EnchantTimesTotal = 0
    self.DeviceItemDuration = 0
    self.ExpLv = 0
    self.RefineLv = 0
    self.RefineSealLv = 0
    self.RefineUnlockExp = 0
    self.CreateTime = 0
    self.GuildRedPacketValue = 0
    self.IsAuction = false
    self.IsBusiness = false
    self.IsBind = false
    self.EnchantExtracted = false
    self.Damaged = false
    -- 是否显示装备改造的星
    self.ShowReformAttrStar = false
    -- 百分数，如果是30，表示30%
    self.RefineAdditionalRate = 0
    -- 有效时间，创建时间+有效时间=失效时间
    self.EffectiveTime = 0
    self.Weight = 0
    self.WheelAttrTID = 0
    -- 道具叠加判断的bitmap
    self.ItemCollapseBitMap = 0
    --会员卡当日使用的次数
    self.CardDayUseCount = 0
    --会员卡每日总共可使用的次数
    self.CardTotalUseCount = 0
    --是否在使用中
    self.IsUsing = false
    --- 客户端类型，客户端维护的容器类型，如果需要使用服务器类型需要套自己转一层
    self.ContainerType = GameEnum.EBagContainerType.None
    --- 服务器的槽位，服务器是不变动槽位的，也没有排序功能；排序是客户端的；这个数据是调换装备用
    self.SvrSlot = C_DEFAULT_SLOT_ID
    --- 道具等级，对应itemtable当中的等级，这个写法是为了减少读表操作
    self.ItemConfigLv = 0
    --- 对于有的特殊需要排序的道具，这里会将对应的特殊排序优先级保存下来
    --- 这一个数据是只有真实道具会有的，其他道具是默认不写
    self.ItemTopId = 0

    ---@type table<number, ItemAttrData[][]>
    self.AttrSet = nil

    --- 表数据
    --- 父表配置，取名字会优先判断有没有父表，如果有则直接取父表的名字。如果没有会取子表的名字
    ---@type ItemTable
    self.ParentItemConfig = nil
    ---@type ItemTable
    self.ItemConfig = nil
    ---@type EquipTable
    self.EquipConfig = nil
    ---@type ItemFunctionTable
    self.ItemFunctionConfig = nil

    mt.__newindex = newIndex
    mt.__index = index
end

--- 重置数据
function ItemData:Reset()
    self.UID = 0
    self.TID = 0
    self.ItemCount = ToInt64(0)
    self.Price = ToInt64(0)
    self.EnchantTimesTotal = 0
    self.EnchantGrade = 0
    self.DeviceItemDuration = 0
    self.RefineLv = 0
    self.RefineSealLv = 0
    self.RefineUnlockExp = 0
    self.CreateTime = 0
    self.GuildRedPacketValue = 0
    self.ItemCollapseBitMap = 0
    --- 如果同步下来的道具是经验，这个时候会用到这个字段
    self.ExpLv = 0
    self.IsBind = false
    self.EnchantExtracted = false
    self.Damaged = false
    self.IsAuction = false
    self.IsBusiness = false
    self.RefineAdditionalRate = 0
    self.ContainerType = GameEnum.EBagContainerType.None
    self.SvrSlot = C_DEFAULT_SLOT_ID
    self.AttrSet = nil
    self.ParentItemConfig = nil
    self.ItemConfig = nil
    self.EquipConfig = nil
    self.ItemFunctionConfig = nil
    self.EffectiveTime = 0
    self.Weight = 0
    self.WheelAttrTID = 0
    self.CardDayUseCount = 0
    self.CardTotalUseCount = 0
    self.IsUsing = false
    self.ItemConfigLv = 0
    self.ItemTopId = 0
end

--- 复制一个当前道具数据本身，这个函数创建的拷贝对于引用类型来说是浅拷贝
--- 但是道具更新过程中会重置，实际上完整的操作是将自己的数据交出去，后续自己的数据被重置
---@return ItemData
function ItemData:CreateCopy()
    local ret = Data.ItemData.new()
    ret.UID = self.UID
    ret.TID = self.TID
    ret.ItemCount = self.ItemCount
    ret.Price = self.Price
    ret.EnchantTimesTotal = self.EnchantTimesTotal
    ret.EnchantGrade = self.EnchantGrade
    ret.DeviceItemDuration = self.DeviceItemDuration
    ret.RefineLv = self.RefineLv
    ret.RefineSealLv = self.RefineSealLv
    ret.RefineUnlockExp = self.RefineUnlockExp
    ret.CreateTime = self.CreateTime
    ret.GuildRedPacketValue = self.GuildRedPacketValue
    ret.ItemCollapseBitMap = self.ItemCollapseBitMap
    ret.ExpLv = self.ExpLv
    ret.IsBind = self.IsBind
    ret.EnchantExtracted = self.EnchantExtracted
    ret.Damaged = self.Damaged
    ret.IsAuction = self.IsAuction
    ret.IsBusiness = self.IsBusiness
    ret.RefineAdditionalRate = self.RefineAdditionalRate
    ret.ContainerType = self.ContainerType
    ret.SvrSlot = self.SvrSlot
    ret.AttrSet = self.AttrSet
    ret.ParentItemConfig = self.ParentItemConfig
    ret.ItemConfig = self.ItemConfig
    ret.EquipConfig = self.EquipConfig
    ret.ItemFunctionConfig = self.ItemFunctionConfig
    ret.EffectiveTime = self.EffectiveTime
    ret.Weight = self.Weight
    ret.WheelAttrTID = self.WheelAttrTID
    ret.CardDayUseCount = self.CardDayUseCount
    ret.CardTotalUseCount = self.CardTotalUseCount
    ret.IsUsing = self.IsUsing
    ret.ItemConfigLv = self.ItemConfigLv
    ret.ItemTopId = self.ItemTopId
    return ret
end

--- 这里是对覆盖ID进行获取，在道具进入缓存的时候会使用
function ItemData:GetInCacheTid()
    return self.ItemConfig.ItemID
end

--- 主要用于itemTemplate上看有没有时钟
function ItemData:NeedShowTimer()
    if self.ItemConfig.TypeTab == GameEnum.EItemType.BelluzGear then
        return false
    end

    if self:_isFake() then
        if nil ~= self.ParentItemConfig then
            return 0 < self.ParentItemConfig.TimeType
        end

        return 0 < self.ItemConfig.TimeType
    end

    return 0 < self:_getRemainTime()
end

--- 获取过期时间点
---@return number
function ItemData:GetExpireTime()
    return self.EffectiveTime
end

--- 获取剩余时间
function ItemData:GetRemainingTime()
    return self:_getRemainTime()
end

function ItemData:GetItemTimeType()
    if nil ~= self.ParentItemConfig then
        return self.ParentItemConfig.TimeType
    end

    if nil ~= self.ItemConfig then
        return self.ItemConfig.TimeType
    end
end

--- 获取道具名，如果道具是嵌套有子表的，这个时候会优先返回父表的名字
--- 目前功能仅用于道具tips，不返回空，可能会返回空串
---@return string
function ItemData:GetName()
    if not self:_isFake() and nil ~= self.ItemConfig then
        return self.ItemConfig.ItemName
    end

    if nil ~= self.ParentItemConfig then
        return self.ParentItemConfig.ItemName
    end

    if nil ~= self.ItemConfig then
        return self.ItemConfig.ItemName
    end

    logError("[ItemData] invalid item data, no config, id: " .. tostring(self.TID))
    return ""
end

--- 是不是客户端本地创建的假数据
function ItemData:IsFakeItem()
    return self:_isFake()
end

--- 获取重量统一接口
function ItemData:GetWeight()
    if nil == self.ItemConfig then
        return 0
    end

    if GameEnum.EItemType.BelluzGear == self.ItemConfig.TypeTab then
        return self.Weight
    end

    return self.ItemConfig.Weight
end

---@param itemType number
---@return boolean
function ItemData:ItemMatchesType(itemType)
    if nil == itemType then
        return false
    end

    return itemType == self.ItemConfig.TypeTab
end

function ItemData:GetRemainUseCount()
    if GameEnum.EItemType.CountLimit ~= self.ItemConfig.TypeTab then
        return 0
    end

    local l_remainUseCount = 0
    local l_cardHasUseCount = self.CardTotalUseCount
    local l_itemUseCountItems = TableUtil.GetItemUseCountTable().GetRowByItemID(self.TID)
    local l_maxUseCount = 0
    if not MLuaCommonHelper.IsNull(l_itemUseCountItems) then
        l_maxUseCount = l_itemUseCountItems.MaxCount
    end

    l_remainUseCount = l_maxUseCount - l_cardHasUseCount
    return l_remainUseCount
end

--- 判断是否应该显示获取道具的特殊提示
---@return boolean
function ItemData:CanShowSpecialTips()
    if nil == self.ItemConfig then
        logError("[ItemData] item config is nil")
        return false
    end

    local genderType = GameEnum.EPlayerGender
    local showTipsType = GameEnum.EGainItemTipsType
    local C_LOCAL_VALID_TIPS_TYPE = {
        [showTipsType.SpecialTips] = 1,
        [showTipsType.HighQualityTips] = 1,
    }

    local playerGender = MPlayerInfo.IsMale and genderType.Male or genderType.Female
    local matchGender = genderType.NoGender == self.ItemConfig.SexLimit or self.ItemConfig.SexLimit == playerGender
    local showTips = nil ~= C_LOCAL_VALID_TIPS_TYPE[self.ItemConfig.AccessPrompt]

    if self.ItemConfig.TypeTab == GameEnum.EItemType.Card and self:GetExistTime() > 0 then
        return false
    end

    local result = matchGender and showTips
    return result
end

--- 获取道具的服务器容器类型
---@return number
function ItemData:GetSvrContType()
    local result = Data.BagTypeClientSvrMap:GetSvrContType(self.ContainerType)
    if Data.BagTypeClientSvrMap:GetInvalidSvrType() == result then
        logError("[ItemData] invalid container type: " .. tostring(self.ContainerType) .. " tid: " .. tostring(self.TID))
        return BagType.BAG
    end

    return result
end

--- 获取道具是不是虚拟货币，只是从容器上判断
---@return boolean
function ItemData:IsVirtualItem()
    local C_ITEM_TYPE_MAP = {
        [GameEnum.EItemType.Sample] = 1,
        [GameEnum.EItemType.Currency] = 1,
    }

    return nil ~= C_ITEM_TYPE_MAP[self.ItemConfig.TypeTab]
end

--- 获取道具的表配置等级
function ItemData:GetEquipTableLv()
    return self.ItemConfigLv
end

--- 装备是否有强化
function ItemData:EquipEnhanced()
    if nil == self.AttrSet then
        return false
    end

    local attrType = GameEnum.EItemAttrModuleType
    local C_VALID_TYPE_ARRAY = {
        attrType.Enchant,
        attrType.Refine,
        attrType.Hole,
        attrType.Card
    }

    local attrList = {}
    for i = 1, #C_VALID_TYPE_ARRAY do
        local singleType = C_VALID_TYPE_ARRAY[i]
        local singleAttrList = self:_getAttrsByType(singleType)
        table.ro_insertRange(attrList, singleAttrList)
    end

    local ret = 0 < #attrList
    return ret
end

--- 描述装备是否拥有稀有词条属性
---@return boolean
function ItemData:IsEquipRareStyle()
    if nil == self.AttrSet then
        return false
    end

    if nil == self.EquipConfig then
        return false
    end

    if 0 >= self.EquipConfig.AttrType then
        return false
    end

    ---@type ItemAttrData[]
    local currentList = {}
    local currentStyleAttrList = self:_getAttrsByType(GameEnum.EItemAttrModuleType.School)
    local currentBaseList = self:_getAttrsByType(GameEnum.EItemAttrModuleType.Base)
    table.ro_insertRange(currentList, currentBaseList)
    table.ro_insertRange(currentList, currentStyleAttrList)
    for i = 1, #currentList do
        local singleAttr = currentList[i]
        if not singleAttr.RareAttr then
            return false
        end
    end

    return true
end

--- 按照类型获取属性
---@return ItemAttrData[]
function ItemData:GetAttrsByType(type)
    return self:_getAttrsByType(type)
end

--- 判断两个东西是否能叠加
---@param itemData ItemData
function ItemData:CanCollapse(itemData)
    if nil == itemData then
        return false
    end

    if self.TID ~= itemData.TID then
        return false
    end

    if self.ItemCollapseBitMap ~= itemData.ItemCollapseBitMap then
        return false
    end

    local totalCount = self.ItemCount + itemData.ItemCount
    if totalCount > self.ItemConfig.Overlap then
        return false
    end

    return true
end

--- 根据枚举获取相关的所有属性
---@return ItemAttrData[]
function ItemData:_getAttrsByType(targetType)
    if nil == self.AttrSet then
        return {}
    end

    local attrList = self.AttrSet[targetType]
    if nil == attrList then
        return {}
    end

    local ret = {}
    for i = 1, #attrList do
        local singleList = attrList[i]
        table.ro_insertRange(ret, singleList)
    end

    return ret
end

--- 获取剩余时间，剩余时间是客户端自己算的，不根据服务器更新
---@return number
function ItemData:_getRemainTime()
    return self.EffectiveTime - tonumber(Common.TimeMgr.GetNowTimestamp())
end

function ItemData:_isFake()
    return int64.equals(0, self.UID)
end

function ItemData:GetExistTime()
    local itemTable
    if self.ParentItemConfig then
        itemTable = self.ParentItemConfig
    else
        itemTable = self.ItemConfig
    end
    return tonumber(itemTable.CountTime)
end

--得到开启的洞的个数，包含插卡和未插卡的洞
function ItemData:GetOpenHoleCount()
    local holeAttrSet = self.AttrSet[GameEnum.EItemAttrModuleType.Hole]
    if holeAttrSet == nil then
        return 0
    end
    local openHoleCount = 0
    for i = 1, #holeAttrSet do
        if 0 < #holeAttrSet[i] then
            openHoleCount = openHoleCount + 1
        end
    end
    return openHoleCount
end

return Data.ItemData