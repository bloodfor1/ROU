--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/Handler/MallBaseHandler"
require "UI/Panel/NewPlayerMailPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.MallBaseHandler
--lua fields end

--lua class define
NewPlayerMailHandler = class("NewPlayerMailHandler", super)
--lua class define end

--lua functions
function NewPlayerMailHandler:ctor()
	
	super.ctor(self, HandlerNames.NewPlayerMail, 0)
	
end --func end
--next--
function NewPlayerMailHandler:Init()
	
	self.panel = UI.NewPlayerMailPanel.Bind(self)
	super.Init(self)

	self.mallMgr = MgrMgr:GetMgr("MallMgr")
	self.mgr = MgrMgr:GetMgr("NewPlayerMgr")
	self.panel.ButtonMail:AddClick(function()
		MgrMgr:GetMgr("EmailMgr").OpenEmail()
	end)

	self.redSignProcessor = self:NewRedSign({
		Key = eRedSignKey.MailOfShop,
		ClickButton = self.panel.ButtonMail
	})
	
end --func end
--next--
function NewPlayerMailHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self.mgr = nil
	
end --func end
--next--
function NewPlayerMailHandler:OnActive()

	super.OnActive(self)
	self.panel.PointTag.TogEx.isOn = true

end --func end
--next--
function NewPlayerMailHandler:OnDeActive()

	super.OnDeActive(self)
	
end --func end
--next--
function NewPlayerMailHandler:Update()
	self.ItemPool:OnUpdate()
end --func end
--next--
function NewPlayerMailHandler:BindEvents()

	super.BindEvents(self)

end --func end
--next--
function NewPlayerMailHandler:OnShow()

	self:InitLeftTime()
    self.mallMgr.DataLis = {}
    self:SetTable(self.mallMgr.MallTable.NewPlayer)
    
end

function NewPlayerMailHandler:OnHide()

	if self.leftTimer ~= nil then
		self:StopUITimer(self.leftTimer)
		self.leftTimer = nil
	end

end

--lua functions end

--lua custom scripts
function NewPlayerMailHandler:InitLeftTime()

	local l_labelRow = TableUtil.GetLabelTable().GetRowByLabelId(1001)
	self.panel.LoseTime.LabText = Lang("NEW_PLAYER_TIPS_3", l_labelRow.BaseLevelLimit[1])
	self.panel.ShopName.LabText = Lang("NEW_PLAYER_MALL")
	local leftTime = self.mgr.GetLeftTime()
	if leftTime <= 0 then
		self.panel.ResetTime:SetActiveEx(false)
	else
		self.panel.ResetTime:SetActiveEx(false)
		self.panel.ResetTime.LabText = Lang("ACTIVITY_LAST_TIME") .. "：" .. self.mgr.GetFormatTime(leftTime)
		if self.leftTimer then
			self:StopUITimer(self.leftTimer)
			self.leftTimer = nil
		end
		self.leftTimer = self:NewUITimer(function()
			self.panel.ResetTime.LabText = Lang("ACTIVITY_LAST_TIME") .. "：" ..  self.mgr.GetFormatTime(leftTime)
			leftTime = leftTime - 1
			if leftTime <= 0 then
				self.panel.LeftTimeRoot:SetActiveEx(false)
				self:StopUITimer(self.leftTimer)
			end
		end, 1, -1, true)
		self.leftTimer:Start()
	end

end
--lua custom scripts end
return NewPlayerMailHandler