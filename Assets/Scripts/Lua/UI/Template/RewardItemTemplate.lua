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
---@class RewardItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Image MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom

---@class RewardItemTemplate : BaseUITemplate
---@field Parameter RewardItemTemplateParameter

RewardItemTemplate = class("RewardItemTemplate", super)
--lua class define end

--lua functions
function RewardItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function RewardItemTemplate:OnDeActive()
	
	
end --func end
--next--
function RewardItemTemplate:OnSetData(data)
	
	local itemSdata = TableUtil.GetItemTable().GetRowByItemID(data.id)
	self.Parameter.Image:SetSprite(itemSdata.ItemAtlas, itemSdata.ItemIcon)
	self.Parameter.Count.LabText = data.count
	self.Parameter.Count.UObj:SetActiveEx(data.isShowCount)
	    self.Parameter.Image:AddClick(function ()
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.id, self.Parameter.Image.transform)
	end)
	
end --func end
--next--
function RewardItemTemplate:BindEvents()
	
	
end --func end
--next--
function RewardItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RewardItemTemplate