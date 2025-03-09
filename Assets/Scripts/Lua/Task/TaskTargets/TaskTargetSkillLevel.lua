require "Task/TaskTargets/TaskTargetBase"

--技能达到指定等级(对应SkillTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetSkillLevel = class("TaskTargetSkillLevel", super)

function TaskTargetSkillLevel:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetSkillLevel:TaskTargetNavigation()
    local l_skillData =
    {
        openType = DataMgr:GetData("SkillData").OpenType.SetTargetSkillId,
        targetId = self.targetId
    }
    UIMgr:ActiveUI(UI.CtrlNames.SkillLearning, l_skillData)
end

function TaskTargetSkillLevel:GetTaskTargetDescribeQuick()
    local l_desc = self:GetTaskTargetDescribe()
    local l_step = self:GetTaskTargetStepTip()
    if l_step == nil then
        return l_desc
    end
    return StringEx.Format("{0}{1}",l_desc,l_step)
end

function TaskTargetSkillLevel:GetTaskTargetDescribe()
    local l_taskTipsCon = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    local l_targetName = self:GetTaskTargetName()
    local l_maxLv = tostring(self.maxStep) 
    local l_str = StringEx.Format(l_taskTipsCon,l_targetName,l_maxLv)
    return l_str
end

function TaskTargetSkillLevel:GetTaskTargetStepTip()
    return nil
end

--获取任务目标的名称 
function TaskTargetSkillLevel:GetTaskTargetName()
    local l_skillData = TableUtil.GetSkillTable().GetRowById(self.targetId)
    if l_skillData == nil then
        logError("skillId :<"..tostring(self.targetId).."> not exists in SkillTable !")
        return ""
    end
    return l_skillData.Name
end

