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
---@class ItemCardPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field EquipPositionIcon MoonClient.MLuaUICom

---@class ItemCardPartTemplate : BaseUITemplate
---@field Parameter ItemCardPartTemplateParameter

ItemCardPartTemplate = class("ItemCardPartTemplate", super)
--lua class define end

--lua functions
function ItemCardPartTemplate:Init()
    super.Init(self)
    self.propInfo = nil
    self.bgAltas = ""
    self.bgIcon = ""
end --func end
--next--
function ItemCardPartTemplate:OnDeActive()
    self.Parameter.BackImg:SetActiveEx(false)

end --func end
--next--
---@param data ItemTemplateParam
function ItemCardPartTemplate:OnSetData(data)
    self.Parameter.BackImg:SetActiveEx(false)
    self.propInfo = data.PropInfo
    local itemTableInfo = self.propInfo.ItemConfig

    if itemTableInfo.TypeTab == 4 then
        self.Parameter.BackImg:SetActiveEx(true)
        local l_atlas, l_sprite = Data.BagModel:getCardPosInfo(self.propInfo.TID)
        self.Parameter.EquipPositionIcon:SetSprite(l_atlas, l_sprite, true)
        self.bgAtlas, self.bgIcon = Data.BagModel:getCardBgInfo(self.propInfo.TID)
    end
end --func end

--next--
--lua functions end

--lua custom scripts
ItemCardPartTemplate.TemplatePath = "UI/Prefabs/ItemPart/ItemCardPart"
function ItemCardPartTemplate:ctor(itemData)
    itemData = itemData or {}
    super.ctor(self, itemData)
end
--lua custom scripts end

return ItemCardPartTemplate