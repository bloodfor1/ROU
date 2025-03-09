--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeiluzSkillPreviewPanel = {}

--lua model end

--lua functions
---@class BeiluzSkillPreviewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Skill2Root MoonClient.MLuaUICom
---@field Skill2Btn MoonClient.MLuaUICom
---@field Skill2Arrow MoonClient.MLuaUICom
---@field Skill1Root MoonClient.MLuaUICom
---@field Skill1Btn MoonClient.MLuaUICom
---@field Skill1Arrow MoonClient.MLuaUICom
---@field ProfessionOnly MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom

---@return BeiluzSkillPreviewPanel
---@param ctrl UIBase
function BeiluzSkillPreviewPanel.Bind(ctrl)
	
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
return UI.BeiluzSkillPreviewPanel