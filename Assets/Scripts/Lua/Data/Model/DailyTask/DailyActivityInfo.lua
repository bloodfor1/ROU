module("Data", package.seeall)

---@class DailyActivityInfo
DailyActivityInfo = class("DailyActivityInfo")

function DailyActivityInfo:ctor()
    self:Reset()
end

--- 初始化数据
---@param netInfo DailyActivityNetInfo
---@param tableInfo DailyActivitiesTable
function DailyActivityInfo:InitInfo(netInfo,tableInfo,isOpen,isShow)
    if tableInfo==nil then
        logError("DailyActivitiesTable 数据为nil")
        return
    end
    ---@type ModuleMgr.DailyTaskMgr
    self.mgr = MgrMgr:GetMgr("DailyTaskMgr")
    self.id = tableInfo.Id
    self.functionId = tableInfo.FunctionID

    local l_isPreShow = self:isPreviewShowFunction(self.id,tableInfo, isOpen)
    local l_openTable = TableUtil.GetOpenSystemTable().GetRowById(tableInfo.FunctionID)
    self.levelLimit = l_openTable.BaseLevel
    self.isOpen= isOpen
    self.isShow= isShow
    self.tableInfo = tableInfo
    self.unOpenTime= l_isPreShow  --非开放日
    self.netInfo = netInfo
    self.isNormal = false
    self.isPvp = tableInfo.Type == GameEnum.ActivityShowType.pvp
    self.isMvp = tableInfo.Type == GameEnum.ActivityShowType.mvp
    self.isExpel = tableInfo.Type == GameEnum.ActivityShowType.expelMonster
    self.isWorldEvent = tableInfo.Type == GameEnum.ActivityShowType.worldEvent
    self.isThemeDungeon = tableInfo.Type == GameEnum.ActivityShowType.themeDungeon
    self.isTowerDefense = tableInfo.Type == GameEnum.ActivityShowType.towerDefense
    self.isGuildHunter= false
    self.state = self.mgr.g_ActivityState.Non
    if tableInfo.ActiveType == 0 then
        self.isNormal = true
    end
    if netInfo~=nil then
        self.isGuildHunter=netInfo.id == self.mgr.g_ActivityType.activity_GuildHunt
        if netInfo.startTime ~= 0 and netInfo.startTime ~= nil then
            self.startSec = MLuaClientHelper.GetTiks2NowSeconds(netInfo.startTime)
            self.startSec = MLuaCommonHelper.Int(self.startSec)

            self.endSec = MLuaClientHelper.GetTiks2NowSeconds(netInfo.endTime)
            self.endSec = MLuaCommonHelper.Int(self.endSec)

            self.begainSec = MLuaClientHelper.GetTiks2Zero(netInfo.startTime)
            self.begainSec = MLuaCommonHelper.Int(self.begainSec)

            self.finishSec = MLuaClientHelper.GetTiks2Zero(netInfo.endTime)
            self.finishSec = MLuaCommonHelper.Int(self.finishSec)

            self.runState = netInfo.runState
            local l_battleStartTime = netInfo.battleStartTime
            if l_battleStartTime == nil then
                l_battleStartTime = 0
            end
            self.battleStartTime = l_battleStartTime == 0 and 0 or MLuaClientHelper.GetTiks2NowSeconds(l_battleStartTime)
            self.battleStartTime = MLuaCommonHelper.Int(self.battleStartTime)

            if self.startSec > 30 * 60 then
                self.state = self.mgr.g_ActivityState.Waiting
            end
            if self.endSec < 0 then
                self.state = self.mgr.g_ActivityState.Finish
            end
            if self.startSec <= 30 * 60 and self.startSec > 0 then
                self.state = self.mgr.g_ActivityState.CountDown
            end
            if self.startSec <= 0 and self.endSec > 0 then
                local l_target = self.endSec
                if netInfo.battleStartTime > 0 then
                    l_target = self.runState == 2 and self.battleStartTime or l_target
                end
                self.state = self.mgr.g_ActivityState.Runing
            end
        end
    end

    if l_isPreShow then
        self.state = self.mgr.g_ActivityState.Non
    end
end



---@Description:是否为可预览的活动
function DailyActivityInfo:isPreviewShowFunction(activityId,activityItem, isOpen)
    if activityItem==nil then
        activityItem= TableUtil.GetDailyActivitiesTable().GetRowById(activityId)
        if activityItem==nil then
            return false
        end
    end
    if not self.mgr.IsTimeLimitActivity(activityItem.ActiveType) then
        return false
    end
    if not isOpen then
        return true
    end
    return not self.mgr.IsActivityInOpenDay(activityId)
end

--- 重置数据
function DailyActivityInfo:Reset()
    self.id = 0
    self.isTimeLimit = false
    self.functionId = 0
    self.levelLimit = 0
    self.isOpen = false
    self.isShow = false
    self.tableInfo = nil
    self.unOpenTime = true
    self.netInfo = nil
    self.isNormal = false
    self.isPvp = false
    self.isMvp = false
    self.isExpel = false
    self.isWorldEvent = false
    self.isThemeDungeon = false
    self.isTowerDefense = false
    self.isGuildHunter = false
    self.state = 0
    self.startSec = 0
    self.endSec = 0
    self.runState = 0
    self.battleStartTime = 0
end

return Data.DailyActivityInfo