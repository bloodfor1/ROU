--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MapPanel = {}

--lua model end

--lua functions
---@class MapPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_WeatherTime MoonClient.MLuaUICom
---@field Txt_WeatherTemperatureInfoTipsType MoonClient.MLuaUICom
---@field Txt_WeatherTemperatureInfoTipsStateTitle MoonClient.MLuaUICom
---@field Txt_WeatherTemperatureInfoTipsState MoonClient.MLuaUICom
---@field Txt_WeatherTemperatureInfoTipsRange MoonClient.MLuaUICom
---@field Txt_WeatherTemperatureInfoTipsDesc MoonClient.MLuaUICom
---@field Txt_WeatherMapName MoonClient.MLuaUICom
---@field Txt_WeatherEvt MoonClient.MLuaUICom
---@field Txt_Weather MoonClient.MLuaUICom
---@field Txt_ShowTowerMonsterNumber MoonClient.MLuaUICom
---@field Txt_PlayerPosition MoonClient.MLuaUICom
---@field Txt_NextTimeInfo MoonClient.MLuaUICom
---@field Txt_MnMapName MoonClient.MLuaUICom
---@field Txt_EvtInfo MoonClient.MLuaUICom
---@field Txt_CurTimeInfoTxt MoonClient.MLuaUICom
---@field Txt_CollectToPlayerOffset MoonClient.MLuaUICom
---@field Txt_BigMapName1 MoonClient.MLuaUICom
---@field Txt_BigMapName MoonClient.MLuaUICom
---@field Toggle_ShowALlToggle MoonClient.MLuaUICom
---@field Tog_03 MoonClient.MLuaUICom
---@field Tog_02 MoonClient.MLuaUICom
---@field Tog_01 MoonClient.MLuaUICom
---@field Slider_SceneTemperatureHot MoonClient.MLuaUICom
---@field Slider_SceneTemperatureCold MoonClient.MLuaUICom
---@field Scroll_NearPeople MoonClient.MLuaUICom
---@field Scroll_MonsterScrollView MoonClient.MLuaUICom
---@field Scroll_MapEvent MoonClient.MLuaUICom
---@field Raw_MnMapObj MoonClient.MLuaUICom
---@field Raw_MnMapBg MoonClient.MLuaUICom
---@field Raw_EffectTemplate MoonClient.MLuaUICom
---@field Raw_BigMapObj MoonClient.MLuaUICom
---@field Raw_BigMapBg MoonClient.MLuaUICom
---@field Panel_WeatherTip MoonClient.MLuaUICom
---@field Panel_WeatherTemperatureInfoTips MoonClient.MLuaUICom
---@field Panel_Weather MoonClient.MLuaUICom
---@field Panel_NpcInfo MoonClient.MLuaUICom
---@field Panel_NoEvent MoonClient.MLuaUICom
---@field Panel_NearPeople MoonClient.MLuaUICom
---@field Panel_MonsInfo MoonClient.MLuaUICom
---@field Panel_MnPlayer MoonClient.MLuaUICom
---@field Panel_MnInfo MoonClient.MLuaUICom
---@field Panel_MapInfo MoonClient.MLuaUICom
---@field Panel_InfoVp2 MoonClient.MLuaUICom
---@field Panel_InfoVp1 MoonClient.MLuaUICom
---@field Panel_EvtInfo MoonClient.MLuaUICom
---@field Panel_EffectParentBigMap MoonClient.MLuaUICom
---@field Panel_EffectParent MoonClient.MLuaUICom
---@field Panel_BigPlayer MoonClient.MLuaUICom
---@field Panel_BigMap MoonClient.MLuaUICom
---@field Obj_RowEvtInfo MoonClient.MLuaUICom
---@field Obj_MonsterContent MoonClient.MLuaUICom
---@field Obj_EventInfoList MoonClient.MLuaUICom
---@field Obj_eventContent MoonClient.MLuaUICom
---@field NoDataNpcInfo MoonClient.MLuaUICom
---@field NoDataMonsterInfo MoonClient.MLuaUICom
---@field NoData MoonClient.MLuaUICom
---@field LoopScroll_NPC MoonClient.MLuaUICom
---@field Img_WeatherTemperatureInfoTipsIcon MoonClient.MLuaUICom
---@field Img_WeatherTemperatureInfoTipsBG MoonClient.MLuaUICom
---@field Img_TowerInfo MoonClient.MLuaUICom
---@field Img_ShowTowerMonsterNumber MoonClient.MLuaUICom
---@field Img_SceneWeatherIcon MoonClient.MLuaUICom
---@field Img_SceneTemperaturePointer MoonClient.MLuaUICom
---@field Img_NextWeatherTemperatureInfoTipsIcon MoonClient.MLuaUICom
---@field Img_EvtInfo MoonClient.MLuaUICom
---@field But_PlayerPositionBG MoonClient.MLuaUICom
---@field But_MnMapPanel MoonClient.MLuaUICom
---@field But_CollectToPlayerOffset MoonClient.MLuaUICom
---@field Btn_ShowTowerReward MoonClient.MLuaUICom
---@field Btn_Reduce MoonClient.MLuaUICom
---@field Btn_OpenWorldMap MoonClient.MLuaUICom
---@field Btn_OpenMapInfo MoonClient.MLuaUICom
---@field Btn_NearPeople MoonClient.MLuaUICom
---@field Btn_FliesWings MoonClient.MLuaUICom
---@field Btn_Enlarge MoonClient.MLuaUICom
---@field Btn_CloseNearPeople MoonClient.MLuaUICom
---@field Btn_CloseMapInfo MoonClient.MLuaUICom
---@field Btn_CloseBig MoonClient.MLuaUICom
---@field Bg_MapNameWeather MoonClient.MLuaUICom
---@field Bg_MapNameNoWeather MoonClient.MLuaUICom
---@field AffixBtn MoonClient.MLuaUICom
---@field WeatherUnitTemplate MoonClient.MLuaUIGroup
---@field Template_NearPeople MoonClient.MLuaUIGroup
---@field MapInfoTitleTemplate MoonClient.MLuaUIGroup
---@field EmptyTemplate MoonClient.MLuaUIGroup
---@field NpcInfoTemplate MoonClient.MLuaUIGroup
---@field BtnMonsInfoTemplate MoonClient.MLuaUIGroup
---@field MapEventInfoTemplate MoonClient.MLuaUIGroup

---@return MapPanel
---@param ctrl UIBase
function MapPanel.Bind(ctrl)
	
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
return UI.MapPanel