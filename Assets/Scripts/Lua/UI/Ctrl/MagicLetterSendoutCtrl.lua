--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MagicLetterSendoutPanel"
require "UI/Template/MagicLetterTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class MagicLetterSendoutCtrl : UIBaseCtrl
MagicLetterSendoutCtrl = class("MagicLetterSendoutCtrl", super)
--lua class define end

--lua functions
function MagicLetterSendoutCtrl:ctor()
	
	super.ctor(self, CtrlNames.MagicLetterSendout, UILayer.Normal, nil, ActiveType.Exclusive)
	
end --func end
--next--
function MagicLetterSendoutCtrl:Init()
	---@type MagicLetterSendoutPanel
	self.panel = UI.MagicLetterSendoutPanel.Bind(self)
	super.Init(self)

	---@type MagicLetterMgr
	self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")

	self.letterInfoPool = self:NewTemplatePool( {
		UITemplateClass = UITemplate.MagicLetterTemplate,
		TemplatePrefab = self.panel.MagicLetterTemplate.gameObject,
		ScrollRect = self.panel.LoopScroll_Letters.LoopScroll
	})
	self.panel.Btn_Sendout:AddClick(function ()
		UIMgr:ActiveUI(UI.CtrlNames.MagicLetter, { isSendLetter=true })
	end,true)
	self.panel.Btn_Close:AddClick(function()
		self:Close()
	end ,true)
	
	self.magicLetterMgr.ReqAllMagicLetters()
end --func end
--next--
function MagicLetterSendoutCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil
	---@Description:关闭面板清空数据，下次重新请求，避免数据不刷新
	self.magicLetterMgr.ClearLetterInfo()
end --func end
--next--
function MagicLetterSendoutCtrl:OnActive()
	self:RefreshPanel()
end --func end
--next--
function MagicLetterSendoutCtrl:OnDeActive()
end --func end
--next--
function MagicLetterSendoutCtrl:Update()
	
	
end --func end
--next--
function MagicLetterSendoutCtrl:BindEvents()
	self:BindEvent(self.magicLetterMgr.EventDispatcher,self.magicLetterMgr.EMagicEvent.OnGetMagicLetterInfo,self.RefreshPanel)
end --func end
--next--
--lua functions end

--lua custom scripts
function MagicLetterSendoutCtrl:RefreshPanel()
    local l_letterInfos = self.magicLetterMgr.GetShowUseLetterInfos()

	local l_hasLetter = l_letterInfos~=nil and #l_letterInfos>0
	self.panel.Panel_NoLetter:SetActiveEx(not l_hasLetter)
	self.letterInfoPool:ShowTemplates({
		Datas = l_letterInfos,
		StartScrollIndex=self.letterInfoPool:GetCellStartIndex(),
		IsNeedShowCellWithStartIndex=false,
		IsToStartPosition=false,
	})

end
--lua custom scripts end
return MagicLetterSendoutCtrl