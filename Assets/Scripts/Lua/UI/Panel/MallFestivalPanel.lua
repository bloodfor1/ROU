--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MallFestivalPanel = {}

--lua model end

--lua functions
---@class MallFestivalPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field NoGiftData MoonClient.MLuaUICom
---@field ItemGroup MoonClient.MLuaUICom
---@field BtnPrevious MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field MallFestivalPrefab MoonClient.MLuaUIGroup

---@return MallFestivalPanel
---@param ctrl UIBase
function MallFestivalPanel.Bind(ctrl)
	
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
return UI.MallFestivalPanel