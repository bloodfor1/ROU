--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MallGoldPanel = {}

--lua model end

--lua functions
---@class MallGoldPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemGroup MoonClient.MLuaUICom
---@field GoldTags MoonClient.MLuaUICom
---@field GoldHotTag MoonClient.MLuaUICom
---@field GoldGiftTag MoonClient.MLuaUICom
---@field GoldAppearanceTag MoonClient.MLuaUICom

---@return MallGoldPanel
---@param ctrl UIBase
function MallGoldPanel.Bind(ctrl)
	
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
return UI.MallGoldPanel