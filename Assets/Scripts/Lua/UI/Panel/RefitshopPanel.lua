--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RefitshopPanel = {}

--lua model end

--lua functions
---@class RefitshopPanel.RefitTrolleyItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field IsUsing MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field BtnUseText MoonClient.MLuaUICom
---@field BtnUse MoonClient.MLuaUICom
---@field BtnItem MoonClient.MLuaUICom

---@class RefitshopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockPanel MoonClient.MLuaUICom
---@field TrolleyName MoonClient.MLuaUICom
---@field ShopTitle MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field ModelImg MoonClient.MLuaUICom
---@field IsUsing MoonClient.MLuaUICom
---@field Introduction MoonClient.MLuaUICom
---@field Condition02 MoonClient.MLuaUICom
---@field Condition01 MoonClient.MLuaUICom
---@field BtnRentText MoonClient.MLuaUICom
---@field BtnRent MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnArrowRight MoonClient.MLuaUICom
---@field BtnArrowLeft MoonClient.MLuaUICom
---@field RefitTrolleyItemPrefab RefitshopPanel.RefitTrolleyItemPrefab

---@return RefitshopPanel
---@param ctrl UIBase
function RefitshopPanel.Bind(ctrl)
	
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
return UI.RefitshopPanel