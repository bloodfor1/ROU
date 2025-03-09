--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
NewPlayerBoxPanel = {}

--lua model end

--lua functions
---@class NewPlayerBoxPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Hint MoonClient.MLuaUICom
---@field EffectOpen MoonClient.MLuaUICom
---@field EffectClose MoonClient.MLuaUICom
---@field BtnOpen MoonClient.MLuaUICom
---@field Anim MoonClient.MLuaUICom

---@return NewPlayerBoxPanel
---@param ctrl UIBase
function NewPlayerBoxPanel.Bind(ctrl)
	
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
return UI.NewPlayerBoxPanel