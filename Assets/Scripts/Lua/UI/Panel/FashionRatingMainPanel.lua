--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FashionRatingMainPanel = {}

--lua model end

--lua functions
---@class FashionRatingMainPanel.PlayerInfo
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtScore MoonClient.MLuaUICom
---@field TxtRank MoonClient.MLuaUICom
---@field TxtPoint MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field Model MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class FashionRatingMainPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtThemeName MoonClient.MLuaUICom
---@field ThemeRound MoonClient.MLuaUICom
---@field PanelMain MoonClient.MLuaUICom
---@field BtnOpen MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field PlayerInfo FashionRatingMainPanel.PlayerInfo

---@return FashionRatingMainPanel
---@param ctrl UIBase
function FashionRatingMainPanel.Bind(ctrl)
	
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
return UI.FashionRatingMainPanel