--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ShareStoryPanel = {}

--lua model end

--lua functions
---@class ShareStoryPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RawImgLogoKorea MoonClient.MLuaUICom
---@field RawImgLogoChina MoonClient.MLuaUICom
---@field QRcode MoonClient.MLuaUICom
---@field plotStoryText MoonClient.MLuaUICom
---@field plotStoryServer MoonClient.MLuaUICom
---@field plotStoryName MoonClient.MLuaUICom
---@field plotStoryImage MoonClient.MLuaUICom
---@field plotStory MoonClient.MLuaUICom
---@field invitationCode MoonClient.MLuaUICom
---@field invitation MoonClient.MLuaUICom
---@field fragmentStoryText MoonClient.MLuaUICom
---@field fragmentStoryServer MoonClient.MLuaUICom
---@field fragmentStoryName MoonClient.MLuaUICom
---@field fragmentStoryImage MoonClient.MLuaUICom
---@field fragmentStory MoonClient.MLuaUICom
---@field Close MoonClient.MLuaUICom
---@field channelWechat MoonClient.MLuaUICom
---@field channelShareqq MoonClient.MLuaUICom
---@field channelShareLine MoonClient.MLuaUICom
---@field channelShareFacebook MoonClient.MLuaUICom
---@field channelSavexiangce MoonClient.MLuaUICom
---@field channelSavephone MoonClient.MLuaUICom
---@field channelKakao MoonClient.MLuaUICom
---@field BorderPanel MoonClient.MLuaUICom

---@return ShareStoryPanel
---@param ctrl UIBase
function ShareStoryPanel.Bind(ctrl)
	
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
return UI.ShareStoryPanel