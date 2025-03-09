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
---@class LifeProfessionRewardPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Icon MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LifeProfessionRewardPrefab : BaseUITemplate
---@field Parameter LifeProfessionRewardPrefabParameter

LifeProfessionRewardPrefab = class("LifeProfessionRewardPrefab", super)
--lua class define end

--lua functions
function LifeProfessionRewardPrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function LifeProfessionRewardPrefab:OnDeActive()
	
	
end --func end
--next--
function LifeProfessionRewardPrefab:OnSetData(data)
	
	if data.isSticker then
		local stickerdata = TableUtil.GetStickersTable().GetRowByStickersID(data.ID)
		self.Parameter.Count.LabText = ""
		if stickerdata ~= nil then
			self.Parameter.Icon:SetSprite(stickerdata.StickersAtlas, stickerdata.StickersIcon)
			self.Parameter.Btn:AddClick(function()
				return
			end, true)
		end
	else
		local itemData = TableUtil.GetItemTable().GetRowByItemID(data.ID)
		self.Parameter.Count.LabText = tostring(data.Count)
		if itemData ~= nil then
			self.Parameter.Icon:SetSprite(itemData.ItemAtlas,itemData.ItemIcon)
			self.Parameter.Btn:AddClick(function()
				MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.ID, self.Parameter.Btn.transform, nil, {
					IsShowCloseButton = true
				})
			end, true)
		end
	end
	
end --func end
--next--
function LifeProfessionRewardPrefab:BindEvents()
	
	
end --func end
--next--
function LifeProfessionRewardPrefab:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return LifeProfessionRewardPrefab