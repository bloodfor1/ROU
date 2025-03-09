module("Data", package.seeall)

---@class ItemCountUpdateRegData
---@field tid number
---@field onCountUpdate function<ItemUpdateCountData>
---@field onCountUpdateSelf table

---@class ItemUpdateCountProcessor
ItemUpdateCountProcessor = class("ItemUpdateCountProcessor")

function ItemUpdateCountProcessor:ctor()
    self:_onInit()

    ---@type table<number, ItemCountUpdateRegData>
    self._regMap = {}
end

function ItemUpdateCountProcessor:_onInit()
    self._eventMgr = MgrProxy:GetGameEventMgr()
    self._eventMgr.Register(self._eventMgr.OnItemCountUpdate, self._onCountUpdate, self)
end

function ItemUpdateCountProcessor:Reg(id, func, funcSelf)
    if nil == id then
        logError("[ItemCountUpdate] invalid param")
        return
    end

    if nil ~= self._regMap[id] then
        logError("[ItemCountUpdate] id is already in map: " .. id)
        return
    end

    ---@type ItemCountUpdateRegData
    local data = {
        tid = id,
        onCountUpdate = func,
        onCountUpdateSelf = funcSelf
    }

    self._regMap[id] = data
end

function ItemUpdateCountProcessor:UnReg(id)
    if nil == id then
        logError("[ItemCountUpdate] invalid param")
        return
    end

    if nil == self._regMap[id] then
        logError("[ItemCountUpdate] id not in map: " .. id)
        return
    end

    self._regMap[id] = nil
end

function ItemUpdateCountProcessor:Clear()
    self._regMap = {}
end

---@param countUpdateDataList ItemUpdateCountData[]
function ItemUpdateCountProcessor:_onCountUpdate(countUpdateDataList)
    for i = 1, #countUpdateDataList do
        local singleData = countUpdateDataList[i]
        local tid = singleData._tid
        local targetData = self._regMap[tid]
        if nil ~= targetData then
            self:_tryInvokeFunc(targetData, singleData)
        end
    end
end

---@param paramData ItemCountUpdateRegData
---@param countData ItemUpdateCountData
function ItemUpdateCountProcessor:_tryInvokeFunc(paramData, countData)
    if nil == paramData or nil == countData then
        logError("[ItemCountUpdate] invalid param")
        return
    end

    if nil == paramData.onCountUpdate then
        logError("[ItemCountUpdate] invalid param, no func")
        return
    end

    if nil == paramData.onCountUpdateSelf then
        paramData.onCountUpdate(countData)
        return
    end

    paramData.onCountUpdate(paramData.onCountUpdateSelf, countData)
end