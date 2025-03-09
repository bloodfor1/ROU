--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TipsDlgPanel = {}

--lua model end

--lua functions
---@class TipsDlgPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsDummy MoonClient.MLuaUICom
---@field TaskTipsTpl MoonClient.MLuaUICom
---@field SecondaryNoticeText MoonClient.MLuaUICom
---@field SecondaryNotice MoonClient.MLuaUICom
---@field QuestionTipsTpl MoonClient.MLuaUICom
---@field QuestionText MoonClient.MLuaUICom
---@field QuestionCloseBtn MoonClient.MLuaUICom
---@field PromptText MoonClient.MLuaUICom
---@field NormalTrumpetText MoonClient.MLuaUICom
---@field NormalTrumpet MoonClient.MLuaUICom
---@field NormalTipsTpl MoonClient.MLuaUICom
---@field MiddleTipsTpl MoonClient.MLuaUICom
---@field ImportantNoticeText MoonClient.MLuaUICom
---@field ImportantNotice MoonClient.MLuaUICom
---@field HintRT MoonClient.MLuaUICom
---@field HintEffectParent2 MoonClient.MLuaUICom
---@field HintEffectParent1 MoonClient.MLuaUICom
---@field FxTips MoonClient.MLuaUICom
---@field DungeonPromptLab MoonClient.MLuaUICom
---@field DungeonPrompt MoonClient.MLuaUICom
---@field DropItemGO MoonClient.MLuaUICom
---@field DropItem MoonClient.MLuaUICom
---@field DangerRT MoonClient.MLuaUICom
---@field DangerHint MoonClient.MLuaUICom
---@field AttrTipsTpl MoonClient.MLuaUICom
---@field AttrTipsNewTpl MoonClient.MLuaUICom
---@field AttrListTxtInfo MoonClient.MLuaUICom
---@field AttrListTipsTpl MoonClient.MLuaUICom
---@field AttrListTargetPos MoonClient.MLuaUICom
---@field AttrListEndTween MoonClient.MLuaUICom
---@field attrAnim MoonClient.MLuaUICom
---@field PraisedTipTpl MoonClient.MLuaUIGroup

---@return TipsDlgPanel
---@param ctrl UIBase
function TipsDlgPanel.Bind(ctrl)
	
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
return UI.TipsDlgPanel