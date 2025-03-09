--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FunctionOpenPanel = {}

--lua model end

--lua functions
---@class FunctionOpenPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TweenScale MoonClient.MLuaUICom
---@field TweenMove MoonClient.MLuaUICom
---@field SkipButton MoonClient.MLuaUICom
---@field ImageAnimation MoonClient.MLuaUICom
---@field FxImage MoonClient.MLuaUICom
---@field FunctionName MoonClient.MLuaUICom
---@field FunctionIcon MoonClient.MLuaUICom
---@field BgAnimation MoonClient.MLuaUICom
---@field BGAlphaGroup MoonClient.MLuaUICom

---@return FunctionOpenPanel
---@param ctrl UIBase
function FunctionOpenPanel.Bind(ctrl)
	
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
return UI.FunctionOpenPanel