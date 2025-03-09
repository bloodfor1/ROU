--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SkillAttrPanel = {}

--lua model end

--lua functions
---@class SkillAttrPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillPanelRect MoonClient.MLuaUICom
---@field SkillPanel MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom

---@return SkillAttrPanel
---@param ctrl UIBase
function SkillAttrPanel.Bind(ctrl)
	
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
return UI.SkillAttrPanel