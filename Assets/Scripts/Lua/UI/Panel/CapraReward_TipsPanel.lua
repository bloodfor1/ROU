--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CapraReward_TipsPanel = {}

--lua model end

--lua functions
---@class CapraReward_TipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field PriceNum MoonClient.MLuaUICom
---@field ItemScroll MoonClient.MLuaUICom
---@field FreeText MoonClient.MLuaUICom
---@field CoinIcon MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom

---@return CapraReward_TipsPanel
---@param ctrl UIBase
function CapraReward_TipsPanel.Bind(ctrl)
	
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
return UI.CapraReward_TipsPanel