--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeachLandingPanel = {}

--lua model end

--lua functions
---@class BeachLandingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field xin MoonClient.MLuaUICom
---@field slotBtn MoonClient.MLuaUICom[]
---@field SkillBtns MoonClient.MLuaUICom
---@field rightPrompt MoonClient.MLuaUICom
---@field right MoonClient.MLuaUICom
---@field leftPrompt MoonClient.MLuaUICom
---@field left MoonClient.MLuaUICom
---@field Control MoonClient.MLuaUICom
---@field closeBtn MoonClient.MLuaUICom
---@field center MoonClient.MLuaUICom
---@field blood MoonClient.MLuaUICom

---@return BeachLandingPanel
---@param ctrl UIBaseCtrl
function BeachLandingPanel.Bind(ctrl)
	
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
return UI.BeachLandingPanel