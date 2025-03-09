--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FashionCatalogPanel = {}

--lua model end

--lua functions
---@class FashionCatalogPanel.PlayerInfo
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtScore MoonClient.MLuaUICom
---@field TxtRank MoonClient.MLuaUICom
---@field TxtPoint MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field Model MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class FashionCatalogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtThemeName MoonClient.MLuaUICom
---@field RingScrollView MoonClient.MLuaUICom
---@field RightArrow MoonClient.MLuaUICom
---@field PanelMain MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field LeftArrow MoonClient.MLuaUICom
---@field FashionVol MoonClient.MLuaUICom
---@field FashionShow MoonClient.MLuaUICom
---@field FashionMain MoonClient.MLuaUICom
---@field FashionHistory MoonClient.MLuaUICom
---@field FashionCloseBtn MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field ChooseOn MoonClient.MLuaUICom[]
---@field ChooseNote MoonClient.MLuaUICom[]
---@field Black MoonClient.MLuaUICom
---@field PlayerInfo FashionCatalogPanel.PlayerInfo

---@return FashionCatalogPanel
function FashionCatalogPanel.Bind(ctrl)

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
return UI.FashionCatalogPanel