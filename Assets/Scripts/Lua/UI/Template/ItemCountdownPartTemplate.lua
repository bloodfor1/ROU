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
---@class ItemCountdownPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom

---@class ItemCountdownPartTemplate : BaseUITemplate
---@field Parameter ItemCountdownPartTemplateParameter

ItemCountdownPartTemplate = class("ItemCountdownPartTemplate", super)
--lua class define end

--lua functions
function ItemCountdownPartTemplate:Init()
    super.Init(self)


end --func end
--next--
function ItemCountdownPartTemplate:OnDestroy()


end --func end
--next--
function ItemCountdownPartTemplate:OnDeActive()


end --func end
--next--
function ItemCountdownPartTemplate:OnSetData(data)

end --func end

--next--
--lua functions end

--lua custom scripts
ItemCountdownPartTemplate.TemplatePath = "UI/Prefabs/ItemCountdownPart"

--lua custom scripts end

return ItemCountdownPartTemplate