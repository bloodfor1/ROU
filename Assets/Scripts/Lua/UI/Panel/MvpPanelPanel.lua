--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MvpPanelPanel = {}

--lua model end

--lua functions
---@class MvpPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field specialRewardWrapContent MoonClient.MLuaUICom
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
---@field Icon_Head MoonClient.MLuaUICom
---@field GoBtn MoonClient.MLuaUICom
---@field Btn_GoDebug MoonClient.MLuaUICom
---@field bossWrapContent MoonClient.MLuaUICom
---@field bossItem MoonClient.MLuaUICom

---@return MvpPanelPanel
function MvpPanelPanel.Bind(ctrl)

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
return UI.MvpPanelPanel