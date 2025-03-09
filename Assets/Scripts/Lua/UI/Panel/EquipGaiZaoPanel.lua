--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EquipGaiZaoPanel = {}

--lua model end

--lua functions
---@class EquipGaiZaoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Title MoonClient.MLuaUICom
---@field Topicon MoonClient.MLuaUICom
---@field Text_EquipName MoonClient.MLuaUICom
---@field SelectEquipDummy MoonClient.MLuaUICom
---@field RightUpPanel MoonClient.MLuaUICom
---@field RightPanel MoonClient.MLuaUICom
---@field MiddlePanel MoonClient.MLuaUICom
---@field Loop_Attrs MoonClient.MLuaUICom
---@field ItemTemplateDummy MoonClient.MLuaUICom
---@field EmptyWidget MoonClient.MLuaUICom
---@field Dummy_ItemConsume MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_GaiZao MoonClient.MLuaUICom
---@field Bth_JiPin MoonClient.MLuaUICom
---@field Bth_DuiBi MoonClient.MLuaUICom

---@return EquipGaiZaoPanel
---@param ctrl UIBase
function EquipGaiZaoPanel.Bind(ctrl)
	
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
return UI.EquipGaiZaoPanel