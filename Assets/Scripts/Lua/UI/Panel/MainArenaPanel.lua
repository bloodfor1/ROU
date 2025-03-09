--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainArenaPanel = {}

--lua model end

--lua functions
---@class MainArenaPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field timerLab MoonClient.MLuaUICom
---@field startEnableLab MoonClient.MLuaUICom
---@field startDisableLab MoonClient.MLuaUICom
---@field startBtn MoonClient.MLuaUICom
---@field setPanel MoonClient.MLuaUICom
---@field setBtn MoonClient.MLuaUICom
---@field redScoreLab MoonClient.MLuaUICom
---@field redCountLab MoonClient.MLuaUICom
---@field recruitBtn MoonClient.MLuaUICom
---@field randomBtn MoonClient.MLuaUICom
---@field preObject MoonClient.MLuaUICom
---@field pkTimerLab MoonClient.MLuaUICom
---@field pKPanel MoonClient.MLuaUICom
---@field pkObject MoonClient.MLuaUICom
---@field openIcon MoonClient.MLuaUICom
---@field openBtn MoonClient.MLuaUICom
---@field inviteIcon MoonClient.MLuaUICom
---@field inviteBtn MoonClient.MLuaUICom
---@field freeBtn MoonClient.MLuaUICom
---@field closePanelBtn MoonClient.MLuaUICom
---@field blueScoreLab MoonClient.MLuaUICom
---@field blueCountLab MoonClient.MLuaUICom
---@field autoBtn MoonClient.MLuaUICom

---@return MainArenaPanel
function MainArenaPanel.Bind(ctrl)

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
return UI.MainArenaPanel