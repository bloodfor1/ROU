---@module ModuleMgr.NpcTalkDlgMgr
module("ModuleMgr.NpcTalkDlgMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

ADD_SELECT_INFO = "ADD_SELECT_INFO" -- 添加选项消息
BATCH_ADD_SELECT_INFO = "BATCH_ADD_SELECT_INFO" -- 批量添加选项消息
REMOVE_ALL_SELECT_INFO = "REMOVE_ALL_SELECT_INFO" -- 清楚所有选项信息
SHOW_SELECT_INFO = "SHOW_SELECT_INFO" -- 显示选项信息
SHOW_TALK_INFO = "SHOW_TALK_INFO" -- 显示talkInfo
COMMAND_TRY_CLOSE = "COMMAND_TRY_CLOSE" -- 尝试关闭Command
COMMAND_NPC_SELECT_FORWARD = "COMMAND_NPC_SELECT_FORWARD" -- 点击选项
COMMAND_NPC_SELECT_QUIT = "COMMAND_NPC_SELECT_QUIT" -- 取消选项
ON_NPC_DISAPPEAR = "ON_NPC_DISAPPEAR" -- npc消失
ON_SET_TALK = "ON_SET_TALK" -- 设置对话内容
ON_LOCK_EVENT = "ON_LOCK_EVENT" -- 锁定事件
ON_FORCE_SELECT_EVENT = "ON_FORCE_SELECT_EVENT" -- 强制选择事件
ON_TRY_CALLBACK = "ON_TRY_CALLBACK" -- 尝试回调
ON_DATA_UPDATE = "ON_DATA_UPDATE" -- 数据更新
ON_UPDATE_SELECT_NPC = "ON_UPDATE_SELECT_NPC" -- 更换当前npc
ON_REPLACE_SELECT_INFO = "ON_REPLACE_SELECT_INFO"
ON_NOTIFY_BTN_SHAKE = "ON_NOTIFY_BTN_SHAKE"

local ETaskStatus
local ETaskType
local ETaskSubChoose
local l_dataMgr
local l_talkSelectSequenceId = 1

ECommandType = -1

FirstTalkStatus = true

function OnInit()

    l_dataMgr = DataMgr:GetData("NpcTalkDlgData")

    ECommandType = l_dataMgr.ECommandType
    
    ETaskStatus = TaskMgr().ETaskStatus
    ETaskType = TaskMgr().ETaskType
    ETaskSubChoose = TaskMgr().ETaskSubChoose
end

function OnLogout()
    
end

function NotifyBtnShake()

    EventDispatcher:Dispatch(ON_NOTIFY_BTN_SHAKE)
end

-- 关闭对话
function TryStopTalk()
    EventDispatcher:Dispatch(COMMAND_TRY_CLOSE)
end

-- 点击选项时
function OnNpcSelectForward(command, tag)
    EventDispatcher:Dispatch(COMMAND_NPC_SELECT_FORWARD, command, tag)
end

-- 取消选择
function OnNpcSelectQuit(command)
    EventDispatcher:Dispatch(COMMAND_NPC_SELECT_QUIT, command)
end

-- npc消失时
function OnNpcDisappear(npcId)
    EventDispatcher:Dispatch(ON_NPC_DISAPPEAR, npcId)
end

-- 设置talk
function OnSetTalk(isPlayer, content, clearSelect)
    EventDispatcher:Dispatch(ON_SET_TALK, isPlayer, content, clearSelect)
end

-- 锁定事件
function OnLockEvent(lock, notRetry)
    EventDispatcher:Dispatch(ON_LOCK_EVENT, lock, notRetry)
end

-- 强制选择
function ForceSelect(on)

    EventDispatcher:Dispatch(ON_FORCE_SELECT_EVENT, on)
end

-- 尝试回调
function TalkDlgTryCallback()

    EventDispatcher:Dispatch(ON_TRY_CALLBACK)
end

-- 关闭界面
function CloseTalkDlg()
    UIMgr:DeActiveUI(UI.CtrlNames.TalkDlg2)
end

-- 打开or发送事件进行更新
function ActiveTalkDlgOrBroadcastEvent(data)
    
    if UIMgr:IsActiveUI(UI.CtrlNames.TalkDlg2) then
        EventDispatcher:Dispatch(ON_DATA_UPDATE, data)
    else
        UIMgr:ActiveUI(UI.CtrlNames.TalkDlg2, data)
    end
end

-- 锁定对话框
function LockTalkDlg()
    OnLockEvent(true)
end

-- 解锁对话框
function UnlockDlg()
    
    OnLockEvent(false, true)
end

-- 解锁对话框
function UnlockDlgWithRetry()
    OnLockEvent(false)
end

-- 设置为对话状态
function Talk()
    l_dataMgr.Talked = true
end

-- 设置为非对话状态
function Reset()
    l_dataMgr.Talked = false
end

-- 查询对话状态
function IsTalked()
    return l_dataMgr.Talked
end

function GetCurrentNpcId()

    return l_dataMgr.CurTalkNpcId
end

function SetCurrentNpcId(npcId, force)
    l_dataMgr.CurTalkNpcId = npcId

    EventDispatcher:Dispatch(ON_UPDATE_SELECT_NPC, force)
end

function HasSelect(selectType)
    local ret = false
    if selectType then
        for i, v in ipairs(l_dataMgr.SelectInfos or {}) do
            if v.type == selectType then
                ret = true
                break
            end
        end
    end
    return ret
end

function HasAnySelect(selectTypes)
    local ret = false
    if selectTypes then
        local l_mark = {}
        for i, v in ipairs(selectTypes) do
            l_mark[v] = true
        end
        for i, v in ipairs(l_dataMgr.SelectInfos or {}) do
            if l_mark[v.type] then
                ret = true
                break
            end
        end
    end
    return ret
end

function NoneSelect()

    return l_dataMgr.selectInfos == nil or #l_dataMgr.selectInfos <= 0
end

function GetNextTalkSelectInfoSequenceId()

    if l_talkSelectSequenceId > 10000000 then
        l_talkSelectSequenceId = 0
    end

    l_talkSelectSequenceId = l_talkSelectSequenceId + 1
    return l_talkSelectSequenceId
end

function GetExistSelectInfo(name, type)
    
    if not l_dataMgr.SelectInfos then
        return
    end

    for i, v in ipairs(l_dataMgr.SelectInfos) do
        if v.name == name and v.type == type then
            return v, i
        end
    end
end

-- 添加npc选项信息数据
function AddSelectInfo(name, callback, closeAfterClick, type, isPlot, subChoose, important)
    if not l_dataMgr.SelectInfos then return end
    
    local l_existInfo = GetExistSelectInfo(name, type)
    if l_existInfo then
        logYellow("AddSelectInfo replace ", name, type)
        EventDispatcher:Dispatch(ON_REPLACE_SELECT_INFO, l_existInfo.sequenceId)
    end

    local info = {
        name = name,
        callback = callback,
        closeAfterClick = closeAfterClick,
        type = type,
        isPlot = isPlot,
        subChoose = subChoose,
        sequenceId = GetNextTalkSelectInfoSequenceId(),
        important = important,
    }
    table.insert(l_dataMgr.SelectInfos, info)
    if not l_dataMgr.SelectShowInfo.showSelect then
        l_dataMgr.SelectShowInfo.showSelect = true
    end

    if isPlot then
        local selectData = {
            talkName = name,
            callBack = callback,
            emojiId = subChoose
        }
        InsertDataToPlotCache(selectData)
    end

    EventDispatcher:Dispatch(ADD_SELECT_INFO, info)
end

function ClearPlotCache()

    l_dataMgr.PlotData = {}
end

function GetPlotCache()
    
    return l_dataMgr.PlotData
end

function InsertDataToPlotCache(data)

    table.insert(l_dataMgr.PlotData, data)
end

-- 批量添加npc选项信息
function AddSelectInfos(names, callbacks, closeAfterClick, type, isPlot, important)
    if #names ~= #callbacks then
        logError("add l_dataMgr.selectInfos error names.count:%s ~= callbacks.count:%s", #names, #callbacks)
        return
    end
    local infos = {}
    local l_count = 0
    for i, v in ipairs(names) do
        local l_existInfo = GetExistSelectInfo(v, type)
        if l_existInfo then
            logYellow("AddSelectInfo replace ", name, type)
            EventDispatcher:Dispatch(ON_REPLACE_SELECT_INFO, l_existInfo.sequenceId)
        end
        local info = {
            name = names[i],
            callback = callbacks[i],
            closeAfterClick = closeAfterClick,
            type = type,
            isPlot = isPlot,
            sequenceId = GetNextTalkSelectInfoSequenceId(),
            important = important,
        }
        
        table.insert(infos, info)

        if isPlot then
            local selectData = {
                talkName = names[i],
                callBack = callbacks[i],
            }
            InsertDataToPlotCache(selectData)
        else
            table.insert(l_dataMgr.SelectInfos, info)
        end
        l_count = l_count + 1
    end

    if l_count > 0 then
        EventDispatcher:Dispatch(BATCH_ADD_SELECT_INFO, infos)
    end
end

-- 获取所有的npc选项数据
function GetSelectInfos()
    return l_dataMgr.SelectInfos
end

function GetSelectShowInfo()
    return l_dataMgr.SelectShowInfo
end

function IsShowSelect()
    return l_dataMgr.SelectShowInfo.showSelect
end

-- 清除npc选项数据
function ClearSelect(command)
    l_dataMgr.SelectInfos = {}
    EventDispatcher:Dispatch(REMOVE_ALL_SELECT_INFO, command)
end

-- 设置显示信息
function SetShowInfo(showInfo)

    if not showInfo then return end

    if showInfo.showSelect ~= nil then
        l_dataMgr.SelectShowInfo.showSelect = showInfo.showSelect
    end
    if showInfo.isPlayer ~= nil then
        l_dataMgr.SelectShowInfo.isPlayer = showInfo.isPlayer
    end
    if showInfo.content ~= nil then
        l_dataMgr.SelectShowInfo.content = showInfo.content
    end
    if showInfo.block ~= nil then
        l_dataMgr.SelectShowInfo.block = showInfo.block
    end
    EventDispatcher:Dispatch(SHOW_TALK_INFO, showInfo)
    if showInfo.showSelect ~= nil then
        EventDispatcher:Dispatch(SHOW_SELECT_INFO, l_dataMgr.SelectShowInfo)
    end
end

-- 显示选项
function ShowSelect(command, isPlayer, content)
    SetShowInfo({
        showSelect = true,
        isPlayer = isPlayer,
        content = content,
        block = command.Block
    })
end

-- 重置数据
function ResetSelectInfo()
    l_dataMgr.SelectInfos = {}
    l_dataMgr.SelectShowInfo = {
        showSelect = false,
        isPlayer = false,
        content = "",
        block = nil
    }
end

----------------------------------------------------------------------------------------------------------任务相关

-- 任务管理器的快捷使用
function TaskMgr()
    return MgrMgr:GetMgr("TaskMgr")
end


-- 获取任务相关的选择按钮信息，并且广播消息以让对话框接受
function GetTaskSelectInfoList(sceneId, npcId, isAutoRun)
    local l_taskIdList = {}--是否有任务

    local npcStatus = TaskMgr().GetNpcStatus(sceneId, npcId)
    if not npcStatus then
        return l_taskIdList, false
    end

    local l_autoRun = isAutoRun or IsAutoRun(sceneId, npcId)
    for i = 1, table.maxn(npcStatus) do
        local oneNpcStatus = npcStatus[i]
        --可接任务
        if oneNpcStatus.status == ETaskStatus.CanTake then
            GetTakeTaskSelectInfo(sceneId, npcId, oneNpcStatus, l_autoRun)
        --进行中的任务
        elseif oneNpcStatus.status == ETaskStatus.Taked then
            GetTaskTakedSelectInfo(sceneId, npcId, oneNpcStatus, l_autoRun)
        --可交任务
        elseif oneNpcStatus.status == ETaskStatus.CanFinish then
            GetFinishTaskSelectInfo(sceneId, npcId, oneNpcStatus, l_autoRun)
        else
            logError("未找到任务:" .. oneNpcStatus.tableInfo.taskId)
        end
    end

    return l_taskIdList, l_autoRun
end

-- 获取接受任务时的按钮
function GetTakeTaskSelectInfo(sceneId, npcId, oneNpcStatus, autoRun)
    --有子任务
    if table.maxn(oneNpcStatus.tableInfo.targetSubTasks) > 0 then
        GetTaskHasChildSelectInfo(sceneId, npcId, oneNpcStatus, autoRun)
    --无子任务
    else
        GetTaskNonChildSelectInfo(sceneId, npcId, oneNpcStatus, autoRun)
    end
end

-- 随机或者顺序(需要等待服务器派发消息)
function HandleSubChooseRandom(sceneId, npcId, oneNpcStatus, taskId, autoRun)

    local l_subTaskId = GetCurrentSubTaskId(oneNpcStatus)
    if l_subTaskId == 0 then
        return
    end
    AcceptSubTask(taskId, l_subTaskId, { autoRun = autoRun, sceneId = sceneId, npcId = npcId })
end

-- 按序列执行
function HandleSubChooseSequence(sceneId, npcId, oneNpcStatus, taskId, autoRun)

    local l_taskInfo = TaskMgr().GetTaskTableInfoByTaskId(taskId)
    local l_commandId = l_taskInfo.talkScript
    local l_commandTag = l_taskInfo.talkAcceptScriptTag
    -- 剧本回调
    local l_callback = function(command)
        local l_subTaskId = GetCurrentSubTaskId(oneNpcStatus)
        if l_subTaskId == 0 then
            return
        end
        local l_break = command:IsDefineCustomVar("BreakTryNextTask")
        TaskMgr().RequestTaskAccept(taskId, l_subTaskId, nil, function(msg)
            if not l_break then
                local l_timer = Timer.New(function()
                    TryGetNextTask(sceneId, npcId, l_subTaskId)
                    UnlockDlg()
                end, 0.1)
                l_timer:Start()
            else
                CloseTalkDlg() 
            end
        end)
    end

    -- 选项名
    local l_talkName = oneNpcStatus.tableInfo.name
    -- 选项回调
    local l_talkCallBack = function()
        RunCommandBlock(taskId, l_commandId, l_commandTag, l_callback)
    end
    l_talkName = GetTaskNameWithPrefix(taskId, l_talkName)
    local l_important = IsImortantTaskById(taskId)
    AddSelectInfo(l_talkName, l_talkCallBack, false, MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE.TASK, nil, nil, l_important)
end

-- 选择分支任务回调
function SubChooseBranchCallback(sceneId, npcId, l_subtaskInfo, taskId, subTaskId)

    local l_commandId = l_subtaskInfo.talkScript
    local l_commandtag = l_subtaskInfo.talkAcceptScriptTag
    ForceSelect(false)

    local l_callback = function(command)
        local l_break = command:IsDefineCustomVar("BreakTryNextTask")
        if not l_break then
            LockTalkDlg()
        end
        TaskMgr().RequestTaskAccept(taskId, subTaskId, nil, function(msg)
            if not l_break then
                local l_timer = Timer.New(function()
                    TryGetNextTask(sceneId, npcId, subTaskId)
                    UnlockDlgWithRetry()
                end, 0.1)
                l_timer:Start()
            else
                CloseTalkDlg()
            end
        end)
    end
    RunCommandBlock(subTaskId, l_commandId, l_commandtag, l_callback)
end

-- 打开任务分支界面
function HandleSubChooseActiveBranch(sceneId, npcId, oneNpcStatus, taskId)
    
    local l_selectInfoList = {}
    local l_subTaskIds = {}
    for j = 1, table.maxn(oneNpcStatus.tableInfo.targetSubTasks) do
        local subTaskId = oneNpcStatus.tableInfo.targetSubTasks[j]
        table.insert(l_subTaskIds,subTaskId)
        local l_subtaskInfo = TaskMgr().GetTaskTableInfoByTaskId(subTaskId)
        local l_talkName = l_subtaskInfo.branchName

        local l_talkCallBack = function()
            SubChooseBranchCallback(sceneId, npcId, l_subtaskInfo, taskId, subTaskId)
        end
        AddSelectInfo(l_talkName, l_talkCallBack, false, MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE.TASK, true, l_subtaskInfo.targetSubTaskChoose)
    end
    
    if oneNpcStatus.tableInfo.taskType == ETaskType.Commission then
        ClearPlotCache()
        MgrMgr:GetMgr("DelegateModuleMgr").EnterTaskEvent(taskId,l_subTaskIds)
    else
        UIMgr:ActiveUI(UI.CtrlNames.NewPlotBranch)
    end 
end

-- 处理需要玩家处理的任务
function HandleSubChooseByPlayer(sceneId, npcId, oneNpcStatus, taskId, autoRun)

    local l_taskInfo = TaskMgr().GetTaskTableInfoByTaskId(taskId)
    local l_subTaskShowType = l_taskInfo.targetMsgEx[1]
    local l_callback = function()
        LockTalkDlg()
        if l_subTaskShowType == "" then
            HandleSubChooseActiveBranch(sceneId, npcId, oneNpcStatus, taskId)
        elseif l_subTaskShowType == "1" then
            UIMgr:ActiveUI(UI.CtrlNames.JobTask,function(ctrl)
                ctrl:SetJobSelectData(taskId,sceneId,npcId)
            end)
        end
    end

    HandleTaskSelectInfo(taskId, l_taskInfo.name, l_taskInfo.talkScript, l_taskInfo.talkAcceptScriptTag, autoRun, l_callback)
end

--获取接受父子任务任务时的按钮
function GetTaskHasChildSelectInfo(sceneId, npcId, oneNpcStatus, l_autoRun)

    local l_taskId = oneNpcStatus.tableInfo.taskId
    local l_subTaskType = oneNpcStatus.tableInfo.targetSubTaskChoose

    if l_subTaskType == ETaskSubChoose.Random then
        HandleSubChooseRandom(sceneId, npcId, oneNpcStatus, l_taskId, l_autoRun)
    elseif  l_subTaskType == ETaskSubChoose.Sequence then
        HandleSubChooseSequence(sceneId, npcId, oneNpcStatus, l_taskId, l_autoRun)
    --玩家自选
    elseif l_subTaskType == ETaskSubChoose.ByPlayer then
        HandleSubChooseByPlayer(sceneId, npcId, oneNpcStatus, l_taskId, l_autoRun)
    end
end

-- 获取当前的子任务
function GetCurrentSubTaskId(oneNpcStatus)
    local l_taskData = oneNpcStatus.taskData
    if not l_taskData.isParentTask then
        return 0
    end
    if not l_taskData.currentTaskTarget then
        return 0
    end
    if l_taskData.currentTaskTarget.targetType ~= TaskMgr().ETaskTargetType.ParentTask then
        return 0
    end
    return l_taskData.currentTaskTarget.targetId
end

-- 处理任务的选项(通用函数)
function HandleTaskSelectInfo(taskId, taskName, commandId, commandTag, autoRun, commandCallback)

    if autoRun then
        RunCommandBlock(taskId, commandId, commandTag, commandCallback)
    else
        local l_talkName = taskName
        local l_talkCallBack = function()
            RunCommandBlock(taskId, commandId, commandTag, commandCallback)
        end
        l_talkName = GetTaskNameWithPrefix(taskId, l_talkName)
        local l_important = IsImortantTaskById(taskId)
        AddSelectInfo(l_talkName, l_talkCallBack, false, MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE.TASK, nil, nil, l_important)
    end
end

--获取接受无父子任务任务时的按钮
function GetTaskNonChildSelectInfo(sceneId, npcId, oneNpcStatus, l_autoRun)
    local l_taskId = oneNpcStatus.tableInfo.taskId
    local l_taskInfo = TaskMgr().GetTaskTableInfoByTaskId(l_taskId)
    local l_callback = function(command)
        local l_break = command:IsDefineCustomVar("BreakTryNextTask")
        if not l_break then
            LockTalkDlg()
        end
        TaskMgr().RequestTaskAccept(l_taskId, 0, nil, function(msg)

            if not l_break then
                local l_timer = Timer.New(function()
                    TryGetNextTask(sceneId, npcId, l_taskId)
                    UnlockDlg()
                end, 0.1)
                l_timer:Start()
            else
                CloseTalkDlg() 
            end
        end)
    end

    HandleTaskSelectInfo(l_taskId, oneNpcStatus.tableInfo.name, l_taskInfo.talkScript, l_taskInfo.talkAcceptScriptTag, l_autoRun, l_callback)
end

-- 对话框接取任务回调
function OnTaskTakedSelectInfoCallback(msg, sceneId, npcId, taskId)
    ---@type TaskReportRes
    local l_info = ParseProtoBufToTable("TaskReportRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    if l_info.delayfinish then
        local l_timeoutTimer = Timer.New(function(b)
            GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.UpdateAllInfo, ModuleMgr.TaskMgr)
        end, 0.1)
        l_timeoutTimer:Start()
        GlobalEventBus:Add(EventConst.Names.UpdateAllInfo, function(self)
            local l_timer = Timer.New(function()
                TryGetNextTask(sceneId, npcId, taskId)
                UnlockDlg()
                GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.UpdateAllInfo, ModuleMgr.TaskMgr)
                if l_timeoutTimer ~= nil then
                    l_timeoutTimer:Stop()
                    l_timeoutTimer = nil
                end
            end, 0.1)
            l_timer:Start()
        end, ModuleMgr.TaskMgr)

    else
        local l_timer = Timer.New(function()
            TryGetNextTask(sceneId, npcId, taskId)
            UnlockDlg()
        end, 0.1)
        l_timer:Start()
    end
end

--获取有任务时候的对话与按钮
function GetTaskTakedSelectInfo(sceneId, npcId, oneNpcStatus, autoRun)
    local l_taskId = oneNpcStatus.tableInfo.taskId
    local l_selectType = MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE.TASK
    local l_step = oneNpcStatus.step
    local l_targetData = oneNpcStatus.taskData:GetTargetByStep(l_step)
    local l_callback = function()
        local l_eventData = {
            taskId = l_taskId,
            step = l_step
        }
        LockTalkDlg()
        TaskMgr().TaskEventTalk(l_eventData, nil, function(msg)
            OnTaskTakedSelectInfoCallback(msg, sceneId, npcId, l_taskId)
        end)
    end

    HandleTaskSelectInfo(l_taskId, oneNpcStatus.tableInfo.name, l_targetData.talkScript, l_targetData.talkTag, autoRun, l_callback)
end

--获取结束任务时的按钮
function GetFinishTaskSelectInfo(sceneId, npcId, oneNpcStatus, autoRun)
    local l_taskId = oneNpcStatus.tableInfo.taskId
    local l_taskInfo = TaskMgr().GetTaskTableInfoByTaskId(l_taskId)

    --如果是父任务，不应该被显示出来
    if table.maxn(oneNpcStatus.tableInfo.targetSubTasks) > 0 then
        return
    end
    local l_callback = function(command)
        local l_break = command:IsDefineCustomVar("BreakTryNextTask")
        if not l_break then
            LockTalkDlg()
        end
        TaskMgr().RequestTaskFinish(l_taskId, nil, function(msg)
            if not l_break then
                local l_timer = Timer.New(function()
                    TryGetNextTask(sceneId, npcId, l_taskId)
                    UnlockDlg()
                end, 0.1)
                l_timer:Start()
            else
                CloseTalkDlg()
            end
        end)
    end

    HandleTaskSelectInfo(l_taskId, oneNpcStatus.tableInfo.name, l_taskInfo.talkScript, l_taskInfo.talkFinishScriptTag, autoRun, l_callback)
end

--运行脚本块
function RunCommandBlock(taskId, commandId, commandTag, callBack)
    if commandId and commandId ~= 0 then
        local l_block = CommandBlock.OpenAndRunBlock("CommandScript/Task/"..tostring(commandId), commandTag)
        if not l_block then
            logError("打不开剧本", "CommandScript/Task/"..tostring(commandId), commandTag)
            return
        end
        CommandBlockManager.SetTaskBlock(taskId, l_block)
        if callBack then
            l_block:SetCallback(callBack)
        end
        return l_block
    else
        logError("commandId is nil or 0")
        callBack()
        return
    end
end

-- 尝试获取下个任务
function TryGetNextTask(sceneId, npcId, lastTaskId)
    local l_nextAutoRun = IsAutoRun(sceneId, npcId, lastTaskId)
    if l_nextAutoRun then
        --连续接新任务的时候需要将前一个任务的行为全部清空
        MgrMgr:GetMgr("ActionTargetMgr").ResetActionQueue()
        GetTaskSelectInfoList(sceneId, npcId, l_nextAutoRun)
    else
        TalkDlgTryCallback()
    end
end

--==============================--
--@Description:npc的任务id list
--@Date: 2019/6/18
--@Param: [args]
--@Return:
--==============================--
function GetNpcTaskIdList(sceneId, npcId)
    local l_taskIdList = {}--是否有任务

    local npcStatus = TaskMgr().GetNpcStatus(sceneId, npcId)
    if not npcStatus then return l_taskIdList end
    for i = 1, table.maxn(npcStatus) do
        local oneNpcStatus = npcStatus[i]
        if oneNpcStatus.status == ETaskStatus.CanTake then
            table.insert( l_taskIdList, oneNpcStatus.tableInfo.taskId)
        elseif oneNpcStatus.status == ETaskStatus.Taked then
            table.insert( l_taskIdList, oneNpcStatus.tableInfo.taskId)
        elseif oneNpcStatus.status == ETaskStatus.CanFinish then
            table.insert( l_taskIdList, oneNpcStatus.tableInfo.taskId)
        end
    end

    return l_taskIdList
end

-- 场景某个npc是否有任务
function HasTask(sceneId, npcId)
    local l_taskIdList = GetNpcTaskIdList(sceneId, npcId)
    return #l_taskIdList > 0
end

-- 通过任务状态判断是否可以自动执行
function CheckIsAutoRunByNpcStatus(sceneId, npcId, lastTaskId)

    local npcStatus = TaskMgr().GetNpcStatus(sceneId, npcId)
    local l_taskId = -1
    local l_autoRun = false
    if not npcStatus then
        return
    end
    for i = 1, table.maxn(npcStatus) do
        local oneNpcStatus = npcStatus[i]
        if oneNpcStatus.status == ETaskStatus.CanTake or oneNpcStatus.status == ETaskStatus.Taked then
            if oneNpcStatus.tableInfo.taskId ~= lastTaskId then
                l_autoRun = array.contains(oneNpcStatus.tableInfo.preTaskId, lastTaskId)
                l_taskId = oneNpcStatus.tableInfo.taskId
                if l_autoRun then
                    break
                end
            end
        elseif oneNpcStatus.status == ETaskStatus.CanFinish then
            if oneNpcStatus.tableInfo.taskId == lastTaskId then
                l_autoRun = true
                l_taskId = lastTaskId
            end
        end
    end

    return l_autoRun, l_taskId
end

-- 是否自动执行任务剧本
function IsAutoRun(sceneId, npcId, lastTaskId)
    local l_autoRun, taskId = false, -1
    if lastTaskId then
        l_autoRun, taskId = CheckIsAutoRunByNpcStatus(sceneId, npcId, lastTaskId)
        if l_autoRun and taskId > 0 then
            l_autoRun = CheckTaskAutoRunWithTypeById(taskId)
        end
    else
        local l_taskIdList = GetNpcTaskIdList(sceneId, npcId)
        if #l_taskIdList == 1 then
            l_autoRun = CheckTaskAutoRunWithTypeById(l_taskIdList[1])
        end
    end
    return l_autoRun
end

function IsImportantTask(taskType)

    return l_dataMgr.ImportantTaskDic[taskType]
end

function IsImortantTaskById(taskId)
    local l_taskInfo = TaskMgr().GetTaskTableInfoByTaskId(taskId)
    if not l_taskInfo then return false end
    return IsImportantTask(l_taskInfo.taskType)
end

-- 通过任务类型判断能否自动执行
function CheckTaskAutoRunWithTypeById(taskId)
    local l_taskInfo = TaskMgr().GetTaskTableInfoByTaskId(taskId)
    if not l_taskInfo then return false end
    return IsImportantTask(l_taskInfo.taskType) and CheckTaskAutoRunWithFilterById(taskId)
end

-- 通过Global表配置判断是否不能自动运行
function CheckTaskAutoRunWithFilterById(taskId)
    for i, v in ipairs(l_dataMgr.AutoRunFilter) do
        if v == taskId then
            return false
        end
    end
    return true
end

-- 子任务接取
function AcceptSubTask(taskId, subTaskId, customData)
    local l_taskInfo = TaskMgr().GetTaskTableInfoByTaskId(subTaskId)
    if customData == nil then
        logError("任务id"..taskId.." 在请求子任务时没有传入customData,检查任务逻辑")
        return
    end
    local l_autoRun = customData.autoRun
    local l_sceneId = customData.sceneId
    local l_npcId = customData.npcId

    local l_callback = function(command)
        local l_break = command:IsDefineCustomVar("BreakTryNextTask")
        if not l_break then
            LockTalkDlg()
        end
        TaskMgr().RequestTaskAccept(taskId, subTaskId, nil, function(msg)
            if not l_break then
                local l_timer = Timer.New(function()
                    TryGetNextTask(l_sceneId, l_npcId, subTaskId)
                    UnlockDlg()
                end, 0.1)
                l_timer:Start()
            else
                CloseTalkDlg()
            end
        end)
    end

    HandleTaskSelectInfo(subTaskId, l_taskInfo.name, l_taskInfo.talkScript, l_taskInfo.talkAcceptScriptTag, l_autoRun, l_callback)
end

-- 跳过剧本
function SkipTaskBlock()
    local taskId = MgrMgr:GetMgr("TaskMgr").GetSelectTaskID()
    if taskId then
        CommandBlockManager.SkipTaskBlock(taskId)
    end
end

-- 获取带任务类型前缀的任务名
function GetTaskNameWithPrefix(taskId, taskName)

    local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(taskId)
    if not l_taskInfo then
        return taskName
    end
    
    local l_row = TableUtil.GetTaskTypeTable().GetRowById(l_taskInfo.taskType)
    if not l_row then
        return taskName
    end

    return l_row.Title .. taskName
end


function DoSelectAction(callback, hideAfterSelect)

    FirstTalkStatus = false
    ResetSelectInfo()
    if callback then
        callback()
    end
    UnlockDlg()
    if hideAfterSelect then
        UIMgr:DeActiveUI(UI.CtrlNames.TalkDlg2)
    end
end

return NpcTalkDlgMgr