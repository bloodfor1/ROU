require "Task/TaskTargets/TaskTargetBase"

--对话(对应NpcTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
TaskTargetSpTalk = class("TaskTargetSpTalk", super)

function TaskTargetSpTalk:ctor(targetIndex, taskId, taskData, targetData, stepInfo)
    super.ctor(self, targetIndex, taskId, taskData, targetData, stepInfo)
    self.npcFlag = false
    self.itemFlag = false

    local l_tmp = string.ro_split(self.msgEx, '=')
    if self.Id == 0 then
        self.talkScript = taskData.tableData.talkScript
        self.itemLimited = tonumber(l_tmp[1])
        self.itemLimitedCount = tonumber(l_tmp[2])
        self.talkTag = l_tmp[3]
    else
        self.itemLimited = tonumber(l_tmp[1])
        self.itemLimitedCount = tonumber(l_tmp[2])
        self.talkScript = l_tmp[3]
        self.talkTag = l_tmp[4]
    end

    self.itemCurrentCount = Data.BagModel:GetBagItemCountByTid(self.itemLimited)
    self.itemFinished = self.itemCurrentCount >= self.itemLimitedCount
end

function TaskTargetSpTalk:ValidateNavData(...)
    local l_npcId = self.targetId
    local l_sceneId = self.targetArg
    local l_npcPos = MSceneMgr:GetNpcPos(l_npcId, l_sceneId, self.taskId)
    if l_npcPos == nil or l_npcPos.x == -1 and l_npcPos.y == -1 and l_npcPos.z == -1 then
        self.navData = nil
    else
        self.navData = {
            sceneId = l_sceneId,
            position = l_npcPos
        }
    end
end

function TaskTargetSpTalk:TargetNavigation(navType)

    if not self.itemFinished then
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.itemLimited, nil, nil, nil, true)
        return
    end
    self:ValidateNavData()
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.navData and self.taskData:NavigationInDungeon(self.navData.sceneId) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_NAVIGATION_IN_DUNGEON_TIP"))
        --副本目标提示增强
        MgrMgr:GetMgr("DungeonTargetMgr").TaskGuideToDungeonsTarget()
    else
        if self:ValidateIgnoreNavigationInScene() then
            return
        end
        self:CheckNavType(navType)
    end
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetSpTalk:TaskTargetNavigation()

    MgrMgr:GetMgr("ActionTargetMgr").MoveToTalkWithNpc(self.targetArg, self.targetId)
end

function TaskTargetSpTalk:GetTaskTargetDescribe()
    local l_taskTipsCon = Lang("TASK_TARGET_TIP_" .. tostring(self.targetType))
    if not self.itemFinished then
        l_taskTipsCon = Lang("TASK_TARGET_TIP_" .. tostring(self.targetType) .. "_LIMITED")
    end
    local l_targetName = self:GetTaskTargetName()
    local l_str = StringEx.Format(l_taskTipsCon, l_targetName)
    return l_str
end


--对话任务不显示次数
function TaskTargetSpTalk:GetTaskTargetStepTip()
    if self.itemFinished then
        return nil
    end
    return StringEx.Format("{0}/{1}", self.itemCurrentCount, self.itemLimitedCount)
end

--获取任务目标的名称 
function TaskTargetSpTalk:GetTaskTargetName()
    if self.itemFinished then
        local l_npcData = TableUtil.GetNpcTable().GetRowById(self.targetId)
        if l_npcData == nil then
            logError("npc:<" .. tostring(self.targetId) .. "> not exists in NpcTable")
            return ""
        end
        return l_npcData.Name
    end
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.itemLimited)
    if l_itemData == nil then
        logError("item:<" .. tostring(self.itemLimited) .. "> not exists in ItemTable")
        return ""
    end
    return l_itemData.ItemName
end

function TaskTargetSpTalk:ItemLimitedChanged()
    local l_count = Data.BagModel:GetBagItemCountByTid(self.itemLimited)
    if int64.equals(l_count, self.itemCurrentCount) then
        return
    end

    self.itemCurrentCount = l_count
    self.itemFinished = self.itemCurrentCount >= self.itemLimitedCount
    if self.itemFinished then
        self:AddNpcEvent()
    else
        self:RemoveNpcEvent()
    end

    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
end

--监听事件添加 
function TaskTargetSpTalk:AddTaskEvent()
    if self.isEventAdded then
        return
    end
    super.AddTaskEvent(self)
    self:AddItemEvent()
    if self.itemFinished then
        self:AddNpcEvent()
    end
end

function TaskTargetSpTalk:AddNpcEvent(...)
    if self.npcFlag then
        return
    end
    self.npcFlag = true
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    l_taskMgr.AddNpcInfo(self.targetArg, self.targetId, self.taskData, self.targetIndex)
end

function TaskTargetSpTalk:RemoveNpcEvent(...)
    if not self.npcFlag then
        return
    end
    self.npcFlag = false
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    l_taskMgr.RemoveNpcInfo(self.targetArg, self.targetId, self.taskData, self.targetIndex)
end

function TaskTargetSpTalk:AddItemEvent(...)
    if self.itemFlag then
        return
    end

    self.itemFlag = true
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, self.ItemLimitedChanged, self)
end

function TaskTargetSpTalk:RemoveItemEvent(...)
    if not self.itemFlag then
        return
    end

    self.itemFlag = false
    gameEventMgr.UnRegister(gameEventMgr.OnBagUpdate, self)
end

--监听事件移除
function TaskTargetSpTalk:RemoveTaskEvent()
    if not self.isEventAdded then
        return
    end
    super.RemoveTaskEvent(self)
    self:RemoveNpcEvent()
    self:RemoveItemEvent()
end

