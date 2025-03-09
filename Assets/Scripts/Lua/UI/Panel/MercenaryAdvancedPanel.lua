--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MercenaryAdvancedPanel = {}

--lua model end

--lua functions
---@class MercenaryAdvancedPanel.AdvancedConditionTem
---@field PanelRef MoonClient.MLuaUIPanel
---@field TaskImage MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom

---@class MercenaryAdvancedPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Transfer2Tog MoonClient.MLuaUICom
---@field Transfer2Lock MoonClient.MLuaUICom
---@field Transfer1Tog MoonClient.MLuaUICom
---@field Transfer1Lock MoonClient.MLuaUICom
---@field SvSkill MoonClient.MLuaUICom
---@field SvNumericalvalue2 MoonClient.MLuaUICom
---@field SvNumericalvalue MoonClient.MLuaUICom
---@field SvCondition MoonClient.MLuaUICom
---@field SchoolText MoonClient.MLuaUICom
---@field SchoolDescText MoonClient.MLuaUICom
---@field PanelWeapon MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field merNametext MoonClient.MLuaUICom
---@field LayOut MoonClient.MLuaUICom
---@field JobText MoonClient.MLuaUICom
---@field JobIcon MoonClient.MLuaUICom
---@field JobEnglishText MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field AdvancedConditionTem MercenaryAdvancedPanel.AdvancedConditionTem

---@return MercenaryAdvancedPanel
function MercenaryAdvancedPanel.Bind(ctrl)

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
return UI.MercenaryAdvancedPanel