--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FishMainPanel = {}

--lua model end

--lua functions
---@class FishMainPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipProcess MoonClient.MLuaUICom
---@field PullRodTip MoonClient.MLuaUICom
---@field OperatePanel MoonClient.MLuaUICom
---@field ExplainTextMessage MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field CloseExplainPanelButton MoonClient.MLuaUICom
---@field BtnProp MoonClient.MLuaUICom
---@field BtnExit MoonClient.MLuaUICom
---@field BtnAutoStart MoonClient.MLuaUICom
---@field BtnAutoSetting MoonClient.MLuaUICom
---@field BtnAutoEnd MoonClient.MLuaUICom
---@field BaitNumText MoonClient.MLuaUICom
---@field BaitNumBg MoonClient.MLuaUICom
---@field AutoFishingTip MoonClient.MLuaUICom

---@return FishMainPanel
function FishMainPanel.Bind(ctrl)

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
return UI.FishMainPanel