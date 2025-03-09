--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SkillOpenPanel = {}

--lua model end

--lua functions
---@class SkillOpenPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TweenMove MoonClient.MLuaUICom
---@field SkipButton MoonClient.MLuaUICom
---@field SkillName5Text MoonClient.MLuaUICom
---@field SkillName5 MoonClient.MLuaUICom
---@field SkillName3Text MoonClient.MLuaUICom
---@field SkillName3 MoonClient.MLuaUICom
---@field SkillBtn MoonClient.MLuaUICom
---@field SkillAnimation MoonClient.MLuaUICom
---@field PassiveImg MoonClient.MLuaUICom
---@field NormalImg MoonClient.MLuaUICom

---@return SkillOpenPanel
function SkillOpenPanel.Bind(ctrl)

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
return UI.SkillOpenPanel