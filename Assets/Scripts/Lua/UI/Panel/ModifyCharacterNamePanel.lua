--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ModifyCharacterNamePanel = {}

--lua model end

--lua functions
---@class ModifyCharacterNamePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextGirl MoonClient.MLuaUICom
---@field TextBoy MoonClient.MLuaUICom
---@field InputFieldName MoonClient.MLuaUICom
---@field HeadIcon MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field Girl MoonClient.MLuaUICom
---@field BtnSubmit MoonClient.MLuaUICom
---@field BtnRandomName MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field Boy MoonClient.MLuaUICom

---@return ModifyCharacterNamePanel
---@param ctrl UIBase
function ModifyCharacterNamePanel.Bind(ctrl)
	
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
return UI.ModifyCharacterNamePanel