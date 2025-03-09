require "Task/TaskTargets/TaskTargetBase"

--对话(对应NpcTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetTalk = class("TaskTargetTalk", super)

function TaskTargetTalk:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.npcFlag = false
    if self.Id == 0 then  
        self.talkScript = taskData.tableData.talkScript
        self.talkTag = self.msgEx
    else
        local l_tmp = string.ro_split(self.msgEx, '=')
        self.talkScript = l_tmp[1]
        self.talkTag = l_tmp[2]
    end
end


function TaskTargetTalk:ValidateNavData()
    local l_npcId = self.targetId
    local l_sceneId = self.targetArg
    local l_npcPos = MSceneMgr:GetNpcPos(l_npcId, l_sceneId,self.taskId)
    if l_npcPos == nil or l_npcPos.x == -1 and l_npcPos.y == -1 and l_npcPos.z == -1 then
        self.navData = nil
    else 
        self.navData = {
            sceneId = l_sceneId,
            position = l_npcPos
        }
    end
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetTalk:TaskTargetNavigation()
    MgrMgr:GetMgr("ActionTargetMgr").MoveToTalkWithNpc(self.targetArg, self.targetId)    
end

--对话任务不显示次数
function TaskTargetTalk:GetTaskTargetStepTip()
    return nil
end

--获取任务目标的名称 
function TaskTargetTalk:GetTaskTargetName()
    local l_npcData = TableUtil.GetNpcTable().GetRowById(self.targetId)
    if l_npcData == nil then
        logError("npc:<"..tostring(self.targetId).."> not exists in NpcTable")
        return ""
    end
    return l_npcData.Name

end

--监听事件添加 
function TaskTargetTalk:AddTaskEvent()
    super.AddTaskEvent(self)
    if self.npcFlag then return end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    l_taskMgr.AddNpcInfo(self.targetArg, self.targetId, self.taskData,self.targetIndex)
    self.npcFlag = true
end

--监听事件移除
function TaskTargetTalk:RemoveTaskEvent()
    if not self.isEventAdded then return end
    super.RemoveTaskEvent(self)
    if not self.npcFlag then return end
    self.npcFlag = false
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    l_taskMgr.RemoveNpcInfo(self.targetArg, self.targetId, self.taskData,self.targetIndex)

end

