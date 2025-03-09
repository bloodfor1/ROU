--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ShowPhotoPanel = {}

--lua model end

--lua functions
---@class ShowPhotoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RawImgLogoKorea MoonClient.MLuaUICom
---@field RawImgLogoChina MoonClient.MLuaUICom
---@field ImgTexturePhoto MoonClient.MLuaUICom
---@field ImgNativePhoto MoonClient.MLuaUICom
---@field BtnWechat MoonClient.MLuaUICom
---@field BtnSina MoonClient.MLuaUICom
---@field BtnShare MoonClient.MLuaUICom
---@field BtnSaveTheLocal MoonClient.MLuaUICom
---@field BtnSaveAlbum MoonClient.MLuaUICom
---@field BtnQQ MoonClient.MLuaUICom
---@field BtnPrev MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field BtnMoveAlbum MoonClient.MLuaUICom
---@field BtnKakaotalk MoonClient.MLuaUICom
---@field BtnFriendCircle MoonClient.MLuaUICom
---@field BtnFacebook MoonClient.MLuaUICom
---@field BtnDiscard MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BlackBG MoonClient.MLuaUICom

---@return ShowPhotoPanel
---@param ctrl UIBase
function ShowPhotoPanel.Bind(ctrl)
	
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
return UI.ShowPhotoPanel