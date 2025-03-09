--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SelectElementShowExpressionPanel"





require "UI/Template/SelectElementExpressionTemplate"
require "UI/Template/SelectElementFaceExpressionTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
SelectElementShowExpressionHandler = class("SelectElementShowExpressionHandler", super)
--lua class define end

local table_insert = table.insert
--lua functions
function SelectElementShowExpressionHandler:ctor()

	super.ctor(self, HandlerNames.SelectElementShowExpression, 0)

end --func end
--next--
function SelectElementShowExpressionHandler:Init()

	self.panel = UI.SelectElementShowExpressionPanel.Bind(self)
	super.Init(self)

	self.expression_pool = self:NewTemplatePool({
		UITemplateClass = UITemplate.SelectElementExpressionTemplate,
		TemplateParent = self.panel.SingleActionContent.transform,
		TemplatePrefab = self.panel.BtnExpressionInstance.LuaUIGroup.gameObject,
		ScrollRect = self.panel.Scroll1.LoopScroll,
	})
	-- 时尚评分不显示表情
	self.panel.Scroll1:SetActiveEx(not MgrMgr:GetMgr("FashionRatingMgr").IsFashionRatingPhoto)

	self.face_expression_pool = self:NewTemplatePool({
		UITemplateClass = UITemplate.SelectElementFaceExpressionTemplate,
		TemplateParent = self.panel.SingleActionContent.transform,
		TemplatePrefab = self.panel.BtnFaceExpressionInstance.LuaUIGroup.gameObject,
		ScrollRect = self.panel.Scroll2.LoopScroll,
	})
end --func end
--next--
function SelectElementShowExpressionHandler:Uninit()

	self.expression_pool = nil
	self.face_expression_pool = nil

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function SelectElementShowExpressionHandler:OnActive()

	local l_data1 = {}
	local l_expressionTable = TableUtil.GetShowExpressionTable().GetTable()
	for _,row in pairs(l_expressionTable) do
		if row.ShowType == 0 then
			table_insert(l_data1, row)
		end
	end

	self.expression_pool:ShowTemplates({Datas = l_data1, Method = function(row)
		self:ShowExpression(row)
	end})

	local l_data2 = {}
	local l_faceExpressionTable = TableUtil.GetShowFaceExpressionTable().GetTable()
	for _,row in pairs(l_faceExpressionTable) do
		local l_isMale = MPlayerInfo.IsMale
		if (l_isMale == true and row.MaleFaceExpression ~= -1) or (l_isMale == false and row.FemaleFaceExpression ~= -1) then
			table_insert(l_data2, row)
		end
	end

	self.face_expression_pool:ShowTemplates({Datas = l_data2, Method = function(row)
		self:ShowFaceExpression(row)
	end})
end --func end
--next--
function SelectElementShowExpressionHandler:OnDeActive()

end --func end
--next--
function SelectElementShowExpressionHandler:Update()


end --func end


--next--
function SelectElementShowExpressionHandler:BindEvents()

	--dont override this function

end --func end
--next--
--lua functions end

--lua custom scripts


function SelectElementShowExpressionHandler:ShowExpression(row)
	MEventMgr:LuaFireEvent(MEventType.MEvent_ShowHeadExpression, MEntityMgr.PlayerEntity, row.ID)
	MgrMgr:GetMgr("SyncTakePhotoStatusMgr").BroadacstExpression(row.ID)

	local l_photographCtrl = UIMgr:GetUI(UI.CtrlNames.Photograph)
	if l_photographCtrl then
		l_photographCtrl:SetExpression(row.ID, row.PlayTime)
	end
end

function SelectElementShowExpressionHandler:ShowFaceExpression(row)

	local l_isMale = MPlayerInfo.IsMale
	local l_expression
	if l_isMale then
		l_expression = row.MaleFaceExpression
	else
		l_expression = row.FemaleFaceExpression
	end
	MEventMgr:LuaFireEvent(MEventType.MEvent_ChangeEmotion, MEntityMgr.PlayerEntity, row.Time, l_expression[0], l_expression[1])
	MgrMgr:GetMgr("SyncTakePhotoStatusMgr").BroadacstFaceExpression(row.ID)

	local l_photographCtrl = UIMgr:GetUI(UI.CtrlNames.Photograph)
	if l_photographCtrl then
		l_photographCtrl:SetAction(row.ID)
	end
end
--lua custom scripts end
