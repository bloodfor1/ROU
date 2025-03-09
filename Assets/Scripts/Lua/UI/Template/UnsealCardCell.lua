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
---@class UnsealCardCellParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field Equiped MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom

---@class UnsealCardCell : BaseUITemplate
---@field Parameter UnsealCardCellParameter

UnsealCardCell = class("UnsealCardCell", super)
--lua class define end

--lua functions
function UnsealCardCell:Init()
	
	super.Init(self)
	    self.Parameter.BackBtn:AddClick(function()
	        self.MethodCallback(self.ShowIndex)
	    end)
	    self.itemTemplate = self:NewTemplate("ItemTemplate",{
	        TemplateParent = self.Parameter.ItemIcon.transform
	    })
	    self:OnDeselect()
	
end --func end
--next--
function UnsealCardCell:BindEvents()
	
	
end --func end
--next--
function UnsealCardCell:OnDestroy()
	
	
end --func end
--next--
function UnsealCardCell:OnDeActive()
	
	
end --func end
--next--
function UnsealCardCell:OnSetData(data)
	    ---@type ItemData
	self.itemData = data.itemData
    self.isEquip = data.isEquip
    self.itemTemplate:SetData({ID = self.itemData.TID, Count = self.itemData.ItemCount, IsShowTips = true})
    self.Parameter.Name.LabText = self.itemData.ItemConfig.ItemName
    self.Parameter.Equiped:SetActiveEx(self.isEquip)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function UnsealCardCell:IsCardIdEqual(cardId)
    return self.itemData and self.itemData.TID == cardId
end

function UnsealCardCell:OnSelect()
    self.Parameter.Select:SetActiveEx(true)
end

function UnsealCardCell:OnDeselect()
    self.Parameter.Select:SetActiveEx(false)
end
--lua custom scripts end
return UnsealCardCell