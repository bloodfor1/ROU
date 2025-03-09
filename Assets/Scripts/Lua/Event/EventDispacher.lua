local package = package
local setmetatable = setmetatable
local pairs = pairs
---@module EventDispatcher
module("EventDispatcher", package.seeall)
--[[
    数据层次
    ["EventName1"] =
    {
        ["_StaticFunc"] = { Func1, Func2 },

        [Object1] = { Func1, Func2 },
        [Object2] = { Func1, Func2 },
    },
    ...
]]

-- 默认调用函数
local function PreInvoke(func, object, ...)
    if object then
        func(object, ...)
    else
        func(...)
    end
end

function new()
    local obj = setmetatable({}, { __index = package.loaded["EventDispatcher"] })
    obj.mPreInvokeFunc = PreInvoke
    obj.mEventTable = {}
    return obj
end

--[[
    @Description: 根据事件和对象注册回调
    @Date: 2018/7/13
    @Param: [eventDispatch: 事件器 eventName:事件名称 func: 事件回调 object: 事件关联对象 userData:TODO]
    @Return
--]]
function Add(eventDispatch, eventName, func, object, userData)
    if not eventDispatch.mEventTable[eventName] then
        eventDispatch.mEventTable[eventName] = {}
    end

    local eventDatas = eventDispatch.mEventTable[eventName]
    if not object then
        object = "_StaticFunc"
    end

    if not eventDatas[object] then
        eventDatas[object] = {}
    end

    eventDatas[object][func] = userData or true
end

-- 设置调用前回调
function SetDispatchHook(Self, HookFunc)
    Self.mPreInvokeFunc = HookFunc
end

--[[
    @Description: 派发事件
    @Date: 2018/7/13
    @Param: [args]
    @Return
--]]
---@param eventDispatch EventDispatch
---@param eventName string | number
---@vararg
function Dispatch(eventDispatch, eventName, ...)
    local eventDatas = eventDispatch.mEventTable[eventName]
    if not Exist(eventDispatch, eventName) then
        return
    end

    for object, objectFuncs in pairs(eventDatas) do
        if object == "_StaticFunc" then
            object = nil
        end

        for func, userData in pairs(objectFuncs) do
            eventDispatch.mPreInvokeFunc(func, object, ...)
        end
    end
end

--[[
    @Description: 是否存在回调
    @Date: 2018/7/13
    @Param: [eventDispatch 事件派发器 eventName: 事件名称]
    @Return
--]]
function Exist(eventDispatch, eventName)
    local eventDatas = eventDispatch.mEventTable[eventName]
    if not eventDatas then
        return false
    end

    local ret = false
    for _, funcs in pairs(eventDatas) do
        if table.ro_size(funcs) > 0 then
            ret = true
            break
        end
    end

    return ret
end

--[[
    @Description: 根据object&func清除事件回调
    @Date: 2018/7/13
    @Param: [args]
    @Return
--]]
function Remove(eventDispatch, eventName, func, object)
    local eventDatas = eventDispatch.mEventTable[eventName]
    if not eventDatas then
        return
    end

    if not object then
        object = "_StaticFunc"
    end

    if eventDatas[object] and func then
        eventDatas[object][func] = nil
    end
end

--[[
    @Description: 根据object清除所有回调
    @Date: 2018/7/13
    @Param: [args]
    @Return
--]]
-- 清除对象的所有回调
function RemoveObjectAllFunc(eventDispatch, eventName, object)
    local eventDatas = eventDispatch.mEventTable[eventName]
    if eventDatas and eventDatas[object] then
        eventDatas[object] = nil
    end
end