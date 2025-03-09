--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainPanel = {}

--lua model end

--lua functions
---@class MainPanel.MainButtonUpPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field SystemName MoonClient.MLuaUICom
---@field SystemIcon MoonClient.MLuaUICom
---@field SystemButton MoonClient.MLuaUICom
---@field RedPromptParent MoonClient.MLuaUICom
---@field NoticeText MoonClient.MLuaUICom
---@field NoticeImg MoonClient.MLuaUICom
---@field NoticeCloseBtn MoonClient.MLuaUICom
---@field NoticeBtn MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field ButtonNotice MoonClient.MLuaUICom

---@class MainPanel.MainButtonRightPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field SystemName MoonClient.MLuaUICom
---@field SystemIcon MoonClient.MLuaUICom
---@field SystemButton MoonClient.MLuaUICom
---@field RedPromptParent MoonClient.MLuaUICom
---@field NoticeText MoonClient.MLuaUICom
---@field NoticeImg MoonClient.MLuaUICom
---@field NoticeCloseBtn MoonClient.MLuaUICom
---@field NoticeBtn MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field ButtonNotice MoonClient.MLuaUICom

---@class MainPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTaskNaving MoonClient.MLuaUICom
---@field TxtFollow MoonClient.MLuaUICom
---@field Txt_BattleTimeValue MoonClient.MLuaUICom
---@field Txt_BattleDpsValue MoonClient.MLuaUICom
---@field Txt_BattleDamageValue MoonClient.MLuaUICom
---@field Txt_AutoBattle MoonClient.MLuaUICom
---@field Tween MoonClient.MLuaUICom
---@field SwitchPrompt MoonClient.MLuaUICom
---@field RightUpButtonB MoonClient.MLuaUICom
---@field RightUpButtonA MoonClient.MLuaUICom
---@field RightPanelB MoonClient.MLuaUICom
---@field RightPanel MoonClient.MLuaUICom
---@field RedSignParent MoonClient.MLuaUICom
---@field MainDlgText MoonClient.MLuaUICom
---@field MainDlg MoonClient.MLuaUICom
---@field ImgAutoBattleButtom MoonClient.MLuaUICom
---@field GM_DPS MoonClient.MLuaUICom
---@field FxOverWeight MoonClient.MLuaUICom
---@field FunctionOpenText MoonClient.MLuaUICom
---@field FunctionOpenPrompt MoonClient.MLuaUICom
---@field FunctionOpenImage MoonClient.MLuaUICom
---@field FunctionOpenEffectImage MoonClient.MLuaUICom
---@field BtnTowerRewardInfo MoonClient.MLuaUICom
---@field BtnSwitchUI MoonClient.MLuaUICom
---@field BtnShowAction2 MoonClient.MLuaUICom
---@field BtnInfo MoonClient.MLuaUICom
---@field BtnFunctionOpen MoonClient.MLuaUICom
---@field BtnExit MoonClient.MLuaUICom
---@field BtnAutoBattle MoonClient.MLuaUICom
---@field Btn_Removestuck MoonClient.MLuaUICom
---@field Btn_CloseDps MoonClient.MLuaUICom
---@field Btn_ClearDps MoonClient.MLuaUICom
---@field BagButton MoonClient.MLuaUICom
---@field MainButtonUpPrefab MainPanel.MainButtonUpPrefab
---@field MainButtonRightPrefab MainPanel.MainButtonRightPrefab

---@return MainPanel
---@param ctrl UIBase
function MainPanel.Bind(ctrl)
	
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
return UI.MainPanel