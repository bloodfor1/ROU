--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CookingDoubleFinshPanel = {}

--lua model end

--lua functions
---@class CookingDoubleFinshPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtFinished MoonClient.MLuaUICom
---@field TxtFailed MoonClient.MLuaUICom
---@field Txt_finishScore MoonClient.MLuaUICom
---@field ImgTitle MoonClient.MLuaUICom
---@field BtnConfirm MoonClient.MLuaUICom

---@return CookingDoubleFinshPanel
---@param ctrl UIBaseCtrl
function CookingDoubleFinshPanel.Bind(ctrl)
	
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
return UI.CookingDoubleFinshPanel