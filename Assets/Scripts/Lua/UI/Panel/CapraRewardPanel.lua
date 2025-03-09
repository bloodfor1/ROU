--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CapraRewardPanel = {}

--lua model end

--lua functions
---@class CapraRewardPanel.CapraGiftItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_tagContent MoonClient.MLuaUICom
---@field Text_Name MoonClient.MLuaUICom
---@field RedPoint MoonClient.MLuaUICom
---@field PresentPriceNum MoonClient.MLuaUICom
---@field PresentCoinIcon MoonClient.MLuaUICom
---@field Panel_DynamicTag MoonClient.MLuaUICom
---@field OriginalPriceNum MoonClient.MLuaUICom
---@field OriginalCoinIcon MoonClient.MLuaUICom
---@field LimitNum MoonClient.MLuaUICom
---@field LimitBuy MoonClient.MLuaUICom
---@field GiftIcon MoonClient.MLuaUICom
---@field FreeText MoonClient.MLuaUICom
---@field BuyText MoonClient.MLuaUICom
---@field Btn_Buy MoonClient.MLuaUICom
---@field AlreadyReceive MoonClient.MLuaUICom
---@field AlreadyBuy MoonClient.MLuaUICom

---@class CapraRewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field NoGiftData MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field GiftScroll MoonClient.MLuaUICom
---@field Deadline MoonClient.MLuaUICom
---@field Btn_Right MoonClient.MLuaUICom
---@field Btn_Left MoonClient.MLuaUICom
---@field Btn_Back MoonClient.MLuaUICom
---@field CapraGiftItem CapraRewardPanel.CapraGiftItem

---@return CapraRewardPanel
---@param ctrl UIBase
function CapraRewardPanel.Bind(ctrl)
	
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
return UI.CapraRewardPanel