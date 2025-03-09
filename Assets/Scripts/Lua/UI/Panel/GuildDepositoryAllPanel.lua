--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildDepositoryAllPanel = {}

--lua model end

--lua functions
---@class GuildDepositoryAllPanel.GuildDepositoryItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemBox MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IsAttented MoonClient.MLuaUICom
---@field EmptyCell MoonClient.MLuaUICom

---@class GuildDepositoryAllPanel.GuildDepositorySelectPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IsLock MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom

---@class GuildDepositoryAllPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextCurDepository MoonClient.MLuaUICom
---@field StockNum MoonClient.MLuaUICom
---@field ItemListContent MoonClient.MLuaUICom
---@field ExplainText MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field ExplainBubble MoonClient.MLuaUICom
---@field EndTime MoonClient.MLuaUICom
---@field EndCount MoonClient.MLuaUICom
---@field DepositorySelectPanel MoonClient.MLuaUICom
---@field DepositoryListContent MoonClient.MLuaUICom
---@field CountContent MoonClient.MLuaUICom
---@field BtnTips MoonClient.MLuaUICom
---@field BtnStock MoonClient.MLuaUICom
---@field BtnDelete MoonClient.MLuaUICom
---@field BtnCurDepository MoonClient.MLuaUICom
---@field BtnCloseExplain MoonClient.MLuaUICom
---@field BtnCancel MoonClient.MLuaUICom
---@field BtnAttent MoonClient.MLuaUICom
---@field BeginTime MoonClient.MLuaUICom
---@field BeginCount MoonClient.MLuaUICom
---@field GuildDepositoryItemPrefab GuildDepositoryAllPanel.GuildDepositoryItemPrefab
---@field GuildDepositorySelectPrefab GuildDepositoryAllPanel.GuildDepositorySelectPrefab

---@return GuildDepositoryAllPanel
function GuildDepositoryAllPanel.Bind(ctrl)

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
return UI.GuildDepositoryAllPanel