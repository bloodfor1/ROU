--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LevelRewardPanel = {}

--lua model end

--lua functions
---@class LevelRewardPanel.GiftBagItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field selected MoonClient.MLuaUICom
---@field received MoonClient.MLuaUICom
---@field ready MoonClient.MLuaUICom
---@field lvTxt MoonClient.MLuaUICom
---@field lock MoonClient.MLuaUICom
---@field icon MoonClient.MLuaUICom
---@field boxMask MoonClient.MLuaUICom
---@field box MoonClient.MLuaUICom
---@field bg MoonClient.MLuaUICom

---@class LevelRewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field upgrade MoonClient.MLuaUICom
---@field scroll MoonClient.MLuaUICom
---@field rewardBtn MoonClient.MLuaUICom
---@field price MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom[]
---@field playerPos MoonClient.MLuaUICom[]
---@field playerLv MoonClient.MLuaUICom
---@field playerIcon MoonClient.MLuaUICom
---@field line MoonClient.MLuaUICom[]
---@field items MoonClient.MLuaUICom[]
---@field growTxt MoonClient.MLuaUICom
---@field growingUp MoonClient.MLuaUICom
---@field growContent MoonClient.MLuaUICom
---@field giftBagTxt MoonClient.MLuaUICom
---@field giftBagContent MoonClient.MLuaUICom
---@field finishLevelReward MoonClient.MLuaUICom
---@field finishGrowReward MoonClient.MLuaUICom
---@field disCountPrice MoonClient.MLuaUICom
---@field discountBtn MoonClient.MLuaUICom
---@field content MoonClient.MLuaUICom
---@field concurrencyIcon MoonClient.MLuaUICom[]
---@field closeBtn MoonClient.MLuaUICom
---@field bg MoonClient.MLuaUICom[]
---@field GiftBagItemTemplate LevelRewardPanel.GiftBagItemTemplate

---@return LevelRewardPanel
function LevelRewardPanel.Bind(ctrl)

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
return UI.LevelRewardPanel