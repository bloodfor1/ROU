--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PvpArenaRecruitPanel = {}

--lua model end

--lua functions
---@class PvpArenaRecruitPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field sendBtn MoonClient.MLuaUICom
---@field secondeBtn MoonClient.MLuaUICom
---@field InputField MoonClient.MLuaUICom
---@field firstBtn MoonClient.MLuaUICom
---@field closeBtn MoonClient.MLuaUICom

---@return PvpArenaRecruitPanel
function PvpArenaRecruitPanel.Bind(ctrl)

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
return UI.PvpArenaRecruitPanel