--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class AdvancedConditionTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TaskImage MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom

---@class AdvancedConditionTem : BaseUITemplate
---@field Parameter AdvancedConditionTemParameter

AdvancedConditionTem = class("AdvancedConditionTem", super)
--lua class define end

--lua functions
function AdvancedConditionTem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function AdvancedConditionTem:OnDestroy()
	
	
end --func end
--next--
function AdvancedConditionTem:OnDeActive()
	
	
end --func end
--next--
function AdvancedConditionTem:OnSetData(data)
	
	    --curlvl
	    --佣兵当前等级
	    --targetlvl
	    --用兵可进阶等级
	    --taskId
	    --进阶任务
	    --可为nil
	    --先传入taskId = nil的data
	    if self:_finish(data) then
	        self.Parameter.GotoButton.gameObject:SetActiveEx(false)
	        self.Parameter.Finish.gameObject:SetActiveEx(true)
	        l_color = RoColor.Hex2Color(RoColor.WordColor.Green[1])
	    else
	        self.Parameter.GotoButton.gameObject:SetActiveEx(true)
	        self.Parameter.Finish.gameObject:SetActiveEx(false)
	        l_color = RoColor.Hex2Color(RoColor.WordColor.Red[1])
	    end
	    if data.taskId == nil then
	        self.Parameter.Point.LabText = StringEx.Format(Common.Utils.Lang("Mercenary_Advanced_Lv"), data.targetlvl)
	        self.Parameter.GotoButton.gameObject:SetActiveEx(false)
	    else
	        local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(data.taskId)
	        if l_taskInfo == nil then
	            return
	        end
	        self.Parameter.TaskImage:SetActiveEx(true)
	            --临时处理，需要补充任务完成所需的等级
	        self.Parameter.Point.LabText = Lang("MERCENARY_LEVEL", l_taskInfo.minBaseLevel) .. Common.Utils.Lang("DUNGEONS_TASK_State2") .. StringEx.Format("[{0}]", l_taskInfo.name)
	        self.Parameter.GotoButton:AddClick(function()
	            if data.curlvl >= data.targetlvl then
	                UIMgr:DeActiveUI(UI.CtrlNames.Mercenary)
	                UIMgr:DeActiveUI(UI.CtrlNames.MercenaryAdvanced)
	                MgrMgr:GetMgr("TaskMgr").NavToTaskAcceptNpc(data.taskId)
	            else
	                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Mercenary_Advanced_LvLow"))
	            end
	        end)
	    end
	    self.Parameter.Point.LabColor = l_color
	
end --func end
--next--
function AdvancedConditionTem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AdvancedConditionTem:_finish(data)
    if data.taskId == nil then
        return data.curlvl >= data.targetlvl
    else
        return MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(data.taskId)
    end
end
--lua custom scripts end
return AdvancedConditionTem