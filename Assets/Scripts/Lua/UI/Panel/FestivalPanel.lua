--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FestivalPanel = {}

--lua model end

--lua functions
---@class FestivalPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field FestivalPanel MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field AllText MoonClient.MLuaUICom
---@field AllBackGround MoonClient.MLuaUICom
---@field LeftActivity MoonClient.MLuaUIGroup

---@return FestivalPanel
---@param ctrl UIBase
function FestivalPanel.Bind(ctrl)
	
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
return UI.FestivalPanel