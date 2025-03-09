--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PartyLuckStarPanel = {}

--lua model end

--lua functions
---@class PartyLuckStarPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Rank MoonClient.MLuaUICom
---@field PrizeTitle MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field NoIcon MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field Mark MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return PartyLuckStarPanel
---@param ctrl UIBase
function PartyLuckStarPanel.Bind(ctrl)
	
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
return UI.PartyLuckStarPanel