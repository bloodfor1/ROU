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
---@class GuildIconItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IconImg MoonClient.MLuaUICom
---@field CurImg MoonClient.MLuaUICom

---@class GuildIconItemTemplate : BaseUITemplate
---@field Parameter GuildIconItemTemplateParameter

GuildIconItemTemplate = class("GuildIconItemTemplate", super)
--lua class define end

--lua functions
function GuildIconItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildIconItemTemplate:OnDeActive()
	
	
end --func end
--next--
function GuildIconItemTemplate:OnSetData(data)
	
	    self.data = data  -- 记录数据 点击回调用
	    self.Parameter.IconImg:SetSprite(data.iconAltas, data.iconName)
	    if data.isCur then
	        self.Parameter.CurImg.UObj:SetActiveEx(true)
	    end
	    self.Parameter.ItemButton:AddClick(function()
	        self:MethodCallback(self)
	    end)
	
end --func end
--next--
function GuildIconItemTemplate:BindEvents()
	
	
end --func end
--next--
function GuildIconItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
--设置被选中框是否显示
function GuildIconItemTemplate:SetSelect(isSelected)
    self.Parameter.IsSelected.UObj:SetActiveEx(isSelected)
end
--lua custom scripts end
return GuildIconItemTemplate