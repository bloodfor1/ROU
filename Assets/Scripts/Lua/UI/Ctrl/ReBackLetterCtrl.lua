--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ReBackLetterPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ReBackLetterCtrl : UIBaseCtrl
ReBackLetterCtrl = class("ReBackLetterCtrl", super)
--lua class define end

local effectCount = 3

--lua functions
function ReBackLetterCtrl:ctor()
	
	super.ctor(self, CtrlNames.ReBackLetter, UILayer.Function, nil, ActiveType.Exclusive)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
	self.overrideSortLayer = UILayerSort.Function + 15
	
end --func end
--next--
function ReBackLetterCtrl:Init()
	
	self.panel = UI.ReBackLetterPanel.Bind(self)
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("ReBackMgr")

	self.l_spine = self.panel.SkeletonGraphic.gameObject:GetComponent("SkeletonGraphic")

	self.panel.BtnOpen:AddClickWithLuaSelf(self.OnBtnOpen,self)
	self.panel.BtnFinish:AddClickWithLuaSelf(self.OnBtnFinish,self)
	self.panel.BtnCloseNext:AddClickWithLuaSelf(self.OnBtnOpen,self)
	
end --func end
--next--
function ReBackLetterCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ReBackLetterCtrl:OnActive()

	self.panel.Close:SetActiveEx(true)
	self.panel.Open:SetActiveEx(false)
	
end --func end

function ReBackLetterCtrl:OnShow()
	self:SetEffectVisible(true)
end

function ReBackLetterCtrl:OnHide()
	self:SetEffectVisible(false)
end

function ReBackLetterCtrl:SetEffectVisible(value)
	for i=1,effectCount do
		self.panel.Effect[i]:SetActiveEx(value)
	end
end
--next--
function ReBackLetterCtrl:OnDeActive()

end --func end
--next--
function ReBackLetterCtrl:Update()
	
	
end --func end
--next--
function ReBackLetterCtrl:BindEvents()

	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_WELCOME_NEXT_RES,self.OnWelcomeNext,self)
	self:BindEvent(MgrMgr:GetMgr("RoleTagMgr").EventDispatcher, MgrMgr:GetMgr("RoleTagMgr").RoleTagChangeEvent, self.OnRoleTagChange)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ReBackLetterCtrl:OnBtnOpen()
	self.mgr.ReqPrizeWelcomeNext(nil,0)
end

function ReBackLetterCtrl:OpenLetter()
	self.panel.Close:SetActiveEx(false)
	self.l_spine.startingAnimation = "Open"
	self.l_spine:Initialize(true)
	self:NewUITimer(function()
		self.panel.Open:SetActiveEx(true)
		self.panel.Title.LabText = Common.Utils.Lang("RETURN_LETTER_TITLE",MPlayerInfo.Name)
		self.panel.Content.LabText = Common.Utils.Lang("RETURN_LETTER_CONTENT",self.mgr.GetAFKDay())
	end, 1.5,1):Start()
end

function ReBackLetterCtrl:OnBtnFinish()
	self.mgr.ReqPrizeWelcomeNext()
end

function ReBackLetterCtrl:OnWelcomeNext()
	local statue = self.mgr.GetStatue()
	if statue == ReturnPrizeWelcomeStatus.kReturnPrizeWelcomeStatus_letter or statue == ReturnPrizeWelcomeStatus.kReturnPrizeWelcomeStatus_content then
		self:OpenLetter()
	else
		UIMgr:DeActiveUI(UI.CtrlNames.ReBackLetter)
		UIMgr:ActiveUI(UI.CtrlNames.ReBackTips)
	end
end

function ReBackLetterCtrl:OnRoleTagChange()
	if MPlayerInfo.ShownTagId ~= ROLE_TAG.RoleTagRegress then
		UIMgr:DeActiveUI(UI.CtrlNames.ReBackLetter)
	end
end

--lua custom scripts end
return ReBackLetterCtrl