--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/ConsultationPanel"
require "UI/Template/CapraQuestionTemplate"
require "UI/Template/CapraAnswerTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
ConsultationHandler = class("ConsultationHandler", super)
--lua class define end

--lua functions
function ConsultationHandler:ctor()
	
	super.ctor(self, HandlerNames.Consultation, 0)
	
end --func end
--next--
function ConsultationHandler:Init()
	
	self.panel = UI.ConsultationPanel.Bind(self)
	super.Init(self)

	self.mgr=MgrMgr:GetMgr("CapraFAQMgr")

	self.panel.CapraQuestionTipsParent:SetActiveEx(false)

	self.panel.CapraQuestionPrefab.gameObject:SetActiveEx(false)
	self.panel.CapraAnswerPrefab.gameObject:SetActiveEx(false)

	self.panel.QuestionInputField.Input.onValueChanged:AddListener(function(value)
		self:_onQuestionInputField(value)
	end)

	self.panel.SearchButton:AddClick(function ()
        self.mgr.CloseCapraQuestionTipsParent()
		self:_onSearchButton()
	end)

	self.questionTipsPool = self:NewTemplatePool({
		TemplateClassName = "CapraQuestionTipsTemplate",
		TemplatePrefab = self.panel.CapraQuestionTipsPrefab.gameObject,
		TemplateParent = self.panel.CapraQuestionTipsParent.transform,
		Method = function(value)
			self:_onQuestionTips(value)
		end
	})

	self.questionAndAnswerPool=self:NewTemplatePool({
		ScrollRect=self.panel.CapraFAQScroll.LoopScroll,
		PreloadPaths = {},
		GetTemplateAndPrefabMethod = function(data)
			return self:GetTemplateAndPrefab(data)
		end,
		GetDatasMethod = MgrMgr:GetMgr("CapraFAQMgr").GetCapraFAQQuestionDatas
	})
	
end --func end
--next--
function ConsultationHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self.mgr=nil
	self.questionTipsPool=nil
	self.questionAndAnswerPool=nil
	
end --func end
--next--
function ConsultationHandler:OnActive()

	self.mgr.SetDefaultAnswer()

	if self.mgr.OnOpenConsultationQuestion then
		self:_askQuestion(self.mgr.OnOpenConsultationQuestion)
		self.mgr.OnOpenConsultationQuestion=nil
	end

	self.questionAndAnswerPool:ShowTemplates({StartScrollIndex=self.mgr.GetCapraFAQQuestionCount()})
	
end --func end
--next--
function ConsultationHandler:OnDeActive()
	
	
end --func end
--next--
function ConsultationHandler:Update()
	
	
end --func end
--next--
function ConsultationHandler:BindEvents()
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.HTTP_KEYWORD_DATA_BACK, self._onReceiveSelectQuestions)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.HTTP_ANSWER_DATA_BACK, self._onReceiveSearchQuestion)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.SendAskQuestionEvent, self._askQuestion)
	self:BindEvent(self.mgr.EventDispatcher,DataMgr:GetData("CapraFAQData").CLOSE_CAPRA_TIPS_Parent, self._closeTips)

end --func end
--next--
--lua functions end

--lua custom scripts

function ConsultationHandler:_closeTips()
    self.panel.CapraQuestionTipsParent:SetActiveEx(false)
end

function ConsultationHandler:GetTemplateAndPrefab(data)
	if data==nil then
		return
	end
	if data.IsQuestion then
		l_class = UITemplate.CapraQuestionTemplate
		l_prefab = self.panel.CapraQuestionPrefab.gameObject
	else
		l_class = UITemplate.CapraAnswerTemplate
		l_prefab = self.panel.CapraAnswerPrefab.gameObject
	end
	return l_class,l_prefab
end

function ConsultationHandler:_onQuestionInputField(value)

	if string.ro_isEmpty(value) then
		self.panel.QuestionInputFieldImage:SetActiveEx(true)
		self.panel.CapraQuestionTipsParent:SetActiveEx(false)
		return
	end

	self.panel.QuestionInputFieldImage:SetActiveEx(false)
	self.mgr.GetHttpRequest(self.mgr.HttpType.KeyWord, value)

end

function ConsultationHandler:_onQuestionTips(question)
	if question == nil then
		return
	end
	self.panel.QuestionInputField.Input.text = ""
	self.panel.CapraQuestionTipsParent:SetActiveEx(false)
	self:_askQuestion(question)
end

function ConsultationHandler:_onReceiveSelectQuestions(questions)

	self.panel.CapraQuestionTipsParent:SetActiveEx(false)
	if questions == nil then
		return
	end
	local l_datas=questions.result
	if l_datas==nil then
		return
	end

	if #l_datas == 0 then
		return
	end

	self.panel.CapraQuestionTipsParent:SetActiveEx(true)
	self.questionTipsPool:ShowTemplates({Datas = l_datas})

end

--点击搜索按钮
function ConsultationHandler:_onSearchButton()
	local l_question = self.panel.QuestionInputField.Input.text
	if string.ro_isEmpty(l_question) then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Consultation_OnSearchButtonTips"))
		return
	end

	self:_askQuestion(l_question)
end

function ConsultationHandler:_askQuestion(question)

	if string.ro_isEmpty(question) then
		return
	end

	local l_data={}
	l_data.IsQuestion=true
	l_data.Text=question

	self.mgr.SetCapraFAQQuestionData(l_data)

	self.mgr.GetHttpRequest(self.mgr.HttpType.Answer, question)
end

--点击搜索按钮后收到返回的答案
function ConsultationHandler:_onReceiveSearchQuestion(question)
	local l_data={}
	l_data.IsQuestion=false
	l_data.Text=question.answer
	l_data.Keyword=question.keyword
	l_data.Question=question.httpkey

	self.mgr.SetCapraFAQQuestionData(l_data)

	self.mgr.RequestFAQReportOnGetAnswer(question.httpkey, question.answer)

	self.questionAndAnswerPool:ShowTemplates({StartScrollIndex=self.mgr.GetCapraFAQQuestionCount()})
end
--lua custom scripts end
return ConsultationHandler