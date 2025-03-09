--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TotalRechargeAwardPanel = {}

--lua model end

--lua functions
---@class TotalRechargeAwardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tip MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field RightRoot MoonClient.MLuaUICom
---@field ProgressScroll MoonClient.MLuaUICom
---@field MyProgressNum MoonClient.MLuaUICom
---@field MyProgress MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field LeftRoot MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field Image_Got MoonClient.MLuaUICom
---@field Help MoonClient.MLuaUICom
---@field Btn_GotoMall MoonClient.MLuaUICom
---@field Btn_GetAward MoonClient.MLuaUICom
---@field Btn_Back MoonClient.MLuaUICom
---@field AwardListScroll MoonClient.MLuaUICom
---@field TotalRechargeMiaoItem MoonClient.MLuaUIGroup

---@return TotalRechargeAwardPanel
---@param ctrl UIBase
function TotalRechargeAwardPanel.Bind(ctrl)
	
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
return UI.TotalRechargeAwardPanel