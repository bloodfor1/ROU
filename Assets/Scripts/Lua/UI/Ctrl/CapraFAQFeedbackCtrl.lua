--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CapraFAQFeedbackPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
CapraFAQFeedbackCtrl = class("CapraFAQFeedbackCtrl", super)
--lua class define end

--lua functions
function CapraFAQFeedbackCtrl:ctor()
	
	super.ctor(self, CtrlNames.CapraFAQFeedback, UILayer.Function, nil, ActiveType.None)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function CapraFAQFeedbackCtrl:Init()
	
	self.panel = UI.CapraFAQFeedbackPanel.Bind(self)
	super.Init(self)

	self.panel.ButtonClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.CapraFAQFeedback)
	end)

	self.panel.CancelButton:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.CapraFAQFeedback)
	end)

	self.panel.ConfirmButton:AddClick(function()
		local l_question = self.panel.QuestionInputField.Input.text
		if string.ro_isEmpty(l_question) then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CapraFAQFeedback_NoQuestion"))
			return
		end
		MgrMgr:GetMgr("CapraFAQMgr").RequestFAQReportOnSendQuestion(l_question)

		UIMgr:DeActiveUI(UI.CtrlNames.CapraFAQFeedback)
	end)

	self.panel.QuestionInputField.Input.onValueChanged:AddListener(function(value)
		self:_onQuestionInputField(value)
	end)

	
end --func end
--next--
function CapraFAQFeedbackCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function CapraFAQFeedbackCtrl:OnActive()
	
	
end --func end
--next--
function CapraFAQFeedbackCtrl:OnDeActive()
	
	
end --func end
--next--
function CapraFAQFeedbackCtrl:Update()
	
	
end --func end
--next--
function CapraFAQFeedbackCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function CapraFAQFeedbackCtrl:_onQuestionInputField(value)
    local l_textNum = string.ro_len_normalize(value)
    self.panel.Text_Num.LabText = StringEx.Format("{0}/200",l_textNum)
	if string.ro_isEmpty(value) then
		self.panel.QuestionInputFieldImage:SetActiveEx(true)
		return
	end
	self.panel.QuestionInputFieldImage:SetActiveEx(false)

end
--lua custom scripts end
return CapraFAQFeedbackCtrl