--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PropIconPanel = {}

--lua model end

--lua functions
---@class PropIconPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextBtnUseMore MoonClient.MLuaUICom
---@field TextBtnUse MoonClient.MLuaUICom
---@field SystemOpen MoonClient.MLuaUICom
---@field SystemIcon MoonClient.MLuaUICom
---@field ItemParentMore MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field ItemOnePanel MoonClient.MLuaUICom
---@field ItemNameMore MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemMorePanel MoonClient.MLuaUICom
---@field CountInput MoonClient.MLuaUICom
---@field BtnUseMore MoonClient.MLuaUICom
---@field BtnUse MoonClient.MLuaUICom
---@field BtnCloseMore MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return PropIconPanel
---@param ctrl UIBase
function PropIconPanel.Bind(ctrl)
	
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
return UI.PropIconPanel