--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamInvitePanel = {}

--lua model end

--lua functions
---@class TeamInvitePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tog MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field QualityGroup MoonClient.MLuaUICom
---@field NoData MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Map MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field InputField MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom[]
---@field CurrentInvite MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field BtnSmall_B MoonClient.MLuaUICom
---@field BtnBig_B MoonClient.MLuaUICom
---@field BtnBg MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field AchieveTpl MoonClient.MLuaUICom

---@return TeamInvitePanel
---@param ctrl UIBase
function TeamInvitePanel.Bind(ctrl)
	
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
return UI.TeamInvitePanel