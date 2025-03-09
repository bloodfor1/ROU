--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PartyMainPanel = {}

--lua model end

--lua functions
---@class PartyMainPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field TextLuckyCode MoonClient.MLuaUICom
---@field TextLeftTime MoonClient.MLuaUICom
---@field TextLakeNum MoonClient.MLuaUICom
---@field TemIndex MoonClient.MLuaUICom
---@field SkillEffect MoonClient.MLuaUICom[]
---@field SkillCD0 MoonClient.MLuaUICom[]
---@field PredictTitle MoonClient.MLuaUICom
---@field PredictLeftTime MoonClient.MLuaUICom
---@field PredictIcon MoonClient.MLuaUICom
---@field PartyNum MoonClient.MLuaUICom
---@field PartyInfoTitle MoonClient.MLuaUICom
---@field PartyInfo MoonClient.MLuaUICom
---@field MusicSlider MoonClient.MLuaUICom
---@field MusicPlayBtn MoonClient.MLuaUICom
---@field MusicName MoonClient.MLuaUICom
---@field Music MoonClient.MLuaUICom
---@field LotteryPredict MoonClient.MLuaUICom
---@field IsOpenPredect MoonClient.MLuaUICom
---@field InfoGrid MoonClient.MLuaUICom
---@field EditSelect MoonClient.MLuaUICom[]
---@field Edit05 MoonClient.MLuaUICom
---@field Edit04 MoonClient.MLuaUICom
---@field Edit03 MoonClient.MLuaUICom
---@field Edit02 MoonClient.MLuaUICom
---@field Edit01 MoonClient.MLuaUICom
---@field DanceIndexTips MoonClient.MLuaUICom
---@field DanceIndex MoonClient.MLuaUICom
---@field DanceEdit MoonClient.MLuaUICom
---@field DanceDragGo MoonClient.MLuaUICom
---@field DanceBtnPanel MoonClient.MLuaUICom
---@field DanceBtn MoonClient.MLuaUICom[]
---@field Dance08 MoonClient.MLuaUICom
---@field Dance07 MoonClient.MLuaUICom
---@field Dance06 MoonClient.MLuaUICom
---@field Dance05 MoonClient.MLuaUICom
---@field Dance04 MoonClient.MLuaUICom
---@field Dance03 MoonClient.MLuaUICom
---@field Dance02 MoonClient.MLuaUICom
---@field Dance01 MoonClient.MLuaUICom
---@field BtnNotClickToggle MoonClient.MLuaUICom
---@field BtnLuckyStar MoonClient.MLuaUICom
---@field BtnLake MoonClient.MLuaUICom
---@field BtnInfo MoonClient.MLuaUICom
---@field BtnEmpty MoonClient.MLuaUICom[]
---@field BtnEdit MoonClient.MLuaUICom
---@field BtnDanceEditToggleGray MoonClient.MLuaUICom
---@field BtnDanceEditToggle MoonClient.MLuaUICom
---@field BtnDanceEditInfo MoonClient.MLuaUICom
---@field BtnCloseDanceEdit MoonClient.MLuaUICom
---@field BtnCheck MoonClient.MLuaUICom
---@field Add MoonClient.MLuaUICom[]

---@return PartyMainPanel
---@param ctrl UIBase
function PartyMainPanel.Bind(ctrl)
	
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
return UI.PartyMainPanel