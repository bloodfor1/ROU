require "Task/TaskTargets/TaskTargetBase"

--采集(对应CollectTable)类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetCollect = class("TaskTargetCollect", super)

function TaskTargetCollect:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.collectData = TableUtil.GetCollectTable().GetRowById(self.targetId)
    if self.collectData == nil then
        logError("collectId:<"..self.targetId.."> not exists in CollectTable !")
        return
    end
    self.range = self.collectData.CanCollectArea
end

--不同子类根据情况重写
function TaskTargetCollect:TaskTargetNavigation()
    --todo 通过special字段进行之前配置的兼容性  后续工具做到支持后会将该代码一出
    if self.navData then
        if Common.Utils.IsNilOrEmpty(self.msgEx) then
            MgrMgr:GetMgr("ActionTargetMgr")
                .MoveToPos(self.navData.sceneId, self.navData.position)
        else
            if tonumber(self.msgEx) == 1 then
                MgrMgr:GetMgr("ActionTargetMgr")
                    .MoveToPos(self.navData.sceneId, self.navData.position,nil,nil,nil,self.range)                
            end
        end

    end
end

--获取任务面板任务目标描述
function TaskTargetCollect:GetTaskTargetDescribe()
    local l_str = self:GetTaskTargetName()
    return l_str
end

--获取任务目标的飘字提示
function TaskTargetCollect:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetCollect:GetTaskTargetName()
    if self.collectData == nil then
        return "No<"..self.targetId..">Collections, please check!"
    end
    return self.collectData.CollectName
end


--监听事件添加
function TaskTargetCollect:AddTaskEvent()
    if self.isEventAdded then return end
    super.AddTaskEvent(self)
    if self.Id == 0 then
        MgrMgr:GetMgr("PlayerInfoMgr").AddCollectionWithTask(self.taskId,self.targetId)
    else
        MgrMgr:GetMgr("PlayerInfoMgr").AddCollectionWithTaskTarget(self.Id,self.targetId)
    end
end

--监听事件移除
function TaskTargetCollect:RemoveTaskEvent()
    if not self.isEventAdded then return end
    super.RemoveTaskEvent(self)
    if self.Id == 0 then
        MgrMgr:GetMgr("PlayerInfoMgr").RemoveCollectionWithTask(self.taskId,self.targetId)
    else
        MgrMgr:GetMgr("PlayerInfoMgr").RemoveCollectionWithTaskTarget(self.Id,self.targetId)
    end
end
