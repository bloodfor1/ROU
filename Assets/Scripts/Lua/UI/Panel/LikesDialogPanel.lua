--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LikesDialogPanel = {}

--lua model end

--lua functions
---@class LikesDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtYesCenter MoonClient.MLuaUICom
---@field TxtPlaceholder MoonClient.MLuaUICom
---@field Txt_Likes MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field Obj_Input MoonClient.MLuaUICom
---@field CloseBth MoonClient.MLuaUICom
---@field Btn_Send MoonClient.MLuaUICom

---@return LikesDialogPanel
---@param ctrl UIBase
function LikesDialogPanel.Bind(ctrl)
	
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
return UI.LikesDialogPanel