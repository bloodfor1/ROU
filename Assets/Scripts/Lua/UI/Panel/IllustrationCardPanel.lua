--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationCardPanel = {}

--lua model end

--lua functions
---@class IllustrationCardPanel.IllustrationCardPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectPanel MoonClient.MLuaUICom
---@field CardPrefab MoonClient.MLuaUICom
---@field CardItem MoonClient.MLuaUICom
---@field CardButton MoonClient.MLuaUICom

---@class IllustrationCardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollCard MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field CardTypeSelectText MoonClient.MLuaUICom
---@field CardTypeSelectButton MoonClient.MLuaUICom
---@field CardSuggestText MoonClient.MLuaUICom
---@field CardSearchPanel MoonClient.MLuaUICom
---@field CardSearchInputField MoonClient.MLuaUICom
---@field CardSearchButton MoonClient.MLuaUICom
---@field CardScroll MoonClient.MLuaUICom
---@field CardNotFoundText MoonClient.MLuaUICom
---@field CardNameFrame MoonClient.MLuaUICom
---@field CardName MoonClient.MLuaUICom
---@field CardImage MoonClient.MLuaUICom
---@field CardGetButton MoonClient.MLuaUICom
---@field CardFrame MoonClient.MLuaUICom
---@field CardDescContent MoonClient.MLuaUICom
---@field CardCollectedText MoonClient.MLuaUICom
---@field CardCloseSearchButton MoonClient.MLuaUICom
---@field CardCleanupButton MoonClient.MLuaUICom
---@field CardAttrTog MoonClient.MLuaUICom
---@field CardAttrText MoonClient.MLuaUICom
---@field CardAttrList7 MoonClient.MLuaUICom
---@field CardAttrList6 MoonClient.MLuaUICom
---@field CardAttrList5 MoonClient.MLuaUICom
---@field CardAttrList4 MoonClient.MLuaUICom
---@field CardAttrList3 MoonClient.MLuaUICom
---@field CardAttrList2 MoonClient.MLuaUICom
---@field CardAttrList100 MoonClient.MLuaUICom
---@field CardAttrList10 MoonClient.MLuaUICom
---@field CardAttrList1 MoonClient.MLuaUICom
---@field CardAttrGroup MoonClient.MLuaUICom
---@field IllustrationCardPrefab IllustrationCardPanel.IllustrationCardPrefab

---@return IllustrationCardPanel
function IllustrationCardPanel.Bind(ctrl)

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
return UI.IllustrationCardPanel