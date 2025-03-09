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
---@class GuildDepositoryItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemBox MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IsAttented MoonClient.MLuaUICom
---@field EmptyCell MoonClient.MLuaUICom

---@class GuildDepositoryItemTemplate : BaseUITemplate
---@field Parameter GuildDepositoryItemTemplateParameter

GuildDepositoryItemTemplate = class("GuildDepositoryItemTemplate", super)
--lua class define end

--lua functions
function GuildDepositoryItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildDepositoryItemTemplate:OnDestroy()
	
	
end --func end
--next--
function GuildDepositoryItemTemplate:OnDeActive()
	
	    self.data = nil
	    self.item = nil
	
end --func end
--next--
function GuildDepositoryItemTemplate:OnSetData(data)
	
	    self.data = data
	    if data.itemInfo then
	        --如果目标格子有物品
	        self.Parameter.EmptyCell.UObj:SetActiveEx(false)
	        if not self.item then
	            self.item = self:NewTemplate("ItemTemplate", {IsActive = false, TemplateParent = self.Parameter.ItemBox.transform})
	        end
	        self.item:SetData({
	            ID = data.itemInfo.itemId,
	            Count = 1,
	            IsShowCount = false,
	            ButtonMethod = function()
	                self:MethodCallback()
	                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.itemInfo.itemId,nil,nil,nil,false)
	            end,
	        })
	        self.Parameter.IsAttented.UObj:SetActiveEx(data.itemInfo.isAttented)
	    else
	        --目标格子无物品
	        self.Parameter.EmptyCell.UObj:SetActiveEx(true)
	        self.Parameter.IsAttented.UObj:SetActiveEx(false)
	        if self.item then
	            self:UninitTemplate(self.item)
	            self.item = nil
	        end
	    end
	    self.Parameter.IsSelected.UObj:SetActiveEx(false)
	
end --func end
--next--
function GuildDepositoryItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildDepositoryItemTemplate:OnSelect()
    self.Parameter.IsSelected.UObj:SetActiveEx(true)
end

function GuildDepositoryItemTemplate:OnDeselect()
    self.Parameter.IsSelected.UObj:SetActiveEx(false)
end
--lua custom scripts end
return GuildDepositoryItemTemplate