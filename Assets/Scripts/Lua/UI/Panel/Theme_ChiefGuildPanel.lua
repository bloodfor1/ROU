--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Theme_ChiefGuildPanel = {}

--lua model end

--lua functions
---@class Theme_ChiefGuildPanel.ChiefGuildCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field PlaceOn MoonClient.MLuaUICom
---@field PlaceOff MoonClient.MLuaUICom
---@field NameOn MoonClient.MLuaUICom
---@field NameOff MoonClient.MLuaUICom
---@field HeadOn MoonClient.MLuaUICom
---@field HeadOff MoonClient.MLuaUICom
---@field BackOn MoonClient.MLuaUICom
---@field BackOff MoonClient.MLuaUICom

---@class Theme_ChiefGuildPanel.ChielfSkillCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field ImportantDes MoonClient.MLuaUICom
---@field Des MoonClient.MLuaUICom

---@class Theme_ChiefGuildPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TagTextOn MoonClient.MLuaUICom
---@field TagTextOff MoonClient.MLuaUICom
---@field TabTog MoonClient.MLuaUICom
---@field Skill_Scroll MoonClient.MLuaUICom
---@field SizeText MoonClient.MLuaUICom
---@field RaceText MoonClient.MLuaUICom
---@field OnImg MoonClient.MLuaUICom
---@field OffImg MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field HeadTog MoonClient.MLuaUICom
---@field Guild_Scroll MoonClient.MLuaUICom
---@field DesText MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field AttrText MoonClient.MLuaUICom
---@field AttrImg MoonClient.MLuaUICom
---@field ChiefGuildCell Theme_ChiefGuildPanel.ChiefGuildCell
---@field ChielfSkillCell Theme_ChiefGuildPanel.ChielfSkillCell

---@return Theme_ChiefGuildPanel
---@param ctrl UIBase
function Theme_ChiefGuildPanel.Bind(ctrl)
	
	--dont override this function
	---@type MoonClient.MLuaUIPanel
	local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
	ctrl:OnBindPanel(panelRef)
	return BindMLuaPanel(panelRef)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return UI.Theme_ChiefGuildPanel