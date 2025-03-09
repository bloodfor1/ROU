--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MedalPanel = {}

--lua model end

--lua functions
---@class MedalPanel.MedalGloryModelPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockLv MoonClient.MLuaUICom
---@field TxtUnlockLv MoonClient.MLuaUICom
---@field MedalUpgrade MoonClient.MLuaUICom
---@field MedalOpenedBg MoonClient.MLuaUICom
---@field MedalOpened MoonClient.MLuaUICom
---@field MedalName MoonClient.MLuaUICom
---@field MedalLv MoonClient.MLuaUICom
---@field MedalLocked MoonClient.MLuaUICom
---@field MedalImage MoonClient.MLuaUICom
---@field MedalCanActive MoonClient.MLuaUICom
---@field GloryModelPrefab MoonClient.MLuaUICom
---@field ActiveMedal MoonClient.MLuaUICom

---@class MedalPanel.MedalHolyMedalPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockLv MoonClient.MLuaUICom
---@field TxtUnlockLv MoonClient.MLuaUICom
---@field MedalOpenedBg MoonClient.MLuaUICom
---@field MedalOpened MoonClient.MLuaUICom
---@field MedalName MoonClient.MLuaUICom
---@field MedalLv MoonClient.MLuaUICom
---@field MedalLocked MoonClient.MLuaUICom
---@field MedalImage MoonClient.MLuaUICom
---@field MedalEffect MoonClient.MLuaUICom
---@field MedalCanActive MoonClient.MLuaUICom
---@field MedalBgEffect MoonClient.MLuaUICom
---@field MedalActivate MoonClient.MLuaUICom
---@field HolyMedalPrefab MoonClient.MLuaUICom
---@field ActiveMedal MoonClient.MLuaUICom

---@class MedalPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TweenScale MoonClient.MLuaUICom
---@field TweenMove MoonClient.MLuaUICom
---@field PrestigePanel MoonClient.MLuaUICom
---@field PrestigeNumText MoonClient.MLuaUICom
---@field MainShow MoonClient.MLuaUICom
---@field HolyMedalScroll MoonClient.MLuaUICom
---@field HolyMedalContent MoonClient.MLuaUICom
---@field GloryMedalScroll MoonClient.MLuaUICom
---@field GloryMedalContent MoonClient.MLuaUICom
---@field CurtainEffect MoonClient.MLuaUICom
---@field Curtain MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field ActivateImage MoonClient.MLuaUICom
---@field ActivateEffectBG MoonClient.MLuaUICom
---@field ActivateEffect MoonClient.MLuaUICom
---@field MedalGloryModelPrefab MedalPanel.MedalGloryModelPrefab
---@field MedalHolyMedalPrefab MedalPanel.MedalHolyMedalPrefab

---@return MedalPanel
---@param ctrl UIBase
function MedalPanel.Bind(ctrl)
	
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
return UI.MedalPanel