--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ItemExchangeShopPanel = {}

--lua model end

--lua functions
---@class ItemExchangeShopPanel.ItemExchangeListTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class ItemExchangeShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field TextName MoonClient.MLuaUICom
---@field TargetCount MoonClient.MLuaUICom
---@field SureBtn MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field RecipesRect MoonClient.MLuaUICom
---@field RecipeEmpty MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field NonePanel MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field LeftBuyTime MoonClient.MLuaUICom
---@field InputText MoonClient.MLuaUICom
---@field InputCount MoonClient.MLuaUICom
---@field IngredientsParent MoonClient.MLuaUICom
---@field HandlerRect MoonClient.MLuaUICom
---@field HandlerCloseBtn MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field Cooking MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ItemExchangeListTemplate ItemExchangeShopPanel.ItemExchangeListTemplate

---@return ItemExchangeShopPanel
function ItemExchangeShopPanel.Bind(ctrl)

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
return UI.ItemExchangeShopPanel