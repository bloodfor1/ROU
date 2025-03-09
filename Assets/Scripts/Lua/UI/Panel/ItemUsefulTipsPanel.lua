--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ItemUsefulTipsPanel = {}

--lua model end

--lua functions
---@class ItemUsefulTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field VehicleViewer MoonClient.MLuaUICom
---@field TxtVehicleTitle MoonClient.MLuaUICom
---@field TxtModelTitle MoonClient.MLuaUICom
---@field TxtMaterialUseful MoonClient.MLuaUICom
---@field TradeSellItemSelect MoonClient.MLuaUICom
---@field TradeSellItemBtn MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field ModelViewer MoonClient.MLuaUICom
---@field Model_Obj MoonClient.MLuaUICom
---@field Model_Character MoonClient.MLuaUICom
---@field MaterialUsefulPanel MoonClient.MLuaUICom
---@field ItemTem MoonClient.MLuaUICom
---@field imageEquipFlag MoonClient.MLuaUICom
---@field HideOtherAppearances MoonClient.MLuaUICom
---@field Group_Vehicle MoonClient.MLuaUICom
---@field Group_Equip MoonClient.MLuaUICom
---@field Group_Barber MoonClient.MLuaUICom
---@field Contentvehicle MoonClient.MLuaUICom
---@field ContentEquip MoonClient.MLuaUICom
---@field ContentBarber MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field AllItemBg MoonClient.MLuaUICom

---@return ItemUsefulTipsPanel
---@param ctrl UIBase
function ItemUsefulTipsPanel.Bind(ctrl)
	
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
return UI.ItemUsefulTipsPanel