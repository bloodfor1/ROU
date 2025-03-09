--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MonsterInfoTipsPanel = {}

--lua model end

--lua functions
---@class MonsterInfoTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsHeadIcon MoonClient.MLuaUICom
---@field TipsDes MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field TargetName MoonClient.MLuaUICom
---@field Target MoonClient.MLuaUICom
---@field Relic MoonClient.MLuaUICom
---@field MonsterTypeShapeLab MoonClient.MLuaUICom
---@field MonsterTypeShape MoonClient.MLuaUICom
---@field MonsterTypeRaceLab MoonClient.MLuaUICom
---@field MonsterTypeRace MoonClient.MLuaUICom
---@field MonsterTypeAttrLab MoonClient.MLuaUICom
---@field MonsterTypeAttr MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnGotoMonsterPos MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom

---@return MonsterInfoTipsPanel
---@param ctrl UIBase
function MonsterInfoTipsPanel.Bind(ctrl)
	
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
return UI.MonsterInfoTipsPanel