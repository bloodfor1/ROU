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
---@class GuildDinnerDishItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RankNum MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field CookText MoonClient.MLuaUICom

---@class GuildDinnerDishItemTemplate : BaseUITemplate
---@field Parameter GuildDinnerDishItemTemplateParameter

GuildDinnerDishItemTemplate = class("GuildDinnerDishItemTemplate", super)
--lua class define end

--lua functions
function GuildDinnerDishItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildDinnerDishItemTemplate:OnDestroy()
	
	
end --func end
--next--
function GuildDinnerDishItemTemplate:OnDeActive()
	
	
end --func end
--next--
function GuildDinnerDishItemTemplate:OnSetData(data)
	if data==nil then
		return
	end
	self.Parameter.RankNum:SetSprite("GuildBanquet", "UI_GuildBanquet_Img_0"..tostring(data.rank)..".png", true)
	self.Parameter.NameText.LabText = StringEx.Format(Common.Utils.Lang("GUILD_BANQUET_NAME"), data.name1, data.name2)
	self.Parameter.CookText.LabText = StringEx.Format(Common.Utils.Lang("GUILD_BANQUET_COUNT"), data.count, data.score)
end--func end
--next--
function GuildDinnerDishItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildDinnerDishItemTemplate