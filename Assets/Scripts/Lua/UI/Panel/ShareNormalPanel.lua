--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ShareNormalPanel = {}

--lua model end

--lua functions
---@class ShareNormalPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ServerName MoonClient.MLuaUICom
---@field ServerImage MoonClient.MLuaUICom
---@field RawImgLogoKorea MoonClient.MLuaUICom
---@field RawImgLogoChina MoonClient.MLuaUICom
---@field QRCode MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field ModelImg MoonClient.MLuaUICom
---@field Model MoonClient.MLuaUICom
---@field invitationCode MoonClient.MLuaUICom
---@field invitation MoonClient.MLuaUICom
---@field Close MoonClient.MLuaUICom
---@field channelWechat MoonClient.MLuaUICom
---@field channelShareqq MoonClient.MLuaUICom
---@field channelShareLine MoonClient.MLuaUICom
---@field channelShareFacebook MoonClient.MLuaUICom
---@field channelSavexiangce MoonClient.MLuaUICom
---@field channelSavephone MoonClient.MLuaUICom
---@field channels MoonClient.MLuaUICom
---@field channelKakao MoonClient.MLuaUICom
---@field BorderPanel MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom

---@return ShareNormalPanel
---@param ctrl UIBase
function ShareNormalPanel.Bind(ctrl)
	
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
return UI.ShareNormalPanel