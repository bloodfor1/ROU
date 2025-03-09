module("Task", package.seeall)

--任务目标基类  不同目标进行不同逻辑的具体实现 包含导航 相关事件的触发逻辑等
---@class TaskTargetBase
TaskTargetBase = class("TaskTargetBase")
function TaskTargetBase:ctor(targetIndex,taskId,taskData,targetData, stepInfo)
    self.taskId = taskId
    self.taskData = taskData
    if self.taskData.isCycTask then
        self.Id = targetData.Id
    else
        self.Id = 0
    end
    self.targetType = targetData.targetType
    self.targetId = targetData.targetId
    self.targetArg = targetData.targetArg
    self.targetIndex = targetIndex
    self.customTime = targetData.customTime
    self.isEventAdded = false  --记录该目标事件是否已经被注册过 防止重复注册该目标事件监听
    self.currentStep = targetData.step
    self.maxStep = targetData.maxStep
    self.navData = nil
    --任务寻路
    if targetData.navPosition == nil or #targetData.navPosition ~= 4 then
        if self.targetType ~= MgrMgr:GetMgr("TaskMgr").ETaskTargetType.NpcTalk then
            -- logError("task navigation maybe incorrect !")
            self.navData = nil
        end
    else
        local l_sceneId = targetData.navPosition[1]
        local l_position = Vector3.New(targetData.navPosition[2],targetData.navPosition[3], targetData.navPosition[4])
        --场景ID如果为0则认为配置坐标无效(容错处理)
        if l_sceneId == 0 then
            self.navData = nil
        else
            self.navData = {
                sceneId = l_sceneId,
                position = l_position
            }
        end

    end

    --镜像副本进入点寻路
    if targetData.dungeonPosition == nil or #targetData.dungeonPosition ~= 4 then
        -- logError("task copy dungeon Position navigation maybe incorrect !")
        self.copyNavData = nil
    else
        local l_sceneId = targetData.dungeonPosition[1]
        local l_position = Vector3.New(targetData.dungeonPosition[2],
            targetData.dungeonPosition[3], targetData.dungeonPosition[4])
        --场景ID如果为0则认为配置坐标无效(容错处理)
        if l_sceneId == 0 then
            self.copyNavData = nil
        else
            self.copyNavData = {
                sceneId = l_sceneId,
                position = l_position
            }
        end
    end

    --扩展字段 用于不同任务目标的特殊需求
    self.msgEx = targetData.msgEx
    --任务目标描述
    self.desc = targetData.desc

    --任务触发器缓存
    self.triggers = nil
    if self.Id ~= 0 then
        self.triggers = MgrMgr:GetMgr("TaskTriggerMgr").InitTaskTriggersByTarget(self.taskId,self.Id)
    end
    self.ignoreNav = targetData.ignoreNav
end

--比对两个目标是否是同一个目标  用于taskbase中重写任务目标时的验证
function TaskTargetBase:CompareTarget(target)
    return self.targetType == target.type and
            self.targetId == target.targetId and
            self.targetArg == target.targetArg 
end

--同步任务目标进度  并返回该目标是否完成
function TaskTargetBase:SyncTargetStep(stepInfo,tips)
    tips = false --策划需求不需要弹目标进度更新  如果需要飘字提示删除该行代码，打开下面注释代码即可，具体目标是否需要飘字通过实现GetTaskTargetTip接口 返回nil则该目标无需飘字 
    -- if tips == nil then
    --     tips = false
    -- end
    local l_preStep = self.currentStep
    self.currentStep = stepInfo.step
    self.maxStep = stepInfo.maxStep
    if l_preStep < self.currentStep and tips then
        local l_targetTips = self:GetTaskTargetTip()
        if l_targetTips ~= nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_targetTips)
        end
        if l_preStep < self.currentStep and self.currentStep >= self.maxStep then
            self:OnTargetCompleted()
        end
    end
    return self.currentStep >= self.maxStep
end

--该目标完成时的响应   
function TaskTargetBase:OnTargetCompleted( ... )
    MgrMgr:GetMgr("TaskMgr").OnTaskTargetCompleted(self)
end

--监听事件添加
function TaskTargetBase:AddTaskEvent()
    if self.isEventAdded then return end
    local l_eventName = MgrMgr:GetMgr("TaskMgr").taskEventName[self.targetType]
    if l_eventName ~= nil then
        GlobalEventBus:Add(l_eventName,
            function(self, eventData)
                self:ExecuteEventLogic(eventData)
            end,
        self)
    end
    GlobalEventBus:Add(EventConst.Names.OnPlayerStopMoveForTask,
        function(self, sceneId,position)
            if self.navData == nil then return end
            self:ExecutePlayerStopEventLogic(sceneId,position)
        end,
    self)
    self:AddTrigger()
    self.isEventAdded = true
end

function TaskTargetBase:AddTrigger( ... )
    if self.triggers == nil then
        return
    end
    for i=1,#self.triggers do
        self.triggers[i]:ExecuteTrigger()
    end
end

function TaskTargetBase:RemoveTrigger( ... )
    if self.triggers == nil then
        return
    end
    for i=1,#self.triggers do
        self.triggers[i]:ReverseTrigger()
    end
end

--监听事件移除
function TaskTargetBase:RemoveTaskEvent()
    if not self.isEventAdded then return end
    self.isEventAdded = false
    local l_eventName = MgrMgr:GetMgr("TaskMgr").taskEventName[self.targetType]
    if l_eventName ~= nil then
        GlobalEventBus:RemoveObjectAllFunc(l_eventName, self)
    end
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.OnPlayerStopMoveForTask, self)
    self:CheckClosePropIcon()
    self:RemoveTrigger()

end

--事件执行体
--子类单独实现
function TaskTargetBase:ExecuteEventLogic(eventData)
    -- body
end
--停止移动时的事件
function TaskTargetBase:ExecutePlayerStopEventLogic(sceneId,position)
    -- body
end

--上报目标完成
function TaskTargetBase:ReportTaskTargetComplete()
    local l_sendInfo = self:TaskReportInfo()
    if l_sendInfo ~= nil then
        MgrMgr:GetMgr("TaskMgr").RequestTaskReportWithTarget(l_sendInfo)
    end
end

---上报目标完成数据
---子类单独实现
function TaskTargetBase:TaskReportInfo( )
    return nil
end

--确认任务目标是否完成
function TaskTargetBase:CheckTargetComplete( ... )
    return self.currentStep >= self.maxStep
end

function TaskTargetBase:GetNavigationData( ... )
    self:ValidateNavData()
    if self:ValidateIgnoreNavigationInScene() then
        return nil
    end
    local eventData = MgrMgr:GetMgr("TaskTriggerMgr").GetTaskDungeonTriggerEvent(self.taskId)

    if eventData == nil then
        return self.navData
    end

    if eventData.args == 0 then
        logError("任务<"..self.taskId.."> 配置了进入镜像触发器 但镜像副本场景id=0 请检查配置")
        return self.navData
    end

    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon(eventData.args) then
        return self.navData
    end
    return self.copyNavData
end

--验证是否忽略场景内寻路
--isNeedShowTip   是否需要提示
function TaskTargetBase:ValidateIgnoreNavigationInScene(isNeedShowTip)
    if self.navData == nil then
        return false
    end
    if self.navData.sceneId == MScene.SceneID and self.ignoreNav then
        if isNeedShowTip then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_NAVIGATION_ALREADY_IN_SCENE")) 
        end
        return true
    end
    return false
end

function TaskTargetBase:TargetNavigation(navType)
    --特殊情况下任务数据丢失 容错判断
    if not self.taskData then
        return
    end

    self:ValidateNavData()
    if self:ValidateIgnoreNavigationInScene(true) then
        return
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.navData and self.taskData:NavigationInDungeon(self.navData.sceneId)  then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_NAVIGATION_IN_DUNGEON_TIP")) 
        --副本目标提示增强
        MgrMgr:GetMgr("DungeonTargetMgr").TaskGuideToDungeonsTarget()
    else
        self:CheckNavType(navType)
    end
end

function TaskTargetBase:ValidateNavData( ... )
end

function TaskTargetBase:CheckNavType(navType)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if navType == l_taskMgr.ETaskNavType.Normal then
        self:TaskTargetNavigation()
    end
end

--通用为导航到指定地点
--不同子类根据情况重写
function TaskTargetBase:TaskTargetNavigation()
    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position)
    end
end

--获取快捷任务栏任务目标描述  由子类分别实现
function TaskTargetBase:GetTaskTargetDescribeQuick()
    local l_desc = self:GetTaskTargetDescribe()
    local l_step = self:GetTaskTargetStepTip()
    if l_step == nil then
        return l_desc
    end
    return StringEx.Format("{0}{1}",l_desc,l_step)
end

--获取快捷任务面板任务目标描述
--这里给一个较为通用的 其余由子类分别实现
function TaskTargetBase:GetTaskTargetDescribe()
    local l_taskTipsCon = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    local l_targetName = self:GetTaskTargetName()
    local l_str = StringEx.Format(l_taskTipsCon,l_targetName)
    return l_str
end

--获取任务目标的飘字提示  由子类分别实现
function TaskTargetBase:GetTaskTargetTip()
    -- body
end

--获取任务目标的名称  由子类分别实现
function TaskTargetBase:GetTaskTargetName()
    -- body
    return ""
end

--获取任务目标完成进度的字符串
function TaskTargetBase:GetTaskTargetStepTip()
    return StringEx.Format("{0}/{1}", self.currentStep, self.maxStep)
end

function TaskTargetBase:QuickGiveUp( ... )
    return false
end

--确认是否需要进入地下城
function TaskTargetBase:CheckNeedEnterDungeons()
    local eventData = MgrMgr:GetMgr("TaskTriggerMgr").GetTaskDungeonTriggerEvent(self.taskId)

    if eventData == nil then
        -- logGreen("无数据")
        return false,0
    end

    if eventData.args == 0 then
        -- logGreen("不需要进入地下城")
        return false,0
    end

    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon(eventData.args) then
        -- logGreen("已经在地下城")
        return false,0
    end

    if self.copyNavData == nil then
        MgrMgr:GetMgr("TaskMgr").RequestGotoDungeon(eventData.taskId)
        return true,eventData.triggerArg
    end
    MgrMgr:GetMgr("ActionTargetMgr")
        .MoveToPos(self.copyNavData.sceneId, self.copyNavData.position, function ( ... )
            MgrMgr:GetMgr("TaskMgr").RequestGotoDungeon(eventData.taskId)
        end)
    return true,eventData.triggerArg
end

--判断位置坐标是否在规定范围内
--sceneId   玩家场景Id
--position  玩家坐标
--range     偏差范围 默认1.5
function TaskTargetBase:CheckPosInRange(sceneId, position, range)
    -- if self.navData == nil then return false end
    local l_range = range or 1.5
    local l_targetSceneId = self.navData.sceneId
    local l_taregtPosition = self.navData.position
    if sceneId ~= l_targetSceneId then return false end
    local dis = math.pow((l_taregtPosition.x - position.x), 2) + math.pow((l_taregtPosition.z - position.z), 2)
    local tdis = math.pow(l_range, 2)
    if dis < tdis then
        return true
    end
    return false
end

function TaskTargetBase:CheckClosePropIcon( ... )
    if UIMgr:IsActiveUI(UI.CtrlNames.PropIcon) then
        local l_ui = UIMgr:GetUI(UI.CtrlNames.PropIcon)
        if l_ui and l_ui:GetTaskTarget() == self then
            UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
        end
    end
end

function TaskTargetBase:UpdataExData( targetInfo )

end

function TaskTargetBase:GiveUp( ... )
    self.currentStep = 0
    self:RemoveTaskEvent()
end

function TaskTargetBase:Destroy( ... )
    self:RemoveTaskEvent()
    self.triggers = nil
    self.taskData = nil
end