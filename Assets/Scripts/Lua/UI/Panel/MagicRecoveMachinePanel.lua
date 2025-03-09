--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MagicRecoveMachinePanel = {}

--lua model end

--lua functions
---@class MagicRecoveMachinePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtZeny MoonClient.MLuaUICom
---@field TxtTitle MoonClient.MLuaUICom
---@field TxtSelect MoonClient.MLuaUICom
---@field TxtRightTitle MoonClient.MLuaUICom
---@field TxtNoSelectTips MoonClient.MLuaUICom
---@field TxtNoItem MoonClient.MLuaUICom
---@field TxtHelpMessage MoonClient.MLuaUICom
---@field TxtHelp MoonClient.MLuaUICom
---@field TxtArrow MoonClient.MLuaUICom
---@field ScrollViewItem MoonClient.MLuaUICom
---@field PanelSpend MoonClient.MLuaUICom
---@field PanelSelect MoonClient.MLuaUICom
---@field PanelRight MoonClient.MLuaUICom
---@field PanelNoItem MoonClient.MLuaUICom
---@field PanelLeft MoonClient.MLuaUICom
---@field PanelHelp MoonClient.MLuaUICom
---@field PanelHeadAndEquip MoonClient.MLuaUICom
---@field PanelGet MoonClient.MLuaUICom
---@field PanelCard MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field ItemHeadAndEquip MoonClient.MLuaUICom
---@field ItemCard MoonClient.MLuaUICom
---@field Imgtips MoonClient.MLuaUICom
---@field ImgSpendIcon MoonClient.MLuaUICom
---@field ImgIcon MoonClient.MLuaUICom
---@field ImgGet MoonClient.MLuaUICom
---@field ImgCard MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom
---@field BtnRecove MoonClient.MLuaUICom
---@field BtnHelp MoonClient.MLuaUICom
---@field BtnCloseHelp MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnBox MoonClient.MLuaUICom
---@field BtnArrow MoonClient.MLuaUICom
---@field BgCard MoonClient.MLuaUICom
---@field ItemShowPrefab MoonClient.MLuaUIGroup

---@return MagicRecoveMachinePanel
function MagicRecoveMachinePanel.Bind(ctrl)

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
return UI.MagicRecoveMachinePanel