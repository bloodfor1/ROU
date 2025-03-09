--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildCrystalPrayPanel = {}

--lua model end

--lua functions
---@class GuildCrystalPrayPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ZenyPriceNum MoonClient.MLuaUICom
---@field ZenyHaveNum MoonClient.MLuaUICom
---@field TogCostType MoonClient.MLuaUICom
---@field PrayTypeText MoonClient.MLuaUICom
---@field ExplainText MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field ExplainBubble MoonClient.MLuaUICom
---@field CrystalIconBg MoonClient.MLuaUICom
---@field CrystalIcon MoonClient.MLuaUICom
---@field CrastalSelectTip MoonClient.MLuaUICom
---@field ContributionPriceNum MoonClient.MLuaUICom
---@field ContributionPrice MoonClient.MLuaUICom
---@field ContributionHaveNum MoonClient.MLuaUICom
---@field ChargeBuffText MoonClient.MLuaUICom
---@field BuffValueEx MoonClient.MLuaUICom[]
---@field BuffValue MoonClient.MLuaUICom[]
---@field BuffPropertyBox MoonClient.MLuaUICom[]
---@field BuffName MoonClient.MLuaUICom[]
---@field BuffLastTime MoonClient.MLuaUICom
---@field BtnRemoveAssign MoonClient.MLuaUICom
---@field BtnPrayText MoonClient.MLuaUICom
---@field BtnPrayHelp MoonClient.MLuaUICom
---@field BtnPray MoonClient.MLuaUICom
---@field BtnCraystalChargeText MoonClient.MLuaUICom
---@field BtnCraystalChargeHelp MoonClient.MLuaUICom
---@field BtnCraystalCharge MoonClient.MLuaUICom
---@field BtnCloseExplain MoonClient.MLuaUICom
---@field AssignFlag MoonClient.MLuaUICom

---@return GuildCrystalPrayPanel
function GuildCrystalPrayPanel.Bind(ctrl)

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
return UI.GuildCrystalPrayPanel