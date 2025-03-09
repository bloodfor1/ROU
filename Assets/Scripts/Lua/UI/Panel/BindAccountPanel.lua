--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BindAccountPanel = {}

--lua model end

--lua functions
---@class BindAccountPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Panel_SDKLogin MoonClient.MLuaUICom
---@field GoogleText MoonClient.MLuaUICom
---@field FacebookText MoonClient.MLuaUICom
---@field Button_Google MoonClient.MLuaUICom
---@field Button_Facebook MoonClient.MLuaUICom
---@field Button_Apple MoonClient.MLuaUICom
---@field Btn_Exit MoonClient.MLuaUICom
---@field Btn_Delete MoonClient.MLuaUICom
---@field AppleText MoonClient.MLuaUICom

---@return BindAccountPanel
---@param ctrl UIBase
function BindAccountPanel.Bind(ctrl)
	
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
return UI.BindAccountPanel