--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ReplicaCardPanel = {}

--lua model end

--lua functions
---@class ReplicaCardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_RemainNum MoonClient.MLuaUICom
---@field Txt_Name MoonClient.MLuaUICom
---@field TogEx_Start MoonClient.MLuaUICom
---@field Obj_ExplainPosMark MoonClient.MLuaUICom
---@field Btn_explain MoonClient.MLuaUICom
---@field Btn_Compound MoonClient.MLuaUICom
---@field Btn_ChangeCardState MoonClient.MLuaUICom
---@field Btn_Bg MoonClient.MLuaUICom

---@return ReplicaCardPanel
---@param ctrl UIBase
function ReplicaCardPanel.Bind(ctrl)
	
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
return UI.ReplicaCardPanel