--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ReBackPanel"
require "UI/Template/MallItemPrefab"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ReBackCtrl : UIBaseCtrl
ReBackCtrl = class("ReBackCtrl", super)
--lua class define end

--lua functions
function ReBackCtrl:ctor()
	
	super.ctor(self, CtrlNames.ReBack, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function ReBackCtrl:Init()
	
	self.panel = UI.ReBackPanel.Bind(self)
	super.Init(self)

	self.mallMgr = MgrMgr:GetMgr("MallMgr")
	self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")
	self.mgr = MgrMgr:GetMgr("ReBackMgr")

	self.panel.BtnClose:AddClickWithLuaSelf(self.OnBtnClose,self)

	self.redSignProcessorLogin=nil
	self.redSignProcessorTask=nil


end --func end
--next--
function ReBackCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self.mallMgr = nil
	self.openMgr = nil
	self.mgr = nil
	self.redSignProcessorLogin=nil
	self.redSignProcessorTask=nil

end --func end
--next--
function ReBackCtrl:OnActive()

	--MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplay(nil, 0)
	self:InitPreSelect()
	self:InitCustomHandlers()
	self:InitHandler(self.handlerTable, self.panel.Toggle, self.panel.MainView, self.selectDefaultHandler)

	self:_showRedSign()
end --func end
--next--
function ReBackCtrl:OnDeActive()

	-- 重置货币栏显示货币种类
	MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplay(nil, 0)

end --func end

function ReBackCtrl:OnHandlerSwitch(handlerName, lastHandlerName)
	self:SetCurrency(handlerName == UI.HandlerNames.ReBackMallGold)
end

function ReBackCtrl:OnShow()
	self:SetCurrency(self.curHandler and self.curHandler.name == UI.HandlerNames.ReBackMallGold)
end

--next--
function ReBackCtrl:Update()


	super.Update(self)

end --func end
--next--
function ReBackCtrl:BindEvents()
	local l_roleTagMgr = MgrMgr:GetMgr("RoleTagMgr")
	self:BindEvent(l_roleTagMgr.EventDispatcher, l_roleTagMgr.RoleTagChangeEvent, self._roleTagChangeEvent)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ReBackCtrl:OnBtnClose()
	UIMgr:DeActiveUI(UI.CtrlNames.ReBack)
end

function ReBackCtrl:InitPreSelect()
	self.mallMgr.SelectTab = nil
	if self.uiPanelData then
		self.preSelectMajorId = self.uiPanelData.MajorID
		if self.preSelectMajorId then
			self:OnFindItem(self.preSelectMajorId)
		end
	end

end

function ReBackCtrl:InitCustomHandlers()

	self:EnsureUnloadHandler(UI.HandlerNames.ReBackTask)
	self:EnsureUnloadHandler(UI.HandlerNames.ReBackMallGold)

	self.handlerTable = {}
	local l_eSystemId = self.openMgr.eSystemId
	local l_checkFunc = self.openMgr.IsSystemOpen

	if l_checkFunc(l_eSystemId.ReturnLogin)  then
		table.insert(self.handlerTable, {UI.HandlerNames.ReBackLogin, Lang("RETURN_TAG_LOGIN")})
	end

	if l_checkFunc(l_eSystemId.ReturnTask)  then
		table.insert(self.handlerTable, {UI.HandlerNames.ReBackTask, Lang("RETURN_TAG_TASK")})
	end
	if l_checkFunc(l_eSystemId.ReturnPayShop) or l_checkFunc(l_eSystemId.ReturnPointShop) then
		table.insert(self.handlerTable, {UI.HandlerNames.ReBackMallGold, Lang("RETURN_TAG_SHOP")})
	end

	if l_checkFunc(l_eSystemId.ReBackPrivilege)  then
		table.insert(self.handlerTable, {UI.HandlerNames.ReBackPrivilege, Lang("RETURN_TAG_PRIVILEGE")})
	end

	if self.preSelectMajorId and (l_checkFunc(l_eSystemId.ReturnPayShop) or l_checkFunc(l_eSystemId.ReturnPointShop)) then
		self.selectDefaultHandler = UI.HandlerNames.ReBackMallGold
	else
		self.selectDefaultHandler = UI.HandlerNames.ReBackLogin
	end
end

--寻找商品
function ReBackCtrl:OnFindItem(majorID)
	local l_table = TableUtil.GetMallTable().GetTable()
	for i, v in ipairs(l_table) do
		if v.MajorID == majorID then
			self.mallMgr.chooseItem = v
			self.mallMgr.SelectTab = v.Tab
			return
		end
	end
end

function ReBackCtrl:SetCurrency(show)
	if show then
		local l_uiPanelConfigData = {}
		l_uiPanelConfigData.InsertPanelName = UI.CtrlNames.ReBack

		local currencyPanelData= {}
		currencyPanelData.CurrencyDisplay={103,403}
		UIMgr:ActiveUI(UI.CtrlNames.Currency, currencyPanelData, l_uiPanelConfigData)
	else
		UIMgr:DeActiveUI(UI.CtrlNames.Currency)
	end
end

function ReBackCtrl:_roleTagChangeEvent()
	if MPlayerInfo.ShownTagId ~= ROLE_TAG.RoleTagRegress then
		UIMgr:DeActiveUI(UI.CtrlNames.ReBack)
	end
end

function ReBackCtrl:_showRedSign()
	if self.redSignProcessorLogin==nil then
		self.redSignProcessorLogin=self:NewRedSign({
			Key=eRedSignKey.ReBackLogin,
			ClickButton=self:GetHandlerByName(HandlerNames.ReBackLogin).toggle:GetComponent("MLuaUICom"),
		})
	end

	if self.redSignProcessorTask==nil then
		self.redSignProcessorTask=self:NewRedSign({
			Key=eRedSignKey.ReBackTask,
			ClickButton=self:GetHandlerByName(HandlerNames.ReBackTask).toggle:GetComponent("MLuaUICom"),
		})
	end
end

function ReBackCtrl:SetResetTimeInfo(handlerName)

end

--lua custom scripts end
return ReBackCtrl