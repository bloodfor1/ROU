--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CarryShopPanel = {}

--lua model end

--lua functions
---@class CarryShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field TargetCount MoonClient.MLuaUICom
---@field ScrollRect MoonClient.MLuaUICom
---@field NeedList MoonClient.MLuaUICom
---@field LoopScroll MoonClient.MLuaUICom
---@field LcokTips MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field InputCount MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field BtnPlus MoonClient.MLuaUICom
---@field BtnMinus MoonClient.MLuaUICom
---@field Btn_synthesis MoonClient.MLuaUICom
---@field CarryShopTem MoonClient.MLuaUIGroup

---@return CarryShopPanel
---@param ctrl UIBase
function CarryShopPanel.Bind(ctrl)
	
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
return UI.CarryShopPanel