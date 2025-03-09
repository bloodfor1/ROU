--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GiftPanel = {}

--lua model end

--lua functions
---@class GiftPanel.EmblemGiftTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field InfoTittle MoonClient.MLuaUICom
---@field emblemRemoveBtn MoonClient.MLuaUICom
---@field emblemBtn MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@class GiftPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field timeText MoonClient.MLuaUICom
---@field TextMessage MoonClient.MLuaUICom
---@field SpecialBtn MoonClient.MLuaUICom
---@field SliderText MoonClient.MLuaUICom
---@field NormalNamePanel MoonClient.MLuaUICom
---@field LongNamePanel MoonClient.MLuaUICom
---@field ItemScroll MoonClient.MLuaUICom
---@field ItemBtn MoonClient.MLuaUICom
---@field HeadBtn MoonClient.MLuaUICom
---@field GiftTxt MoonClient.MLuaUICom
---@field GiftSlider MoonClient.MLuaUICom
---@field GiftFriendText MoonClient.MLuaUICom
---@field GiftFriendSpecialText MoonClient.MLuaUICom
---@field GiftFriendSpecialBtn MoonClient.MLuaUICom
---@field GiftBtn MoonClient.MLuaUICom
---@field Gift_Img_Bg MoonClient.MLuaUICom
---@field FriendScroll MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field EmblemContent MoonClient.MLuaUICom
---@field EmblemBtn MoonClient.MLuaUICom
---@field Emblem MoonClient.MLuaUICom
---@field CloseExplainPanelButton MoonClient.MLuaUICom
---@field BtnHelp MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field GiftItemPrefab MoonClient.MLuaUIGroup
---@field ItemPrefab MoonClient.MLuaUIGroup
---@field EmblemGiftTemplate GiftPanel.EmblemGiftTemplate

---@return GiftPanel
---@param ctrl UIBase
function GiftPanel.Bind(ctrl)
	
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
return UI.GiftPanel