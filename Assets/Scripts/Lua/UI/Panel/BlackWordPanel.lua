--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BlackWordPanel = {}

--lua model end

--lua functions
---@class BlackWordPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtContent MoonClient.MLuaUICom
---@field ImgBg MoonClient.MLuaUICom

---@return BlackWordPanel
---@param ctrl UIBaseCtrl
function BlackWordPanel.Bind(ctrl)
	
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
return UI.BlackWordPanel