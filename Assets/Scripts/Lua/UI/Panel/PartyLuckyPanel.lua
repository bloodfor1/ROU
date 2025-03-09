--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PartyLuckyPanel = {}

--lua model end

--lua functions
---@class PartyLuckyPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleText MoonClient.MLuaUICom
---@field RawImg_Finish MoonClient.MLuaUICom
---@field PatyLotteryParent MoonClient.MLuaUICom
---@field ObjectGroup MoonClient.MLuaUICom
---@field Handle MoonClient.MLuaUICom
---@field Eff_RawImage MoonClient.MLuaUICom[]

---@return PartyLuckyPanel
---@param ctrl UIBase
function PartyLuckyPanel.Bind(ctrl)
	
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
return UI.PartyLuckyPanel