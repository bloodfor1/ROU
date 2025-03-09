--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AdventureChapterAwardPanel = {}

--lua model end

--lua functions
---@class AdventureChapterAwardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ModelView MoonClient.MLuaUICom
---@field EffectView MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnGetAward MoonClient.MLuaUICom
---@field AwardName MoonClient.MLuaUICom

---@return AdventureChapterAwardPanel
---@param ctrl UIBaseCtrl
function AdventureChapterAwardPanel.Bind(ctrl)
	
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
return UI.AdventureChapterAwardPanel