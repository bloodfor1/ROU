--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DungeonTargetPanel = {}

--lua model end

--lua functions
---@class DungeonTargetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field TargetHide MoonClient.MLuaUICom
---@field Target MoonClient.MLuaUICom
---@field runText MoonClient.MLuaUICom
---@field RawImg MoonClient.MLuaUICom
---@field process MoonClient.MLuaUICom
---@field OpenBtn MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field finishText MoonClient.MLuaUICom
---@field EnhanceTipEffect MoonClient.MLuaUICom
---@field CloneGoj MoonClient.MLuaUICom

---@return DungeonTargetPanel
---@param ctrl UIBase
function DungeonTargetPanel.Bind(ctrl)
	
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
return UI.DungeonTargetPanel