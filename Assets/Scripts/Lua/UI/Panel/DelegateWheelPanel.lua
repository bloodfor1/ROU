--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DelegateWheelPanel = {}

--lua model end

--lua functions
---@class DelegateWheelPanel.DelegateWheelItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field CurrentImg MoonClient.MLuaUICom
---@field changeBtn MoonClient.MLuaUICom

---@class DelegateWheelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WheelTitle MoonClient.MLuaUICom
---@field WheelCostTxt MoonClient.MLuaUICom
---@field WheelAnimator MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field slider MoonClient.MLuaUICom
---@field ShopIcon MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field process MoonClient.MLuaUICom
---@field p9 MoonClient.MLuaUICom
---@field p8 MoonClient.MLuaUICom
---@field p7 MoonClient.MLuaUICom
---@field p6 MoonClient.MLuaUICom
---@field p5 MoonClient.MLuaUICom
---@field p4 MoonClient.MLuaUICom
---@field p3 MoonClient.MLuaUICom
---@field p2 MoonClient.MLuaUICom
---@field p10 MoonClient.MLuaUICom
---@field p1 MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field luckBtn MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field iconText MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Checked MoonClient.MLuaUICom
---@field DelegateWheelItem DelegateWheelPanel.DelegateWheelItem

---@return DelegateWheelPanel
---@param ctrl UIBase
function DelegateWheelPanel.Bind(ctrl)
	
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
return UI.DelegateWheelPanel