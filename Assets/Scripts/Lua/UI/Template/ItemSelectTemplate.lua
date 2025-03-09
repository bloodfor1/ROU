--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI.Template.ItemTemplate"
require "Data.Model.BagModel"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ItemSelectTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemTemp MoonClient.MLuaUICom
---@field BtnRemoveItem MoonClient.MLuaUICom
---@field BtnAdd MoonClient.MLuaUICom

---@class ItemSelectTemplate : BaseUITemplate
---@field Parameter ItemSelectTemplateParameter

ItemSelectTemplate = class("ItemSelectTemplate", super)
--lua class define end

--lua functions
function ItemSelectTemplate:Init()
    super.Init(self)
end --func end
--next--
function ItemSelectTemplate:OnDestroy()
    if self.itemTemplate ~= nil then
        self.itemTemplate = nil
    end
end --func end
--next--
function ItemSelectTemplate:OnSetData(data)
    self.itemId = data.itemId
    self.parent = data.parent
    self.itemList = data.itemList
    self.callback = data.callback
    self.selectedGroup = data.selectedGroup
    self:SetItemId(self.itemId)
end --func end
--next--
function ItemSelectTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function ItemSelectTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function ItemSelectTemplate:SetItemId(itemId)
    self.itemId = itemId
    if self.itemId ~= 0 then
        if self.itemTemplate ~= nil then
            self:UninitTemplate(self.itemTemplate)
            self.itemTemplate = nil
        end

        local l_itemCount = Data.BagModel:GetCoinOrPropNumById(self.itemId)
        self.itemTemplate = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.Parameter.ItemTemp.transform,
            Data = {
                ID = self.itemId,
                IsShowCount = l_itemCount > 0,
                IsGray = 0 >= l_itemCount,
                Count = l_itemCount,
                ButtonMethod = function()
                    self.parent:OpenSelectItem(self)
                end,
            }
        })

        self.itemTemplate:gameObject():SetLocalScaleOne()
        self.itemTemplate:gameObject():SetLocalPosZero()
        self.Parameter.BtnRemoveItem.gameObject:SetActiveEx(true)
        self.Parameter.BtnRemoveItem:AddClick(function()
            self:RemoveItem()
        end)

        self.Parameter.BtnAdd.gameObject:SetActiveEx(false)
    else
        self.Parameter.BtnAdd.gameObject:SetActiveEx(true)
        self.Parameter.BtnRemoveItem.gameObject:SetActiveEx(false)
        self.Parameter.BtnAdd:AddClick(function()
            if self.parent.currentSelectedItemTemplate == self then
                self.parent:CloseSelectItem()
                return
            end
            self.parent:OpenSelectItem(self)
        end)
    end

    if self.callback ~= nil then
        self.callback(itemId)
    end

end

function ItemSelectTemplate:RemoveItem()
    if self.itemTemplate ~= nil then
        self:UninitTemplate(self.itemTemplate)
        self.itemTemplate = nil
    end
    self:SetItemId(0)
    if self.parent.panel.FightAutoSelectItemPanel.gameObject.activeSelf then
        self.parent:OpenSelectItem(self)
    end
end
--lua custom scripts end
return ItemSelectTemplate