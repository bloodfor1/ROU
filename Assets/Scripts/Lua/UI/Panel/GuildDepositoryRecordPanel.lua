--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildDepositoryRecordPanel = {}

--lua model end

--lua functions
---@class GuildDepositoryRecordPanel.GuildSaleRecordItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextTime MoonClient.MLuaUICom
---@field TextContent MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom

---@class GuildDepositoryRecordPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelfRecordScrollView MoonClient.MLuaUICom
---@field SelfEmptyIcon MoonClient.MLuaUICom
---@field PublicRecordScrollView MoonClient.MLuaUICom
---@field PublicEmptyIcon MoonClient.MLuaUICom
---@field GuildSaleRecordItemPrefab GuildDepositoryRecordPanel.GuildSaleRecordItemPrefab

---@return GuildDepositoryRecordPanel
function GuildDepositoryRecordPanel.Bind(ctrl)

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
return UI.GuildDepositoryRecordPanel