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
---@class MagicExtractTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemShowPrefab MoonClient.MLuaUICom

---@class MagicExtractTemplate : BaseUITemplate
---@field Parameter MagicExtractTemplateParameter

MagicExtractTemplate = class("MagicExtractTemplate", super)
--lua class define end

--lua functions
function MagicExtractTemplate:Init()
	
	super.Init(self)
	self.item = nil
	
end --func end
--next--
function MagicExtractTemplate:OnDestroy()
	
	self.item = nil
	
end --func end
--next--
function MagicExtractTemplate:OnDeActive()
	
	
end --func end
--next--
function MagicExtractTemplate:OnSetData(data)
	
	if self.item == nil then
		self.item = self:NewTemplate("ItemTemplate",{
			TemplateParent = self.Parameter.LuaUIGroup.transform,
			Data = data
		})
		self.item:gameObject():GetComponent("RectTransform").anchoredPosition = Vector2(0, 10)
	else
		self.item:SetData(data)
	end
	
end --func end
--next--
function MagicExtractTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MagicExtractTemplate