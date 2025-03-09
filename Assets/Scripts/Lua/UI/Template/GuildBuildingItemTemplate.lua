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
---@class GuildBuildingItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field IsBuilding MoonClient.MLuaUICom
---@field BuildingIcon MoonClient.MLuaUICom

---@class GuildBuildingItemTemplate : BaseUITemplate
---@field Parameter GuildBuildingItemTemplateParameter

GuildBuildingItemTemplate = class("GuildBuildingItemTemplate", super)
--lua class define end

--lua functions
function GuildBuildingItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildBuildingItemTemplate:OnDeActive()
	
	
end --func end
--next--
function GuildBuildingItemTemplate:OnSetData(data)
	
	    self.data = data
	    self.Parameter.BuildingIcon:SetSprite(data.ItemAtlas, data.ItemIcon, true)
	    self.Parameter.Select.UObj:SetActiveEx(false)
	    local l_info = DataMgr:GetData("GuildData").GetGuildBuildInfo(data.Id)
	    self.Parameter.Level.LabText = l_info and tostring(l_info.level) or "0"
	    if l_info and l_info.is_upgrading then
	        self.Parameter.IsBuilding.UObj:SetActiveEx(true)
	    else
	        self.Parameter.IsBuilding.UObj:SetActiveEx(false)
	    end
	    self.Parameter.Prefab:AddClick(function()
	        self:MethodCallback(self)
	    end)
	
end --func end
--next--
function GuildBuildingItemTemplate:BindEvents()
	
	
end --func end
--next--
function GuildBuildingItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
--设置被选中框是否显示
function GuildBuildingItemTemplate:SetSelect(isSelected)
    self.Parameter.Select.UObj:SetActiveEx(isSelected)
end
--lua custom scripts end
return GuildBuildingItemTemplate