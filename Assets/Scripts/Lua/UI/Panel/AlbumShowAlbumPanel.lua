--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AlbumShowAlbumPanel = {}

--lua model end

--lua functions
---@class AlbumShowAlbumPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tog2 MoonClient.MLuaUICom
---@field Tog1 MoonClient.MLuaUICom
---@field Tog MoonClient.MLuaUICom
---@field LoverAlbum MoonClient.MLuaUICom
---@field InstanceAlbum MoonClient.MLuaUICom
---@field EditPanel MoonClient.MLuaUICom
---@field DefaultAlbum MoonClient.MLuaUICom
---@field BtnShare MoonClient.MLuaUICom
---@field BtnEditName MoonClient.MLuaUICom
---@field BtnEdit MoonClient.MLuaUICom
---@field BtnDelete MoonClient.MLuaUICom
---@field BtnBack MoonClient.MLuaUICom
---@field BtnAddAlbum MoonClient.MLuaUICom
---@field AlbumContent MoonClient.MLuaUICom

---@return AlbumShowAlbumPanel
---@param ctrl UIBaseCtrl
function AlbumShowAlbumPanel.Bind(ctrl)
	
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
return UI.AlbumShowAlbumPanel