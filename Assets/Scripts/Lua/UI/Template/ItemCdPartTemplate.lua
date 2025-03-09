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
---@class ItemCdPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgSelect MoonClient.MLuaUICom
---@field TxtCd MoonClient.MLuaUICom
---@field ImgCd MoonClient.MLuaUICom
---@field ImgRed MoonClient.MLuaUICom

---@class ItemCdPartTemplate : BaseUITemplate
---@field Parameter ItemCdPartTemplateParameter

ItemCdPartTemplate = class("ItemCdPartTemplate", super)
--lua class define end

--lua functions
function ItemCdPartTemplate:Init()
    super.Init(self)
end --func end
--next--
function ItemCdPartTemplate:OnDeActive()
    self.Parameter.ImgSelect:SetActiveEx(false)
    self.Parameter.TxtCd:SetActiveEx(false)
    self.Parameter.ImgCd:SetActiveEx(false)
    self.Parameter.ImgRed:SetActiveEx(false)

end --func end
--next--
function ItemCdPartTemplate:OnSetData(data)

end --func end

--next--
--lua functions end

--lua custom scripts
ItemCdPartTemplate.TemplatePath = "UI/Prefabs/ItemPart/ItemCdPart"

function ItemCdPartTemplate:SetImgCd(visible)
    self.Parameter.ImgCd.gameObject:SetActiveEx(visible)
end

--lua custom scripts end
return ItemCdPartTemplate