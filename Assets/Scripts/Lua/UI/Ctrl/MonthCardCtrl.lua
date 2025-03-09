--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MonthCardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_monthCardMgr = MgrMgr:GetMgr("MonthCardMgr")
--lua fields end

--lua class define
MonthCardCtrl = class("MonthCardCtrl", super)
--lua class define end

--lua functions
function MonthCardCtrl:ctor()
	
	super.ctor(self, CtrlNames.MonthCard, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function MonthCardCtrl:Init()
	self.panel = UI.MonthCardPanel.Bind(self)
	super.Init(self)
	self.scrollRect=nil
	self:initPanel()
end --func end
--next--
function MonthCardCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	if self.scrollRect then
		self.scrollRect.OnStartDrag=nil
		self.scrollRect.OnEndDrag=nil
		self.scrollRect.OnItemIndexChanged=nil
		self.scrollRect.onInitItem=nil
		self.scrollRect=nil
	end

end --func end
--next--
function MonthCardCtrl:OnActive()
	l_monthCardMgr.GetMonthCardRewardTxt()
	self:ShowPanel()
end --func end
--next--
function MonthCardCtrl:OnDeActive()
	
	
end --func end
--next--
function MonthCardCtrl:Update()
	if self.MonthCardShowTems then
		for key, value in pairs(self.MonthCardShowTems) do
			value:Update()
		end
	end
end --func end
--next--
function MonthCardCtrl:BindEvents()
	
end --func end
--next--
--lua functions end

--lua custom scripts
--当前的最大数量
function MonthCardCtrl:initPanel()
	self.scrollRect = self.panel.RingScrollRect.gameObject:GetComponent("MoonClient.MRingScrollRect")
	self.panel.Panel_TwoShowItem:SetActiveEx(false)

	self.panel.Btn_ChangeLeft:AddClick(function()
		local index = self.scrollRect.CurItemIndex
		if index == 0 then
			index = maxScrollCount - 1
		else
			index = index - 1
		end
		self.scrollRect:SelectIndex(index, true)
	end)

	self.panel.Btn_ChangeRight:AddClick(function()
		local index = self.scrollRect.CurItemIndex
		if index == maxScrollCount - 1 then
			index = 0
		else
			index = index + 1
		end
		self.scrollRect:SelectIndex(index, true)
	end)

	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.MonthCard)
	end)

	self.scrollRect.OnItemIndexChanged = function()
		for key, value in pairs(self.MonthCardShowTems) do
			value:ShowItemMask(self.scrollRect.CurItemIndex+1)
		end
	end
end

local maxScrollCount = 3
local l_openSystem = MgrMgr:GetMgr("OpenSystemMgr")
function MonthCardCtrl:ShowPanel(arg1, arg2, arg3)
	maxScrollCount = 3
	local l_isOpenSubscribeTo = l_openSystem.IsSystemOpen(l_openSystem.eSystemId.SubscribeTo)
	local l_isOpenPrivilegedPackage = l_openSystem.IsSystemOpen(l_openSystem.eSystemId.PrivilegedPackage)

	--- 仅显示两个选项卡是特殊排版展示
	if not l_isOpenSubscribeTo then
		maxScrollCount = 2
		self:onOnlyNeedShowTwoItem()
		return
	end

	if not l_isOpenPrivilegedPackage then
		maxScrollCount = 1
	end
	self.MonthCardShowTems = {}
	self.scrollRect.onInitItem = function(go, index)
		local l_curIndex = index+1
		if not l_isOpenPrivilegedPackage and index == 2 then
			l_curIndex = 3
		end
		local l_showItemMaskIndex = 0
		--初始化设置一下Mask
		if index + 1 == maxScrollCount then
			l_showItemMaskIndex = 1
		end
		self.MonthCardShowTems[index]=self:NewTemplate("MonthCardShowItem",{
			TemplateInstanceGo = go,
			TemplateParent = go.transform.parent,
			Data = 
			{
				ShowType = l_curIndex,
				showItemMaskIndex = l_showItemMaskIndex
			},
		})
	end
	self.scrollRect:SetCount(maxScrollCount)
end

function MonthCardCtrl:onOnlyNeedShowTwoItem()
	self.panel.Panel_TwoShowItem:SetActiveEx(true)
	self.MonthCardShowTems = {}
	for i = 1, 2 do
		local l_monthCardItem = self:NewTemplate("MonthCardShowItem",{
			TemplatePrefab = self.panel.Show_Item.gameObject,
			TemplateParent = self.panel.Panel_TwoShowItem.Transform,
			Data =
			{
				ShowType = i,
				changeScale = 0.9,
				noMask = true,
			},
		})
		self.MonthCardShowTems[i] = l_monthCardItem
	end
end
--lua custom scripts end
return MonthCardCtrl