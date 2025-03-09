--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ChoiceFragrancePanel"
require "UI/Template/FragranceTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ChoiceFragranceCtrl : UIBaseCtrl
ChoiceFragranceCtrl = class("ChoiceFragranceCtrl", super)
--lua class define end

--lua functions
function ChoiceFragranceCtrl:ctor()
	
	super.ctor(self, CtrlNames.ChoiceFragrance, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function ChoiceFragranceCtrl:Init()
	---@type ChoiceFragrancePanel
	self.panel = UI.ChoiceFragrancePanel.Bind(self)
	super.Init(self)

	self.mask = self:NewPanelMask(BlockColor.Dark, nil)

	self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
	self.panel.Btn_Determine:AddClick(function()
		self:Close()
	end,true)
	self.fragrancePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.FragranceTemplate,
		ScrollRect = self.panel.Loop_ChooseEffect.LoopScroll,
		TemplatePrefab = self.panel.Template_Fragrance.gameObject,
	})
end --func end
--next--
function ChoiceFragranceCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ChoiceFragranceCtrl:OnActive()
	self:showFragranceInfo()
end --func end
--next--
function ChoiceFragranceCtrl:OnDeActive()
	

end --func end
--next--
function ChoiceFragranceCtrl:Update()
	
	
end --func end
--next--
function ChoiceFragranceCtrl:BindEvents()
	self:BindEvent(self.magicLetterMgr.EventDispatcher,self.magicLetterMgr.EMagicEvent.OnCurrentChooseFragranceChanged,self.updateSelectedInfo)
	-- self:BindEvent(self.magicLetterMgr.EventDispatcher,self.magicLetterMgr.EMagicEvent.FragranceMovieTexLoadComplete,self.showFragranceInfo)
end --func end
--next--
--lua functions end

--lua custom scripts
function ChoiceFragranceCtrl:showFragranceInfo()
	
	local l_fragranceData = TableUtil.GetMagicPaperTypeTable().GetTable()
	self.fragrancePool:ShowTemplates({
		Datas = l_fragranceData,
		StartScrollIndex=self.fragrancePool:GetCellStartIndex(),
		IsNeedShowCellWithStartIndex=false,
		IsToStartPosition=false,
	})
end

function ChoiceFragranceCtrl:updateSelectedInfo()

	if not self.fragrancePool then return end

	for i = 1, self.fragrancePool:totalCount() do
		local l_item = self.fragrancePool:GetItem(i)
		if l_item then
			l_item:UpdateSelected()
		end
	end
end

--lua custom scripts end
return ChoiceFragranceCtrl