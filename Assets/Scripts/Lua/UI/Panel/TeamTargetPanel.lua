--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamTargetPanel = {}

--lua model end

--lua functions
---@class TeamTargetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName MoonClient.MLuaUICom
---@field TxtLimit MoonClient.MLuaUICom
---@field TogS MoonClient.MLuaUICom
---@field TogL MoonClient.MLuaUICom
---@field TextTime MoonClient.MLuaUICom
---@field Templent MoonClient.MLuaUICom
---@field PageViewR MoonClient.MLuaUICom
---@field PageViewL MoonClient.MLuaUICom
---@field PagesR MoonClient.MLuaUICom
---@field PagesL MoonClient.MLuaUICom
---@field PageRTem MoonClient.MLuaUICom
---@field PageLTem MoonClient.MLuaUICom
---@field MercenaryText MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnconfirmEdit MoonClient.MLuaUICom
---@field AutoPair MoonClient.MLuaUICom

---@return TeamTargetPanel
function TeamTargetPanel.Bind(ctrl)

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
return UI.TeamTargetPanel