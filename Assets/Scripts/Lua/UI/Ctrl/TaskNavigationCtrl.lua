--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TaskNavigationPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
TaskNavigationCtrl = class("TaskNavigationCtrl", super)
--lua class define end

--lua functions
function TaskNavigationCtrl:ctor()

	super.ctor(self, CtrlNames.TaskNavigation, UILayer.Function, nil, ActiveType.Standalone)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Transparent
	self.ClosePanelNameOnClickMask=UI.CtrlNames.TaskNavigation

end --func end
--next--
function TaskNavigationCtrl:Init()
	self.panel = UI.TaskNavigationPanel.Bind(self)
	super.Init(self)
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --	UIMgr:DeActiveUI(UI.CtrlNames.TaskNavigation)
    --end)
	self.initPositionY = 130
	self.targetCache = {}
	for i=1,5 do
		local l_targetTag = StringEx.Format("Target_{0}",i)
		local l_textTag = StringEx.Format("TargetText_{0}",i)
		local l_targetObj = self.panel[l_targetTag]
		local l_textObj = self.panel[l_textTag]
		if l_targetObj ~= nil and l_textObj ~= nil then
			local l_target = {}
			l_target.ui = l_targetObj
			l_target.text = l_textObj
			l_target.data = nil
			table.insert(self.targetCache,l_target)
		end
	end
end --func end
--next--
function TaskNavigationCtrl:Uninit()
	self.targetCache = nil
	self.taskData = nil
	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function TaskNavigationCtrl:OnActive()


end --func end
--next--
function TaskNavigationCtrl:OnDeActive()


end --func end
--next--
function TaskNavigationCtrl:Update()


end --func end



--next--
function TaskNavigationCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function TaskNavigationCtrl:SetNavigationData(taskData,targetList)
	local l_cnt = #targetList
	local l_positionY = self.initPositionY

	if l_cnt > 3 then
		l_positionY = self.initPositionY + (l_cnt - 3) * 35
	end
	 MLuaCommonHelper.SetRectTransformPosY(self.panel.TargetList.gameObject, l_positionY)
	for i=1,#self.targetCache do
		local l_target = self.targetCache[i]
		if i > l_cnt then
			l_target.ui:SetActiveEx(false)
		else
			l_target.ui:SetActiveEx(true)
			l_target.data = targetList[i]
			l_target.text.LabText = l_target.data:GetTaskTargetDescribe()
			l_target.ui:AddClick(
		        function ()
	        		l_target.data:TargetNavigation(taskData.tableData.navType)
		        	UIMgr:DeActiveUI(UI.CtrlNames.TaskNavigation)
		        end
    		)
		end
	end
end

--lua custom scripts end
return TaskNavigationCtrl