--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/NewPlayerPanel"
require "UI/Template/MallItemPrefab"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class NewPlayerCtrl : UIBaseCtrl
NewPlayerCtrl = class("NewPlayerCtrl", super)
--lua class define end

--lua functions
function NewPlayerCtrl:ctor()
	
	super.ctor(self, CtrlNames.NewPlayer, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function NewPlayerCtrl:Init()
	
	self.panel = UI.NewPlayerPanel.Bind(self)
	super.Init(self)

	self.mallMgr = MgrMgr:GetMgr("MallMgr")
	self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")
	self.mgr = MgrMgr:GetMgr("NewPlayerMgr")
	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.NewPlayer)
	end)
	
end --func end
--next--
function NewPlayerCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self.mallMgr = nil
	self.openMgr = nil
	self.mgr = nil
	
end --func end
--next--
function NewPlayerCtrl:OnActive()

	self:InitCustomHandlers()
	self:InitHandler(self.handlerTable, self.panel.Toggle, self.panel.MainView, self.selectDefaultHandler)
	self:SetCurrency(true)

end --func end
--next--
function NewPlayerCtrl:OnDeActive()
	MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplay(nil, 0)
end --func end
--next--
function NewPlayerCtrl:Update()
	super.Update(self)
end --func end
--next--
function NewPlayerCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function NewPlayerCtrl:SetResetTimeInfo(handlerName)

end

function NewPlayerCtrl:OnHandlerSwitch(handlerName)
	--self:SetCurrency(handlerName == UI.HandlerNames.NewPlayerMail)
end

function NewPlayerCtrl:SetCurrency(show)

	if show then
		local l_uiPanelConfigData = {}
		l_uiPanelConfigData.InsertPanelName = UI.CtrlNames.NewPlayer
		local currencyPanelData = {}
		currencyPanelData.CurrencyDisplay = {103, 102, 101}
		UIMgr:ActiveUI(UI.CtrlNames.Currency, currencyPanelData, l_uiPanelConfigData)
	else
		UIMgr:DeActiveUI(UI.CtrlNames.Currency)
	end

end

function NewPlayerCtrl:InitCustomHandlers()

	self.handlerTable = {}
	local l_eSystemId = self.openMgr.eSystemId
	local l_checkFunc = self.openMgr.IsSystemOpen
	if l_checkFunc(l_eSystemId.NewPlayerGift)  then
		table.insert(self.handlerTable, {UI.HandlerNames.NewPlayerBox, Lang("NEW_PLAYER_GIFT")})
	end
	if l_checkFunc(l_eSystemId.NewPlayerShop)  then
		table.insert(self.handlerTable, {UI.HandlerNames.NewPlayerMail, Lang("RETURN_TAG_SHOP")})
	end
	if l_checkFunc(l_eSystemId.NewPlayerShow)  then
		table.insert(self.handlerTable, {UI.HandlerNames.NewPlayerPrivilege, Lang("NEW_PLAYER_SHOW")})
	end
	self.selectDefaultHandler = UI.HandlerNames.NewPlayerBox

end
--lua custom scripts end
return NewPlayerCtrl