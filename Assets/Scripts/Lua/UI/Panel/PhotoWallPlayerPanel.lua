--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PhotoWallPlayerPanel = {}

--lua model end

--lua functions
---@class PhotoWallPlayerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgPhoto MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return PhotoWallPlayerPanel
function PhotoWallPlayerPanel.Bind(ctrl)

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
return UI.PhotoWallPlayerPanel