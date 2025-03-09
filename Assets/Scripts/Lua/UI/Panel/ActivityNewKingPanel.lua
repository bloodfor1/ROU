--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ActivityNewKingPanel = {}

--lua model end

--lua functions
---@class ActivityNewKingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalCount MoonClient.MLuaUICom
---@field TargetCount MoonClient.MLuaUICom[]
---@field Rule MoonClient.MLuaUICom
---@field RewardReceived MoonClient.MLuaUICom[]
---@field RewardMask MoonClient.MLuaUICom[]
---@field red MoonClient.MLuaUICom[]
---@field Receive MoonClient.MLuaUICom[]
---@field BtnGOTO MoonClient.MLuaUICom
---@field BtnBack MoonClient.MLuaUICom
---@field ActivityTime MoonClient.MLuaUICom
---@field ActivityShowTime MoonClient.MLuaUICom

---@return ActivityNewKingPanel
---@param ctrl UIBase
function ActivityNewKingPanel.Bind(ctrl)
	
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
return UI.ActivityNewKingPanel