--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeiluzCoreSynthesisPanel = {}

--lua model end

--lua functions
---@class BeiluzCoreSynthesisPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTip MoonClient.MLuaUICom
---@field TopSkillName MoonClient.MLuaUICom[]
---@field TopName MoonClient.MLuaUICom
---@field TopItemRoot MoonClient.MLuaUICom
---@field TopItemBG MoonClient.MLuaUICom
---@field TopItem MoonClient.MLuaUICom
---@field Tip MoonClient.MLuaUICom
---@field SelectedDoubleSkill MoonClient.MLuaUICom
---@field ModelSwitch MoonClient.MLuaUICom[]
---@field MatSkillName MoonClient.MLuaUICom[]
---@field MatRoot MoonClient.MLuaUICom[]
---@field MatItemRoot MoonClient.MLuaUICom[]
---@field MatIconBtn MoonClient.MLuaUICom[]
---@field MatCostRoot MoonClient.MLuaUICom
---@field MatCostNum MoonClient.MLuaUICom[]
---@field MatCostIcon MoonClient.MLuaUICom[]
---@field MatButton MoonClient.MLuaUICom[]
---@field Mat MoonClient.MLuaUICom[]
---@field ItemSub MoonClient.MLuaUICom[]
---@field ForgeMaterialParent MoonClient.MLuaUICom
---@field EmptyTip MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field CoreList MoonClient.MLuaUICom
---@field CombineIconNew MoonClient.MLuaUICom
---@field BtnTip MoonClient.MLuaUICom
---@field BtnSkillPreview MoonClient.MLuaUICom
---@field BtnGetWay MoonClient.MLuaUICom
---@field BtnCombine MoonClient.MLuaUICom
---@field achievePos MoonClient.MLuaUICom

---@return BeiluzCoreSynthesisPanel
---@param ctrl UIBase
function BeiluzCoreSynthesisPanel.Bind(ctrl)
	
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
return UI.BeiluzCoreSynthesisPanel