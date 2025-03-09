require "Data/BaseModel"
require "Event/EventDispacher"

module("Data", package.seeall)

local super = Data.BaseModel
PlayerInfoModel = class("PlayerInfoModel", super)

PlayerInfoModel.HPPERCENT = EventDispatcher.new()
PlayerInfoModel.SLIDERBAR = EventDispatcher.new()
PlayerInfoModel.BASELV = EventDispatcher.new()
PlayerInfoModel.MPPERCENT = EventDispatcher.new()
PlayerInfoModel.JOBLV = EventDispatcher.new()
PlayerInfoModel.BASEEXPDATA = EventDispatcher.new()
PlayerInfoModel.BASEEXPBLESSDATA = EventDispatcher.new()
PlayerInfoModel.JOBEXPDATA = EventDispatcher.new()
PlayerInfoModel.JOBEXPBLESSDATA = EventDispatcher.new()
PlayerInfoModel.COINCHANGE = EventDispatcher.new()

--登出清理
function PlayerInfoModel:Logout()
    --目前只清理有问题的 后续请自行补充 20200709 cmd
    self._BaseLv = nil
end

function PlayerInfoModel:getSliderBar()
    return self._SliderBar
end

function PlayerInfoModel:setSliderBar(SliderBar)
    if self._SliderBar == SliderBar then
        return
    end
    self._SliderBar = SliderBar
    PlayerInfoModel.SLIDERBAR:Dispatch(Data.onDataChange, SliderBar)
end

function PlayerInfoModel:getHPPercent()
    return self._HPPercent
end

function PlayerInfoModel:setHPPercent(HPPercent)
    if self._HPPercent == HPPercent then
        return
    end
    self._HPPercent = HPPercent
    PlayerInfoModel.HPPERCENT:Dispatch(Data.onDataChange, HPPercent)
end

function PlayerInfoModel:getMPPercent()
    return self._MPPercent
end

function PlayerInfoModel:setMPPercent(MPPercent)
    if self._MPPercent == MPPercent then
        return
    end
    self._MPPercent = MPPercent
    PlayerInfoModel.MPPERCENT:Dispatch(Data.onDataChange, MPPercent)
end

function PlayerInfoModel:getBaseLv()
    return self._BaseLv
end

function PlayerInfoModel:setBaseLv(BaseLv)
    if self._BaseLv == BaseLv then
        return
    end
    local l_originalBaseLv = self._BaseLv  --记录修改前的等级数据
    self._BaseLv = BaseLv
    --如果是登录则修改前的数据为nil 不抛事件
    if l_originalBaseLv then
        PlayerInfoModel.BASELV:Dispatch(Data.onDataChange, BaseLv)
    end
end

function PlayerInfoModel:getJobLv()
    return self._JobLv
end

function PlayerInfoModel:setJobLv(JobLv)
    if self._JobLv == JobLv then
        return
    end
    self._JobLv = JobLv
    PlayerInfoModel.JOBLV:Dispatch(Data.onDataChange, JobLv)
end

function PlayerInfoModel:getBaseExpData()
    return self._BaseExpData
end --func end

function PlayerInfoModel:setBaseExpData(BaseExpData)
    if self._BaseExpData == BaseExpData then
        return
    end
    self._BaseExpData = BaseExpData
    PlayerInfoModel.BASEEXPDATA:Dispatch(Data.onDataChange, BaseExpData)
end --func end

function PlayerInfoModel:getBaseExpBlessData()
    return self._baseExpBless
end

function PlayerInfoModel:setBaseExpBlessData(value)
    if self._baseExpBless == value then
        return
    end
    self._baseExpBless = value
    PlayerInfoModel.BASEEXPBLESSDATA:Dispatch(Data.onDataChange, value)
end

function PlayerInfoModel:getJobExpData()
    return self._JobExpData
end --func end

function PlayerInfoModel:setJobExpData(JobExpData)
    if self._JobExpData == JobExpData then
        return
    end
    self._JobExpData = JobExpData
    PlayerInfoModel.JOBEXPDATA:Dispatch(Data.onDataChange, JobExpData)
end --func end

function PlayerInfoModel:getJobExpBlessData()
    return self._jobBlessValue
end

function PlayerInfoModel:setJobExpBlessData(value)
    if self._jobBlessValue == value then
        return
    end
    self._jobBlessValue = value
    PlayerInfoModel.JOBEXPBLESSDATA:Dispatch(Data.onDataChange, value)
end

function PlayerInfoModel:SetExtraFightTime(time)
    local lastTime = MPlayerInfo.ExtraFightTime
    MPlayerInfo.ExtraFightTime = time
    MgrMgr:GetMgr("DailyTaskMgr").OnExtraFightTimeChange(time / 60000, lastTime / 60000)

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnExtraFightTimeChanged)
end

function PlayerInfoModel:DispatchCoinChange()
    PlayerInfoModel.COINCHANGE:Dispatch(Data.onDataChange)
end

function PlayerInfoModel:ctor()
    super.ctor(self, CtrlNames.Main)
end --func end
