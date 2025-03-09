--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/Handler/MallBaseHandler"
require "UI/Panel/ReBackMallGoldPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.MallBaseHandler
--lua fields end

--lua class define
ReBackMallGoldHandler = class("ReBackMallGoldHandler", super)
--lua class define end

--lua functions
function ReBackMallGoldHandler:ctor()
	
	super.ctor(self, HandlerNames.ReBackMallGold, 0)
	
end --func end
--next--
function ReBackMallGoldHandler:Init()
	
	self.panel = UI.ReBackMallGoldPanel.Bind(self)
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("ReBackMgr")
	self.mallMgr = MgrMgr:GetMgr("MallMgr")
	self.panel.ButtonMail:AddClick(function()
		MgrMgr:GetMgr("EmailMgr").OpenEmail()
	end)

	self.redSignProcessor = self:NewRedSign({
		Key = eRedSignKey.MailOfShop,
		ClickButton = self.panel.ButtonMail
	})
	
end --func end
--next--
function ReBackMallGoldHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ReBackMallGoldHandler:OnActive()

	super.OnActive(self)
	self.mallMgr.DataLis = {}
	self:CustomActive()
	
end --func end
--next--
function ReBackMallGoldHandler:OnDeActive()
	
	
end --func end

function ReBackMallGoldHandler:OnShow()
	self.mallMgr.DataLis = {}
	self:InitLeftTime()
	self:SetResetTimeInfo()
	self:_onBackByOtherPanel()
end

function ReBackMallGoldHandler:OnHide()
	if self.leftTimer then
		self:StopUITimer(self.leftTimer)
	end
	if self.resetTimer then
		self:StopUITimer(self.resetTimer)
	end
	--UIMgr:_deActiveUI(UI.CtrlNames.Currency)
end

function ReBackMallGoldHandler:InitLeftTime()
	local leftTime = self.mgr.GetLeftTime()
	if leftTime <= 0 then
		self.panel.LeftTimeRoot:SetActiveEx(false)
	else
		self.panel.LeftTimeRoot:SetActiveEx(true)
		self.panel.LeftTime.LabText = self.mgr.GetFormatTime(leftTime)
		self.leftTimer = self:NewUITimer(function()
			self.panel.LeftTime.LabText = self.mgr.GetFormatTime(leftTime)
			leftTime = leftTime - 1
			if leftTime <= 0 then
				self.panel.LeftTimeRoot:SetActiveEx(false)
				self:StopUITimer(self.leftTimer)
			end
		end,1,-1,true)
		self.leftTimer:Start()
	end
end


function ReBackMallGoldHandler:ResetTime(mallId)
	local l_refresh, l_data = self.mallMgr.GetMallData(mallId, false)
	if not l_refresh and l_data.time and l_data.time > 0 then
		self.resetTimer = self:NewUITimer(function()
			log("倒计时结束,刷新道具")
			self.mallMgr.SendGetMallInfo(mallId)
		end, l_data.time - Time.realtimeSinceStartup)
		self.resetTimer:Start()
	end
end

--next--
function ReBackMallGoldHandler:Update()

	self.ItemPool:OnUpdate()
end --func end
--next--
function ReBackMallGoldHandler:BindEvents()

	super.BindEvents(self)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ReBackMallGoldHandler:CustomActive()
	local l_returnPointOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ReturnPointShop)
	local l_returnPayOpen = self.openMgr.IsSystemOpen(self.openMgr.eSystemId.ReturnPayShop)

	if l_returnPointOpen then
		self.panel.PointTag:OnToggleExChanged(function(b)
			if b then
				self:SetTable(self.mallMgr.MallTable.ReBackPoint)
			end
		end, true)
		self.panel.PointTag:SetActiveEx(true)
		if l_returnPayOpen and self.mallMgr.SelectTab == self.mallMgr.MallTable.ReBackPay then
			self.panel.PointTag.TogEx.isOn = false
		else
			self.panel.PointTag.TogEx.isOn = true
		end
	else
		self.panel.PointTag:SetActiveEx(false)
	end

	if l_returnPayOpen then
		self.panel.PayTag:OnToggleExChanged(function(b)
			if b then
				self:SetTable(self.mallMgr.MallTable.ReBackPay)
			end
		end, true)
		self.panel.PayTag:SetActiveEx(true)
		if not l_returnPointOpen or self.mallMgr.SelectTab == self.mallMgr.MallTable.ReBackPay then
			self.panel.PayTag.TogEx.isOn = true
		else
			self.panel.PayTag.TogEx.isOn = false
		end
	else
		self.panel.PayTag:SetActiveEx(false)
	end
end

function ReBackMallGoldHandler:_onBackByOtherPanel()
	if self.panel.PointTag.TogEx.isOn then
		self:SetTable(self.mallMgr.MallTable.ReBackPoint)
	elseif self.panel.PayTag.TogEx.isOn then
		self:SetTable(self.mallMgr.MallTable.ReBackPay)
	end
end

function ReBackMallGoldHandler:SetResetTimeInfo()
	local l_mallId = self.curMallId
	local l_mallRow = nil
	local l_rows = TableUtil.GetMallInterfaceTable().GetTable()
	for i = 1, #l_rows do
		local l_row = l_rows[i]
		if l_row then
			if l_row.Tab == l_mallId then
				l_mallRow = l_row
				break
			end
		end
	end

	self.panel.ResetTime:SetActiveEx(false)
	if l_mallRow and l_mallRow.ShowCountDown then
		self.panel.ResetTime:SetActiveEx(true)
		if l_mallRow.RefreshIntervalType == 101 then
			local l_st = StringEx.Format(Lang("Mall_Refresh_Time_Day"), l_mallRow.RefreshTime) --每日{0}点刷新
			self.panel.ResetTime.LabText = l_st
		elseif l_mallRow.RefreshIntervalType == 102 then
			local l_st = StringEx.Format(Lang("Mall_Refresh_Time_Week"), Lang("Week" .. tostring(l_mallRow.RefreshDate)), l_mallRow.RefreshTime)--每{0}凌晨{1}点刷新
			self.panel.ResetTime.LabText = l_st
		else
			self.panel.ResetTime.LabText = "???"
		end
	end

	self:ResetTime(l_mallId)
end

--lua custom scripts end
return ReBackMallGoldHandler