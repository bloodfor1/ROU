--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ActivityCheckInPanel = {}

--lua model end

--lua functions
---@class ActivityCheckInPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpRightUI MoonClient.MLuaUICom
---@field TimeTips MoonClient.MLuaUICom
---@field TimeNum MoonClient.MLuaUICom
---@field SpineShip MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field SelectedNumRoot MoonClient.MLuaUICom
---@field SelectedList MoonClient.MLuaUICom
---@field RollDiceRoot MoonClient.MLuaUICom
---@field RollDiceFX MoonClient.MLuaUICom
---@field RollDiceBtn MoonClient.MLuaUICom
---@field RewardRoot MoonClient.MLuaUICom
---@field Reward6 MoonClient.MLuaUICom
---@field Reward5 MoonClient.MLuaUICom
---@field Reward4 MoonClient.MLuaUICom
---@field Reward3 MoonClient.MLuaUICom
---@field Reward2 MoonClient.MLuaUICom
---@field Reward1 MoonClient.MLuaUICom
---@field Reward0 MoonClient.MLuaUICom
---@field ReusltBtnGroup MoonClient.MLuaUICom
---@field ResultTips MoonClient.MLuaUICom
---@field ResultRoot MoonClient.MLuaUICom
---@field ResultDiceFx MoonClient.MLuaUICom
---@field ResultBackFX MoonClient.MLuaUICom
---@field NotChooseRoot MoonClient.MLuaUICom
---@field MultiplePoint MoonClient.MLuaUICom
---@field HasChooseRoot MoonClient.MLuaUICom
---@field FxSetDiceFinish MoonClient.MLuaUICom
---@field FxControl MoonClient.MLuaUICom
---@field Eff_ShuiHUa MoonClient.MLuaUICom
---@field DiceBtn MoonClient.MLuaUICom
---@field Dice6 MoonClient.MLuaUICom
---@field Dice5 MoonClient.MLuaUICom
---@field Dice4 MoonClient.MLuaUICom
---@field Dice3 MoonClient.MLuaUICom
---@field Dice2 MoonClient.MLuaUICom
---@field Dice1 MoonClient.MLuaUICom
---@field CostNum MoonClient.MLuaUICom
---@field CostImage MoonClient.MLuaUICom
---@field CatTalk MoonClient.MLuaUICom
---@field CatAnim MoonClient.MLuaUICom
---@field Btn_Wenhao MoonClient.MLuaUICom
---@field Btn_Rethrow MoonClient.MLuaUICom
---@field Btn_Receive MoonClient.MLuaUICom
---@field Btn_OK MoonClient.MLuaUICom
---@field Btn_close MoonClient.MLuaUICom
---@field Btn_Change MoonClient.MLuaUICom
---@field BottomUI MoonClient.MLuaUICom
---@field AwardRedPoint MoonClient.MLuaUICom
---@field AllRoot MoonClient.MLuaUICom
---@field ActivityCheckInAwardItemTemplate MoonClient.MLuaUIGroup
---@field ActivityCheckInDiceItemTemplate MoonClient.MLuaUIGroup
---@field ActivityCheckInSelectedItem MoonClient.MLuaUIGroup

---@return ActivityCheckInPanel
---@param ctrl UIBase
function ActivityCheckInPanel.Bind(ctrl)
	
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
return UI.ActivityCheckInPanel