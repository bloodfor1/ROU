--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
NewPlayerPanel = {}

--lua model end

--lua functions
---@class NewPlayerPanel.MallItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextTime MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field PriceNum MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LimitText MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Discounts MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class NewPlayerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleGroup MoonClient.MLuaUICom
---@field Toggle MoonClient.MLuaUICom
---@field MainView MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field MallItemPrefab NewPlayerPanel.MallItemPrefab

---@return NewPlayerPanel
---@param ctrl UIBase
function NewPlayerPanel.Bind(ctrl)
	
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
return UI.NewPlayerPanel