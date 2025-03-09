--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CountDownPanel = {}

--lua model end

--lua functions
---@class CountDownPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Tip MoonClient.MLuaUICom
---@field TimePanel MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Right MoonClient.MLuaUICom
---@field Center MoonClient.MLuaUICom

---@return CountDownPanel
---@param ctrl UIBase
function CountDownPanel.Bind(ctrl)
	
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
return UI.CountDownPanel