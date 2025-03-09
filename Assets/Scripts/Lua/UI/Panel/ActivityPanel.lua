--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ActivityPanel = {}

--lua model end

--lua functions
---@class ActivityPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextPvpDesc MoonClient.MLuaUICom
---@field specialRewardWrapContent MoonClient.MLuaUICom
---@field RankBtn MoonClient.MLuaUICom
---@field PvpPanel MoonClient.MLuaUICom
---@field pvpJoinBtn MoonClient.MLuaUICom
---@field pvpInfoBtn MoonClient.MLuaUICom
---@field pvpCreatBtn MoonClient.MLuaUICom
---@field pvpClose MoonClient.MLuaUICom
---@field Number2 MoonClient.MLuaUICom
---@field Number1 MoonClient.MLuaUICom
---@field normalRewardWrapContent MoonClient.MLuaUICom
---@field NameLab MoonClient.MLuaUICom
---@field mvpPanel MoonClient.MLuaUICom
---@field mvpClose MoonClient.MLuaUICom
---@field mvpBg MoonClient.MLuaUICom
---@field monsterNameLab MoonClient.MLuaUICom
---@field monsterDesLab MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field Img_Prompt2 MoonClient.MLuaUICom
---@field Img_Prompt1 MoonClient.MLuaUICom
---@field headIcon MoonClient.MLuaUICom
---@field GoBtn MoonClient.MLuaUICom
---@field bossWrapContent MoonClient.MLuaUICom
---@field bossItem MoonClient.MLuaUICom

---@return ActivityPanel
---@param ctrl UIBaseCtrl
function ActivityPanel.Bind(ctrl)
	
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
return UI.ActivityPanel