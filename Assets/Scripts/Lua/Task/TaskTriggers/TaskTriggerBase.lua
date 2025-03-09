module("Task", package.seeall)
---@class TaskTriggerBase
TaskTriggerBase = class("TaskTriggerBase")
function TaskTriggerBase:ctor(taskId,triggerParams)
    self.taskId = taskId
    --- 事件类型
    self.triggerType = triggerParams[3]
    --- 事件参数
    self.triggerArg = triggerParams[4]
end

function TaskTriggerBase:ValidateParams()
    if self.triggerParams == nil then
        return false
    end
    if #self.triggerParams < self.paramsCount then
        logError("任务<"..self.taskId.."> 触发器类型="..self.triggerType.."参数配置数量有误,合法参数数量为:"..self.paramsCount..",配置参数数量为:"..tostring(#self.triggerParams))
        return false
    end
    return true
end

function TaskTriggerBase:ExecuteTrigger()
end

function TaskTriggerBase:ReverseTrigger( ... )
end

function TaskTriggerBase:OnClear( ... )
end

local super = Task.TaskTriggerBase

--进入镜像
---@class TaskTriggerEnterCopy:TaskTriggerBase
TaskTriggerEnterCopy = class("TaskTriggerEnterCopy",super)
function TaskTriggerEnterCopy:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerEnterCopy:ExecuteTrigger()
    MgrMgr:GetMgr("TaskTriggerMgr").AddDungeonTrigger(self)
end

function TaskTriggerEnterCopy:ReverseTrigger()
    MgrMgr:GetMgr("TaskTriggerMgr").RemoveDungeonTrigger(self)
end

--离开镜像
---@class TaskTriggerExitCopy:TaskTriggerBase
TaskTriggerExitCopy = class("TaskTriggerExitCopy",super)
function TaskTriggerExitCopy:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerExitCopy:ExecuteTrigger()
    MgrMgr:GetMgr("TaskTriggerMgr").RemoveDungeonTrigger(self)
end

function TaskTriggerExitCopy:ReverseTrigger()
    MgrMgr:GetMgr("TaskTriggerMgr").AddDungeonTrigger(self)
end

--刷NPC
---@class TaskTriggerAddNpc:TaskTriggerBase
TaskTriggerAddNpc = class("TaskTriggerAddNpc",super)
function TaskTriggerAddNpc:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
    self.taskId = taskId
    self.sceneId = triggerParams[5]
    self.position = Vector3.New(triggerParams[6],triggerParams[7],triggerParams[8])
    self.rotation = triggerParams[9]
end

function TaskTriggerAddNpc:ExecuteTrigger()
    -- logRed("add local npc : sceneId  = "..self.sceneId..",npcId = "..self.triggerArg)
    -- 新增任务数据判空
    if self.sceneId==nil or self.triggerArg==nil or self.position==nil or self.rotation==nil or self.taskId==nil then
        logError("TaskTrigger Data is nil Please Check -->>>>TaskId "..self.taskId,self.sceneId,self.triggerArg,self.position,self.rotation)
        return
    end
    MNpcMgr:AddLocalNpc(self.sceneId,self.triggerArg,self.position,self.rotation,self.taskId)
    MgrMgr:GetMgr("TaskTriggerMgr").CacheNpcTrigger(self)
end

function TaskTriggerAddNpc:ReverseTrigger()
    -- logRed("Reverse local npc : sceneId  = "..self.sceneId..",npcId = "..self.triggerArg)
    MNpcMgr:RemoveLocalNpc(self.triggerArg,true)
    MgrMgr:GetMgr("TaskTriggerMgr").RemoveNpcTrigger(self.triggerArg)
end

function TaskTriggerAddNpc:OnClear( ... )
    MNpcMgr:RemoveLocalNpc(self.triggerArg,true)
end

--删NPC
---@class TaskTriggerRemoveNpc:TaskTriggerBase
TaskTriggerRemoveNpc = class("TaskTriggerRemoveNpc",super)
function TaskTriggerRemoveNpc:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerRemoveNpc:ExecuteTrigger()
    -- logRed("remove local npcId = "..self.triggerArg)
    MNpcMgr:RemoveLocalNpc(self.triggerArg)
    MgrMgr:GetMgr("TaskTriggerMgr").RemoveNpcTrigger(self.triggerArg)
end


--隐藏NPC
---@class TaskTriggerHideNpc:TaskTriggerBase
TaskTriggerHideNpc = class("TaskTriggerHideNpc",super)
function TaskTriggerHideNpc:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerHideNpc:ExecuteTrigger()
    MNpcMgr:SetNpcVisibility(self.triggerArg, false)
end

function TaskTriggerHideNpc:ReverseTrigger()
    MNpcMgr:SetNpcVisibility(self.triggerArg, true)
end

--显示NPC
---@class TaskTriggerShowNpc:TaskTriggerBase
TaskTriggerShowNpc = class("TaskTriggerShowNpc",super)
function TaskTriggerShowNpc:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerShowNpc:ExecuteTrigger()
    MNpcMgr:SetNpcVisibility(self.triggerArg, true)
end

function TaskTriggerShowNpc:ReverseTrigger()
    MNpcMgr:SetNpcVisibility(self.triggerArg, false)
end

--播放cutsence
---@class TaskTriggerCutScene:TaskTriggerBase
TaskTriggerCutScene = class("TaskTriggerCutScene",super)
function TaskTriggerCutScene:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerCutScene:ExecuteTrigger()
    MgrMgr:GetMgr("TaskMgr").PlayTaskTimeLine(self.triggerArg)
end

--调用镜头
---@class TaskTriggerCamera:TaskTriggerBase
TaskTriggerCamera = class("TaskTriggerCamera",super)
function TaskTriggerCamera:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
    self.focus = triggerParams[5]
end

function TaskTriggerCamera:ExecuteTrigger()
    if self.triggerArg == nil or self.focus == nil then
        return
    end
    MgrMgr:GetMgr("TaskMgr").TaskChangeCamera(self.triggerArg,self.focus)
    if MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerCameraTimer ~= nil then
        MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerCameraTimer:Stop()
        MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerCameraTimer = nil
    end
    local l_cameraId = self.triggerArg
    local l_focusId = self.focus
    if l_focusId == 0 then
        MPlayerInfo:Focus2Player(l_cameraId)
    else
        MPlayerInfo:Focus2Npc(l_cameraId,l_focusId)
    end
    MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerCameraTimer = Timer.New(function(b)
        MPlayerInfo:ExitAdaptiveState()
        MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerCameraTimer = nil
    end, 5)
    MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerCameraTimer:Start()
end

--喊话
---@class TaskTriggerCutSceneTalk:TaskTriggerBase
TaskTriggerCutSceneTalk = class("TaskTriggerCutSceneTalk",super)
function TaskTriggerCutSceneTalk:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
    self.talkHost = triggerParams[5]
    self.talkId = triggerParams[6]
end

function TaskTriggerCutSceneTalk:ExecuteTrigger()
    local l_talkType = self.triggerArg
    local l_taklHostId = self.talkHost
    local l_talkId = self.talkId
    local l_talkData = TableUtil.GetCutSceneTalkTable().GetRowByID(l_talkId)
    if l_talkData == nil then
        logError("cutscene talk id<"..l_talkId.."> not exists in CutSceneTalkTable @天考")
        return
    end
    local l_talkTime = l_talkData.TalkTime
    if l_talkTime == 0 then
        logError("CutSceneTalkTable中,喊话 id <"..l_talkId.."> 持续时间为0,建议修改规范 @倩雯")
        return
    end
    
    CommonUI.ModelAlarm.ShowAlarm(l_talkType, l_taklHostId, l_talkData.TalkLanguage, l_talkData.Scale, l_talkData.Pos)
    MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerTalkTimer = Timer.New(function(b)
        --CommonUI.ModelAlarm.HideAlarm()
        MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerTalkTimer = nil
    end, l_talkTime)
    MgrMgr:GetMgr("TaskTriggerMgr").taskTriggerTalkTimer:Start()
end

--剧本
---@class TaskTriggerRunScript:TaskTriggerBase
TaskTriggerRunScript = class("TaskTriggerRunScript",super)
function TaskTriggerRunScript:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerRunScript:ExecuteTrigger()
    local l_commandId = StringEx.Format("CommandScript/StoryTalk/{0}",tostring(self.triggerArg))
    CommandBlock.OpenAndRunBlock(l_commandId,nil)
end

--黑幕
---@class TaskTriggerBlackCurtain:TaskTriggerBase
TaskTriggerBlackCurtain = class("TaskTriggerBlackCurtain",super)
function TaskTriggerBlackCurtain:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerBlackCurtain:ExecuteTrigger()
    MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(self.triggerArg)
end

--打开功能界面
TaskTriggerOpenSystem = class("TaskTriggerOpenSystem",super)
function TaskTriggerOpenSystem:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerOpenSystem:ExecuteTrigger()
    local l_systemId = self.triggerArg
    local l_systemFunction = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_systemId)
    if l_systemFunction ~= nil then
        l_systemFunction()
    end
end

--打开UI
---@class TaskTriggerActiveUI:TaskTriggerBase
TaskTriggerActiveUI = class("TaskTriggerActiveUI",super)
function TaskTriggerActiveUI:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
    --兼容TaskTable
    if triggerParams[5]~=nil then
        self.uiType=triggerParams[5]
    else 
        self.uiType=0
    end
end

function TaskTriggerActiveUI:ExecuteTrigger()
   self:ActiveUIByType()
end

function TaskTriggerActiveUI:ActiveUIByType()
    local l_uiId = self.triggerArg
    local l_uiType = self.uiType
    if l_uiType==0 then
        UIMgr:ActiveUI(UI.CtrlNames.StoryBoard,{storyBoardId = l_uiId,callback = nil,args = nil})
    elseif l_uiType==1 then
        MgrMgr:GetMgr("RateAppMgr").ShowRateDialog(l_uiId,nil)
    end
end

--添加特效
---@class TaskTriggerAddEffect:TaskTriggerBase
TaskTriggerAddEffect = class("TaskTriggerAddEffect",super)
function TaskTriggerAddEffect:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
    self.paramsCount = 8
    self.sceneId = triggerParams[5]
    self.position = Vector3.New(triggerParams[6],triggerParams[7],triggerParams[8])
    self.fxId = 0
end

function TaskTriggerAddEffect:ExecuteTrigger()
    MgrMgr:GetMgr("TaskTriggerMgr").CacheEffectTrigger(self)
    self:AddEffect()
end

function TaskTriggerAddEffect:ReverseTrigger()
    self:RemoveEffect()
    MgrMgr:GetMgr("TaskTriggerMgr").RemoveEffectTrigger(self.triggerArg,true)
end

function TaskTriggerAddEffect:OnClear( ... )
    self:RemoveEffect()
end

function TaskTriggerAddEffect:AddEffect()
    if MScene.SceneID == self.sceneId then
        if self.fxId == 0 then
            local fxData = MFxMgr:GetDataFromPool()
            fxData.position = self.position
            self.fxId = MFxMgr:CreateFx(self.triggerArg, fxData)
            MFxMgr:ReturnDataToPool(fxData)
        else
            logYellow("[TaskTriggerAddEffect] 特效{0}(来自任务{1})试图重复加载", self.triggerArg, self.taskId)
        end
    end
end

function TaskTriggerAddEffect:RemoveEffect( ... )
    if self.fxId ~= 0 then
        MFxMgr:DestroyFx(self.fxId)
        self.fxId = 0
    end
end

--移除特效
---@class TaskTriggerRemoveEffect:TaskTriggerBase
TaskTriggerRemoveEffect = class("TaskTriggerRemoveEffect",super)
function TaskTriggerRemoveEffect:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
end

function TaskTriggerRemoveEffect:ExecuteTrigger()
    MgrMgr:GetMgr("TaskTriggerMgr").RemoveEffectTrigger(self.triggerArg)
end

--播放动作
---@class TaskTriggerPlayAction:TaskTriggerBase
TaskTriggerPlayAction = class("TaskTriggerPlayAction",super)
function TaskTriggerPlayAction:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
    self.hostType = triggerParams[4]
    self.hostId = triggerParams[5]
    self.actionId = triggerParams[6]
end

function TaskTriggerPlayAction:ExecuteTrigger()

    local l_entity = nil
    if self.hostType == 1 then
        l_entity = MEntityMgr.PlayerEntity
    else
        l_entity = MNpcMgr:FindNpcInViewport(self.hostId)
    end
    if l_entity == nil then
        return
    end
    MEventMgr:LuaFireEvent(MEventType.MEvent_Special, l_entity, ROGameLibs.kEntitySpecialType_Action, self.actionId)
end

--播放音频
---@class TaskTriggerPlayAudio:TaskTriggerBase
TaskTriggerPlayAudio = class("TaskTriggerPlayAudio", super)
function TaskTriggerPlayAudio:ctor(taskId,triggerParams)
    super.ctor(self,taskId,triggerParams)
    self.audioId = triggerParams[4]
end

function TaskTriggerPlayAudio:ExecuteTrigger()
    local l_audioRow = TableUtil.GetAudioCommonTable().GetRowById(self.audioId)
    if l_audioRow == nil then
        logError("audio event :"..tostring(self.audioId).."not exists in AudioCommonTable @任务策划 !")
        return
    end

    MAudioMgr:Play("event:/"..l_audioRow.AudioBank.."/"..l_audioRow.AudioPath)

end

