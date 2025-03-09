--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MercenarySelectionPanel = {}

--lua model end

--lua functions
---@class MercenarySelectionPanel.MercenarySelectTem
---@field PanelRef MoonClient.MLuaUIPanel
---@field Toggle MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field MercenaryName MoonClient.MLuaUICom
---@field MercenaryLvltxt MoonClient.MLuaUICom
---@field MercenaryJob MoonClient.MLuaUICom
---@field MercenaryHead MoonClient.MLuaUICom
---@field MercenaryAttackTxt MoonClient.MLuaUICom
---@field MercenaryAttack MoonClient.MLuaUICom

---@class MercenarySelectionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field MercenaryNum MoonClient.MLuaUICom
---@field loopview MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field MercenarySelectTem MercenarySelectionPanel.MercenarySelectTem

---@return MercenarySelectionPanel
function MercenarySelectionPanel.Bind(ctrl)

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
return UI.MercenarySelectionPanel