--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RoleInfoPanel = {}

--lua model end

--lua functions
---@class RoleInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field VigourCollider MoonClient.MLuaUICom
---@field TxtSaverTip MoonClient.MLuaUICom
---@field TxtPlayerProfession MoonClient.MLuaUICom
---@field TxtPlayerName MoonClient.MLuaUICom
---@field TxtPlayerID MoonClient.MLuaUICom
---@field Txt_Vigour MoonClient.MLuaUICom
---@field Txt_Sp MoonClient.MLuaUICom
---@field Txt_Point MoonClient.MLuaUICom
---@field Txt_JobLv MoonClient.MLuaUICom
---@field Txt_Job MoonClient.MLuaUICom
---@field Txt_Hp MoonClient.MLuaUICom
---@field Txt_BaseLv MoonClient.MLuaUICom
---@field Txt_Base MoonClient.MLuaUICom
---@field Tittle_3 MoonClient.MLuaUICom
---@field Tittle_2 MoonClient.MLuaUICom
---@field Tittle_1 MoonClient.MLuaUICom
---@field titleName MoonClient.MLuaUICom
---@field Slider_Vigour MoonClient.MLuaUICom
---@field Slider_Sp MoonClient.MLuaUICom
---@field Slider_Job MoonClient.MLuaUICom
---@field Slider_Hp MoonClient.MLuaUICom
---@field Slider_Base MoonClient.MLuaUICom
---@field ShareButton MoonClient.MLuaUICom
---@field ServerLevelParent MoonClient.MLuaUICom
---@field ScrollContent MoonClient.MLuaUICom
---@field RoleInfoSavePanel MoonClient.MLuaUICom
---@field RoleInfoDetail MoonClient.MLuaUICom
---@field RedPromptParent MoonClient.MLuaUICom
---@field Liubianxing MoonClient.MLuaUICom
---@field Img_PlayerHead MoonClient.MLuaUICom
---@field ImageUp MoonClient.MLuaUICom
---@field ImageDown MoonClient.MLuaUICom
---@field Image_1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field Explain MoonClient.MLuaUICom
---@field DlgPanel MoonClient.MLuaUICom
---@field Detail MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Common MoonClient.MLuaUICom
---@field ColliderExp MoonClient.MLuaUICom
---@field ButtonVigour MoonClient.MLuaUICom
---@field ButtonSp MoonClient.MLuaUICom
---@field ButtonCloseDilog MoonClient.MLuaUICom
---@field Button_Hp MoonClient.MLuaUICom
---@field BtnServerLv MoonClient.MLuaUICom
---@field BtnMiddle_B MoonClient.MLuaUICom
---@field BtnMiddle_A MoonClient.MLuaUICom
---@field BtnInfo MoonClient.MLuaUICom
---@field BtnCancelInfo MoonClient.MLuaUICom
---@field BtnApplyInfo MoonClient.MLuaUICom
---@field Btn_xidian MoonClient.MLuaUICom
---@field Btn_VigourTips MoonClient.MLuaUICom
---@field Btn_tuijian MoonClient.MLuaUICom
---@field Btn_SpTips MoonClient.MLuaUICom
---@field Btn_JobTips MoonClient.MLuaUICom
---@field Btn_JobLVTips MoonClient.MLuaUICom
---@field Btn_jian MoonClient.MLuaUICom
---@field Btn_jia MoonClient.MLuaUICom
---@field Btn_HpTips MoonClient.MLuaUICom
---@field Btn_CloseSeverLevel MoonClient.MLuaUICom
---@field Btn_ChangeName MoonClient.MLuaUICom
---@field btn_change_title MoonClient.MLuaUICom
---@field btn_change_icon MoonClient.MLuaUICom
---@field Btn_BaseTips MoonClient.MLuaUICom
---@field Btn_BaseLVTips MoonClient.MLuaUICom
---@field Btn_AutoAdd MoonClient.MLuaUICom
---@field Btn_AttrTips MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field AttrValue MoonClient.MLuaUICom[]
---@field AttrTpl MoonClient.MLuaUICom
---@field AttrScrollRect MoonClient.MLuaUICom
---@field AttrParent MoonClient.MLuaUICom
---@field AttrName MoonClient.MLuaUICom
---@field AttrInfoTpl_1 MoonClient.MLuaUICom
---@field AttrInfoTpl MoonClient.MLuaUICom
---@field AttrInfoBtn MoonClient.MLuaUICom[]
---@field AttrIcon MoonClient.MLuaUICom
---@field Arrow MoonClient.MLuaUICom[]
---@field AbilityGrp_3 MoonClient.MLuaUICom
---@field AbilityGrp_2 MoonClient.MLuaUICom
---@field AbilityGrp_1 MoonClient.MLuaUICom

---@return RoleInfoPanel
---@param ctrl UIBase
function RoleInfoPanel.Bind(ctrl)
	
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
return UI.RoleInfoPanel