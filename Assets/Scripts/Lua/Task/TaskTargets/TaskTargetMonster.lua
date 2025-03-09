require "Task/TaskTargets/TaskTargetBase"

--动态怪物任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetMonster = class("TaskTargetMonster",super)

function TaskTargetMonster:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetMonster:TargetNavigation(navType)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.targetId == 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TASK_TARGET_ELITE_MONSTER_TIP"))
        return
    elseif self.targetId == 4 then
        local l_opendata = {
            openType = DataMgr:GetData("IllustrationMonsterData").MonsterOpenType.ShowMini
        }
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonsterBg,l_opendata)
        return
    elseif self.targetId == 5 then
        local l_opendata = {
            openType = DataMgr:GetData("IllustrationMonsterData").MonsterOpenType.ShowMvp
        }
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonsterBg,l_opendata)
        return
    elseif self.targetId == 9 then
        UIMgr:ActiveUI(UI.CtrlNames.FarmPrompt)
        return
    end

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


function TaskTargetMonster:GetTaskTargetDescribe()
    local l_taskTipsCon = StringEx.Format("TASK_TARGET_TIP_{0}_{1}",tostring(self.targetType),tostring(self.targetId))
    return Lang(l_taskTipsCon)
end
return TaskTargetMonster


