--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class WatchDetailsButtonTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ON MoonClient.MLuaUICom
---@field Off MoonClient.MLuaUICom
---@field ButtonName2 MoonClient.MLuaUICom
---@field ButtonName1 MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class WatchDetailsButtonTemplate : BaseUITemplate
---@field Parameter WatchDetailsButtonTemplateParameter

WatchDetailsButtonTemplate = class("WatchDetailsButtonTemplate", super)
--lua class define end

--lua functions
function WatchDetailsButtonTemplate:Init()
	
	super.Init(self)
	self.mgr = MgrMgr:GetMgr("WatchWarMgr")
	self.isSelected = nil
	
end --func end
--next--
function WatchDetailsButtonTemplate:OnDestroy()
	
	self.mgr = nil
	self.isSelected = nil
	
end --func end
--next--
function WatchDetailsButtonTemplate:OnDeActive()
	
	
end --func end
--next--
function WatchDetailsButtonTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function WatchDetailsButtonTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function WatchDetailsButtonTemplate:CustomSetData(data)

	local l_row = TableUtil.GetSpectatorTypeTable().GetRowByID(data)
	self.data = data
	self.Parameter.ButtonName1.LabText = l_row.Name
	self.Parameter.ButtonName2.LabText = l_row.Name

	self.Parameter.Button:AddClick(function()
		local l_limit = self.mgr.IsSpectatorRefreshLimit(self.data, true)
		self.mgr.SetSelectClassifyTypeID(self.data, not l_limit)
	end)

	self:UpdateSelectState()
end

function WatchDetailsButtonTemplate:IsSelected()
	
	return self.mgr.GetSelectClassifyTypeID() == self.data
end

function WatchDetailsButtonTemplate:UpdateSelectState()

	local l_selected = self:IsSelected()
	if self.isSelected == l_selected then
		return
	end
	self.isSelected = l_selected
	self.Parameter.Off.gameObject:SetActiveEx(not l_selected)
	self.Parameter.ON.gameObject:SetActiveEx(l_selected)
end
--lua custom scripts end
return WatchDetailsButtonTemplate