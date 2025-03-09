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
---@class GuilldInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Member2 MoonClient.MLuaUICom
---@field Txt_Member1 MoonClient.MLuaUICom
---@field Txt_GuildScore MoonClient.MLuaUICom
---@field Txt_GuildName MoonClient.MLuaUICom
---@field Img_Rank4 MoonClient.MLuaUICom
---@field Img_Rank3 MoonClient.MLuaUICom
---@field Img_Rank2 MoonClient.MLuaUICom
---@field Img_Rank1 MoonClient.MLuaUICom
---@field Img_GuildIcon MoonClient.MLuaUICom
---@field Img_Figure MoonClient.MLuaUICom
---@field Head_Member2 MoonClient.MLuaUICom
---@field Head_Member1 MoonClient.MLuaUICom
---@field BtnHead MoonClient.MLuaUICom
---@field Btn_Member1 MoonClient.MLuaUICom

---@class GuilldInfoTemplate : BaseUITemplate
---@field Parameter GuilldInfoTemplateParameter

GuilldInfoTemplate = class("GuilldInfoTemplate", super)
--lua class define end

--lua functions
function GuilldInfoTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function GuilldInfoTemplate:BindEvents()
	
	
end --func end
--next--
function GuilldInfoTemplate:OnDestroy()
	
	
end --func end
--next--
function GuilldInfoTemplate:OnDeActive()
	
	
end --func end
--next--
function GuilldInfoTemplate:OnSetData(data)
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuilldInfoTemplate