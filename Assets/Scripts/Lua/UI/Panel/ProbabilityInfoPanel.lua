--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ProbabilityInfoPanel = {}

--lua model end

--lua functions
---@class ProbabilityInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UrlText MoonClient.MLuaUICom
---@field ScrollRect MoonClient.MLuaUICom
---@field Btn_Question MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field ProbablityBlockTem MoonClient.MLuaUIGroup

---@return ProbabilityInfoPanel
---@param ctrl UIBase
function ProbabilityInfoPanel.Bind(ctrl)
	
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
return UI.ProbabilityInfoPanel