module("Data", package.seeall)

---@class ItemAttrExtraParam
ItemAttrExtraParam = class("ItemAttrExtraParam")

function ItemAttrExtraParam:ctor(key, value, randomType, name)
    self.key = key
    self.value = value
    self.randomType = randomType
    self.name = name
end