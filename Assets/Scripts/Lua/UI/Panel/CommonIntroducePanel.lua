--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CommonIntroducePanel = {}

--lua model end

--lua functions
---@class CommonIntroducePanel.BigPicItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Pic MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom

---@class CommonIntroducePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field NormalScroll MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field BigPicScroll MoonClient.MLuaUICom
---@field BigPicContent MoonClient.MLuaUICom
---@field BigPicItemTemplate CommonIntroducePanel.BigPicItemTemplate

---@return CommonIntroducePanel
---@param ctrl UIBaseCtrl
function CommonIntroducePanel.Bind(ctrl)
	
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
return UI.CommonIntroducePanel