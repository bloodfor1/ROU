--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ViewstickersPanel = {}

--lua model end

--lua functions
---@class ViewstickersPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleName MoonClient.MLuaUICom
---@field TextName MoonClient.MLuaUICom
---@field TeamText MoonClient.MLuaUICom
---@field TargetIcon MoonClient.MLuaUICom
---@field Sticker MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field Offset MoonClient.MLuaUICom
---@field LvText MoonClient.MLuaUICom
---@field LvClass MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field Guild MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@return ViewstickersPanel
function ViewstickersPanel.Bind(ctrl)
	
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
return UI.ViewstickersPanel