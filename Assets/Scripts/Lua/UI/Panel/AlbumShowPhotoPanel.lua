--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AlbumShowPhotoPanel = {}

--lua model end

--lua functions
---@class AlbumShowPhotoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tog MoonClient.MLuaUICom
---@field PhotoContent MoonClient.MLuaUICom
---@field NoData MoonClient.MLuaUICom
---@field InstancePhoto MoonClient.MLuaUICom
---@field ImgPhoto MoonClient.MLuaUICom
---@field EditPanel MoonClient.MLuaUICom
---@field BtnShare MoonClient.MLuaUICom
---@field BtnPhoto1 MoonClient.MLuaUICom
---@field BtnEdit MoonClient.MLuaUICom
---@field BtnDelete MoonClient.MLuaUICom
---@field BtnChangeAlbum MoonClient.MLuaUICom
---@field BtnBack MoonClient.MLuaUICom

---@return AlbumShowPhotoPanel
---@param ctrl UIBase
function AlbumShowPhotoPanel.Bind(ctrl)
	
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
return UI.AlbumShowPhotoPanel