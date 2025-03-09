--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SkillPointTipPanel = {}

--lua model end

--lua functions
---@class SkillPointTipPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field txtSkillTypeName MoonClient.MLuaUICom
---@field txtSkillName MoonClient.MLuaUICom
---@field txtSkillIntroduce MoonClient.MLuaUICom
---@field txtSkillAttr MoonClient.MLuaUICom
---@field txtRequireLabel MoonClient.MLuaUICom
---@field txtNextLvSkillTip MoonClient.MLuaUICom
---@field txtNextLvSkillIntroduce MoonClient.MLuaUICom
---@field txtNextDetailInfo MoonClient.MLuaUICom
---@field txtCurrentLV MoonClient.MLuaUICom
---@field txtCurrentDetailInfo MoonClient.MLuaUICom
---@field TogAttackWhenSelect MoonClient.MLuaUICom
---@field skillSpecialDes MoonClient.MLuaUICom
---@field SkillPointTipPanel MoonClient.MLuaUICom
---@field SkillFuncLabel MoonClient.MLuaUICom
---@field SkillFuncId MoonClient.MLuaUICom
---@field SelectLvPanel MoonClient.MLuaUICom
---@field scroll MoonClient.MLuaUICom
---@field Layout MoonClient.MLuaUICom
---@field imgSkillType MoonClient.MLuaUICom
---@field imgSkillIcon MoonClient.MLuaUICom
---@field imgSkillAttr MoonClient.MLuaUICom
---@field content MoonClient.MLuaUICom
---@field btnSubtractionLevel MoonClient.MLuaUICom
---@field BtnConfirm MoonClient.MLuaUICom
---@field btnClosePanel MoonClient.MLuaUICom
---@field BtnCancel MoonClient.MLuaUICom
---@field btnAddLevel MoonClient.MLuaUICom
---@field AutoBan MoonClient.MLuaUICom
---@field AttackWhenSelectPanel MoonClient.MLuaUICom

---@return SkillPointTipPanel
function SkillPointTipPanel.Bind(ctrl)

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
return UI.SkillPointTipPanel