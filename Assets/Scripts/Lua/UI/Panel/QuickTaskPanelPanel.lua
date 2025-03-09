--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
QuickTaskPanelPanel = {}

--lua model end

--lua functions
---@class QuickTaskPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TypeGrp MoonClient.MLuaUICom
---@field Type_3 MoonClient.MLuaUICom
---@field Type_2 MoonClient.MLuaUICom
---@field Type_1 MoonClient.MLuaUICom
---@field TitleImage MoonClient.MLuaUICom
---@field TaskTpl MoonClient.MLuaUICom
---@field TaskPanel MoonClient.MLuaUICom
---@field SelectTaskImg MoonClient.MLuaUICom
---@field Progress MoonClient.MLuaUICom
---@field GiveUpBtn MoonClient.MLuaUICom
---@field FxGameObject MoonClient.MLuaUICom
---@field DebugTaskId MoonClient.MLuaUICom
---@field AwardItemBox MoonClient.MLuaUICom

---@return QuickTaskPanelPanel
---@param ctrl UIBase
function QuickTaskPanelPanel.Bind(ctrl)
	
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
return UI.QuickTaskPanelPanel