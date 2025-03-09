--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CookingSinglePanel = {}

--lua model end

--lua functions
---@class CookingSinglePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TargetIcon MoonClient.MLuaUICom
---@field TargetCount MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field RewardName MoonClient.MLuaUICom
---@field RewardIcon MoonClient.MLuaUICom
---@field RewardEffect MoonClient.MLuaUICom
---@field Reward MoonClient.MLuaUICom
---@field Recipes MoonClient.MLuaUICom
---@field RecipeName MoonClient.MLuaUICom
---@field RecipeList MoonClient.MLuaUICom
---@field RecipeItem MoonClient.MLuaUICom
---@field RecipeIcon MoonClient.MLuaUICom
---@field RecipeEmpty MoonClient.MLuaUICom
---@field RecipeCount MoonClient.MLuaUICom
---@field ReardMask MoonClient.MLuaUICom
---@field QTE_Result MoonClient.MLuaUICom
---@field QTE_Failed MoonClient.MLuaUICom
---@field InputCount MoonClient.MLuaUICom
---@field IngredientsList MoonClient.MLuaUICom
---@field IngredientItem MoonClient.MLuaUICom
---@field IngredientIcon MoonClient.MLuaUICom
---@field IngredientCount MoonClient.MLuaUICom
---@field CookingName MoonClient.MLuaUICom
---@field CookingDesc MoonClient.MLuaUICom
---@field Cooking MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnRewardClose MoonClient.MLuaUICom
---@field BtnCooking MoonClient.MLuaUICom
---@field BtnCloseCooking MoonClient.MLuaUICom
---@field BgMask MoonClient.MLuaUICom

---@return CookingSinglePanel
---@param ctrl UIBaseCtrl
function CookingSinglePanel.Bind(ctrl)
	
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
return UI.CookingSinglePanel