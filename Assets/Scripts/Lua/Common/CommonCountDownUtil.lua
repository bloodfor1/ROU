-- 倒计时触发器，这是一个被动的对象，和业务逻辑无关
---@module Common
module("Common", package.seeall)

---@class CommonCountDownUtil
CommonCountDownUtil = class("CommonCountDownUtil")

local L_CONST_DEFAULT_TIME = -1
local L_CONST_DEFAULT_PHASE = 0

-- 数据列表
function CommonCountDownUtil:ctor()
    self._runTime = L_CONST_DEFAULT_TIME
    self._intervalPhase = L_CONST_DEFAULT_PHASE
    self._totalTime = 0
    self._interval = 0
    self._cb = nil
    self._cbSelf = nil
    self._clearCb = nil
    self._clearCbSelf = nil
end

-- 这里是初始化，不是运行部分
---@param paramTable CountDownUtilParam
function CommonCountDownUtil:Init(paramTable)
    if nil == paramTable then
        logError("[CountDownUtil] init param is nil, init failed")
        return
    end

    self._totalTime = paramTable.totalTime
    self._interval = paramTable.interval or 1
    self._cb = paramTable.callback
    self._cbSelf = paramTable.callbackSelf
    self._clearCb = paramTable.clearCallback
    self._clearCbSelf = paramTable.clearCallbackSelf
end

-- 返回是否在运行
function CommonCountDownUtil:IsRunning()
    return 0 <= self._runTime
end

function CommonCountDownUtil:Start()
    self._runTime = 0
end

function CommonCountDownUtil:Stop()
    self:_stop()
end

function CommonCountDownUtil:OnUpdate()
    if 0 > self._runTime then
        return
    end

    local l_dt = Time.deltaTime
    self._runTime = self._runTime + l_dt
    if self._runTime >= self._totalTime then
        self:_stop()
        return
    end

    if self._runTime >= (self._intervalPhase * self._interval) then
        local l_param = self:_getParamWrap()
        self:_callCb(l_param)
        self._intervalPhase = self._intervalPhase + 1
    end
end

function CommonCountDownUtil:_stop()
    local l_param = self:_getParamWrap()
    self:_callClearCb(l_param)
    self._runTime = L_CONST_DEFAULT_TIME
    self._intervalPhase = L_CONST_DEFAULT_PHASE
end

-- 触发常规回调
function CommonCountDownUtil:_callCb(param)
    self._invokeCb(self._cb, self._cbSelf, param)
end

-- 触发清空回调
function CommonCountDownUtil:_callClearCb(param)
    self._invokeCb(self._clearCb, self._clearCbSelf, param)
end

-- 构建返回参数列表
function CommonCountDownUtil:_getParamWrap()
    local l_ret = {
        totalTime = self._totalTime,
        elapsedTime = self._interval * self._intervalPhase,
        realElapsedTime = self._runTime
    }

    return l_ret
end

function CommonCountDownUtil._invokeCb(cb, cbSelf, param)
    if nil == cb then
        return
    end

    if nil == cbSelf then
        cb(param)
        return
    end

    cb(cbSelf, param)
end