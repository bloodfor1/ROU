--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ReBackMallGoldPanel = {}

--lua model end

--lua functions
---@class ReBackMallGoldPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ReturnShopTags MoonClient.MLuaUICom
---@field ResetTime MoonClient.MLuaUICom
---@field PointTag MoonClient.MLuaUICom
---@field PayTag MoonClient.MLuaUICom
---@field LeftTimeRoot MoonClient.MLuaUICom
---@field LeftTime MoonClient.MLuaUICom
---@field ItemGroup MoonClient.MLuaUICom
---@field ButtonMail MoonClient.MLuaUICom

---@return ReBackMallGoldPanel
---@param ctrl UIBase
function ReBackMallGoldPanel.Bind(ctrl)
	
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
return UI.ReBackMallGoldPanel