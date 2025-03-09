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
---@class FashionLevelChangeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemFashionLevel MoonClient.MLuaUICom
---@field havReward MoonClient.MLuaUICom
---@field FashionLevelChange MoonClient.MLuaUICom

---@class FashionLevelChangeItemTemplate : BaseUITemplate
---@field Parameter FashionLevelChangeItemTemplateParameter

FashionLevelChangeItemTemplate = class("FashionLevelChangeItemTemplate", super)
--lua class define end

--lua functions
function FashionLevelChangeItemTemplate:Init()
	
	super.Init(self)
	self:Bind()
	
end --func end
--next--
function FashionLevelChangeItemTemplate:Bind()
	
	
end --func end
--next--
function FashionLevelChangeItemTemplate:BindEvents()
	
	
end --func end
--next--
function FashionLevelChangeItemTemplate:OnDestroy()
	
	
end --func end
--next--
function FashionLevelChangeItemTemplate:OnDeActive()
	
	
end --func end

--next--
function FashionLevelChangeItemTemplate:OnSetData(data)
	
	if data ~= nil then
		self.cellData = data
		self:RefreshCell(data)
	end
	end --func end
	function FashionLevelChangeItemTemplate:RefreshCell(data)
	self.Parameter.ItemFashionLevel.LabText = self.cellData.GarderobeAwardRow.ID
	if self.cellData.GarderobeAwardRow.AwardId ~= nil and self.cellData.GarderobeAwardRow.AwardId ~= 0  then
		self.Parameter.havReward.gameObject:SetActiveEx(true)
	else
		self.Parameter.havReward.gameObject:SetActiveEx(false)
	end

	if MgrMgr:GetMgr("GarderobeMgr").Callfashionlevelbyfashioncount(MgrMgr:GetMgr("GarderobeMgr").FashionRecord.fashion_count) >= self.cellData.GarderobeAwardRow.ID then
		self.Parameter.FashionLevelChange:SetSpriteAsync(self.cellData.GarderobeAwardRow.ListAtlas, self.cellData.GarderobeAwardRow.ListIcon[0], nil, false)
	else
		self.Parameter.FashionLevelChange:SetSpriteAsync(self.cellData.GarderobeAwardRow.ListAtlas, self.cellData.GarderobeAwardRow.ListIcon[2], nil, false)
	end
	self.Parameter.FashionLevelChange:AddClick(function()
		self:NotiyPoolSelect()
		local ui = UIMgr:GetUI(UI.CtrlNames.GarderobeFashion)
		if ui then
			ui:SelectAttr(self.cellData)
			--self:Select(true)
		end
	end)
	self.RedSignFashionLevelChange = self:NewRedSign({
		Key = eRedSignKey.GuildWelfare,
		ClickButton = self.Parameter.WelfareItemButton,
	})
end--func end

--next--
function FashionLevelChangeItemTemplate:OnSelect()
	self.Parameter.FashionLevelChange:SetSpriteAsync(self.cellData.GarderobeAwardRow.ListAtlas, self.cellData.GarderobeAwardRow.ListIcon[1], nil, false)
end --func end

--next--
function FashionLevelChangeItemTemplate:OnDeselect()
	if MgrMgr:GetMgr("GarderobeMgr").Callfashionlevelbyfashioncount(MgrMgr:GetMgr("GarderobeMgr").FashionRecord.fashion_count) >= self.cellData.GarderobeAwardRow.ID then
		self.Parameter.FashionLevelChange:SetSpriteAsync(self.cellData.GarderobeAwardRow.ListAtlas, self.cellData.GarderobeAwardRow.ListIcon[0], nil, false)
	else
		self.Parameter.FashionLevelChange:SetSpriteAsync(self.cellData.GarderobeAwardRow.ListAtlas, self.cellData.GarderobeAwardRow.ListIcon[2], nil, false)
	end
	
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return FashionLevelChangeItemTemplate