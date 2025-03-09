--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CapraFAQPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
CapraFAQCtrl = class("CapraFAQCtrl", super)
--lua class define end

--lua functions
function CapraFAQCtrl:ctor()
	
	super.ctor(self, CtrlNames.CapraFAQ, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function CapraFAQCtrl:Init()
	
	self.panel = UI.CapraFAQPanel.Bind(self)
	super.Init(self)

	self.panel.ToggleTpl:SetActiveEx(false)

	self.panel.ButtonClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.CapraFAQ)
	end)
	
end --func end
--next--
function CapraFAQCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function CapraFAQCtrl:OnActive()
	
	
end --func end
--next--
function CapraFAQCtrl:OnDeActive()
	
	
end --func end
--next--
function CapraFAQCtrl:Update()
	
	
end --func end
--next--
function CapraFAQCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function CapraFAQCtrl:SetupHandlers()
	local l_handlerTb = {}
	local l_defaultHandlerName = nil

	local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
	if l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Consultation) then
		local openTable= TableUtil.GetOpenSystemTable().GetRowById(l_openSystemMgr.eSystemId.Consultation)
		table.insert(l_handlerTb, { HandlerNames.Consultation, openTable.Title, "CommonIcon", "UI_CommonIcon_baike.png", "UI_CommonIcon_baike.png" })
	end

	if l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Recommend) then
		local openTable= TableUtil.GetOpenSystemTable().GetRowById(l_openSystemMgr.eSystemId.Recommend)
		table.insert(l_handlerTb, { HandlerNames.Recommend, openTable.Title, "CommonIcon", "UI_CommonIcon_wenda.png", "UI_CommonIcon_wenda.png" })
	end

	self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, l_defaultHandlerName)

end
--lua custom scripts end
return CapraFAQCtrl