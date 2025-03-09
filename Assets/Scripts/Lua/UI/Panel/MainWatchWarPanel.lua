--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainWatchWarPanel = {}

--lua model end

--lua functions
---@class MainWatchWarPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RightGuildName MoonClient.MLuaUICom
---@field RightContent_ MoonClient.MLuaUICom
---@field RightContent MoonClient.MLuaUICom
---@field Right MoonClient.MLuaUICom
---@field LeftGuildName MoonClient.MLuaUICom
---@field LeftContent_ MoonClient.MLuaUICom
---@field LeftContent MoonClient.MLuaUICom
---@field Left MoonClient.MLuaUICom
---@field ImageFabulous MoonClient.MLuaUICom
---@field ButtonFoldRight MoonClient.MLuaUICom
---@field ButtonFoldLeft MoonClient.MLuaUICom
---@field ButtonExpandRight MoonClient.MLuaUICom
---@field ButtonExpandLeft MoonClient.MLuaUICom
---@field BtnShare MoonClient.MLuaUICom
---@field BtnSetup MoonClient.MLuaUICom
---@field BtnFlower MoonClient.MLuaUICom
---@field BtnFabulous MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BGFoldRight MoonClient.MLuaUICom
---@field BGFoldLeft MoonClient.MLuaUICom
---@field BGExpandRight MoonClient.MLuaUICom
---@field BGExpandLeft MoonClient.MLuaUICom
---@field LeftSimpleGO MoonClient.MLuaUIGroup
---@field RightSimpleGO MoonClient.MLuaUIGroup
---@field LeftTeamGO MoonClient.MLuaUIGroup
---@field RightTeamGO MoonClient.MLuaUIGroup

---@return MainWatchWarPanel
---@param ctrl UIBase
function MainWatchWarPanel.Bind(ctrl)
	
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
return UI.MainWatchWarPanel