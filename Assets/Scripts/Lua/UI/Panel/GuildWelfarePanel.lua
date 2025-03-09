--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildWelfarePanel = {}

--lua model end

--lua functions
---@class GuildWelfarePanel.GuildWelfareCellPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field WelfareItemTitle MoonClient.MLuaUICom
---@field WelfareItemImage MoonClient.MLuaUICom
---@field WelfareItemDesc MoonClient.MLuaUICom
---@field WelfareItemButtonText MoonClient.MLuaUICom
---@field WelfareItemButton MoonClient.MLuaUICom
---@field WelfareItem_None MoonClient.MLuaUICom
---@field WelfareItem MoonClient.MLuaUICom
---@field BtnTip MoonClient.MLuaUICom

---@class GuildWelfarePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollWelfareContent MoonClient.MLuaUICom
---@field ScrollWelfare MoonClient.MLuaUICom
---@field DescribeTitle MoonClient.MLuaUICom
---@field DescribeText MoonClient.MLuaUICom
---@field DescribePart MoonClient.MLuaUICom
---@field GuildWelfareCellPrefab GuildWelfarePanel.GuildWelfareCellPrefab

---@return GuildWelfarePanel
function GuildWelfarePanel.Bind(ctrl)

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
return UI.GuildWelfarePanel