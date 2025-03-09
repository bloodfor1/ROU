--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class SchoolPreviewCardItemPreviewParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName MoonClient.MLuaUICom
---@field TxtLv MoonClient.MLuaUICom

---@class SchoolPreviewCardItemPreview : BaseUITemplate
---@field Parameter SchoolPreviewCardItemPreviewParameter

SchoolPreviewCardItemPreview = class("SchoolPreviewCardItemPreview", super)
--lua class define end

--lua functions
function SchoolPreviewCardItemPreview:Init()
    super.Init(self)
    self.item = nil
end --func end
--next--
function SchoolPreviewCardItemPreview:OnDeActive()
    self:Clear()
end --func end
--next--
function SchoolPreviewCardItemPreview:OnSetData(data)
    self:Clear()
    local l_cardId = data.ID
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_cardId)
    if l_itemData == nil then
        logError("在ItemTable中找不到Id：" .. l_cardId)
        return
    end
    local itemData = table.ro_clone(data)
    itemData.TemplateParent = self.Parameter.LuaUIGroup.transform
    self.item = self:NewTemplate("ItemTemplate", itemData)
    self.item:gameObject():GetComponent("RectTransform").anchoredPosition = Vector2(-62, -5)
    MLuaCommonHelper.SetLocalScale(self.item:gameObject(), 0.85, 0.85, 1)
    self.item:SetData(itemData)
    self.Parameter.TxtName.LabText = l_itemData.ItemName
end
--func end
function SchoolPreviewCardItemPreview:Clear()
    if self.item then
        -- MResLoader:DestroyObj(self.item:gameObject())
        self:UninitTemplate(self.item)
        self.item = nil
    end
end --func end
--next--
function SchoolPreviewCardItemPreview:BindEvents()

end --func end
--next--
function SchoolPreviewCardItemPreview:OnDestroy()

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SchoolPreviewCardItemPreview