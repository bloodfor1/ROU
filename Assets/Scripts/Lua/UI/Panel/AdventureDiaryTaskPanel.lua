--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AdventureDiaryTaskPanel = {}

--lua model end

--lua functions
---@class AdventureDiaryTaskPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TargetText MoonClient.MLuaUICom
---@field TargetDescribeText MoonClient.MLuaUICom
---@field MissionName MoonClient.MLuaUICom
---@field MissionImg MoonClient.MLuaUICom
---@field ContentPart MoonClient.MLuaUICom
---@field Complete MoonClient.MLuaUICom
---@field CanTakeTipText MoonClient.MLuaUICom
---@field CanTakeTip MoonClient.MLuaUICom
---@field BtnPre MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field BtnGo MoonClient.MLuaUICom
---@field BtnGetAward MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field AwardScroll MoonClient.MLuaUICom

---@return AdventureDiaryTaskPanel
---@param ctrl UIBase
function AdventureDiaryTaskPanel.Bind(ctrl)
	
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
return UI.AdventureDiaryTaskPanel