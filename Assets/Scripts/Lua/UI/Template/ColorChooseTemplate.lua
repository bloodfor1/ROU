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
---@class ColorChooseTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Obj_Choose MoonClient.MLuaUICom
---@field Img_Lock MoonClient.MLuaUICom
---@field Img_Color MoonClient.MLuaUICom

---@class ColorChooseTemplate : BaseUITemplate
---@field Parameter ColorChooseTemplateParameter

ColorChooseTemplate = class("ColorChooseTemplate", super)
--lua class define end

--lua functions
function ColorChooseTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function ColorChooseTemplate:BindEvents()
	
	
end --func end
--next--
function ColorChooseTemplate:OnDestroy()
	
	
end --func end
--next--
function ColorChooseTemplate:OnDeActive()
	
	
end --func end
--next--
function ColorChooseTemplate:OnSetData(data)
	if data == nil then
		return
	end
	if data.dyeId == 0 then
		self.Parameter.Img_Color.Img.color = RoColor.Hex2Color(RoColor.BgColor.None)
	else
		local l_colorItem = TableUtil.GetVehicleColorationTable().GetRowByColorationID(data.dyeId)
		if not MLuaCommonHelper.IsNull(l_colorItem) then
			self.Parameter.Img_Color.Img.color = RoColor.Hex2Color(l_colorItem.RgbValue .. "FF")
		end
	end

	self.Parameter.Img_Lock:SetActiveEx(data.isLock)
	self.Parameter.Obj_Choose:SetActiveEx(data.isChoosing)
	if data.isChoosing then
		self:NotiyPoolSelect()
		self.MethodCallback(data.dyeId)
	end
	self.Parameter.Img_Color:AddClick(function ()
		if self:IsSelect() then
			return
		end
		self.MethodCallback(data.dyeId)
		self:NotiyPoolSelect()
	end,true)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ColorChooseTemplate:OnSelect()
	self.Parameter.Obj_Choose:SetActiveEx(true)
end

function ColorChooseTemplate:OnDeselect()
	self.Parameter.Obj_Choose:SetActiveEx(false)
end
--lua custom scripts end
return ColorChooseTemplate