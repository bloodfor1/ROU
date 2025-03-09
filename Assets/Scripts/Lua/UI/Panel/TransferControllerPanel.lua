--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TransferControllerPanel = {}

--lua model end

--lua functions
---@class TransferControllerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleText MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Rumors MoonClient.MLuaUICom
---@field Paths MoonClient.MLuaUICom
---@field NPCs MoonClient.MLuaUICom
---@field MerchantInfo MoonClient.MLuaUICom
---@field mask MoonClient.MLuaUICom
---@field MainCities MoonClient.MLuaUICom
---@field ImgNowMap MoonClient.MLuaUICom
---@field ImageWenhao MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom[]
---@field IconMask MoonClient.MLuaUICom[]
---@field citys MoonClient.MLuaUICom[]
---@field Btn_Close MoonClient.MLuaUICom
---@field TransferControllerNpcTemplate MoonClient.MLuaUIGroup
---@field TransferControllerRumorTemplate MoonClient.MLuaUIGroup
---@field MerchantPathTemplate MoonClient.MLuaUIGroup

---@return TransferControllerPanel
---@param ctrl UIBase
function TransferControllerPanel.Bind(ctrl)
	
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
return UI.TransferControllerPanel