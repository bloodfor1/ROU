--- 道具属性
--- 因为道具最终会抽象为各个属性值，所以定义出这样一个结构去表示道具属性
---@field ItemAttrData Data.ItemAttrData

---@module Data.ItemAttrData
module("Data", package.seeall)

---@class ItemAttrData
ItemAttrData = class("ItemAttrData")

--- 参数是服务器PB数据
---@return ItemAttrData
function ItemAttrData:ctor(type, attrID, attrValue, tableID, extraParam)
    self.AttrType = type
    self.AttrID = attrID
    self.AttrValue = attrValue
    self.TableID = tableID
    ---@type ItemAttrExtraParam[]
    self.ExtraParam = extraParam
    self.RareAttr = false
    self.ExpireTime = 0
    --- 当前数据equipTextID用来判定是否需要覆盖
    self.EquipTextID = 0
    --- 当前数据的配置编号，编号只对配置列生效
    self.AttrIdx = 0
    --- 表示属性描述的覆盖类型，对应EquipText当中的字段
    self.OverrideType = GameEnum.EAttrDescType.Default
    --- 属性随机类型
    self.RandomType = GameEnum.EStyleAttrRandType.Static
end

--- 如果有这个配置说明可能会覆盖
function ItemAttrData:CanOverrideDesc()
    return 0 < self.EquipTextID
end

--- 判断是不是需要忽略这个属性
function ItemAttrData:IgnoreAttr()
    if not BuffIgnoreHashSet[self.AttrID] then
        return false
    end

    if GameEnum.EItemAttrType.Buff ~= self.AttrType then
        return false
    end

    return true
end
