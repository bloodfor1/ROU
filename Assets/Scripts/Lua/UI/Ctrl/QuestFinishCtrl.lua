--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/QuestFinishPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
QuestFinishCtrl = class("QuestFinishCtrl", super)
--lua class define end

--lua functions
function QuestFinishCtrl:ctor()
	logGreen("QuestFinishCtrl ctor")

	super.ctor(self, CtrlNames.QuestFinish, UILayer.Tips, nil, ActiveType.Standalone)
	self.tasks = {}
	self.removeAnim = nil
end --func end
--next--
function QuestFinishCtrl:Init()
	logGreen("QuestFinishCtrl Init")
	self.panel = UI.QuestFinishPanel.Bind(self)
	super.Init(self)
	self:ShowOneTips()
	logGreen("Init self.tasks.count:"..#self.tasks)

end --func end
--next--
function QuestFinishCtrl:Uninit()

	self.tasks = nil
	self.removeAnim = nil

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function QuestFinishCtrl:OnActive()


end --func end
--next--
function QuestFinishCtrl:OnDeActive()


end --func end
--next--
function QuestFinishCtrl:Update()


end --func end



--next--
function QuestFinishCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function QuestFinishCtrl:ShowQuestFinish(task)
	table.insert(self.tasks,task)
	if self.removeAnim ~= nil then
		-- logGreen("stop animation")
		self:StopUITimer(self.removeAnim)
		self.removeAnim = nil
		self:SetQuestFinishState(false)
	end
end

function QuestFinishCtrl:ShowOneTips()
	logGreen("show one tip")
	if self.tasks == nil or #self.tasks < 1 then
		-- logGreen("tasks is nil")
		self.removeAnim = self:NewUITimer(function()
			self:SetQuestFinishState(true)
		end,2)
		self.removeAnim:Start()
		return
	end
	-- logGreen("tasks[1]:"..self.tasks[1].name)

	local questTips = self:CloneObj(self.panel.QuestTips.gameObject, false)
	questTips.transform:SetParent(self.uObj.transform)
	questTips.transform:SetLocalScaleOne()
	questTips.transform:SetLocalPosZero()
	questTips.transform.localRotation = Vector3.New(0, 0, 0)
	questTips.gameObject:SetActiveEx(true)
	questTips.transform:Find("TaskName"):GetComponent("MLuaUICom").LabText = self.tasks[1].name
	table.remove(self.tasks,1)

	local l_timer = self:NewUITimer(function()
		self:ShowOneTips()
	end,0.5)
	l_timer:Start()
end

function QuestFinishCtrl:SetQuestFinishState(state)
	if state then
		UIMgr:DeActiveUI(CtrlNames.QuestFinish)
	else
		self:ShowOneTips()
	end
end

--lua custom scripts end
