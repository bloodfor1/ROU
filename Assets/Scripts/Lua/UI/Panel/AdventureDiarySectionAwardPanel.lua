--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AdventureDiarySectionAwardPanel = {}

--lua model end

--lua functions
---@class AdventureDiarySectionAwardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Condition MoonClient.MLuaUICom
---@field BtnGetText MoonClient.MLuaUICom
---@field BtnGet MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field AwardList MoonClient.MLuaUICom

---@return AdventureDiarySectionAwardPanel
---@param ctrl UIBase
function AdventureDiarySectionAwardPanel.Bind(ctrl)
	
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
return UI.AdventureDiarySectionAwardPanel