--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DelegateBranchPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
DelegateBranchCtrl = class("DelegateBranchCtrl", super)
--lua class define end

--lua functions
function DelegateBranchCtrl:ctor()
	
	super.ctor(self, CtrlNames.DelegateBranch, UILayer.Function, nil, ActiveType.Exclusive)
	self.currentSelectTaskId = 0
end --func end
--next--
function DelegateBranchCtrl:Init()
	
	self.panel = UI.DelegateBranchPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function DelegateBranchCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function DelegateBranchCtrl:OnActive()
	self.panel.ConfirmTips.LabText = tostring(self.uiPanelData.tips)

	self:InitOptionals()

	self.panel.BtnNo:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.DelegateBranch)
    end)
    self.panel.ButtonClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.DelegateBranch)
    end)

	self.panel.BtnYes:AddClick(function( ... )
		local l_taskId = self.uiPanelData.taskId
		if self.currentSelectTaskId == 0 or l_taskId == 0 then
			return
		end
		UIMgr:DeActiveUI(UI.CtrlNames.DelegateBranch)
		MgrMgr:GetMgr("TaskMgr").RequestTaskAccept(l_taskId,self.currentSelectTaskId)
	end)

end --func end

function DelegateBranchCtrl:InitOptionals( ... )
	self.optionCache = {}

	local l_taskDatas = self.uiPanelData.taskData

	local l_expendStr = Lang("DELEGATE_DANCE_TASK_EXPENDS_INFO")
	local l_enough = false
	for i=1,#l_taskDatas do
		local l_taskData = l_taskDatas[i]
		local l_option = self:CloneObj(self.panel.OptionTpl.gameObject)
		l_option.transform:SetParent(self.panel.Options.transform)
		l_option.transform:SetLocalScaleOne()
		l_option.gameObject:SetActiveEx(true)
		l_expendStr = l_expendStr..tostring(l_taskData.expendCount)
		l_tipInfo = l_option.transform:Find("TogLab"):GetComponent("MLuaUICom")
		if i < #l_taskDatas then
			l_expendStr = l_expendStr..Lang("DELEGATE_DANCE_TASK_EXPENDS_INFO_OR")
		end
		local l_comRef = l_option:GetComponent("MLuaUICom")
		l_comRef:OnToggleChanged(function(value)
			self.currentSelectTaskId = l_taskData.taskId
		end)
		local l_tipStr =  StringEx.Format(Lang("DELEGATE_DANCE_TASK_TIPS"),l_taskData.expendCount,self:GetDanceTimeWithTask(l_taskData.taskId))
		
		if l_taskData.expendEnough then
			if not l_enough then
				l_enough = true
				l_comRef.Tog.isOn = true
			end
			l_comRef.Tog.interactable = true
			l_tipInfo.LabText = GetColorText(l_tipStr,RoColorTag.Blue)
		else
			l_comRef.Tog.interactable = false
			l_tipInfo.LabText = GetColorText(l_tipStr,RoColorTag.Red)

		end				
		table.insert(self.optionCache,l_option)
	end
	self.panel.ExpendInfo.LabText = l_expendStr

end

function DelegateBranchCtrl:GetDanceTimeWithTask(taskId)
	local l_taskData = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(taskId)
	if l_taskData == nil then
		return 0
	end
	local l_danceTargetMsg = l_taskData.targetMsgEx[1]
	if Common.Utils.IsNilOrEmpty(l_danceTargetMsg) then
		return 0
	end
 	local l_tmp = string.ro_split(l_danceTargetMsg, "=")
 	if #l_tmp == 2 then
 		local l_minutes = math.ceil(tonumber(l_tmp[2]) / 60)
 		return l_minutes
 	end
	return 0
end

--next--
function DelegateBranchCtrl:OnDeActive()
	
	if self.optionCache == nil then
		return
	end

	for i=1,#self.optionCache do
		local l_option = self.optionCache[i]
		if l_option ~= nil then
			MResLoader:DestroyObj(l_option)
		end
	end
	self.optionCache = nil
end --func end
--next--
function DelegateBranchCtrl:Update()
	
	
end --func end
--next--
function DelegateBranchCtrl:Refresh()
	
	
end --func end
--next--
function DelegateBranchCtrl:OnLogout()
	
	
end --func end
--next--
function DelegateBranchCtrl:OnReconnected(roleData)
	
	
end --func end
--next--
function DelegateBranchCtrl:Show(withTween)
	
	if not super.Show(self, withTween) then return end
	
end --func end
--next--
function DelegateBranchCtrl:Hide(withTween)
	
	if not super.Hide(self, withTween) then return end
	
end --func end
--next--
function DelegateBranchCtrl:BindEvents()
	
	
end --func end
--next--
function DelegateBranchCtrl:UnBindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return DelegateBranchCtrl