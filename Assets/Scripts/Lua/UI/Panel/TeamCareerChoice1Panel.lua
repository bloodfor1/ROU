--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamCareerChoice1Panel = {}

--lua model end

--lua functions
---@class TeamCareerChoice1Panel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Widget_Member MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field Txt_Hint MoonClient.MLuaUICom
---@field Tog_ShowNextTime MoonClient.MLuaUICom
---@field Dummy_Career MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_Start MoonClient.MLuaUICom

---@return TeamCareerChoice1Panel
---@param ctrl UIBase
function TeamCareerChoice1Panel.Bind(ctrl)
	
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
return UI.TeamCareerChoice1Panel