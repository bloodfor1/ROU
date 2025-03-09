--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Choosejob_npcPanel = {}

--lua model end

--lua functions
---@class Choosejob_npcPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RightJobText MoonClient.MLuaUICom
---@field RightJobShadow MoonClient.MLuaUICom
---@field RightJobPic MoonClient.MLuaUICom
---@field RightJobName MoonClient.MLuaUICom
---@field RightJobImage MoonClient.MLuaUICom
---@field RightJobChooseBtn MoonClient.MLuaUICom
---@field LeftJobText MoonClient.MLuaUICom
---@field LeftJobShadow MoonClient.MLuaUICom
---@field LeftJobPic MoonClient.MLuaUICom
---@field LeftJobName MoonClient.MLuaUICom
---@field LeftJobImage MoonClient.MLuaUICom
---@field LeftJobChooseBtn MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return Choosejob_npcPanel
---@param ctrl UIBase
function Choosejob_npcPanel.Bind(ctrl)
	
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
return UI.Choosejob_npcPanel