--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DailyTaskPanel = {}

--lua model end

--lua functions
---@class DailyTaskPanel.ItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class DailyTaskPanel.ItemTemplate2
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class DailyTaskPanel.ItemTemplate3
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class DailyTaskPanel.ItemTemplate4
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class DailyTaskPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleEx_Limitedtime MoonClient.MLuaUICom
---@field ToggleEx_Adventure MoonClient.MLuaUICom
---@field timesLab MoonClient.MLuaUICom
---@field TimeLimit MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field SellOnBtn MoonClient.MLuaUICom
---@field SellOffBtn MoonClient.MLuaUICom
---@field Scroll_MapIcon MoonClient.MLuaUICom
---@field RewardItem MoonClient.MLuaUICom
---@field rewardItem MoonClient.MLuaUICom
---@field RewardIcon4 MoonClient.MLuaUICom
---@field RewardIcon3 MoonClient.MLuaUICom
---@field RewardIcon2 MoonClient.MLuaUICom
---@field RewardIcon1 MoonClient.MLuaUICom
---@field rewardGrid MoonClient.MLuaUICom
---@field RaycastImg_ShieldScroll MoonClient.MLuaUICom
---@field pvpClose MoonClient.MLuaUICom
---@field Pos MoonClient.MLuaUICom
---@field Panel_DailyList MoonClient.MLuaUICom
---@field Obj_itemParent MoonClient.MLuaUICom
---@field Obj_Content MoonClient.MLuaUICom
---@field numLab MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Loop_ActivityList MoonClient.MLuaUICom
---@field ItemPanel MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field InfoTittle MoonClient.MLuaUICom
---@field InfoTime MoonClient.MLuaUICom
---@field InfoTeamBtn MoonClient.MLuaUICom
---@field InfoPanel MoonClient.MLuaUICom
---@field InfoNum MoonClient.MLuaUICom
---@field InfoMod MoonClient.MLuaUICom
---@field InfoLv MoonClient.MLuaUICom
---@field infoGoBtn MoonClient.MLuaUICom
---@field InfoFinish MoonClient.MLuaUICom
---@field InfoContext MoonClient.MLuaUICom
---@field InfoBG MoonClient.MLuaUICom
---@field Img_Mask MoonClient.MLuaUICom
---@field Img_Listbg MoonClient.MLuaUICom
---@field Img_DailyTaskBg MoonClient.MLuaUICom
---@field Image22 MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field icon MoonClient.MLuaUICom
---@field GetFashionInviteTxt MoonClient.MLuaUICom
---@field GetFashionInvite MoonClient.MLuaUICom
---@field ExtendText MoonClient.MLuaUICom
---@field EmblemPanel MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field DrawLab MoonClient.MLuaUICom
---@field DesLab MoonClient.MLuaUICom
---@field ContentParent MoonClient.MLuaUICom
---@field ComeBackBtn MoonClient.MLuaUICom
---@field BuyOnBtn MoonClient.MLuaUICom
---@field BuyOffBtn MoonClient.MLuaUICom
---@field But_Introduce MoonClient.MLuaUICom
---@field Btn_On MoonClient.MLuaUICom
---@field Btn_Off MoonClient.MLuaUICom
---@field Btn_AwardPreviewON MoonClient.MLuaUICom
---@field Btn_AwardPreviewOFF MoonClient.MLuaUICom
---@field BoliRewardBG MoonClient.MLuaUICom
---@field BoliReward MoonClient.MLuaUICom
---@field BoliInfoBG MoonClient.MLuaUICom
---@field BoliInfo MoonClient.MLuaUICom
---@field BgImg MoonClient.MLuaUICom
---@field BadgeIconEffect MoonClient.MLuaUICom
---@field BadgeIcon MoonClient.MLuaUICom
---@field Background1 MoonClient.MLuaUICom
---@field ActiveItem MoonClient.MLuaUICom
---@field _TxtTowerInfolevel MoonClient.MLuaUICom
---@field DailyMapIconTemplate MoonClient.MLuaUIGroup
---@field ItemTemplate DailyTaskPanel.ItemTemplate
---@field ItemTemplate2 DailyTaskPanel.ItemTemplate2
---@field ItemTemplate3 DailyTaskPanel.ItemTemplate3
---@field ItemTemplate4 DailyTaskPanel.ItemTemplate4
---@field DailyActvityTemplate MoonClient.MLuaUIGroup
---@field Template_PreShow MoonClient.MLuaUIGroup

---@return DailyTaskPanel
---@param ctrl UIBaseCtrl
function DailyTaskPanel.Bind(ctrl)
	
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
return UI.DailyTaskPanel