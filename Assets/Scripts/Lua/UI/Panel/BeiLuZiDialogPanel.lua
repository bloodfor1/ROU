--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeiLuZiDialogPanel = {}

--lua model end

--lua functions
---@class BeiLuZiDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field SkillName MoonClient.MLuaUICom[]
---@field ItemRoot MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BeiluzName MoonClient.MLuaUICom
---@field AttrChangeTxt2 MoonClient.MLuaUICom
---@field AttrChangeTxt1 MoonClient.MLuaUICom
---@field AttrChange MoonClient.MLuaUICom

---@return BeiLuZiDialogPanel
---@param ctrl UIBase
function BeiLuZiDialogPanel.Bind(ctrl)
	
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
return UI.BeiLuZiDialogPanel