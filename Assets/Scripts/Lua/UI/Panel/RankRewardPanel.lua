--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RankRewardPanel = {}

--lua model end

--lua functions
---@class RankRewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Title MoonClient.MLuaUICom
---@field ScrollRect MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field RankRowRewardTem MoonClient.MLuaUIGroup

---@return RankRewardPanel
---@param ctrl UIBase
function RankRewardPanel.Bind(ctrl)
	
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
return UI.RankRewardPanel