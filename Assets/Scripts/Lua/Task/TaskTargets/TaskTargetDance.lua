require "Task/TaskTargets/TaskTargetBase"

--拍照类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetDance = class("TaskTargetDance",super)

function TaskTargetDance:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.random = false
    self.maxDanceTime = 0

    if self.customTime <= 0 then
   		self.customTime = 0
    end
    local l_tmp = string.ro_split(self.msgEx, "=")
    self.navRange = 0
    if #l_tmp == 2 then
        self.navRange = tonumber(l_tmp[1])
        self.maxDanceTime = tonumber(l_tmp[2])
    end
    self.isPause = true
    self.timer = Timer.New(function ( ... )
        self:UpdateTime()
    end , 1, -1, true)

    if self.navData == nil then
        self.orgNavData = nil
    else
        self.orgNavData = {
            sceneId = self.navData.sceneId,
            position = self.navData.position
        }
        MgrMgr:GetMgr("TaskMgr").RequestTaskRandomNavigation(self.orgNavData.sceneId,self.orgNavData.position,self.navRange,function ( navData )
            self.navData.sceneId = navData.scene_map_id
            self.navData.position = navData.position   
            self.random = true
        end)
    end
end

function TaskTargetDance:GetNavigationData( ... )
    if self.random then
        return self.navData
    else
        return nil  
    end
end

function TaskTargetDance:UpdateNavigationAsync( callback )
    if self.random then
        if callback then
            callback(self.navData)
        end
        return
    end
     MgrMgr:GetMgr("TaskMgr").RequestTaskRandomNavigation(self.orgNavData.sceneId,self.orgNavData.position,self.navRange,function ( navData )
        if self.random then
            callback(self.navData)
            return
        end
        self.navData.sceneId = navData.scene_map_id
        self.navData.position = navData.position   
        self.random = true
        callback(self.navData)
     end)
end


function TaskTargetDance:TargetNavigation(navType)
    if self.navData == nil then
        return
    end
    if not self.random then
         MgrMgr:GetMgr("TaskMgr").RequestTaskRandomNavigation(self.orgNavData.sceneId,self.orgNavData.position,self.navRange,function ( navData )
            if not self.random then
                self.navData.sceneId = navData.scene_map_id
                self.navData.position = navData.position  
                self.random = true
            end
            super.TargetNavigation(self,navType)
         end)
        return
    end
    super.TargetNavigation(self,navType)
end

function TaskTargetDance:TaskTargetNavigation()
    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position,function( ... )
                self:ReportTaskTargetComplete()

                -- if self:CheckPosInRange(MScene.SceneID, MEntityMgr.PlayerEntity.Position) then 
                --     self:ReportTaskTargetComplete()
                -- end                  
            end)
    end
end

function TaskTargetDance:CheckPosInRange(sceneId, position)
    local l_targetSceneId = self.orgNavData.sceneId
    local l_taregtPosition = self.orgNavData.position
    if sceneId ~= l_targetSceneId then return false end
    local dis = math.pow((l_taregtPosition.x - position.x), 2) + math.pow((l_taregtPosition.z - position.z), 2)
    local tdis = math.pow(self.navRange, 2)
    if dis < tdis then
        return true
    end
    return false
end

function TaskTargetDance:TaskReportInfo( ... )
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.postion.sceneid = self.navData.sceneId
    l_sendInfo.postion.x = self.navData.position.x
    l_sendInfo.postion.z = self.navData.position.z
    return l_sendInfo
end

--获取快捷任务栏任务目标描述  由子类分别实现
function TaskTargetDance:GetTaskTargetDescribeQuick()
    return self:GetTaskTargetDescribe()
end

--获取任务面板任务目标描述
--这里给一个较为通用的 其余由子类分别实现
function TaskTargetDance:GetTaskTargetDescribe()
    local l_lastTime = self.maxDanceTime - self.customTime
    if l_lastTime < 0 then
        l_lastTime = 0
    end
    local l_taskTipsCon = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    local l_lastTime = Common.Functions.SecondsToTimeStr(l_lastTime)
    if not self.isPause then
        return StringEx.Format(l_taskTipsCon,l_lastTime)
    else
        return string.format("%s  %s",StringEx.Format(l_taskTipsCon,l_lastTime),Lang("TASK_DANCE_PAUSE")) 
    end
end

--监听事件添加
function TaskTargetDance:AddTaskEvent()
    if self.isEventAdded then return end
    if self.timer ~= nil then
    	self.timer:Start()
    end
    super.AddTaskEvent(self)
end


--监听事件执行体
function TaskTargetDance:ExecuteEventLogic(eventData)
    if eventData.task_id ~= self.taskId then
        return
    end
    if not eventData.is_pause and self.isPause then
        local l_lastTimeStr = StringEx.Format(Lang("TASK_DELEGATE_DANCE_TIPS"),math.ceil((self.maxDanceTime - self.customTime) / 60))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_lastTimeStr)
    end
    self.customTime = tonumber(eventData.dance_time) 
    self.isPause = eventData.is_pause
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickOneTask,self.taskId)
end
--监听事件移除
function TaskTargetDance:RemoveTaskEvent()

    if not self.isEventAdded then return end
    super.RemoveTaskEvent(self)
   	if self.timer ~= nil then
    	self.timer:Stop()
    end
end

function TaskTargetDance:UpdateTime( ... )
	if self.customTime >= self.maxDanceTime or self.isPause then
		return
	end
    GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskTime)
    self.customTime = self.customTime + 1
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickOneTask,self.taskId)
end


function TaskTargetDance:UpdataExData( targetInfo )
    self.customTime = targetInfo.customTime
end


function TaskTargetDance:Destroy( ... )
    super.Destroy(self)
	self.timer = nil	
    self.random = false
end
