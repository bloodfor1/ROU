--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MallFeedingPanel = {}

--lua model end

--lua functions
---@class MallFeedingPanel.MallFeedingPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field SellOut MoonClient.MLuaUICom
---@field Recommend MoonClient.MLuaUICom
---@field PriceNum MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field AddtionNode MoonClient.MLuaUICom
---@field Addtion MoonClient.MLuaUICom

---@class MallFeedingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalRechargeAwardBtn MoonClient.MLuaUICom
---@field TextTime MoonClient.MLuaUICom
---@field LimitBtn MoonClient.MLuaUICom
---@field ItemGroup MoonClient.MLuaUICom
---@field HelpBtn MoonClient.MLuaUICom
---@field MallFeedingPrefab MallFeedingPanel.MallFeedingPrefab

---@return MallFeedingPanel
---@param ctrl UIBase
function MallFeedingPanel.Bind(ctrl)
	
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
return UI.MallFeedingPanel