module("Task", package.seeall)


--任务基类  控制任务相关逻辑 主要接取NPC 放弃等相关逻辑及维护任务目标数据
---@class TaskBase
TaskBase = class("TaskBase")

---@author edwardchen
---@date 2020/8/17 11:33
---@class TaskTableData 从任务表读出的任务配置数据，TaskMgr.ParseTaskTableInfo()
---@field taskId number 任务ID
---@field preTaskId number[] 前置任务ID列表，完成其一即可
---@field togetherPreId number[] 并列前置限制，需要全部完成
---@field taskType number 任务类型TaskMgr.ETaskType
---@field minBaseLevel number 接取任务Base等级下限
---@field maxBaseLevel number 接取任务Base等级上限
---@field minJobLevel number 接取任务Job等级下限
---@field maxJobLevel number 接取任务Job等级上限
---@field pushBaseLevel number 推送任务Base等级下限
---@field hideBaseLevel number 推送任务Base等级上限（超过隐藏）
---@field acceptLimitProfession number[] 职业限制，0代表全职业
---@field acceptLimitGender number 性别限制（0.男;1.女;2.无限制）
---@field name string 任务名称
---@field branchName string 进入子任务选项文本
---@field taskDesc string 任务简单描述
---@field acceptLimitIdentity number 接取社交身份限制(0.无限制;1.队长;2.异性队长;)
---@field acceptLimitItem table 接取需求道具限制，[[1]=[道具ID=数量], [2]=[道具ID=数量], ...]
---@field acceptType number 任务接取形式
---@field itemBeforeFinish table 交任务前扣除的道具，[[1]=[道具ID=数量], [2]=[道具ID=数量], ...]
---@field finishType number 任务交付类型
---@field descAcceptable string 任务可接取时的描述
---@field descCanFinish string 任务可完成时的描述
---@field acceptNpcId number 接取npc对象id
---@field acceptNpcMapId number 接取npc场景id
---@field finishNpcId number 交付npc对象id
---@field finishNpcMapId number 交付npc场景id
---@field isAutoDrop boolean true若任务可放弃
---@field targetSubTasks table 子任务群组，此处有数据则任务目标配置无效
---@field targetSubTaskChoose number 任务群组中子任务选取方式 ETaskSubChoose
---@field talkScript number 任务用脚本名（编号）
---@field talkAcceptScriptTag string 接任务剧本tag
---@field talkFinishScriptTag string 交任务剧本tag
---@field target number[] 目标类型列表，大小为目标个数
---@field targetArg number[][] 目标参数列表，大小为目标个数，单元为[目标参数,参数数量]
---@field targetPosition number[][] 目标坐标列表，大小为目标个数，单元为[场景id,posX,posY,posZ]
---@field dungeonPosition number[][] 副本入口坐标列表，大小为目标个数，结构同targetPosition
---@field ignoreNav boolean[] true若同一场景内不导航，大小为目标个数
---@field targetMsgEx any[] 目标特殊参数列表，大小为目标个数，类型不确定
---@field targetDesc any[] 目标描述列表，大小为目标个数，类型不确定
---@field taskTriggers number[][] 任务触发器列表，触发器格式[时机,时机参数,事件类型,事件参数,其他参数1,其他参数2,其他参数3]
---@field targetRunType number 目标执行方式(1.并列执行;2.依次执行;)
---@field isReminder boolean 是否在完成任务时显示反馈
---@field delegateNpcId number 增加好感度的npc对象id，已弃用
---@field delegateNpcFavors number 增加的好感度数值，已弃用
---@field taskLocationMap any 未知字段，已弃用
---@field rewardId number 奖励id
---@field typeTag number 不同类型任务所归属的页签 ETaskTag
---@field typeTitle string 任务类型显示于界面上的对应小标题
---@field targetSelectionType number 并行的任务目标如何追踪 EParallelTargetTrackType
---@field signTip number NPC头顶气泡(1.红色;2.蓝色;3.绿色;4.紫色;)
---@field finishTips string 完成任务时飘字
---@field navType number 寻路模式 ETaskNavType
---@field AcceptAutoPath number 接取后是否自动寻路(0.自动寻路;1.不自动寻路;)
---@field HideSymbol number NPC是否显示头顶符号(0.显示符号;1.不显示符号;)

---@param taskTableData TaskTableData
function TaskBase:ctor(taskTableData)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    ---@type TaskTableData
    self.tableData = taskTableData
    self.taskId = self.tableData.taskId
    self.taskStatus = l_taskMgr.ETaskStatus.NotTake
    ---@type TaskTargetBase[]
    self.taskTargetList = nil
    self.isParentTask = false
    self.isCycTask = false
    ---@type TaskTargetBase
    self.currentTaskTarget = nil
    --- 任务的可接时间，仅在可接的时候赋值
    self.showTime = 0
    --- 任务的完成时间限制
    self.totalTime = self.tableData.limitTime
    --- 可完成任务的剩余时间
    self.lastTime = self.totalTime
    self.currentStep = 0
    --- 任务在任务列表中的显示优先级，越小越优先
    self.showPriority = 0
end

function TaskBase:TryGetTargetTime()
    if self.currentTaskTarget == nil then
        return nil
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")

    if self.currentTaskTarget.targetType == l_taskMgr.ETaskTargetType.Dance then
        return {totalTime = self.currentTaskTarget.maxDanceTime,lastTime = self.currentTaskTarget.maxDanceTime - self.currentTaskTarget.customTime} 
    elseif self.currentTaskTarget.targetType == l_taskMgr.ETaskTargetType.DelayTime then
        return {totalTime = self.currentTaskTarget.maxDelayTime ,lastTime = self.currentTaskTarget.delayTime} 
    end
    return nil
end

function TaskBase:CheckIsPreTask( taskId )
    for i=1,#self.tableData.preTaskId do
        if taskId == self.tableData.preTaskId[i] then
            return true
        end
    end
    return false
end

function TaskBase:GetTargetByStep(idx)
    if self.taskTargetList == nil or #self.taskTargetList < idx then
        return nil
    end
    return self.taskTargetList[idx]
end

--获取当前任务进度  由子类(环任务:目前只有环任务有这个需求,后续其他有需求可以实现这个接口,或者新增子类实现)负责实现
function TaskBase:GetTaskProgress( ... )
    return nil
end

function TaskBase:GetMaxStep( ... )
    if self.taskTargetList == nil then
        return 0
    end
    return #self.taskTargetList
end

function TaskBase:GetCurrentStep( ... )
    if self.taskTargetList == nil then
        return 0 
    end
    local l_step = 0
    for i=1,#self.taskTargetList do
        if self.taskTargetList[i]:CheckTargetComplete() then
            l_step = l_step + 1
        end
    end
    return l_step
end

--同步任务数据
function TaskBase:SyncTaskData(taskInfo,isLogin)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_status = taskInfo.taskStatus
    --服务器不验证任务可接低等级  推送过来后  如果不满足截取条件则把该任务置为不可接状态
    if taskInfo.taskStatus == l_taskMgr.ETaskStatus.CanTake then
        if not self:CheckTaskCanAccept() then
            l_status = l_taskMgr.ETaskStatus.NotTake    
        end
    end
    self.time = taskInfo.time
    self.showTime = taskInfo.showTime
    if self.taskTargetList == nil then
        self:CreateTaskTargets(taskInfo.targets)
        self:SyncTaskTargets()
    else
        self:SyncTaskTargets(taskInfo.targets,true)     
    end
    return self:ChangeTaskStatus(l_status,isLogin)
end

function TaskBase:TaskLimitTime()
    if self.taskStatus ~= MgrMgr:GetMgr("TaskMgr").ETaskStatus.Taked then
        self.lastTime = 0
        return
    end
    local l_currentTime = Common.TimeMgr.GetNowTimestamp()
    local l_finishTime = self.time + self.totalTime
    self.lastTime = l_finishTime - l_currentTime
    if self.lastTime < 0 then
        self.lastTime = 0
    end
end


--创建任务目标
function TaskBase:CreateTaskTargets(targets)
    self.taskTargetList = {}
    self.currentTaskTarget = nil

    local l_targetDatas = {}
    --服务器未下发任务目标直接取配置数据
    if targets == nil or #targets == 0 then
        l_targetDatas = self:CreateTargetDataByConfig()   
    else
    --服务器下发数据直接用服务器数据并从配置数据中取缺少的字段数据
        l_targetDatas = self:CreateTargetDataByServer(targets)   
    end
    if #l_targetDatas == 0 then
        logError("task <"..self.taskId.."> targets is empty !")
    end
    for i=1,#l_targetDatas do
        local l_taskTarget = self:CreateTaskTarget(i,self.taskId,l_targetDatas[i])
        if l_taskTarget ~= nil then
            table.insert(self.taskTargetList,l_taskTarget)
        end
    end
end

function TaskBase:CreateTargetDataByConfig(  )
    local l_targetDatas = {}
    for i=1,#self.tableData.target do
        local l_targetData = self:ParseTargetData(i)
        table.insert(l_targetDatas,l_targetData)
    end  
    return l_targetDatas
end

function TaskBase:CreateTargetDataByServer(targets)
    local l_targetDatas = {}
    for i=1,#targets do
        local l_targetData = self:ParseTargetData(i,targets[i])
        table.insert(l_targetDatas,l_targetData)
    end
    return l_targetDatas
end

--同步任务目标
function TaskBase:SyncTaskTargets(targets,tips)
    --有服务器下发的数据则尝试重写任务目标数据
    if targets ~= nil then
        self:OverrideTaskTarget(targets)
    end
    for i=1,#self.taskTargetList do
        local l_taskTarget = self.taskTargetList[i]
        if l_taskTarget ~= nil then
            if targets ~= nil then
                if i > #targets then
                    break
                end
                -- logError("TaskBase:SyncTaskTargets:"..self.taskId)
                local l_taskTargetStep = {}
                l_taskTargetStep.step = targets[i].step
                l_taskTargetStep.maxStep = targets[i].maxStep  
                l_taskTarget:SyncTargetStep(l_taskTargetStep,tips)  
                l_taskTarget:UpdataExData(targets[i])
            end
        end
    end
end

function TaskBase:CompareTargets(targets)
    --如果服务器下发目标数量与当前任务目标数量不同  或者有任何一个任务目标数据不同则认为目标不同步 需要重写
    if #targets ~= #self.taskTargetList then
        return false
    end
    for i=1,#targets do
        if not self.taskTargetList[i]:CompareTarget(targets[i]) then
            return false
        end
    end
    return true
end

--重写任务目标
function TaskBase:OverrideTaskTarget(targets)
    if self:CompareTargets(targets) then
        return
    end
    for i=1,#self.taskTargetList do
        self.taskTargetList[i]:Destroy()
    end
    self.taskTargetList = {}
    self:CreateTaskTargets(targets)
end

--转换任务目标数据  
function TaskBase:ParseTargetData(index,targetInfo)
    local l_targetData = {}
    if targetInfo ~= nil then
        l_targetData.Id = targetInfo.Id
        l_targetData.targetType = targetInfo.type
        l_targetData.targetId = targetInfo.targetId
        l_targetData.targetArg = targetInfo.targetArg
        l_targetData.step = targetInfo.step
        l_targetData.maxStep = targetInfo.maxStep
        l_targetData.customTime = targetInfo.customTime
    else
        --如果目标数据为空  则通过配置构建任务目标数据否则使用服务器下发数据
        l_targetData.Id = 0
        l_targetData.targetType = self.tableData.target[index]
        l_targetData.targetId = self.tableData.targetArg[index][1]
        l_targetData.targetArg = self.tableData.targetArg[index][2]
        l_targetData.step = 0
        if l_targetData.targetType == MgrMgr:GetMgr("TaskMgr").ETaskTargetType.NpcTalk then
            l_targetData.maxStep = 1
        else
            l_targetData.maxStep = self.tableData.targetArg[index][2]
        end
        l_targetData.customTime = 0
    end
    --如果id为0 说明该任务目标来自任务表 否则是环任务  任务目标由TaskTargetLibrary提供数据
    if l_targetData.Id == 0 then
        l_targetData.navPosition = self.tableData.targetPosition[index]
        l_targetData.dungeonPosition = self.tableData.dungeonPosition[index]
        l_targetData.msgEx = self.tableData.targetMsgEx[index]
        l_targetData.desc = self.tableData.targetDesc[index]   
        l_targetData.ignoreNav = self.tableData.ignoreNav[index]
        return l_targetData
    end

    local l_targetCon = TableUtil.GetTaskTargetLibrary().GetRowByID(l_targetData.Id)
    if l_targetCon == nil then
        logError("targetId<"..l_targetData.Id.."> not exists in TaskTargetLibrary ")
        return l_targetData
    end

    local l_targetArgCon = l_targetCon.Target

    if l_targetArgCon.Count > 0 then
        local l_targetArgs = Common.Functions.VectorSequenceToTable(l_targetArgCon)
        l_targetData.navPosition = l_targetArgs[3]
        l_targetData.dungeonPosition = nil
        if #l_targetArgs > 3 then
            l_targetData.dungeonPosition = l_targetArgs[4]
        end
    end
    l_targetData.msgEx = l_targetCon.SpecialMes
    l_targetData.desc = l_targetCon.TargetDes
    l_targetData.ignoreNav = false     
    return l_targetData
end

--等级改变时任务数据需要更新
function TaskBase:UpdateTaskStatuWithLvUp()
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self:CheckTaskCanAccept() then
        if self.taskStatus == l_taskMgr.ETaskStatus.NotTake then
            self:ChangeTaskStatus(l_taskMgr.ETaskStatus.CanTake)
        end
    end
end

function TaskBase:CheckTaskCanAccept( ... )
    return  MgrMgr:GetMgr("TaskMgr").CanTakeTask(self.tableData)
end

function TaskBase:GetTaskDescribe( ... )
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus == l_taskMgr.ETaskStatus.CanTake or self.taskStatus == l_taskMgr.ETaskStatus.NotTake then
        return self.tableData.descAcceptable
    elseif self.taskStatus == l_taskMgr.ETaskStatus.Taked or self.taskStatus == l_taskMgr.ETaskStatus.Failed then
        if self:TargetRunTypeSequence() and self.currentTaskTarget ~= nil then
            if self.currentTaskTarget ~= nil then
                return self.currentTaskTarget.desc
            end
        else
            if self.taskTargetList and #self.taskTargetList > 0 then
                return self.taskTargetList[1].desc
            end
        end
    elseif self.taskStatus == l_taskMgr.ETaskStatus.CanFinish then
        return self.tableData.descCanFinish
    end
    return nil
end

function TaskBase:GetTaskLimitStrForUI(isTaskUI)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus == l_taskMgr.ETaskStatus.Taked then
        local l_timeStr = self:GetTaskTakedLimitStr()
        if isTaskUI ~= nil and l_timeStr ~= nil then
            return StringEx.Format(Common.Utils.Lang("TASK_LAST_TIME"),l_timeStr)
        end
        return l_timeStr
    elseif self.taskStatus == l_taskMgr.ETaskStatus.NotTake then
        return self:GetTaskNotTakeLimitStr()
    elseif self.taskStatus == l_taskMgr.ETaskStatus.CanTake and self:AcceptMail() then
        return Common.Utils.Lang("TASK_ACCEPT_MAIL")
    elseif self.taskStatus == l_taskMgr.ETaskStatus.Failed then
        return Common.Utils.Lang("TASK_FAILED_TIP")
    end
    return nil
end

--时间限制
function TaskBase:GetTaskTakedLimitStr( ... )
    if self.totalTime ~= nil and self.totalTime > 0 then
        return Common.Functions.SecondsToTimeStr(self.lastTime)
    end
    return nil
end

--获取任务不可接时的限制条件
function TaskBase:GetTaskNotTakeLimitStr( ... )
    local l_minBaseLv = self.tableData.minBaseLevel
    local l_maxBaseLv = self.tableData.maxBaseLevel

    local l_minJobLv = self.tableData.minJobLevel
    local l_maxJobLv = self.tableData.maxJobLevel

    local l_playerLv = MPlayerInfo.Lv
    local l_playerJobLv = MPlayerInfo.JobLv

    if l_minBaseLv ~= 0 and l_playerLv < l_minBaseLv then
        return StringEx.Format(Common.Utils.Lang("TASK_ACCEPT_BASE_LEVEL"),l_minBaseLv)
    end
    if l_maxBaseLv ~= 0 and l_playerLv > l_maxBaseLv then
        return StringEx.Format(Common.Utils.Lang("TASK_ACCEPT_BASE_LEVEL"),l_maxBaseLv)
    end  


    if l_minJobLv ~= 0 and l_playerJobLv < l_minJobLv then
        return StringEx.Format(Common.Utils.Lang("TASK_ACCEPT_JOB_LEVEL"),l_minJobLv)
    end
    if l_maxJobLv ~= 0 and l_playerJobLv > l_maxJobLv then
        return StringEx.Format(Common.Utils.Lang("TASK_ACCEPT_JOB_LEVEL"),l_maxJobLv)
    end  
    return nil
end

function TaskBase:UpdateShowPriorityWithStatus( status )
    local l_taskMgr =  MgrMgr:GetMgr("TaskMgr")
    if status == l_taskMgr.ETaskStatus.NotTake then
        local l_tagData = TableUtil.GetTaskTypeTable().GetRowById(self.tableData.taskType)
        if l_tagData ~= nil then
            self.showPriority = l_tagData.UnTakeOrder
        end
    else
        if self.taskStatus == l_taskMgr.ETaskStatus.NotTake then
            local l_tagData = TableUtil.GetTaskTypeTable().GetRowById(self.tableData.taskType)
            if l_tagData ~= nil then
                self.showPriority = l_tagData.Order
            end 
        end
    end
end

--更新任务状态 返回是否刚接到任务  逻辑简单  不需要FSM
function TaskBase:ChangeTaskStatus(status,isLogin)
    self:UpdateShowPriorityWithStatus(status)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_preStep = self.currentStep
    --如果修改前后任务状态相同只需要同步目标 不需要做其他处理
    if self.taskStatus == status then
        self:UpdateTargetsStatus()
        if isLogin then--如果是登陆进来的初始化数据  这是引导NPC位置
            MgrMgr:GetMgr("TaskGuideNpcMgr").OnTaskInit(self.taskId, self.taskStatus,self.currentStep)
        else
            if self.taskStatus == l_taskMgr.ETaskStatus.Taked then
                if self.currentStep ~= l_preStep then 
                    --当前任务目标完成情况有更新
                    l_taskMgr.UpdateSelectTaskNavigation(self)
                    --抛出任务状态有改变的事件供外部使用 参1 任务Id  参2 当前状态 参3 当前进度(除已接取之外均为0)
                    GlobalEventBus:Dispatch(EventConst.Names.TaskStatusUpdate, self.taskId, self.taskStatus,self.currentStep)
                    GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskUIFx,self.taskId)

                end
            end
        end
        self:TaskLimitTime()
        return false
    end
    --删除旧状态的NPC
    self:RemoveTaskNpc()
    --设置新的状态
    self.taskStatus = status

    self:UpdateTargetsStatus()
    --根据切换后的状态添加关联NPC
    self:AddTaskNpc()

    --状态变更事件
    if isLogin then
        MgrMgr:GetMgr("TaskGuideNpcMgr").OnTaskInit(self.taskId, self.taskStatus,self.currentStep)
    else
        l_taskMgr.UpdateSelectTaskNavigation(self)
        GlobalEventBus:Dispatch(EventConst.Names.TaskStatusUpdate, self.taskId, self.taskStatus,self.currentStep)
    end

    self:TaskLimitTime()
    if self.taskStatus == l_taskMgr.ETaskStatus.Taked then
        return true
    end
    -- if self.taskStatus == MgrMgr:GetMgr("TaskMgr").ETaskStatus.CanTake and self:AcceptMail() then
    --     self:NavigationByCanTake()
    -- end

    return false
end

--根据当前状态更新目标数据
function TaskBase:UpdateTargetsStatus(isLogin)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_seqTargetType = self.tableData.targetSelectionType == l_taskMgr.EParallelTargetTrackType.Sequence
    local l_hasTarget = false  
    for i=1,#self.taskTargetList do
        local l_taskTarget = self.taskTargetList[i]
        if l_taskTarget ~= nil then
            if self.taskStatus ~= l_taskMgr.ETaskStatus.Taked then
                l_taskTarget:RemoveTaskEvent()
                if self.currentTaskTarget ~= nil then
                    self.currentTaskTarget = nil 
                end
            else
                local l_completed = l_taskTarget:CheckTargetComplete()
                --如果该目标未完成  设置第一个未完成的目标为当前目标
                if not l_completed then
                    --若任务目标为串行  退出同步
                    if self:TargetRunTypeSequence() then
                        l_taskTarget:AddTaskEvent()
                        if self.currentTaskTarget ~= l_taskTarget then
                            self.currentTaskTarget = l_taskTarget
                        end
                        break
                    else
                        l_taskTarget:AddTaskEvent()
                        --如果无当前目标并且并行导航方式为顺序则设置当前目标  选择方式的由外部确认
                        if not l_hasTarget and l_seqTargetType then
                            self.currentTaskTarget = l_taskTarget
                            l_hasTarget = true
                        end
                    end    
                else   
                    l_taskTarget:RemoveTaskEvent()            
                end   
            end
        end
    end
    self.currentStep = self:GetCurrentStep()
    -- logGreen("task = "..self.taskId.."l_currentStep:"..self.currentStep)
end

--任务只需要处理接取及交付的NPC相关，TAKED状态由相应目标自身处理npc数据
--添加任务对应NPC挂载数据
function TaskBase:AddTaskNpc()
    -- logGreen("AddTaskNpc taskId:"..self.taskId)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus == l_taskMgr.ETaskStatus.CanTake and self:AcceptNormal() then
        -- logGreen("add accept npc:"..self.taskId)
        l_taskMgr.AddNpcInfo(self.tableData.acceptNpcMapId, self.tableData.acceptNpcId,self)
    elseif self.taskStatus  == l_taskMgr.ETaskStatus.CanFinish and self:FinishNormal() then
        -- logGreen("add finish npc:"..self.taskId)
        l_taskMgr.AddNpcInfo(self.tableData.finishNpcMapId, self.tableData.finishNpcId,self)
    end
end

--删除任务对应NPC挂载数据
function TaskBase:RemoveTaskNpc()
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus  == l_taskMgr.ETaskStatus.CanTake and self:AcceptNormal() then
        -- logGreen("remove accept npc:"..self.taskId)
        --可接取状态 清除接取NPC
        l_taskMgr.RemoveNpcInfo(self.tableData.acceptNpcMapId, self.tableData.acceptNpcId, self)
    elseif self.taskStatus  == l_taskMgr.ETaskStatus.CanFinish and self:FinishNormal() then
        -- logGreen("remove finish npc:"..self.taskId)
        --可完成状态 清除交付NPC
        l_taskMgr.RemoveNpcInfo(self.tableData.finishNpcMapId, self.tableData.finishNpcId, self)
    end
end

--是否需要显示小地图
function TaskBase:MiniMapFilter()
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_notTake = self.taskStatus == l_taskMgr.ETaskStatus.NotTake 
    if self.tableData.taskType == l_taskMgr.ETaskType.WorldEvent then
        l_notTake = self.taskStatus == l_taskMgr.ETaskStatus.NotTake or self.taskStatus == l_taskMgr.ETaskStatus.CanTake
    end
    return l_notTake
    -- local l_notTake = self.taskStatus == l_taskMgr.ETaskStatus.NotTake or self.taskStatus == l_taskMgr.ETaskStatus.CanTake
    -- local l_showTaked = self.tableData.acceptShowType == l_taskMgr.ETaskShowType.Default
    -- return l_notTake and l_showTaked
end

--新接到任务时是否立即寻路
function TaskBase:NavigateAtOnce()
    return not self.isParentTask
end

--是否需要显示 包含NPC数据  param isTaskUI = true taskctrl需要的数据
function TaskBase:NeedShow( isTaskUI )
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_showType = self.tableData.acceptShowType

    if l_showType == l_taskMgr.ETaskShowType.None then
        return false
    end

    -- if self.taskStatus == l_taskMgr.ETaskStatus.NotTake and not self:CheckPushLv() then
    if self.taskStatus == l_taskMgr.ETaskStatus.NotTake and not l_taskMgr.ValidateTaskAcceptableByTableData(self.tableData) and l_showType ~= l_taskMgr.ETaskShowType.BeforeAccept then
        return false
    end

    if l_showType == l_taskMgr.ETaskShowType.None then
        return false
    elseif l_showType == l_taskMgr.ETaskShowType.Default then
        if self.taskStatus == l_taskMgr.ETaskStatus.NotTake or self.taskStatus == l_taskMgr.ETaskStatus.CanTake then
            return false
        end
    elseif l_showType == l_taskMgr.ETaskShowType.Acceptable then
        if self.taskStatus == l_taskMgr.ETaskStatus.NotTake then
            return false
        end
    elseif l_showType == l_taskMgr.ETaskShowType.OnlyUI then

        if self.taskStatus == l_taskMgr.ETaskStatus.NotTake then
                return false
        end
        if self.taskStatus == l_taskMgr.ETaskStatus.CanTake then
            if not isTaskUI then
                return false
            end
        end
    end

    local l_hideLevel = self.tableData.hideBaseLevel
    if l_hideLevel > 0 and not isTaskUI then
        if MPlayerInfo.Lv > l_hideLevel then
            if self.taskStatus == l_taskMgr.ETaskStatus.NotTake 
                or self.taskStatus == l_taskMgr.ETaskStatus.CanTake then
                return false
            end
        end
    end
    return self:CheckSubTaskShow()
end

--是否需要在任务面板显示仅UI  param isTaskUI = true taskctrl需要的数据
function TaskBase:NeedShowOnUI( isTaskUI ,includeAcceptable ,selectTag )
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")

    if self.tableData.typeTag ~= selectTag then
        return false
    end

    local l_notTaked = self.taskStatus == l_taskMgr.ETaskStatus.NotTake or self.taskStatus == l_taskMgr.ETaskStatus.CanTake
    if l_notTaked and not includeAcceptable then
        return false
    end
    return self:NeedShow(isTaskUI)
end

function TaskBase:GetParentTaskId( ... )
    return  MgrMgr:GetMgr("TaskMgr").GetParentTaskIdWithSubTaskId(self.taskId)
end

function TaskBase:CheckSubTaskShow()
    local l_parentId = self:GetParentTaskId()
    if l_parentId == nil then
        return true
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")

    local l_parentTask = l_taskMgr.GetTaskList()[l_parentId]
    local l_parentTaskStatus = l_parentTask.taskStatus
    --如果父任务未接  子任务不显示
    if l_parentTaskStatus == l_taskMgr.ETaskStatus.NotTake or l_parentTaskStatus == l_taskMgr.ETaskStatus.CanTake then
        return false
    end
    --父任务已接  子任务非玩家自选  显示当前需要做的子任务
    if l_parentTask.currentTaskTarget == nil then
        return false
    end
    if l_parentTask.currentTaskTarget.targetId ~= self.taskId then
        return false
    end
    return true
end

function TaskBase:NeewShowTargets()
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus == l_taskMgr.ETaskStatus.NotTake or 
        self.taskStatus == l_taskMgr.ETaskStatus.CanTake or 
        self.taskStatus == l_taskMgr.ETaskStatus.CanFinish then
        return false
    end
    return true

end

--获取追踪面板任务目标描述
function TaskBase:GetTaskTrackTargetDesc()

    local l_targetsDesc = {}
    if self:TargetRunTypeSequence() and self.currentTaskTarget ~= nil then
        local l_targetDesc = self.currentTaskTarget:GetTaskTargetDescribeQuick()
        if l_targetDesc ~= nil then
            table.insert(l_targetsDesc,l_targetDesc)
        end
    else
        if self.taskTargetList then
            for i = 1, #self.taskTargetList do
                local l_targetDesc = self.taskTargetList[i]:GetTaskTargetDescribeQuick()
                if l_targetDesc ~= nil then
                    table.insert(l_targetsDesc,l_targetDesc)
                end
            end
        end
    end
    return l_targetsDesc
end

function TaskBase:GetTaskUITargetDesc()
    local l_targetsDesc = {}
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus == l_taskMgr.ETaskStatus.NotTake or self.taskStatus == l_taskMgr.ETaskStatus.CanTake then
        l_targetsDesc = self:GetNotTakeTargetDesc()
    else
        l_targetsDesc = self:GetTakedTargetDesc()
    end
    return l_targetsDesc
end

function TaskBase:GetTakedTargetDesc()
    local l_targetsDesc = {}
    if self:TargetRunTypeSequence() and self.currentTaskTarget ~= nil then
        local l_targetDesc = self.currentTaskTarget:GetTaskTargetDescribe()
        if l_targetDesc ~= nil then
            local l_targetInfo = {}
            l_targetInfo.desc = l_targetDesc
            l_targetInfo.step = self.currentTaskTarget:GetTaskTargetStepTip()
            l_targetInfo.completed = false
            table.insert(l_targetsDesc,l_targetInfo)
        end
    elseif self.taskTargetList then
        for i = 1, #self.taskTargetList do
            local l_targetDesc = self.taskTargetList[i]:GetTaskTargetDescribe()
            if l_targetDesc ~= nil then
                local l_targetInfo = {}
                l_targetInfo.desc = l_targetDesc
                l_targetInfo.step = self.taskTargetList[i]:GetTaskTargetStepTip()
                l_targetInfo.completed = self.taskTargetList[i]:CheckTargetComplete()
                if l_targetInfo.completed then
                    l_targetInfo.step = Common.Utils.Lang("EDEN_TASK_FINISHED")
                end
                table.insert(l_targetsDesc,l_targetInfo)
            end
        end
    end
    return l_targetsDesc
end

function TaskBase:GetNotTakeTargetDesc( )
    local l_targetsDesc = {}
    if self.taskTargetList then
        if self:TargetRunTypeSequence() then
            local l_targetDesc = self.taskTargetList[1]:GetTaskTargetDescribe()
            if l_targetDesc ~= nil then
                local l_targetInfo = {}
                l_targetInfo.desc = l_targetDesc
                l_targetInfo.step = self.taskTargetList[1]:GetTaskTargetStepTip()
                l_targetInfo.completed = false
                table.insert(l_targetsDesc,l_targetInfo)
            end
        else
            for i=1,#self.taskTargetList do
                local l_targetDesc = self.taskTargetList[i]:GetTaskTargetDescribe()
                if l_targetDesc ~= nil then
                    local l_targetInfo = {}
                    l_targetInfo.desc = l_targetDesc
                    l_targetInfo.step = self.taskTargetList[i]:GetTaskTargetStepTip()
                    l_targetInfo.completed = false
                    table.insert(l_targetsDesc,l_targetInfo)
                end
            end
        end
    end
    return l_targetsDesc
end

--任务目标执行是否是串行
function TaskBase:TargetRunTypeSequence( ... )
    return self.tableData.targetRunType == MgrMgr:GetMgr("TaskMgr").ETargetRunType.Sequence
end

--任务接取和交付类型判断
------------------------begin--------------------------------
---@return boolean true若接取形式为正常对话接取
function TaskBase:AcceptNormal( ... )
    return self.tableData.acceptType == MgrMgr:GetMgr("TaskMgr").ETaskAcceptType.Normal
end

---@return boolean true若接取形式为飞鸽传书接取
function TaskBase:AcceptMail( ... )
    return self.tableData.acceptType == MgrMgr:GetMgr("TaskMgr").ETaskAcceptType.Mail
end

function TaskBase:FinishNormal( ... )
    return self.tableData.finishType == MgrMgr:GetMgr("TaskMgr").ETaskFinishType.Normal
end
------------------------end--------------------------------

--任务导航相关
------------------------begin--------------------------------
function TaskBase:TaskNavigation( ... )

    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")

    if l_taskMgr.TaskNavigationLocked() then
        return
    end

    if MEntityMgr.PlayerEntity ~= nil then
        --公共坐骑上不导航
        if MEntityMgr.PlayerEntity.IsRidePubVehicle then
            return
        end
        --取消Special状态
        MEventMgr:LuaFireEvent(MEventType.MEvent_ClientActiveStopSpecial, MEntityMgr.PlayerEntity)
    end

    --跑商任务 特判不打断原有行为队列
    if self.taskId ~= l_taskMgr.BusinessLineTaskId then
        MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
    end

    MgrMgr:GetMgr("ActionTargetMgr").StopAutoBattle()
    
    local l_navType = self.tableData.navType
    local l_success = true  --该值控制是否需要设置当前追踪  状态为:不可接及失败的任务不设置追踪  已接任务下发给任务目标来决定是否追踪
    --所有任务导航均需要先根据导航数据请求服务器路径  用于加小地图标识
    if self.taskStatus == l_taskMgr.ETaskStatus.NotTake then  --不可接
        self:NavigationByNotTake()
        l_success = false
    elseif self.taskStatus == l_taskMgr.ETaskStatus.CanTake then --可接
        self:NavigationByCanTake(l_navType)
    elseif self.taskStatus == l_taskMgr.ETaskStatus.Taked then --已接(由具体目标控制)
        self:NavigationByTaked(l_navType)
    elseif self.taskStatus == l_taskMgr.ETaskStatus.Failed then  --失败
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_FAILED_TIP"))
        l_success = false
    elseif self.taskStatus == l_taskMgr.ETaskStatus.CanFinish and self:FinishNormal() then --已完成 可交付
        self:NavigationByFinish(l_navType)
    end
    if Application.isEditor then
        logYellow("click task id:"..tostring(self.taskId))
    end
    if l_success then
        l_taskMgr.SetSelectTask(self)
    else
        l_taskMgr.SetSelectTask(nil)
    end
end

function TaskBase:GetNavigationData()
    local l_taskMgr =  MgrMgr:GetMgr("TaskMgr")
    if self.tableData.navType == l_taskMgr.ETaskNavType.Invalid then
        return nil
    end
    if self.taskStatus == l_taskMgr.ETaskStatus.NotTake then  --不可接
        return nil
    elseif self.taskStatus == l_taskMgr.ETaskStatus.CanTake and self:AcceptNormal() then --可接
        local l_npcPos = MSceneMgr:GetNpcPos(self.tableData.acceptNpcId, self.tableData.acceptNpcMapId, self.taskId)
        if l_npcPos.x == -1 or l_npcPos.y == -1 or l_npcPos.z == -1 then
            logRed("任务<"..self.taskId..">接取NPC<"..self.tableData.acceptNpcId..">坐标<"..tostring(l_npcPos)..">不合法  弱网时出现是正常现象请忽略 最终解释权归cmd所有")
            return nil
        else 
            local l_navData = {}
            l_navData.sceneId = self.tableData.acceptNpcMapId
            l_navData.position = l_npcPos
            return l_navData
        end
    elseif self.taskStatus == l_taskMgr.ETaskStatus.Taked then --已接(由具体目标控制)
        if self.currentTaskTarget ~= nil then  --当前任务目标的导航
            return self.currentTaskTarget:GetNavigationData()
        else
            return nil
        end
    elseif self.taskStatus == l_taskMgr.ETaskStatus.Failed then  --失败
        return nil
    elseif self.taskStatus == l_taskMgr.ETaskStatus.CanFinish and self:FinishNormal() then --已完成 可交付
        local l_npcPos = MSceneMgr:GetNpcPos(self.tableData.finishNpcId, self.tableData.finishNpcMapId, self.taskId)
        if l_npcPos.x == -1 or l_npcPos.y == -1 or l_npcPos.z == -1 then
            logRed("任务<"..self.taskId..">交付NPC<"..self.tableData.finishNpcId..">坐标<"..tostring(l_npcPos)..">不合法  弱网时出现是正常现象请忽略 最终解释权归cmd所有")
            return nil
        else 
            local l_navData = {}
            l_navData.sceneId = self.tableData.finishNpcMapId
            l_navData.position = l_npcPos
            return l_navData
        end
    end
    return nil
end


function TaskBase:NavigationInDungeon(sceneId)
    return MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon() and MScene.SceneID ~= sceneId
end

function TaskBase:NavigationByNotTake( ... )
    local l_minBaseLv = self.tableData.minBaseLevel
    local l_maxBaseLv = self.tableData.maxBaseLevel
    local l_minJobLv = self.tableData.minJobLevel
    local l_maxJobLv = self.tableData.maxJobLevel
    local l_playerLv = MPlayerInfo.Lv
    local l_playerJobLv = MPlayerInfo.JobLv
    local l_tips_idx = 1
    if l_minBaseLv ~= 0 and l_playerLv < l_minBaseLv then
        --等级不够提示经验获取途径
        UIMgr:ActiveUI(UI.CtrlNames.ExpAchieveTips, function(ctrl)
            ctrl:ShowExpAchieve(l_minBaseLv)
        end)
    elseif l_maxBaseLv ~= 0 and l_playerLv > l_maxBaseLv then
        l_tips_idx = 2

    elseif l_minJobLv ~= 0 and l_playerJobLv < l_minJobLv then
          l_tips_idx = 3

    elseif l_maxJobLv ~= 0 and l_playerJobLv > l_maxJobLv then
        l_tips_idx = 4
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang(StringEx.Format("TASK_ACCEPT_VALIDATE_TIP_{0}",l_tips_idx)))
end

function TaskBase:NavigationByCanTake( navType )

    if self:AcceptNormal() then
        local l_taskMgr =  MgrMgr:GetMgr("TaskMgr")
        if self:CheckNavgationInvalid(navType) then
            return
        end
        if self:NavigationInDungeon(self.tableData.acceptNpcMapId) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_NAVIGATION_IN_DUNGEON_TIP")) 
            --副本目标提示增强
            MgrMgr:GetMgr("DungeonTargetMgr").TaskGuideToDungeonsTarget()
            return
        end
        if navType ==l_taskMgr.ETaskNavType.Normal  then
            self:TalkWithTaskNpc(self.tableData.acceptNpcId,self.tableData.acceptNpcMapId)
        end
    elseif self:AcceptMail() then
        local l_actionMgr = MgrMgr:GetMgr("ActionTargetMgr")
        l_actionMgr.ResetActionQueue()
        l_actionMgr.StopAutoBattle()
        MgrMgr:GetMgr("TaskMgr").ShowTaskAcceptMail(self.taskId)
    end
end

function TaskBase:NavigationByTaked(navType )
    if self:CheckNavgationInvalid(navType) then
        -- logError("NavigationByTaked Invalid")
        return 
    end
    if self.currentTaskTarget ~= nil then  --当前任务目标的导航
        local l_needToDungeons,l_dungeonId = self.currentTaskTarget:CheckNeedEnterDungeons()
        if l_needToDungeons then --检测该任务是否需要进入镜像副本
            logRed("需要进入镜像副本:"..l_dungeonId..",如果寻路不正确，请检查该任务"..self.taskId.."是否有正确的镜像副本触发器")
            return 
        end
        -- logError("NavigationByTaked currentTaskTarget:"..self.currentTaskTarget.targetType)
        self.currentTaskTarget:TargetNavigation(navType)
        return 
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_seqTargetType = self.tableData.targetSelectionType == l_taskMgr.EParallelTargetTrackType.Sequence
    -- logError("NavigationByTaked currentTaskTarget :"..tostring(l_seqTargetType))

    if not l_seqTargetType then
        local l_targets = {}
        for i=1,#self.taskTargetList do
            local l_taskTarget = self.taskTargetList[i]
            if not l_taskTarget:CheckTargetComplete() then
                table.insert(l_targets,l_taskTarget)
            end
        end
        if #l_targets == 1 then
            l_targets[1]:TargetNavigation(navType)
            return 
        end
        UIMgr:ActiveUI(UI.CtrlNames.TaskNavigation,function ( ctrl )
            ctrl:SetNavigationData(self,l_targets)
        end)
        return 
    end
    return 
end

function TaskBase:NavigationByFinish(navType)
    local l_taskMgr =  MgrMgr:GetMgr("TaskMgr")
    if self:CheckNavgationInvalid(navType) then
        return
    end
    if self:NavigationInDungeon(self.tableData.finishNpcMapId) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_NAVIGATION_IN_DUNGEON_TIP")) 
        --副本目标提示增强
        MgrMgr:GetMgr("DungeonTargetMgr").TaskGuideToDungeonsTarget()
        return
    end
    if navType ==l_taskMgr.ETaskNavType.Normal  then
        self:TalkWithTaskNpc(self.tableData.finishNpcId, self.tableData.finishNpcMapId)
    end
end

function TaskBase:CheckNavgationInvalid(navType)
    local l_taskMgr =  MgrMgr:GetMgr("TaskMgr")
    if navType == l_taskMgr.ETaskNavType.Invalid then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_NAV_INVALID_TIP"))
        return true
    elseif navType == l_taskMgr.ETaskNavType.Explore then  --这个模式只提示 会继续走寻路逻辑
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_NAVIGATION_BY_YOURSELF")) 
    end
    return false
end

function TaskBase:TalkWithTaskNpc( npcId,sceneId )
    local l_actionMgr = MgrMgr:GetMgr("ActionTargetMgr")
    l_actionMgr.ResetActionQueue()
    l_actionMgr.StopAutoBattle()
    l_actionMgr.MoveToTalkWithNpc(sceneId, npcId)
end


function TaskBase:QuickGiveUp( ... )
    return false
end
------------------------end--------------------------------

--获取该任务所需任务道具
function TaskBase:GetTaskNeedItem()
    local l_items = {}
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus ~= l_taskMgr.ETaskStatus.Taked then
        return l_items
    end
    --串行道具需求
    if self:TargetRunTypeSequence() and self.currentTaskTarget ~= nil then
        if self.currentTaskTarget.targetType ~= l_taskMgr.ETaskTargetType.ItemCollect and self.currentTaskTarget.targetType ~= l_taskMgr.ETaskTargetType.DyncItemRecycle then
            return l_items
        end
        local l_itemId = self.currentTaskTarget.targetId
        local l_itemCnt = self.currentTaskTarget.maxStep
        local l_itemInfo = {
            ID = l_itemId,
            Count = l_itemCnt
        }
        table.insert(l_items,l_itemInfo)
    else
        for i=1,#self.taskTargetList do
            local l_taskTarget = self.taskTargetList[i]
            if not l_taskTarget:CheckTargetComplete() then
                if l_taskTarget.targetType == l_taskMgr.ETaskTargetType.ItemCollect or l_taskTarget.targetType == l_taskMgr.ETaskTargetType.DyncItemRecycle then
                    local l_itemId = l_taskTarget.targetId
                    local l_itemCnt = l_taskTarget.maxStep
                    local l_itemInfo = {
                        ID = l_itemId,
                        Count = l_itemCnt
                    }
                    table.insert(l_items,l_itemInfo)
                end
            end
        end
    end
    return l_items
end

function TaskBase:GetTitleColor()
    local l_taskType = self.tableData.taskType
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if l_taskType == l_taskMgr.ETaskType.Main or l_taskType == l_taskMgr.ETaskType.Surprise or l_taskType == l_taskMgr.ETaskType.Adventure then
        return RoColorTag.Yellow
    end
    return RoColorTag.Blue
end

function TaskBase:GiveUp()
    self:RemoveTaskNpc()
    for i=1,#self.taskTargetList do
        self.taskTargetList[i]:GiveUp()
    end
    self.currentTaskTarget = nil
end

function TaskBase:Destroy()
    -- 根据任务状态
    -- logError("task :"..self.taskId.." destroy")
    -- self:RemoveChildrenTask()
    self:RemoveTaskNpc()
    if self.taskTargetList ~= nil then
        for i=1,#self.taskTargetList do
            self.taskTargetList[i]:Destroy()
        end
        self.taskTargetList = nil
    end
    self.currentTaskTarget = nil
end

--创建任务目标类
function TaskBase:CreateTaskTarget(targetIndex,taskId,targetData, stepInfo)
    if targetData == nil then return nil end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if targetData.targetType == l_taskMgr.ETaskTargetType.NpcTalk then
        --对话(对应NpcTable)
        require "Task/TaskTargets/TaskTargetTalk"
        return TaskTargetTalk.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.MonsterFarm then
        --打怪(对应EntityTable)
        require "Task/TaskTargets/TaskTargetKillEnemy"
        return TaskTargetKillEnemy.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Collection then
        --采集(对应CollectTable)
        require "Task/TaskTargets/TaskTargetCollect"
        return TaskTargetCollect.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.ItemCollect then
        --收集(回收)(对应ItemTable)
        require "Task/TaskTargets/TaskTargetSearch"
        return TaskTargetSearch.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Navigation then
        --寻路(对应SceneTable)
        require "Task/TaskTargets/TaskTargetNavigation"
        return TaskTargetNavigation.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.UseItem then
        --使用道具(对应ItemTable)
        require "Task/TaskTargets/TaskTargetUseItem"
        return TaskTargetUseItem.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.DungeonComplete then
        --完成副本(对应DungeonsTable)
        require "Task/TaskTargets/TaskTargetDungeonsComplete"
        return TaskTargetDungeonsComplete.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.SystemComplete then
        --完成某项功能(对应OpenSystemTable)
        require "Task/TaskTargets/TaskTargetDoFunction"
        return TaskTargetDoFunction.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.TakePhotograph then
        --拍照
        require "Task/TaskTargets/TaskTargetPhotograph"
        return TaskTargetPhotograph.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.ActivityComplete then
        --完成某项活动(对应ActivitiesTable)
        require "Task/TaskTargets/TaskTargetActivity"
        return TaskTargetActivity.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Achievement then
        --完成某个成就(对应AchievementDetailTable)
        require "Task/TaskTargets/TaskTargetAchievement"
        return TaskTargetAchievement.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.MonsterLoot then
        --打怪掉落(对应ItemTable)
        require "Task/TaskTargets/TaskTargetMonsterLoot"
        return TaskTargetMonsterLoot.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.ParentTask then
        --父任务(客户端不处理)
        require "Task/TaskTargets/TaskTargetSub"
        return TaskTargetSub.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.DungeonEnter then
        --进入副本(对应DungeonsTable)
        require "Task/TaskTargets/TaskTargetEnterDungeons"
        return TaskTargetEnterDungeons.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.CookingSingle then
        --单人烹饪(对应RecipeTable)
        require "Task/TaskTargets/TaskTargetSingleCooking"
        return TaskTargetSingleCooking.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.CookingDouble then
        --双人烹饪(副本)(对应DungeonsTable)
        require "Task/TaskTargets/TaskTargetDoubleCooking"
        return TaskTargetDoubleCooking.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.VehiclePublic then
        --公共载具(对应VehiclePublicTable)
        require "Task/TaskTargets/TaskTargetPublicVehicle"
        return TaskTargetPublicVehicle.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.SceneObject then
        --场景交互(对应TaskSceneInteractionTable)
        require "Task/TaskTargets/TaskTargetSceneInteraction"
        return TaskTargetSceneInteraction.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.VehiclePublicSingle then
        --单人公共载具(对应VehiclePublicTable)
        require "Task/TaskTargets/TaskTargetPublicVehicleSingle"
        return TaskTargetPublicVehicleSingle.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.PlayerActionDouble then
        --双人交互(对应ShowActionTable)
        require "Task/TaskTargets/TaskTargetDoubleAction"
        return TaskTargetDoubleAction.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.CastSkill then
        --使用技能(对应SkillTable)
        require "Task/TaskTargets/TaskTargetSkillCast"
        return TaskTargetSkillCast.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.PlayTimeline then
        --播放TimeLine(对应CutSceneTable)
        require "Task/TaskTargets/TaskTargetPlayTimeLine"
        return TaskTargetPlayTimeLine.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.SkillLevel then
        --技能达到指定等级(对应SkillTable)
        require "Task/TaskTargets/TaskTargetSkillLevel"
        return TaskTargetSkillLevel.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.FakeUseItem then
        --使用道具(假)
        require "Task/TaskTargets/TaskTargetFakeUseItem"
        return TaskTargetFakeUseItem.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.PlayBlackCurtain then
        --播放黑幕(对应BlackCurtainTable)
        require "Task/TaskTargets/TaskTargetPlayBlackCurtain"
        return TaskTargetPlayBlackCurtain.new(targetIndex,taskId, self, targetData, stepInfo) 
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.DyncItemRecycle then
        --动态回收
        require "Task/TaskTargets/TaskTargetDynamicRecycle"
        return TaskTargetDynamicRecycle.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Monster then
        --动态怪物
        require "Task/TaskTargets/TaskTargetMonster"
        return TaskTargetMonster.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.DyncPhoto then
        --完成QTE
        require "Task/TaskTargets/TaskTargetDynamicPhoto"
        return TaskTargetDynamicPhoto.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.QTECompleted then
        --完成QTE
        require "Task/TaskTargets/TaskTargetQTE"
        return TaskTargetQTE.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Convoy then
        --护送
        require "Task/TaskTargets/TaskTargetConvoy"
        return TaskTargetConvoy.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Carry then
        --搬运
        require "Task/TaskTargets/TaskTargetCarry"
        return TaskTargetCarry.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Virtual then
        --道具需求(虚拟)
        require "Task/TaskTargets/TaskTargetVirtual"
        return TaskTargetVirtual.new(targetIndex,taskId, self, targetData, stepInfo) 
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.CollectionCategory then
        --采集某一类型采集物
        require "Task/TaskTargets/TaskTargetCollectCategory"
        return TaskTargetCollectCategory.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.DelayTime then
        --延迟N秒后完成
        require "Task/TaskTargets/TaskTargetDelay"
        return TaskTargetDelay.new(targetIndex,taskId, self, targetData, stepInfo) 
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.NpcAction then
        --与NPC交互
        require "Task/TaskTargets/TaskTargetNpcAction"
        return TaskTargetNpcAction.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.ShowAction then
        --ShowAction
        require "Task/TaskTargets/TaskTargetShowAction"
        return TaskTargetShowAction.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.SpTalk then
        --SP_Talk
        require "Task/TaskTargets/TaskTargetSpTalk"
        return TaskTargetSpTalk.new(targetIndex,taskId, self, targetData, stepInfo)  
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.Dance then
        --泡点跳舞
        require "Task/TaskTargets/TaskTargetDance"
        return TaskTargetDance.new(targetIndex,taskId, self, targetData, stepInfo)
    elseif targetData.targetType == l_taskMgr.ETaskTargetType.PlayActivity then
        --完成N次指定玩法类型
        require "Task/TaskTargets/TaskTargetPlayActivity"
        return TaskTargetPlayActivity.new(targetIndex,taskId, self, targetData, stepInfo)
    else
        --全部不达标 报错配置有问题
        local l_debugInfo = l_taskMgr.DEBUT_TASK_NAMES[self.tableData.taskType]
        if l_debugInfo == nil then
            logError("严重错误，任务目标创建失败 任务ID：<"..tostring(taskId).."> 无该任务类型！")
            return nil 
        end
        logError("严重错误，任务目标创建失败 任务ID：<"..tostring(taskId)..">第<"..targetIndex..">个目标配置目标类型为："..tostring(targetData.targetType).."错误 @"..l_debugInfo[1].." 检查<"..l_debugInfo[2]..">配置")
        return nil
    end
end