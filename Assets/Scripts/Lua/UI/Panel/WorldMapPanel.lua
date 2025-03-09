--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
WorldMapPanel = {}

--lua model end

--lua functions
---@class WorldMapPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Template_SceneID MoonClient.MLuaUICom
---@field Panel_WorldInfo MoonClient.MLuaUICom
---@field Panel_MapMask MoonClient.MLuaUICom
---@field Panel_CaveInfo MoonClient.MLuaUICom
---@field Panel_BtnMaps MoonClient.MLuaUICom
---@field Img_SltLight MoonClient.MLuaUICom
---@field Img_NowMap MoonClient.MLuaUICom
---@field Btn_ShowWorldInfo MoonClient.MLuaUICom
---@field Btn_ShowCave MoonClient.MLuaUICom
---@field Btn_HideWorldInfo MoonClient.MLuaUICom
---@field Btn_EvtOn MoonClient.MLuaUICom
---@field Btn_EvtOFF MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Btn_CaveOFF MoonClient.MLuaUICom
---@field Panel_EvtInfo MoonClient.MLuaUIGroup

---@return WorldMapPanel
---@param ctrl UIBase
function WorldMapPanel.Bind(ctrl)
	
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
return UI.WorldMapPanel