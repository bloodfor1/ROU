--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LifeProfessionMainPanel = {}

--lua model end

--lua functions
---@class LifeProfessionMainPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_SucChanceSingle MoonClient.MLuaUICom
---@field Txt_SucChanceRight MoonClient.MLuaUICom
---@field Txt_SucChanceLeft MoonClient.MLuaUICom
---@field Txt_SkillTitleDesc MoonClient.MLuaUICom
---@field Txt_SkillTitle MoonClient.MLuaUICom
---@field Txt_SkillProgress MoonClient.MLuaUICom
---@field Txt_SkillProductName MoonClient.MLuaUICom
---@field Txt_SkillProductDesc MoonClient.MLuaUICom
---@field Txt_LifeSkillLevelRight MoonClient.MLuaUICom
---@field Txt_LifeSkillLevelLeft MoonClient.MLuaUICom
---@field Txt_LifeSkillLevelDesc MoonClient.MLuaUICom
---@field Txt_LevelUpLevelLimit MoonClient.MLuaUICom
---@field Txt_LevelName2 MoonClient.MLuaUICom
---@field Txt_LevelName1 MoonClient.MLuaUICom
---@field Txt_LevelName MoonClient.MLuaUICom
---@field Txt_Level2 MoonClient.MLuaUICom
---@field Txt_Level1 MoonClient.MLuaUICom
---@field Txt_Level MoonClient.MLuaUICom
---@field Txt_CurrentDirectoryName MoonClient.MLuaUICom
---@field Txt_BigSucRewardSingle MoonClient.MLuaUICom
---@field Txt_BigSucRewardRight MoonClient.MLuaUICom
---@field Txt_BigSucRewardLeft MoonClient.MLuaUICom
---@field Txt_BigSucChanceSingle MoonClient.MLuaUICom
---@field Txt_BigSucChanceRight MoonClient.MLuaUICom
---@field Txt_BigSucChanceLeft MoonClient.MLuaUICom
---@field Slider_SkillProgressBg MoonClient.MLuaUICom
---@field Slider_SkillProgress MoonClient.MLuaUICom
---@field Scroll_SkillProduct MoonClient.MLuaUICom
---@field Scroll_LifeProfessionSite MoonClient.MLuaUICom
---@field Scroll_LifeDirectory MoonClient.MLuaUICom
---@field Scroll_CostProp MoonClient.MLuaUICom
---@field Raw_LevelUp MoonClient.MLuaUICom
---@field Panel_UnlockShow MoonClient.MLuaUICom
---@field Panel_UnlockDesc MoonClient.MLuaUICom
---@field Panel_SkillProductTip MoonClient.MLuaUICom
---@field Panel_SkillLetter MoonClient.MLuaUICom
---@field Panel_SkillDetailInfo MoonClient.MLuaUICom
---@field Panel_Skill MoonClient.MLuaUICom
---@field Panel_OutLetterPos MoonClient.MLuaUICom
---@field Panel_NaturalLetter MoonClient.MLuaUICom
---@field Panel_Natural MoonClient.MLuaUICom
---@field Panel_LevelUp MoonClient.MLuaUICom
---@field Panel_LevelInfo MoonClient.MLuaUICom
---@field Panel_LetterPaper MoonClient.MLuaUICom
---@field Panel_InLetterPos MoonClient.MLuaUICom
---@field Panel_Empty MoonClient.MLuaUICom
---@field Panel_CostProp MoonClient.MLuaUICom
---@field Obj_UnlockCondition2 MoonClient.MLuaUICom
---@field Obj_UnlockCondition1 MoonClient.MLuaUICom
---@field Obj_UnlockCondition MoonClient.MLuaUICom
---@field Obj_SkillProductTip MoonClient.MLuaUICom
---@field Obj_LetterSourcePos MoonClient.MLuaUICom
---@field Obj_LetterPoppedUpPos MoonClient.MLuaUICom
---@field Obj_LetterOutPos MoonClient.MLuaUICom
---@field Obj_ChengGongLv MoonClient.MLuaUICom
---@field Img_SucChanceArrow MoonClient.MLuaUICom
---@field Img_SlideFill MoonClient.MLuaUICom
---@field Img_SkillProductIcon MoonClient.MLuaUICom
---@field Img_SkillGo MoonClient.MLuaUICom
---@field Img_NaturalGo MoonClient.MLuaUICom
---@field Img_LevelUpLevelLimit MoonClient.MLuaUICom
---@field Img_CostProp2 MoonClient.MLuaUICom
---@field Img_CostProp1 MoonClient.MLuaUICom
---@field Img_BigSucRewardArrow MoonClient.MLuaUICom
---@field Img_BigSucChanceArrow MoonClient.MLuaUICom
---@field Btn_Unlock MoonClient.MLuaUICom
---@field Btn_TipBg MoonClient.MLuaUICom
---@field Btn_LevelUp MoonClient.MLuaUICom
---@field Btn_Help MoonClient.MLuaUICom
---@field Btn_Go MoonClient.MLuaUICom
---@field Btn_Empty MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Template_LifeDirectory MoonClient.MLuaUIGroup
---@field Template_SkillProduct MoonClient.MLuaUIGroup
---@field Template_GatherPropInfo MoonClient.MLuaUIGroup
---@field Template_CostProp MoonClient.MLuaUIGroup

---@return LifeProfessionMainPanel
---@param ctrl UIBase
function LifeProfessionMainPanel.Bind(ctrl)
	
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
return UI.LifeProfessionMainPanel