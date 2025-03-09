--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ClassicSkillPanel = {}

--lua model end

--lua functions
---@class ClassicSkillPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillSlots MoonClient.MLuaUICom[]
---@field SkillOutDates MoonClient.MLuaUICom[]
---@field SkillMasks MoonClient.MLuaUICom[]
---@field SkillEnergys MoonClient.MLuaUICom[]
---@field SkillCtrlThumb MoonClient.MLuaUICom
---@field SkillCtrlPanel MoonClient.MLuaUICom
---@field SkillCtrlBG MoonClient.MLuaUICom
---@field SkillCDTxts MoonClient.MLuaUICom[]
---@field SkillCDs MoonClient.MLuaUICom[]
---@field SkillCancel MoonClient.MLuaUICom
---@field AimTarget MoonClient.MLuaUICom

---@return ClassicSkillPanel
---@param ctrl UIBaseCtrl
function ClassicSkillPanel.Bind(ctrl)
	
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
return UI.ClassicSkillPanel