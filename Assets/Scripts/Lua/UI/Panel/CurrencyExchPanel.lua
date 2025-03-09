--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CurrencyExchPanel = {}

--lua model end

--lua functions
---@class CurrencyExchPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ZenyImage MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field TextRate MoonClient.MLuaUICom
---@field Text_Need MoonClient.MLuaUICom
---@field Text_Left MoonClient.MLuaUICom
---@field Text_03 MoonClient.MLuaUICom
---@field Text_02 MoonClient.MLuaUICom
---@field Text_01 MoonClient.MLuaUICom
---@field ShowImage MoonClient.MLuaUICom
---@field ROImage MoonClient.MLuaUICom
---@field QuickPanelUp MoonClient.MLuaUICom
---@field QuickPanelDown MoonClient.MLuaUICom
---@field PayTipRoot2 MoonClient.MLuaUICom
---@field PayTipRoot MoonClient.MLuaUICom
---@field PayTipContent2 MoonClient.MLuaUICom
---@field PayTipContent MoonClient.MLuaUICom
---@field PayTipBtnDetail2 MoonClient.MLuaUICom
---@field PayTipBtnDetail MoonClient.MLuaUICom
---@field Obj_RightExchange MoonClient.MLuaUICom
---@field Obj_QuickExchange MoonClient.MLuaUICom
---@field NormalPanelUp MoonClient.MLuaUICom
---@field NormalPanelDown MoonClient.MLuaUICom
---@field Image_Need MoonClient.MLuaUICom
---@field Image_Left MoonClient.MLuaUICom
---@field DiamondText MoonClient.MLuaUICom
---@field CoinTitle MoonClient.MLuaUICom
---@field CoinText MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field ChangeNumber MoonClient.MLuaUICom
---@field BtnChange MoonClient.MLuaUICom
---@field Btn_QuickExchange MoonClient.MLuaUICom
---@field AchieveScroll MoonClient.MLuaUICom
---@field AchieveTemplate MoonClient.MLuaUIGroup

---@return CurrencyExchPanel
---@param ctrl UIBase
function CurrencyExchPanel.Bind(ctrl)
	
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
return UI.CurrencyExchPanel