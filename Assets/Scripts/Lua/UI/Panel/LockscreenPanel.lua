--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LockscreenPanel = {}

--lua model end

--lua functions
---@class LockscreenPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Time MoonClient.MLuaUICom
---@field Txt_Powersaving MoonClient.MLuaUICom
---@field Img_Mask MoonClient.MLuaUICom
---@field Img_Lock MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@return LockscreenPanel
---@param ctrl UIBase
function LockscreenPanel.Bind(ctrl)
	
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
return UI.LockscreenPanel