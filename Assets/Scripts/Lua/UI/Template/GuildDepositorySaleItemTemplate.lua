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
---@class GuildDepositorySaleItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PriceText MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field ItemSlot MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IsBidded MoonClient.MLuaUICom
---@field IsAttented MoonClient.MLuaUICom

---@class GuildDepositorySaleItemTemplate : BaseUITemplate
---@field Parameter GuildDepositorySaleItemTemplateParameter

GuildDepositorySaleItemTemplate = class("GuildDepositorySaleItemTemplate", super)
--lua class define end

--lua functions
function GuildDepositorySaleItemTemplate:Init()
    
            super.Init(self)
    
end --func end
--next--
function GuildDepositorySaleItemTemplate:OnDestroy()
    
    self.item = nil
    
end --func end
--next--
function GuildDepositorySaleItemTemplate:OnDeActive()
    
    
end --func end
--next--
function GuildDepositorySaleItemTemplate:OnSetData(data)
    
        self.data = data
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(data.itemId)
        if l_itemRow then
            self.data.itemRow = l_itemRow
            if not self.item then
                self.item = self:NewTemplate("ItemTemplate", {IsActive = false, TemplateParent = self.Parameter.ItemSlot.transform})
            end
            self.item:SetData({
                ID = data.itemId,
                Count = 1,
                IsShowCount = false
            })
            self.data.itemName = l_itemRow.ItemName
            self.Parameter.ItemName.LabText = l_itemRow.ItemName
            self.Parameter.PriceText.LabText = tostring(data.reservePrice)
            self.Parameter.IsAttented.UObj:SetActiveEx(data.isAttended)
            self.Parameter.IsBidded.UObj:SetActiveEx(data.selfPrice > 0)
        end
        --点击选中
        self.Parameter.Prefab:AddClick(function()
            self:MethodCallback()
        end)
    
end --func end
--next--
function GuildDepositorySaleItemTemplate:BindEvents()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildDepositorySaleItemTemplate:OnSelect()
    self.Parameter.IsSelected.UObj:SetActiveEx(true)
end

function GuildDepositorySaleItemTemplate:OnDeselect()
    self.Parameter.IsSelected.UObj:SetActiveEx(false)
end
--lua custom scripts end
return GuildDepositorySaleItemTemplate