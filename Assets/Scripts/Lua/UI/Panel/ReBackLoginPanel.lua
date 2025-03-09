--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ReBackLoginPanel = {}

--lua model end

--lua functions
---@class ReBackLoginPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ReBackLoginSumAwardScroll MoonClient.MLuaUICom
---@field ReBackLoginDailyAwardScroll MoonClient.MLuaUICom
---@field LeftTimeRoot MoonClient.MLuaUICom
---@field LeftTime MoonClient.MLuaUICom
---@field ReBackLoginSumAwardPrefab MoonClient.MLuaUIGroup
---@field ReBackLoginDailyAwardPrefab MoonClient.MLuaUIGroup

---@return ReBackLoginPanel
---@param ctrl UIBase
function ReBackLoginPanel.Bind(ctrl)
	
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
return UI.ReBackLoginPanel