--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PartyLotteryPanel = {}

--lua model end

--lua functions
---@class PartyLotteryPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RawImg_Finish MoonClient.MLuaUICom[]
---@field OneLottery MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom[]
---@field Handle MoonClient.MLuaUICom
---@field Eff_RawImage MoonClient.MLuaUICom[]

---@return PartyLotteryPanel
function PartyLotteryPanel.Bind(ctrl)

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
return UI.PartyLotteryPanel