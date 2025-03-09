--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LandingAwardPanel = {}

--lua model end

--lua functions
---@class LandingAwardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkeletonGraphic MoonClient.MLuaUICom
---@field LandAwardSelectBtn MoonClient.MLuaUICom[]
---@field ItemName MoonClient.MLuaUICom[]
---@field ItemIcon MoonClient.MLuaUICom[]
---@field IsGet MoonClient.MLuaUICom[]
---@field EffectView MoonClient.MLuaUICom[]
---@field DiaText MoonClient.MLuaUICom
---@field CountNum MoonClient.MLuaUICom[]
---@field Container MoonClient.MLuaUICom
---@field BtnGetAward MoonClient.MLuaUICom[]
---@field BtnClose MoonClient.MLuaUICom

---@return LandingAwardPanel
function LandingAwardPanel.Bind(ctrl)

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
return UI.LandingAwardPanel