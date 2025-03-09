--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LoadingPanel = {}

--lua model end

--lua functions
---@class LoadingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WorldMapDetails MoonClient.MLuaUICom
---@field TxtTips MoonClient.MLuaUICom
---@field TxtLoad MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field RImgBg2 MoonClient.MLuaUICom
---@field RImgBg1 MoonClient.MLuaUICom
---@field Path MoonClient.MLuaUICom
---@field Mine MoonClient.MLuaUICom
---@field LoadingAnim MoonClient.MLuaUICom

---@return LoadingPanel
function LoadingPanel.Bind(ctrl)

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
return UI.LoadingPanel