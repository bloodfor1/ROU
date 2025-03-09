module("Data", package.seeall)

--- 用来描述属性参数的数据
---@class ItemStyleParamPair
ItemStyleParamPair = class("ItemStyleParamPair")

function ItemStyleParamPair:ctor()
    self.Key = 0
    self.MaxValue = 0
    self.MinValue = -1
    self.RandType = GameEnum.EStyleAttrRandType.None
end