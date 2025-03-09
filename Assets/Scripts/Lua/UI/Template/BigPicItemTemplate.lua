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
---@class BigPicItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Pic MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom

---@class BigPicItemTemplate : BaseUITemplate
---@field Parameter BigPicItemTemplateParameter

BigPicItemTemplate = class("BigPicItemTemplate", super)
--lua class define end

--lua functions
function BigPicItemTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function BigPicItemTemplate:OnDestroy()
	
	
end --func end
--next--
function BigPicItemTemplate:OnDeActive()
	
	
end --func end
--next--
function BigPicItemTemplate:OnSetData(data)
	
	self.Parameter.Text.LabText = data.tip
	if not IsEmptyOrNil(data.atlas) and not IsEmptyOrNil(data.icon) then
		self.Parameter.Pic:SetSpriteAsync(data.atlas, data.icon,function ( ... )
			LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.Content.transform)
		end,true)
	else
		self.Parameter.Pic:SetActiveEx(false)
	end
	
end --func end
--next--
function BigPicItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BigPicItemTemplate