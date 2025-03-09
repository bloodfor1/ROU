--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BossbuffPanel = {}

--lua model end

--lua functions
---@class BossbuffPanel.AffxCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field AffixIcon MoonClient.MLuaUICom
---@field AffixDes MoonClient.MLuaUICom

---@class BossbuffPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Panel MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field AffixScroll MoonClient.MLuaUICom
---@field AffxCell BossbuffPanel.AffxCell

---@return BossbuffPanel
---@param ctrl UIBase
function BossbuffPanel.Bind(ctrl)
	
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
return UI.BossbuffPanel