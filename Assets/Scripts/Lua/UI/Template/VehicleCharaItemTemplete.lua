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
---@class VehicleCharaItemTempleteParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field ImageUseFlag MoonClient.MLuaUICom
---@field ImageEquipFlag MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom

---@class VehicleCharaItemTemplete : BaseUITemplate
---@field Parameter VehicleCharaItemTempleteParameter

VehicleCharaItemTemplete = class("VehicleCharaItemTemplete", super)
--lua class define end

--lua functions
function VehicleCharaItemTemplete:Init()
	
	super.Init(self)
	
end --func end
--next--
function VehicleCharaItemTemplete:OnDestroy()
	
	self.data = nil
	
end --func end
--next--
function VehicleCharaItemTemplete:OnDeActive()
	
	
end --func end
--next--
function VehicleCharaItemTemplete:OnSetData(data)
	
	self.data = data
	local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
	local _,l_dyeID = l_vehicleInfoMgr.GetEquipOrnamentAndDyeId(data.ID)
	local l_itemAtlas,l_itemIcon = l_vehicleInfoMgr.GetVehicleHeadInfo(data.ID,l_dyeID)
	if l_itemAtlas==nil then
		return
	end
	self.Parameter.Image:SetSprite(l_itemAtlas, l_itemIcon, true)
	local l_itemQualityAtlas = "Common"
	local l_itemQualityIcon = Data.BagModel:getItemBgById(data.ID)
	self.Parameter.EquipIconBg:SetSprite(l_itemQualityAtlas, l_itemQualityIcon, true)
	self.Parameter.Selected.gameObject:SetActiveEx(data.isSelect)
	self:CheckState()
	self.Parameter.ItemButton:AddClick(function()
		if self.MethodCallback then
			self.MethodCallback(data.ID, self.ShowIndex)
		end
	end)
end --func end
--next--
function VehicleCharaItemTemplete:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function VehicleCharaItemTemplete:ShowFrame(flag)
	self.Parameter.Selected.gameObject:SetActiveEx(flag)
end

function VehicleCharaItemTemplete:CheckState()
	self.Parameter.ImageEquipFlag.gameObject:SetActiveEx(self.data.isOwnT and not self.data.isUse)
	self.Parameter.ImageUseFlag.gameObject:SetActiveEx(self.data.isUse)
end
--lua custom scripts end
return VehicleCharaItemTemplete