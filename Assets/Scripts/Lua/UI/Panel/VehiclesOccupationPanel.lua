--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
VehiclesOccupationPanel = {}

--lua model end

--lua functions
---@class VehiclesOccupationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_VehicleUseCondition MoonClient.MLuaUICom
---@field Txt_VehicleStageCondition MoonClient.MLuaUICom
---@field Txt_VehicleProgress MoonClient.MLuaUICom
---@field Txt_UseLimit MoonClient.MLuaUICom
---@field Txt_Unlocked MoonClient.MLuaUICom
---@field Txt_QualityPercentage MoonClient.MLuaUICom
---@field Txt_QualityFetchDesc MoonClient.MLuaUICom
---@field Txt_PropDesc MoonClient.MLuaUICom
---@field Txt_Percentage MoonClient.MLuaUICom
---@field Txt_Number MoonClient.MLuaUICom
---@field Txt_Level MoonClient.MLuaUICom
---@field Txt_FetchDesc MoonClient.MLuaUICom
---@field Txt_AddQualityName MoonClient.MLuaUICom
---@field Toggle_Senior MoonClient.MLuaUICom
---@field Toggle_Primary MoonClient.MLuaUICom
---@field Tmp_VehicleTitle MoonClient.MLuaUICom
---@field Tmp_Title MoonClient.MLuaUICom
---@field TaskImage MoonClient.MLuaUICom
---@field RawImg_StageUpR MoonClient.MLuaUICom
---@field RawImg_StageUpL MoonClient.MLuaUICom
---@field RawImg_model MoonClient.MLuaUICom
---@field RawImg_Ablity MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field Panel_StageCondition MoonClient.MLuaUICom
---@field Panel_QualityRight MoonClient.MLuaUICom
---@field Panel_QualityPropInfo MoonClient.MLuaUICom
---@field Panel_QualityDetailInfo MoonClient.MLuaUICom
---@field Panel_QualityCondition MoonClient.MLuaUICom
---@field Panel_QualityAddAttr MoonClient.MLuaUICom
---@field Panel_Quality MoonClient.MLuaUICom
---@field Panel_Notavailable MoonClient.MLuaUICom
---@field Panel_LvUptips MoonClient.MLuaUICom
---@field Panel_Condition MoonClient.MLuaUICom
---@field Panel_AttInfo MoonClient.MLuaUICom
---@field Panel_Advancedtips MoonClient.MLuaUICom
---@field Panel_Ability MoonClient.MLuaUICom
---@field Obj_ThirdQuality MoonClient.MLuaUICom
---@field Obj_StartQualityAnim MoonClient.MLuaUICom
---@field Obj_StartAbilityAnim MoonClient.MLuaUICom
---@field obj_StageupItemParent MoonClient.MLuaUICom
---@field Obj_StageUpAttParent MoonClient.MLuaUICom
---@field Obj_SecondQuality MoonClient.MLuaUICom
---@field Obj_LvUpParent MoonClient.MLuaUICom
---@field Obj_FourthQuality MoonClient.MLuaUICom
---@field Obj_FirstQuality MoonClient.MLuaUICom
---@field Obj_FifthQuality MoonClient.MLuaUICom
---@field Obj_ConsumeParent MoonClient.MLuaUICom
---@field Obj_abilityAttrParent MoonClient.MLuaUICom
---@field Img_VehicleUseCondition MoonClient.MLuaUICom
---@field Img_Two MoonClient.MLuaUICom
---@field Img_TouchAreaRight MoonClient.MLuaUICom
---@field Img_TouchAreaQuality MoonClient.MLuaUICom
---@field Img_TouchAreaLeft MoonClient.MLuaUICom
---@field Img_TouchArea MoonClient.MLuaUICom
---@field Img_Speed MoonClient.MLuaUICom
---@field Img_Sky MoonClient.MLuaUICom
---@field Img_RedHint MoonClient.MLuaUICom
---@field Img_QualityTwo MoonClient.MLuaUICom
---@field Img_QualitySpeed MoonClient.MLuaUICom
---@field Img_QualitySky MoonClient.MLuaUICom
---@field Img_QualityProp MoonClient.MLuaUICom
---@field Img_QualityOne MoonClient.MLuaUICom
---@field Img_QualityLand MoonClient.MLuaUICom
---@field Img_One MoonClient.MLuaUICom
---@field Img_MaskLvUp MoonClient.MLuaUICom
---@field Img_MaskAdvanced MoonClient.MLuaUICom
---@field Img_Mask MoonClient.MLuaUICom
---@field Img_Land MoonClient.MLuaUICom
---@field Img_Enable_Mask MoonClient.MLuaUICom
---@field Effect_Advanced MoonClient.MLuaUICom
---@field BtnHelp MoonClient.MLuaUICom
---@field Btn_VehicleInfo1 MoonClient.MLuaUICom
---@field Btn_VehicleInfo MoonClient.MLuaUICom
---@field Btn_UseQualityProp MoonClient.MLuaUICom
---@field Btn_StageUp MoonClient.MLuaUICom
---@field Btn_Rest MoonClient.MLuaUICom
---@field Btn_Replace MoonClient.MLuaUICom
---@field Btn_QualityGoto MoonClient.MLuaUICom
---@field Btn_NextVehicle MoonClient.MLuaUICom
---@field Btn_LvUp MoonClient.MLuaUICom
---@field Btn_LevelConditionFinish MoonClient.MLuaUICom
---@field Btn_LastVehicle MoonClient.MLuaUICom
---@field Btn_GotoStage MoonClient.MLuaUICom
---@field Btn_Goto MoonClient.MLuaUICom
---@field Btn_Finish MoonClient.MLuaUICom
---@field Btn_Enabling MoonClient.MLuaUICom
---@field Btn_Culture MoonClient.MLuaUICom
---@field Btn_CloseUpgradeStage MoonClient.MLuaUICom
---@field Btn_CloseQualityPropInfo MoonClient.MLuaUICom
---@field Btn_CloseLvUp MoonClient.MLuaUICom
---@field Btn_Advanced MoonClient.MLuaUICom
---@field Template_AttrInfo MoonClient.MLuaUIGroup
---@field Template_Item MoonClient.MLuaUIGroup
---@field QualityInfoTemplate MoonClient.MLuaUIGroup
---@field Template_QualityExtraAttr MoonClient.MLuaUIGroup
---@field template_stageup MoonClient.MLuaUIGroup

---@return VehiclesOccupationPanel
---@param ctrl UIBase
function VehiclesOccupationPanel.Bind(ctrl)
	
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
return UI.VehiclesOccupationPanel