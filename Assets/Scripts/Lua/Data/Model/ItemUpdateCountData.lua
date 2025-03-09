--- 职责：道具数量有关的简易类，作为数据变更广播的返回值
module("Data", package.seeall)

---@class ItemUpdateCountData
ItemUpdateCountData = class("ItemUpdateCountData")

function ItemUpdateCountData:ctor(id, oldCount, newCount)
    --- 道具TID
    self._tid = id
    --- 旧道具数量
    ---@type int64
    self._oldCount = oldCount
    --- 新道具数量
    ---@type int64
    self._newCount = newCount

    if nil == id then
        self._tid = 0
    end

    if nil == oldCount then
        self._oldCount = ToInt64(0)
    end

    if nil == newCount then
        self._newCount = ToInt64(0)
    end
end

---@return int64
function ItemUpdateCountData:GetCompareCount()
    return self._newCount - self._oldCount
end

