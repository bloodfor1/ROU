--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PhotoWallPanel = {}

--lua model end

--lua functions
---@class PhotoWallPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field ImgPhotoDesc MoonClient.MLuaUICom
---@field ImgPhoto MoonClient.MLuaUICom
---@field DescPanel MoonClient.MLuaUICom
---@field BtnPrev MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnAutoPlay MoonClient.MLuaUICom

---@return PhotoWallPanel
function PhotoWallPanel.Bind(ctrl)

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
return UI.PhotoWallPanel