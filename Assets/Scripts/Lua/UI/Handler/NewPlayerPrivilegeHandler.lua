--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/NewPlayerPrivilegePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
NewPlayerPrivilegeHandler = class("NewPlayerPrivilegeHandler", super)
--lua class define end

--lua functions
function NewPlayerPrivilegeHandler:ctor()
	
	super.ctor(self, HandlerNames.NewPlayerPrivilege, 0)
	
end --func end
--next--
function NewPlayerPrivilegeHandler:Init()
	
	self.panel = UI.NewPlayerPrivilegePanel.Bind(self)
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("NewPlayerMgr")
	self.privilegeItemTemplatePool = self:NewTemplatePool({
		TemplateClassName = "PrivilegeItemTemplate",
		TemplatePrefab = self.panel.PrivilegeItemPrefab.gameObject,
		TemplateParent = self.panel.PrivilegeItemParent.transform,
	})
	
end --func end
--next--
function NewPlayerPrivilegeHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self.mgr = nil

end --func end
--next--
function NewPlayerPrivilegeHandler:OnActive()

	local returnPrivilege = TableUtil.GetNewPlayerPrivilege().GetTable()
	self.privilegeItemTemplatePool:ShowTemplates({ Datas = returnPrivilege })
	
end --func end
--next--
function NewPlayerPrivilegeHandler:OnDeActive()
	
end --func end
--next--
function NewPlayerPrivilegeHandler:Update()
	
end --func end
--next--
function NewPlayerPrivilegeHandler:BindEvents()

end --func end

--next--
function NewPlayerPrivilegeHandler:OnShow()
	self:InitLeftTime()
end --func end

--next--
function NewPlayerPrivilegeHandler:OnHide()

	if self.leftTimer then
		self:StopUITimer(self.leftTimer)
		self.leftTimer = nil
	end

end --func end
--lua functions end

--lua custom scripts
function NewPlayerPrivilegeHandler:InitLeftTime()

	local l_labelRow = TableUtil.GetLabelTable().GetRowByLabelId(1001)
	self.panel.LoseTime.LabText = Lang("NEW_PLAYER_TIPS_3", l_labelRow.BaseLevelLimit[1])
	local leftTime = self.mgr.GetLeftTime()
	if leftTime <= 0 then
		self.panel.LeftTimeRoot:SetActiveEx(false)
	else
		self.panel.LeftTimeRoot:SetActiveEx(false)
		self.panel.LeftTime.LabText = self.mgr.GetFormatTime(leftTime)
		if self.leftTimer then
			self:StopUITimer(self.leftTimer)
			self.leftTimer = nil
		end
		self.leftTimer = self:NewUITimer(function()
			self.panel.LeftTime.LabText = self.mgr.GetFormatTime(leftTime)
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
return NewPlayerPrivilegeHandler