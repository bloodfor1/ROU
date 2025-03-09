--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
InfoWorldPvePanel = {}

--lua model end

--lua functions
---@class InfoWorldPvePanel.RewardItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Image MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom

---@class InfoWorldPvePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field timesLab MoonClient.MLuaUICom
---@field InfoWorldBG MoonClient.MLuaUICom
---@field InfoTitle MoonClient.MLuaUICom
---@field InfoTime MoonClient.MLuaUICom
---@field InfoTeamBtn MoonClient.MLuaUICom
---@field InfoOpening MoonClient.MLuaUICom
---@field InfoNum MoonClient.MLuaUICom
---@field InfoMod MoonClient.MLuaUICom
---@field InfoLv MoonClient.MLuaUICom
---@field infoGoBtn MoonClient.MLuaUICom
---@field InfoFinish MoonClient.MLuaUICom
---@field InfoContext MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field But_Introduce MoonClient.MLuaUICom
---@field BgImg MoonClient.MLuaUICom
---@field RewardItemTemplate InfoWorldPvePanel.RewardItemTemplate

---@return InfoWorldPvePanel
---@param ctrl UIBase
function InfoWorldPvePanel.Bind(ctrl)
	
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
return UI.InfoWorldPvePanel