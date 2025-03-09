--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AlbumOpenAlbumPanel = {}

--lua model end

--lua functions
---@class AlbumOpenAlbumPanel.photo1
---@field PanelRef MoonClient.MLuaUIPanel
---@field Photo MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field BtnPhoto MoonClient.MLuaUICom
---@field BGToTakePhoto MoonClient.MLuaUICom

---@class AlbumOpenAlbumPanel.photo2
---@field PanelRef MoonClient.MLuaUIPanel
---@field Photo MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field BtnPhoto MoonClient.MLuaUICom
---@field BGToTakePhoto MoonClient.MLuaUICom

---@class AlbumOpenAlbumPanel.photo3
---@field PanelRef MoonClient.MLuaUIPanel
---@field Photo MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field BtnPhoto MoonClient.MLuaUICom
---@field BGToTakePhoto MoonClient.MLuaUICom

---@class AlbumOpenAlbumPanel.photo4
---@field PanelRef MoonClient.MLuaUIPanel
---@field Photo MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field BtnPhoto MoonClient.MLuaUICom
---@field BGToTakePhoto MoonClient.MLuaUICom

---@class AlbumOpenAlbumPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleTpl MoonClient.MLuaUICom
---@field Textwuwuwu MoonClient.MLuaUICom
---@field PhototNumber MoonClient.MLuaUICom
---@field PageRightValue MoonClient.MLuaUICom
---@field PageLeftValue MoonClient.MLuaUICom
---@field BtnPrev MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field photo1 AlbumOpenAlbumPanel.photo1
---@field photo2 AlbumOpenAlbumPanel.photo2
---@field photo3 AlbumOpenAlbumPanel.photo3
---@field photo4 AlbumOpenAlbumPanel.photo4

---@return AlbumOpenAlbumPanel
---@param ctrl UIBaseCtrl
function AlbumOpenAlbumPanel.Bind(ctrl)
	
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
return UI.AlbumOpenAlbumPanel