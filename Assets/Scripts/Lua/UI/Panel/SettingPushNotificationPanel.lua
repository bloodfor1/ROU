--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SettingPushNotificationPanel = {}

--lua model end

--lua functions
---@class SettingPushNotificationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtNightPushTime MoonClient.MLuaUICom
---@field TxtNightPushName MoonClient.MLuaUICom
---@field TxtAllPushName MoonClient.MLuaUICom
---@field TxtActivePushName MoonClient.MLuaUICom
---@field TogNight MoonClient.MLuaUICom
---@field TogAll MoonClient.MLuaUICom
---@field TogActive MoonClient.MLuaUICom
---@field ScrollRect MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field NoData MoonClient.MLuaUICom
---@field ImgTogNightGray MoonClient.MLuaUICom
---@field ImgTogNight MoonClient.MLuaUICom
---@field ImgTogActiveGray MoonClient.MLuaUICom
---@field ImgTogActive MoonClient.MLuaUICom
---@field SettingPushNotificationItemPrefab MoonClient.MLuaUIGroup

---@return SettingPushNotificationPanel
---@param ctrl UIBase
function SettingPushNotificationPanel.Bind(ctrl)
	
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
return UI.SettingPushNotificationPanel