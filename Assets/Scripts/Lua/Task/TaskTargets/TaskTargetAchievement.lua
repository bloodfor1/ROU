require "Task/TaskTargets/TaskTargetBase"

--拍照类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetAchievement = class("TaskTargetAchievement",super)

function TaskTargetAchievement:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.exNavType = nil
    self.exNavFuncEvt = nil	
    self.exNavFuncArg = nil	

     if not string.ro_isEmpty(self.msgEx) then
        local l_tmp = string.ro_split(self.msgEx, "=")
        self.exNavType = tonumber(l_tmp[1])

        if #l_tmp == 3 then
            if self.exNavType == 2 then
                self.exNavFuncEvt = tonumber(l_tmp[2])  
                self.exNavFuncArg = l_tmp[3]
            end
        elseif #l_tmp == 2 then 
            if self.exNavType == 3 then
                self.exNavFuncEvt = tonumber(l_tmp[2])
                self.exNavFuncArg = nil
            end
        end
    end
end

--不同子类根据情况重写
function TaskTargetAchievement:TaskTargetNavigation()
    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position)
    else
    	if self.exNavType == nil then
    		return
    	end
    	if self.exNavType == 1 then
    		local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    		local l_taskId = l_taskMgr.GetCurrentMainTaskId()
    		if l_taskId ~= nil then
    			l_taskMgr.OnQuickTaskClickWithTaskId(l_taskId)	
    		end
    		return
    	end
    	if self.exNavType == 2 then
    		if self.exNavFuncEvt == nil then
    			return
    		end

            local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
            if not l_openSystemMgr.IsSystemOpen(self.exNavFuncEvt) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_openSystemMgr.GetOpenSystemTipsInfo(self.exNavFuncEvt))               
                return
            end

    		local cMethod = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(self.exNavFuncEvt)
    		if cMethod ~= nil then
                --暂时不处理打开界面传参的情况  具体需求确定及各模块做完支持之后再处理
    			-- if self.exNavFuncArg ~= nil then
    			-- 	cMethod(self.exNavFuncArg)
    			-- else
    			-- 	cMethod()
    			-- end
                cMethod()
    		end
    		return
    	end
        if self.exNavType == 3 then
            if self.exNavFuncEvt == 0 or self.exNavFuncEvt == nil then
                return
            end
            local l_taskId = self.exNavFuncEvt
            local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
            if l_taskMgr.CheckTaskFinished(l_taskId) then
                logRed("该任务已经完成,请@韬哥检查下逻辑")
                return
            end
            local l_taskStatus = l_taskMgr.GetPreShowTaskStatusWithTaskId(l_taskId)
            if l_taskStatus ~= l_taskMgr.ETaskStatus.NotTake then
                l_taskMgr.OnQuickTaskClickWithTaskId(l_taskId)
                return
            end
            local l_acceptLv = l_taskMgr.GetTaskAcceptBaseLv(l_taskId)
            if MPlayerInfo.Lv < l_acceptLv then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("TASK_ACCEPT_BASE_LV_LIMITED_TIP"),l_acceptLv))                         
            end
        end
    end
end


function TaskTargetAchievement:GetTaskTargetName()
    local l_achievementData = TableUtil.GetAchievementDetailTable().GetRowByID(self.targetId)
    if l_achievementData == nil then
        logError("achievement :<"..self.targetId.."> not exists in AchievementDetailTable")
        return ""
    end
    return l_achievementData.Name
end