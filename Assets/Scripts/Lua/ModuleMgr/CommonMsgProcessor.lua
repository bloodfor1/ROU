module("Common", package.seeall)

---@class CommonMsgProcessor
CommonMsgProcessor = class("CommonMsgProcessor")

---@class CommonBroadcastData
---@field ModuleEnum number
---@field DetailDataEnum number
---@field Callback function<number>
---@field CbSelf table
local MAGIC_NUM_INT32 = 4294967296
-- 数据列表
function CommonMsgProcessor:ctor()
    self._eventMgr = MgrProxy:GetGameEventMgr()
    self._eventMgr.Register(self._eventMgr.OnCommonBroadcast, self._onBroadcast, self)
    ---@type table<number, CommonBroadcastData>
    self._msgMap = {}
    self._msgModuleMap = {}
end

---@param paramList CommonBroadcastData[]
function CommonMsgProcessor:Init(paramList)
    if nil == paramList then
        logError("paramList Is Null! Please check your parameters")
        return
    end

    for i = 1, #paramList do
        local singleParam = paramList[i]
        if singleParam.DetailDataEnum == nil then
            self._msgModuleMap[tostring(singleParam.ModuleEnum)] = singleParam
        else
            local key = self:_formKey(singleParam.ModuleEnum, singleParam.DetailDataEnum)
            self._msgMap[tostring(key)] = singleParam
        end
    end
end

function CommonMsgProcessor:Clear()
    self._msgMap = {}
    self._eventMgr.UnRegister(self._eventMgr.OnCommonBroadcast, self)
end

---@param paramList table<number, number>
function CommonMsgProcessor:_onBroadcast(paramList)
    if nil == paramList then
        logError("paramList Is Null! Please check your parameters")
        return
    end

    for key, value in pairs(paramList) do
        local t1 = math.modf(tonumber(tostring(key / MAGIC_NUM_INT32)))
        local t2 = tonumber(tostring(key % MAGIC_NUM_INT32))
        if nil ~= self._msgMap[tostring(key)] then
            local commonProcessData = self._msgMap[tostring(key)]
            if nil ~= commonProcessData.Callback then
                if nil ~= commonProcessData.CbSelf then
                    commonProcessData.Callback(commonProcessData.CbSelf, t2, value)
                else
                    commonProcessData.Callback(t2, value)
                end
            end
        elseif nil ~= self._msgModuleMap[tostring(t1)] then
            local commonProcessData = self._msgModuleMap[tostring(t1)]
            if nil ~= commonProcessData.Callback then
                if nil ~= commonProcessData.CbSelf then
                    commonProcessData.Callback(commonProcessData.CbSelf, t2, value)
                else
                    commonProcessData.Callback(t2, value)
                end
            end
        end
    end
end

---@param moduleEnum number
---@param detailEnum number
---@return number
function CommonMsgProcessor:_formKey(moduleEnum, detailEnum)
    return moduleEnum * MAGIC_NUM_INT32 + detailEnum
end

return CommonMsgProcessor