--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
JobPreviewPanel = {}

--lua model end

--lua functions
---@class JobPreviewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillName MoonClient.MLuaUICom[]
---@field SkillIcon MoonClient.MLuaUICom[]
---@field SkillBox MoonClient.MLuaUICom[]
---@field RoleViewImg MoonClient.MLuaUICom
---@field MaxLvText MoonClient.MLuaUICom[]
---@field Liubianxing MoonClient.MLuaUICom
---@field JobTog MoonClient.MLuaUICom[]
---@field JobNameOff MoonClient.MLuaUICom[]
---@field JobName MoonClient.MLuaUICom[]
---@field JobInfoText MoonClient.MLuaUICom
---@field JobIconOn MoonClient.MLuaUICom[]
---@field JobIconOff MoonClient.MLuaUICom[]
---@field BtnSkillPlay MoonClient.MLuaUICom[]
---@field BtnQuit MoonClient.MLuaUICom
---@field BtnEnter MoonClient.MLuaUICom
---@field AdvanceJobText MoonClient.MLuaUICom

---@return JobPreviewPanel
---@param ctrl UIBase
function JobPreviewPanel.Bind(ctrl)
	
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
return UI.JobPreviewPanel