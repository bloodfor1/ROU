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
---@class ItemAchieveTplParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLv MoonClient.MLuaUICom
---@field Title_02 MoonClient.MLuaUICom
---@field Title_01 MoonClient.MLuaUICom
---@field LvImage MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemAchieveTpl MoonClient.MLuaUICom
---@field IsMvp MoonClient.MLuaUICom
---@field IsElite MoonClient.MLuaUICom
---@field ImageCaptain MoonClient.MLuaUICom

---@class ItemAchieveTpl : BaseUITemplate
---@field Parameter ItemAchieveTplParameter

ItemAchieveTpl = class("ItemAchieveTpl", super)
--lua class define end

--lua functions
function ItemAchieveTpl:Init()
	
	super.Init(self)
	
end --func end
--next--
function ItemAchieveTpl:BindEvents()
	
	
end --func end
--next--
function ItemAchieveTpl:OnDestroy()
	
	
end --func end
--next--
function ItemAchieveTpl:OnDeActive()
	
	
end --func end
--next--
function ItemAchieveTpl:OnSetData(data)
	
	self.Parameter.Title_01.LabText = data.name
	self.Parameter.Title_02.LabText = data.place
	self.Parameter.TxtLv.LabText = data.lv
	self.Parameter.LvImage.gameObject:SetActiveEx(data.isShowLv)
	self.Parameter.ItemIcon:SetSprite(data.atlas, data.icon)
	self.Parameter.IsMvp.gameObject:SetActiveEx(data.isMvp)
	self.Parameter.IsElite.gameObject:SetActiveEx(data.isElite)
	self.Parameter.ItemAchieveTpl:AddClick(data.btnFunc)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ItemAchieveTpl