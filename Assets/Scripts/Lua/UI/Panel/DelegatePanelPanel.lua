--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DelegatePanelPanel = {}

--lua model end

--lua functions
---@class DelegatePanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipText MoonClient.MLuaUICom
---@field TipsPart MoonClient.MLuaUICom
---@field TipsCount MoonClient.MLuaUICom
---@field TipPanel MoonClient.MLuaUICom
---@field tipBtn MoonClient.MLuaUICom
---@field SystemIcon MoonClient.MLuaUICom
---@field rewardContent MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field MonthCardFlag MoonClient.MLuaUICom
---@field InfoTitle MoonClient.MLuaUICom
---@field InfoScroll MoonClient.MLuaUICom
---@field InfoNum MoonClient.MLuaUICom
---@field InfoMod MoonClient.MLuaUICom
---@field infoGoBtn MoonClient.MLuaUICom
---@field InfoExtraText MoonClient.MLuaUICom
---@field InfoExtra MoonClient.MLuaUICom
---@field InfoContext MoonClient.MLuaUICom
---@field InfoCondition MoonClient.MLuaUICom
---@field IconTpl MoonClient.MLuaUICom
---@field IconList MoonClient.MLuaUICom
---@field emblemSlider MoonClient.MLuaUICom
---@field delegateTxt MoonClient.MLuaUICom
---@field DelegateTipsInfo MoonClient.MLuaUICom
---@field DelegateTips MoonClient.MLuaUICom
---@field Delegate MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ConditionNode MoonClient.MLuaUICom
---@field BtnList MoonClient.MLuaUICom
---@field BtnInfo MoonClient.MLuaUICom
---@field BtnIcon MoonClient.MLuaUICom
---@field BtnExit MoonClient.MLuaUICom
---@field BtnEmblem MoonClient.MLuaUICom
---@field BtnCloseTip MoonClient.MLuaUICom
---@field BtnBox MoonClient.MLuaUICom
---@field boxSlider MoonClient.MLuaUICom
---@field boxImg MoonClient.MLuaUICom
---@field BgImg MoonClient.MLuaUICom
---@field DailyItemTemplate MoonClient.MLuaUIGroup

---@return DelegatePanelPanel
---@param ctrl UIBase
function DelegatePanelPanel.Bind(ctrl)
	
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
return UI.DelegatePanelPanel