--- 道具更新的数据，主要是为了封装一些方法
module("Data", package.seeall)

---@class ItemUpdateData
ItemUpdateData = class("ItemUpdateData")
local contType = GameEnum.EBagContainerType

local C_VALID_NAME_MAP = {
    ["OldItem"] = 1,
    ["NewItem"] = 1,
}

function ItemUpdateData._newIndex(table, key, value)
    if not C_VALID_NAME_MAP[key] then
        error("[ItemData] try to newindex key: " .. tostring(key) .. " value: " .. tostring(value))
        return
    end

    rawset(table, key, value)
end

function ItemUpdateData:ctor()
    local mt = getmetatable(self)
    mt.__newindex = nil

    self.ExtraData = -1
    self.Reason = ItemChangeReason.ITEM_REASON_NONE
    self.OldContType = contType.None
    self.NewContType = contType.None
    ---@type ItemData
    self.OldItem = nil
    ---@type ItemData
    self.NewItem = nil

    mt.__newindex = self._newIndex
end

---@return ItemUpdateCompareData
function ItemUpdateData:GetItemCompareData()
    ---@type ItemUpdateCompareData
    local ret = {}
    ret.uid = 0
    local newCount = 0
    local oldCount = 0
    local oldLv = 0
    local newLv = 0

    local C_EXP_TYPE_MAP = {
        [GameEnum.l_virProp.exp] = 1,
        [GameEnum.l_virProp.jobExp] = 1,
    }

    if nil ~= self.NewItem then
        newCount = self.NewItem.ItemCount
        newLv = self.NewItem.ExpLv
        ret.id = self.NewItem.TID
        ret.uid = self.NewItem.UID
    end

    if nil ~= self.OldItem then
        oldCount = self.OldItem.ItemCount
        oldLv = self.OldItem.ExpLv
        ret.id = self.OldItem.TID
        ret.uid = self.OldItem.UID
    end

    --- 如果是普通道具，这个时候直接取差值就可以了
    --- 如果是经验，这个时候要计算等级
    --- 如果等级没有发生变化，这个时候直接取差值
    if nil == C_EXP_TYPE_MAP[ret.id] or oldLv == newLv then
        ret.count = newCount - oldCount
        return ret
    end

    --- 如果是经验，但是是第一次获得经验，新号，会没有经验道具，这个时候直接返回
    if nil == self.OldItem then
        ret.count = newCount - oldCount
        return ret
    end

    local diffValue = 0
    for i = oldLv, newLv - 1 do
        if GameEnum.l_virProp.exp == ret.id then
            ---@type BaseLvTable
            local expConfig = TableUtil.GetBaseLvTable().GetRowByBaseLv(i)
            if nil ~= expConfig then
                diffValue = diffValue + expConfig.Exp
            end
        elseif GameEnum.l_virProp.jobExp == ret.id then
            ---@type JobLvTable
            local expConfig = TableUtil.GetJobLvTable().GetRowByJobLv(i)
            if nil ~= expConfig then
                diffValue = diffValue + expConfig.Exp
            end
        end
    end

    ret.count = newCount - oldCount + diffValue
    return ret
end

--- 获取非空道具数据，有限获取新数据
---@return ItemData
function ItemUpdateData:GetNewOrOldItem()
    local ret = nil
    if nil ~= self.NewItem then
        ret = self.NewItem
    elseif nil ~= self.OldItem then
        ret = self.OldItem
    end

    if nil == ret then
        logError("[ItemUpdateData] invalid data, no valid item")
    end

    return ret
end

--- 判断道具是否时新获得的
function ItemUpdateData:IsItemNewAcquire()
    if nil == self.NewItem then
        return false
    end

    if nil ~= self.OldItem then
        return false
    end

    return true
end

--- 判断是否有道具被移除了
function ItemUpdateData:ItemRemoved()
    return nil == self.NewItem
end

--- 判断时间是否更新了
---@return boolean
function ItemUpdateData:ItemTimeUpdated()
    if nil == self.OldItem or nil == self.NewItem then
        return false
    end

    return self.OldItem:GetExpireTime() ~= self.NewItem:GetExpireTime()
end

--- 道具变动涉及到的容器类型
function ItemUpdateData:ChangeInvolvedCont(contType)
    local ret = self.OldContType == contType or self.NewContType == contType
    return ret
end