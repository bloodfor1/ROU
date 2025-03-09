--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
JobTaskPanel = {}

--lua model end

--lua functions
---@class JobTaskPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectJobTips MoonClient.MLuaUICom
---@field JobText MoonClient.MLuaUICom
---@field JobName MoonClient.MLuaUICom[]
---@field JobImage MoonClient.MLuaUICom[]
---@field JobCell_7000 MoonClient.MLuaUICom
---@field JobCell_6000 MoonClient.MLuaUICom
---@field JobCell_5000 MoonClient.MLuaUICom
---@field JobCell_4000 MoonClient.MLuaUICom
---@field JobCell_3000 MoonClient.MLuaUICom
---@field JobCell_2000 MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field ButtonAcceptJobTask MoonClient.MLuaUICom

---@return JobTaskPanel
---@param ctrl UIBase
function JobTaskPanel.Bind(ctrl)
	
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
return UI.JobTaskPanel