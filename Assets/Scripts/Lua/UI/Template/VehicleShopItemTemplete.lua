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
---@class VehicleShopItemTempleteParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Surplus MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Img_Line MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field ButtonItem MoonClient.MLuaUICom

---@class VehicleShopItemTemplete : BaseUITemplate
---@field Parameter VehicleShopItemTempleteParameter

VehicleShopItemTemplete = class("VehicleShopItemTemplete", super)
--lua class define end

--lua functions
function VehicleShopItemTemplete:Init()

    super.Init(self)
    self.Parameter.Select.gameObject:SetActiveEx(false)
end --func end
--next--
function VehicleShopItemTemplete:OnDestroy()


end --func end
--next--
function VehicleShopItemTemplete:OnDeActive()


end --func end
--next--
function VehicleShopItemTemplete:OnSetData(data)

    self.data = data
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(data.ID)
    self.Parameter.Image:SetSprite(itemTableInfo.ItemAtlas, itemTableInfo.ItemIcon, true)
    local l_itemQualityAtlas = "Common"
    local l_itemQualityIcon = Data.BagModel:getItemBgById(data.ID)
    self.Parameter.Icon:SetSprite(l_itemQualityAtlas, l_itemQualityIcon, true)
    self.Parameter.Name.LabText = itemTableInfo.ItemName
    --self.Parameter.Select.gameObject:SetActiveEx(data.isSelect)
    self.Parameter.Mask.gameObject:SetActiveEx(false)
    self.Parameter.Img_Line.gameObject:SetActiveEx(false)
    self.Parameter.Number.gameObject:SetActiveEx(false)
    self.Parameter.Surplus.gameObject:SetActiveEx(data.isOwnF)
    self.Parameter.ButtonItem:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(data.ID, self.ShowIndex)
        end
    end)

    self.Parameter.Icon:AddClick(function()
        local itemData = Data.BagModel:CreateItemWithTid(data.ID)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, self:transform(), nil, nil, false, { relativePositionY = 28 })
    end)
	
    self.Parameter.RedSignPrompt.gameObject:SetActiveEx(data.isFullRes and not data.isOwnF)
end --func end

--next--
--lua functions end

--lua custom scripts
function VehicleShopItemTemplete:ShowFrame(flag)
    self.Parameter.Select.gameObject:SetActiveEx(flag)
end

function VehicleShopItemTemplete:OnSelect()
    self.Parameter.Select.gameObject:SetActiveEx(true)
end

function VehicleShopItemTemplete:OnDeselect()
    self.Parameter.Select.gameObject:SetActiveEx(false)
end
--lua custom scripts end
return VehicleShopItemTemplete