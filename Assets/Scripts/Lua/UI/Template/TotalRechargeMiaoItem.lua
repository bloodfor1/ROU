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
local l_mgr = MgrMgr:GetMgr("TotalRechargeAwardMgr")
--lua fields end

--lua class define
---@class TotalRechargeMiaoItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedPoint MoonClient.MLuaUICom
---@field NumTxt MoonClient.MLuaUICom
---@field MiaoSelected MoonClient.MLuaUICom
---@field MiaoNot MoonClient.MLuaUICom
---@field MiaoCanGet MoonClient.MLuaUICom

---@class TotalRechargeMiaoItem : BaseUITemplate
---@field Parameter TotalRechargeMiaoItemParameter
---@field m_info TotalRechargeAwardItem
TotalRechargeMiaoItem = class("TotalRechargeMiaoItem", super)
--lua class define end

--lua functions
function TotalRechargeMiaoItem:Init()
	
	super.Init(self)
	l_mgr = MgrMgr:GetMgr("TotalRechargeAwardMgr")

	self.Parameter.MiaoSelected:SetActiveEx(false)
end --func end
--next--
function TotalRechargeMiaoItem:BindEvents()
	
	self.Parameter.MiaoCanGet:AddClickWithLuaSelf(self.OnClickSelect, self)
	self.Parameter.MiaoNot:AddClickWithLuaSelf(self.OnClickSelect, self)
end --func end
--next--
function TotalRechargeMiaoItem:OnDestroy()
	
	
end --func end
--next--
function TotalRechargeMiaoItem:OnDeActive()
	
	
end --func end
--next--
function TotalRechargeMiaoItem:OnSetData(data)
	
	self.m_info = data
	self:RefreshUI()
end --func end
--next--
--lua functions end

---@param root UnityEngine.Transform
function TotalRechargeMiaoItem:SetAllChildActive(root, visible)
	for i = 0,root.childCount - 1 do
		local ch = root:GetChild(i)
		if ch ~= self.Parameter.MiaoSelected.transform then
			ch.gameObject:SetActiveEx(visible)
		end
	end
end

--lua custom scripts
function TotalRechargeMiaoItem:RefreshUI()
	if self.m_info.condition == nil then
		self:SetAllChildActive(self.Parameter.MiaoNot.transform.parent, false)
		return
	end
	self:SetAllChildActive(self.Parameter.MiaoNot.transform.parent, true)
	local can_get = self.m_info.condition <= l_mgr.Datas.m_total_recharge
	self.Parameter.MiaoNot:SetActiveEx(not can_get)
	self.Parameter.MiaoCanGet:SetActiveEx(can_get)
	self.Parameter.RedPoint:SetActiveEx(can_get and not self.m_info.has_got)
	self.Parameter.NumTxt.LabText = l_mgr.Datas.m_currency_symbol .. tostring(self.m_info.condition)
end

function TotalRechargeMiaoItem:OnDeselect()
	self.Parameter.MiaoSelected:SetActiveEx(false)
end
function TotalRechargeMiaoItem:OnSelect()
	self.Parameter.MiaoSelected:SetActiveEx(true)
end
function TotalRechargeMiaoItem:OnClickSelect()
	l_mgr.EventDispatcher:Dispatch(l_mgr.Event.ShowDetail, self.ShowIndex, self.m_info.id)
end
--lua custom scripts end
return TotalRechargeMiaoItem