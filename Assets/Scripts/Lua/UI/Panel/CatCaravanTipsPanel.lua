--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CatCaravanTipsPanel = {}

--lua model end

--lua functions
---@class CatCaravanTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SetBtn MoonClient.MLuaUICom
---@field NeedNum MoonClient.MLuaUICom
---@field NeedIcon MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom
---@field AwardNum MoonClient.MLuaUICom
---@field AwardImage MoonClient.MLuaUICom

---@return CatCaravanTipsPanel
---@param ctrl UIBaseCtrl
function CatCaravanTipsPanel.Bind(ctrl)
	
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
return UI.CatCaravanTipsPanel