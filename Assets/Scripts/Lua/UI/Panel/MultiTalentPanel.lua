--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MultiTalentPanel = {}

--lua model end

--lua functions
---@class MultiTalentPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectImg MoonClient.MLuaUICom
---@field MultiText MoonClient.MLuaUICom
---@field MultiTalent MoonClient.MLuaUICom
---@field MultiIcon MoonClient.MLuaUICom
---@field ButtonTem MoonClient.MLuaUICom
---@field BodyEquipParent MoonClient.MLuaUICom

---@return MultiTalentPanel
function MultiTalentPanel.Bind(ctrl)

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
return UI.MultiTalentPanel