--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ReBackTipsPanel = {}

--lua model end

--lua functions
---@class ReBackTipsPanel.ReturnGuildItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field NumberOfPeople MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field matching MoonClient.MLuaUICom
---@field GuildIcon MoonClient.MLuaUICom
---@field choose MoonClient.MLuaUICom

---@class ReBackTipsPanel.ReturnGift
---@field PanelRef MoonClient.MLuaUIPanel
---@field head MoonClient.MLuaUICom
---@field FriendName MoonClient.MLuaUICom
---@field Choice MoonClient.MLuaUICom

---@class ReBackTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WelcomeBack MoonClient.MLuaUICom
---@field WelcomBackContent MoonClient.MLuaUICom
---@field MeetingGift MoonClient.MLuaUICom
---@field MeetGiftScroll MoonClient.MLuaUICom
---@field GuildScroll MoonClient.MLuaUICom
---@field GuildRecommendation MoonClient.MLuaUICom
---@field GiftBoxScroll MoonClient.MLuaUICom
---@field GiftBox MoonClient.MLuaUICom
---@field BtnWelcomeBack MoonClient.MLuaUICom
---@field BtnMeetingGift MoonClient.MLuaUICom
---@field BtnGuild MoonClient.MLuaUICom
---@field BtnGift MoonClient.MLuaUICom
---@field ReturnGuildItem ReBackTipsPanel.ReturnGuildItem
---@field ReturnGift ReBackTipsPanel.ReturnGift

---@return ReBackTipsPanel
---@param ctrl UIBase
function ReBackTipsPanel.Bind(ctrl)
	
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
return UI.ReBackTipsPanel