--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FashionRatingPhotoPanel = {}

--lua model end

--lua functions
---@class FashionRatingPhotoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtScore MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field Model MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return FashionRatingPhotoPanel
function FashionRatingPhotoPanel.Bind(ctrl)

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
return UI.FashionRatingPhotoPanel