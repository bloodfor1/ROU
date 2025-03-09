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
---@class AchievementCellAwardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom

---@class AchievementCellAwardTemplate : BaseUITemplate
---@field Parameter AchievementCellAwardTemplateParameter

AchievementCellAwardTemplate = class("AchievementCellAwardTemplate", super)
--lua class define end

--lua functions
function AchievementCellAwardTemplate:Init()
	
	    super.Init(self)
	self.Parameter.Name:GetText().useEllipsis=true
end --func end
--next--
function AchievementCellAwardTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementCellAwardTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementCellAwardTemplate:OnSetData(data)
	
	self.Parameter.Icon:AddClick(nil)
	if data.ItemId then
		local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(data.ItemId)
		if l_itemTableInfo==nil then
			return
		end
		self.Parameter.Icon:SetSpriteAsync(l_itemTableInfo.ItemAtlas, l_itemTableInfo.ItemIcon, nil, true)
		self.Parameter.Name.LabText = l_itemTableInfo.ItemName
		self.Parameter.Icon:AddClick(function()
			MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.ItemId,nil,nil,nil,nil)
		end)
	elseif data.StickersID then
		local l_stickersTableInfo = TableUtil.GetStickersTable().GetRowByStickersID(data.StickersID)
		if l_stickersTableInfo==nil then
			return
		end
		self.Parameter.Icon:SetSpriteAsync(l_stickersTableInfo.StickersAtlas,l_stickersTableInfo.StickersIcon, nil, true)
		self.Parameter.Name.LabText = l_stickersTableInfo.StickersName
	end
	self.Parameter.Count.LabText="× "..data.Count
	
end --func end
--next--
function AchievementCellAwardTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AchievementCellAwardTemplate