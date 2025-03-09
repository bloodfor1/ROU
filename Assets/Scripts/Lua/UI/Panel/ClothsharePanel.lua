--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ClothsharePanel = {}

--lua model end

--lua functions
---@class ClothsharePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field touchArea MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field tailClothNum MoonClient.MLuaUICom
---@field StorageValue MoonClient.MLuaUICom
---@field mouthClothNum MoonClient.MLuaUICom
---@field mod MoonClient.MLuaUICom
---@field headClothNum MoonClient.MLuaUICom
---@field fashionClothNum MoonClient.MLuaUICom
---@field faceClothNum MoonClient.MLuaUICom
---@field backClothNum MoonClient.MLuaUICom

---@return ClothsharePanel
---@param ctrl UIBaseCtrl
function ClothsharePanel.Bind(ctrl)
	
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
return UI.ClothsharePanel