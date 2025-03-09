---@module ModuleMgr.TaskTriggerMgr
module("ModuleMgr.TaskTriggerMgr", package.seeall)
require "Task/TaskTriggers/TaskTriggerBase"

DEBUG = false

function DebugTaskTriggerError(str)
    if DEBUG then
        logError(str)
    end
end

function DebugTaskTriggerYellow(str)
    if DEBUG then
        logYellow(str)
    end
end

function DebugTaskTriggerGreen(str)
    if DEBUG then
        logGreen(str)
    end
end

function DebugTaskTriggerRed(str)
    if DEBUG then
        logRed(str)
    end
end


TASK_TRIGGER_TYPE =
{
    ENTER_COPY              = 1,            --进入镜像
    EXIT_COPY               = 2,            --离开镜像
    ADD_NPC                 = 3,            --刷NPC
    REMOVE_NPC              = 4,            --删NPC
    HIDE_NPC                = 5,            --隐藏NPC
    SHOW_NPC                = 6,            --显示NPC
    CUTSCENE                = 9,            --播放cutscene
    CAMERA                  = 13,           --改变镜头
    CUTSCENE_TALK           = 14,           --喊话
    RUN_SCRIPT              = 15,           --剧情脚本
    BLACK_CURTAIN           = 16,           --播放黑幕
    OPEN_SYSTEM             = 19,           --打开功能界面
    ACTIVE_UI               = 22,           --打开UI界面
    ADD_EFFECT              = 24,           --播放特效
    DELETE_EFFECT           = 25,           --删除特效
    PLAY_ACTION             = 26,           --播放动作
    PLAY_AUDIO              = 27,           --播放音效
}

local l_taskTriggerCache = {}
local l_cycTaskTriggerCache = {}
local l_npcTriggerCache = {}
local l_taskCopyDungeonTrigger = {}
local l_effectTriggerCache = {}
local l_effectTriggerSceneCache = {}

function ResetTriggerData( ... )
    l_taskCopyDungeonTrigger = {}

    for k,v in pairs(l_npcTriggerCache) do
        v:OnClear()
    end
    l_npcTriggerCache = {}
    --todo effecttriggers
    for k,v in pairs(l_effectTriggerCache) do
        v:OnClear()
    end
    l_effectTriggerCache = {}
    l_effectTriggerSceneCache = {}
end

function OnLeaveScene(sceneId)
    UpdateEffectTrigger(sceneId, false)
end

function OnEnterScene(sceneId)
    UpdateEffectTrigger(sceneId, true)
end

function UpdateEffectTrigger(sceneId, add)
    local l_triggerList = l_effectTriggerSceneCache[sceneId]
    if l_triggerList == nil or #l_triggerList == 0 then
        return
    end
    for i=1,#l_triggerList do
        if add then
            l_triggerList[i]:AddEffect()
        else
            l_triggerList[i]:RemoveEffect()
        end
    end
end

function OnTaskTriggerAll(triggerInfo, delete)
    if delete == nil then
        delete = false
    end
    if triggerInfo == nil or triggerInfo.data == nil or #triggerInfo.data == 0 then
        return
    end

    local l_triggers = triggerInfo.data
    for i=1,#l_triggers do
        DebugTaskTriggerYellow("trigger.task_id:"..tostring(l_triggers[i].task_id)..",trigger.vector_index:"..tostring(l_triggers[i].vector_index))
        UpdateOneTrigger(l_triggers[i],delete)
    end
end

function OnTaskTriggerEventAllNotify(msg,delete)
    ---@type TaskTriggerAllNotifyData
    local l_info = ParseProtoBufToTable("TaskTriggerAllNotifyData", msg)
    if delete then
        local l_triggerCount = 0
        if l_info.data then
            l_triggerCount = #l_info.data
        end
        DebugTaskTriggerRed("回溯触发器数量:"..l_triggerCount)
    end
    OnTaskTriggerAll(l_info, delete)
end

function OnTaskTriggerNotify(msg)
    ---@type TriggerInfo
    local l_info = ParseProtoBufToTable("TriggerInfo", msg)
    UpdateOneTrigger(l_info)
end

function UpdateOneTrigger( trigger , reverse)
    if reverse then
        DebugTaskTriggerRed("Delete OneTrigger task_id:"..trigger.task_id..",index:"..trigger.vector_index)
    else
        DebugTaskTriggerYellow("Update OneTrigger task_id:"..trigger.task_id..",index:"..trigger.vector_index)
    end
    local l_trigger = GetTaskTrigger(trigger.task_id,trigger.vector_index)
    if l_trigger ~= nil then
        if reverse ~= nil and reverse then
            DebugTaskTriggerGreen("triggerType:"..tostring(l_trigger.triggerType)..",arg:"..tostring(l_trigger.triggerArg)..":ReverseTrigger")
            l_trigger:ReverseTrigger()
        else
            DebugTaskTriggerGreen("triggerType:"..tostring(l_trigger.triggerType)..",arg:"..tostring(l_trigger.triggerArg)..":ExecuteTrigger")
            l_trigger:ExecuteTrigger()
        end
    end
end

function GetTaskTrigger( taskId,idx )
    local l_triggers = l_taskTriggerCache[taskId]
    if l_triggers ~= nil then
        return l_triggers[idx]
    end
    local l_taskData = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(taskId)
    if l_taskData == nil then
        logError(StringEx.Format("taskId:<{0}> did not exists in TaskTable"),taskId)
        return nil
    end
    local l_triggerParams = l_taskData.taskTriggers
    local l_triggerCnt = #l_triggerParams
    if l_triggerCnt == 0 then
        logError(StringEx.Format("taskId:<{0}> did not have any tasktrigger"),taskId)
        return nil
    end
    l_triggers = {}
    for i=1,l_triggerCnt do
        local l_oneTrigger = ParseTaskTrigger(taskId,l_triggerParams[i])
        if l_oneTrigger ~= nil then
            l_triggers[i-1] = l_oneTrigger
        end
    end
    l_taskTriggerCache[taskId] = l_triggers
    if idx > l_triggerCnt then
        logError(StringEx.Format("taskId:<{0}> have {1} tasktrigger，but u want to get the {2}th！！"),taskId,l_triggerCnt,idx)
        return nil
    end
    return l_triggers[idx]
end

function InitTaskTriggersByTarget( taskId,targetId )
    local l_triggers = {}
    local l_targetCon = TableUtil.GetTaskTargetLibrary().GetRowByID(targetId)
    if l_targetCon == nil then
        logError("targetId<"..targetId.."> not exists in TaskTargetLibrary ")
        return nil
    end
    local l_triggerParamsCon = l_targetCon.TaskTrigger
    if l_triggerParamsCon == nil or l_triggerParamsCon.Count == 0 then
        return nil
    end
    local l_triggerParams = Common.Functions.VectorVectorToTable(l_triggerParamsCon)

    local l_triggerImmediately = {}
    for i=1,#l_triggerParams do
        local l_trigger = ParseTaskTrigger(taskId,l_triggerParams[i])
        if l_trigger ~= nil  then
            if l_trigger.triggerType == TASK_TRIGGER_TYPE.ENTER_COPY or l_trigger.triggerType == TASK_TRIGGER_TYPE.ADD_NPC then
                table.insert(l_triggers,l_trigger)
            else
                table.insert(l_triggerImmediately,l_trigger)
            end
        end
    end
    local l_taskTrigger = l_cycTaskTriggerCache[taskId]
    if l_taskTrigger == nil then
        l_cycTaskTriggerCache[taskId] = l_taskTrigger
        l_taskTrigger = {}
    end
    l_taskTrigger[targetId] = l_triggerImmediately

    return l_triggers
end

function GetCycTaskTriggersByTarget(taskId,targetId)
    local l_taskTrigger = l_cycTaskTriggerCache[taskId]
    if l_taskTrigger == nil then
        return
    end
    local l_targetTrigger = l_taskTrigger[targetId]
    if l_targetTrigger == nil then
        return
    end
    for i=1,#l_targetTrigger do
        l_targetTrigger[i]:ExecuteTrigger()
    end
end

function ParseTaskTrigger(taskId,triggerParam)
    local l_triggerType = triggerParam[3]
    if l_triggerType == TASK_TRIGGER_TYPE.ENTER_COPY then
        return Task.TaskTriggerEnterCopy.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.EXIT_COPY then
        return Task.TaskTriggerExitCopy.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.ADD_NPC then
        return Task.TaskTriggerAddNpc.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.REMOVE_NPC then
        return Task.TaskTriggerRemoveNpc.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.HIDE_NPC then
        return Task.TaskTriggerHideNpc.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.SHOW_NPC then
        return Task.TaskTriggerShowNpc.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.CUTSCENE then
        return Task.TaskTriggerCutScene.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.CAMERA then
        return Task.TaskTriggerCamera.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.CUTSCENE_TALK then
        return Task.TaskTriggerCutSceneTalk.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.RUN_SCRIPT then
        return Task.TaskTriggerRunScript.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.BLACK_CURTAIN then
        return Task.TaskTriggerBlackCurtain.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.OPEN_SYSTEM then
        return Task.TaskTriggerOpenSystem.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.ACTIVE_UI then
        return Task.TaskTriggerActiveUI.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.ADD_EFFECT then
        return Task.TaskTriggerAddEffect.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.DELETE_EFFECT then
        return Task.TaskTriggerRemoveEffect.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.PLAY_ACTION then
        return Task.TaskTriggerPlayAction.new(taskId,triggerParam)
    elseif l_triggerType == TASK_TRIGGER_TYPE.PLAY_AUDIO then
        return Task.TaskTriggerPlayAudio.new(taskId,triggerParam)
    end
    return nil
end

function AddDungeonTrigger(dungeonTrigger)
    if l_taskCopyDungeonTrigger[dungeonTrigger.taskId] ~= nil then
        logError(StringEx.Format("Task <{0}> 已经存在进入镜像副本触发器,请检查配置！ "))
        return
    end
    l_taskCopyDungeonTrigger[dungeonTrigger.taskId] = dungeonTrigger
end

function RemoveDungeonTrigger(dungeonTrigger)
    if l_taskCopyDungeonTrigger[dungeonTrigger.taskId] == nil then
        return
    end
    l_taskCopyDungeonTrigger[dungeonTrigger.taskId] = nil
end

function GetTaskDungeonTriggerEvent(taskId)
    return l_taskCopyDungeonTrigger[taskId]
end

function CacheNpcTrigger(trigger)
    local l_npcId = trigger.triggerArg
    if l_npcTriggerCache[l_npcId] == nil then
        l_npcTriggerCache[l_npcId] = trigger
    end
end

function RemoveNpcTrigger(npcId)
    local l_npcTrigger = l_npcTriggerCache[npcId]
    if l_npcTrigger == nil then
        return
    end
    l_npcTrigger[npcId] = nil
end


function CacheEffectTrigger(trigger)
    local l_fxId = trigger.triggerArg
    if l_effectTriggerCache[l_fxId] == nil then
        l_effectTriggerCache[l_fxId] = trigger
    else
        logError("重复刷新特效ID为:"..l_fxId.."的特效触发器@王倩雯")
        return
    end

    local l_sceneFxList = l_effectTriggerSceneCache[trigger.sceneId]
    if l_sceneFxList == nil then
        l_sceneFxList = {}
        l_effectTriggerSceneCache[trigger.sceneId] = l_sceneFxList
    end
    table.insert(l_sceneFxList,trigger)
end

function RemoveEffectTrigger(fxId,reverse)
    local l_fxTrigger = l_effectTriggerCache[fxId]
    if l_fxTrigger == nil then
        logError("删除特效触发器时未找到已经添加的特效ID为:"..fxId.."的特效触发器@王倩雯")
        return
    end
    --如果不是从自身reverse调用的  说明通过移除触发器调用 直接调用该触发器的reverse
    if not reverse then
        l_fxTrigger:ReverseTrigger()
        return
    end
    --如果是自身reverse调用的   自身逻辑已经回复  只需要清理缓存
    local l_sceneId = l_fxTrigger.sceneId
    local l_sceneFxList = l_effectTriggerSceneCache[l_sceneId]
    if l_sceneFxList ~= nil then
        table.ro_removeValue(l_sceneFxList,l_fxTrigger)
        if #l_sceneFxList == 0 then
            l_effectTriggerSceneCache[l_sceneId] = nil
        end
    end
    l_effectTriggerCache[fxId] = nil
end

function InitNpcStatus()
    local l_npc_table = TableUtil.GetNpcTable().GetTable()
    for i = 1, table.maxn(l_npc_table) do
        local l_npcId = l_npc_table[i].Id
        local l_show = l_npc_table[i].IsInitialize
        MNpcMgr:SetNpcVisibility(l_npcId, l_show)
    end
end

InitNpcStatus()