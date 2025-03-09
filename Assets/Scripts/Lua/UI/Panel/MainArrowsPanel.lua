--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainArrowsPanel = {}

--lua model end

--lua functions
---@class MainArrowsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom[]
---@field Shadow MoonClient.MLuaUICom[]
---@field MainDoubleShadow MoonClient.MLuaUICom
---@field MainClassShadow MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom[]
---@field DoubleSetup MoonClient.MLuaUICom
---@field DoubleSelect MoonClient.MLuaUICom[]
---@field DoubleOpen MoonClient.MLuaUICom
---@field DoubleNumSprite MoonClient.MLuaUICom
---@field DoubleDefault MoonClient.MLuaUICom
---@field DoubleArrows MoonClient.MLuaUICom
---@field doubleArrows MoonClient.MLuaUICom[]
---@field ClassicsSelect MoonClient.MLuaUICom[]
---@field ClassicsOpen MoonClient.MLuaUICom
---@field ClassicsNumSprite MoonClient.MLuaUICom
---@field ClassicSetup MoonClient.MLuaUICom
---@field ClassicsDefault MoonClient.MLuaUICom
---@field ClassicsArrows MoonClient.MLuaUICom
---@field classicsArrows MoonClient.MLuaUICom[]

---@return MainArrowsPanel
---@param ctrl UIBase
function MainArrowsPanel.Bind(ctrl)
	
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
return UI.MainArrowsPanel