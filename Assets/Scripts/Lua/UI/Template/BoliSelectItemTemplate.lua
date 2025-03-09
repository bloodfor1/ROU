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
---@class BoliSelectItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field HeadOn MoonClient.MLuaUICom
---@field HeadOff MoonClient.MLuaUICom

---@class BoliSelectItemTemplate : BaseUITemplate
---@field Parameter BoliSelectItemTemplateParameter

BoliSelectItemTemplate = class("BoliSelectItemTemplate", super)
--lua class define end

--lua functions
function BoliSelectItemTemplate:Init()
	super.Init(self)
end --func end
--next--
function BoliSelectItemTemplate:OnDestroy()
	
	
end --func end
--next--
function BoliSelectItemTemplate:OnDeActive()
	
	
end --func end
--next--
function BoliSelectItemTemplate:OnSetData(data)
	
	    self.data = data
	    local l_boliTypeDataRow = TableUtil.GetElfTypeTable().GetRowByID(data.typeId)
	    if l_boliTypeDataRow then
	        if data.findNum > 0 then 
	            --已解锁
	            self.Parameter.HeadOn:SetSprite(l_boliTypeDataRow.Atlas, l_boliTypeDataRow.Icon, true)
	            self.Parameter.HeadOn.Img.color = Color.New(1, 1, 1, 1)
	            MLuaCommonHelper.SetLocalScale(self.Parameter.HeadOn.UObj, 1, 1, 1)
	            self.Parameter.HeadOff:SetSprite(l_boliTypeDataRow.Atlas, l_boliTypeDataRow.Icon, true)
	            MLuaCommonHelper.SetLocalScale(self.Parameter.HeadOff.UObj, 1, 1, 1)
	        else
	            --未解锁
	            self.Parameter.HeadOn:SetSprite(l_boliTypeDataRow.Atlas2, l_boliTypeDataRow.Icon2, true)
	            self.Parameter.HeadOn.Img.color = Color.New(1, 1, 1, 200 / 255)
	            MLuaCommonHelper.SetLocalScale(self.Parameter.HeadOn.UObj, 0.3, 0.3, 1)
	            self.Parameter.HeadOff:SetSprite(l_boliTypeDataRow.Atlas2, l_boliTypeDataRow.Icon2, true)
	            MLuaCommonHelper.SetLocalScale(self.Parameter.HeadOff.UObj, 0.3, 0.3, 1)
	        end
	    end
	    self.Parameter.Prefab:OnToggleExChanged(function()
	        if self.Parameter.Prefab.TogEx.isOn then
	            self:MethodCallback()
	        end
	    end)
	
end --func end
--next--
function BoliSelectItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function BoliSelectItemTemplate:OnSelect()
    self.Parameter.Prefab.TogEx.isOn = true
end
--lua custom scripts end
return BoliSelectItemTemplate