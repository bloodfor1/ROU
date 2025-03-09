--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildHuntInfoPanel = {}

--lua model end

--lua functions
---@class GuildHuntInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field XText MoonClient.MLuaUICom
---@field XSlider MoonClient.MLuaUICom
---@field XIcon MoonClient.MLuaUICom
---@field XCount MoonClient.MLuaUICom
---@field XAim MoonClient.MLuaUICom
---@field RingScrollView MoonClient.MLuaUICom
---@field RightArrow MoonClient.MLuaUICom
---@field RankScore MoonClient.MLuaUICom[]
---@field RankName MoonClient.MLuaUICom[]
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field PassHint MoonClient.MLuaUICom
---@field OpenTimeText MoonClient.MLuaUICom
---@field NextOpenCountDown MoonClient.MLuaUICom
---@field LeftTimeText MoonClient.MLuaUICom
---@field LeftAwardTimesText MoonClient.MLuaUICom
---@field LeftAwardTimes MoonClient.MLuaUICom
---@field LeftArrow MoonClient.MLuaUICom
---@field HuntOpen MoonClient.MLuaUICom
---@field HuntNotOpen MoonClient.MLuaUICom
---@field FxViewOpen MoonClient.MLuaUICom
---@field FxViewClose MoonClient.MLuaUICom
---@field ExplainText MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field ExplainBubble MoonClient.MLuaUICom
---@field DungeonsAwardScrollView MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field BuffScrollView MoonClient.MLuaUICom
---@field BtnViewDeatil MoonClient.MLuaUICom
---@field BtnProgressHelp MoonClient.MLuaUICom
---@field BtnOpenText MoonClient.MLuaUICom
---@field BtnOpen MoonClient.MLuaUICom
---@field BtnInfoHelp MoonClient.MLuaUICom
---@field BtnGoToText MoonClient.MLuaUICom
---@field BtnGoTo MoonClient.MLuaUICom
---@field BtnCloseExplain MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnAwardBox MoonClient.MLuaUICom
---@field BtnAdd MoonClient.MLuaUICom
---@field AwardScrollView MoonClient.MLuaUICom
---@field AwardBoxOpen MoonClient.MLuaUICom
---@field AwardBoxClose MoonClient.MLuaUICom
---@field AvailableTimesText MoonClient.MLuaUICom
---@field AddRaw MoonClient.MLuaUICom
---@field GHBuffPrefab MoonClient.MLuaUIGroup

---@return GuildHuntInfoPanel
---@param ctrl UIBase
function GuildHuntInfoPanel.Bind(ctrl)
	
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
return UI.GuildHuntInfoPanel