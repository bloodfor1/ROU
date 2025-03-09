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
---@class ItemAchieveTargetTplParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_01 MoonClient.MLuaUICom
---@field ItemAchieveTargetTpl MoonClient.MLuaUICom

---@class ItemAchieveTargetTpl : BaseUITemplate
---@field Parameter ItemAchieveTargetTplParameter

ItemAchieveTargetTpl = class("ItemAchieveTargetTpl", super)
--lua class define end

--lua functions
function ItemAchieveTargetTpl:Init()
	
	super.Init(self)
	
end --func end
--next--
function ItemAchieveTargetTpl:BindEvents()
	
	
end --func end
--next--
function ItemAchieveTargetTpl:OnDestroy()
	
	
end --func end
--next--
function ItemAchieveTargetTpl:OnDeActive()
	
	
end --func end
--next--
function ItemAchieveTargetTpl:OnSetData(data)
	self.Parameter.Txt_01.LabText = data.text
	self.Parameter.ItemAchieveTargetTpl:AddClick(function()
		data.btnFunc()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--lua custom scripts end
return ItemAchieveTargetTpl