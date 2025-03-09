--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChooseGiftPanel = {}

--lua model end

--lua functions
---@class ChooseGiftPanel.ChooseGiftItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field tog MoonClient.MLuaUICom
---@field SelectBtn MoonClient.MLuaUICom
---@field rawImage MoonClient.MLuaUICom
---@field giftSelect MoonClient.MLuaUICom
---@field giftNum MoonClient.MLuaUICom
---@field giftName MoonClient.MLuaUICom
---@field giftImage MoonClient.MLuaUICom
---@field giftBG MoonClient.MLuaUICom

---@class ChooseGiftPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field StorageText MoonClient.MLuaUICom
---@field ScrollContent MoonClient.MLuaUICom
---@field Raw_EffBg MoonClient.MLuaUICom
---@field loopScroll MoonClient.MLuaUICom
---@field ItemScroll MoonClient.MLuaUICom
---@field CountText MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseText MoonClient.MLuaUICom
---@field BtnStorage MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field ChooseGiftItemTemplate ChooseGiftPanel.ChooseGiftItemTemplate

---@return ChooseGiftPanel
---@param ctrl UIBaseCtrl
function ChooseGiftPanel.Bind(ctrl)
	
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
return UI.ChooseGiftPanel