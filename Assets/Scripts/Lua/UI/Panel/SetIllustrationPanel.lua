--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SetIllustrationPanel = {}

--lua model end

--lua functions
---@class SetIllustrationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextName MoonClient.MLuaUICom
---@field SuitName MoonClient.MLuaUICom
---@field SuitInfo MoonClient.MLuaUICom
---@field SuitDetail MoonClient.MLuaUICom
---@field SuitContent MoonClient.MLuaUICom
---@field SelectTypeButtonName MoonClient.MLuaUICom
---@field QuestionText MoonClient.MLuaUICom
---@field NoneEquipText MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field ButtonFilter MoonClient.MLuaUICom
---@field AttrContent MoonClient.MLuaUICom
---@field SelectEquipSuitTemplate MoonClient.MLuaUIGroup
---@field SuitEquipementTemplate MoonClient.MLuaUIGroup
---@field SuitEquipmentAttrTemplate MoonClient.MLuaUIGroup

---@return SetIllustrationPanel
function SetIllustrationPanel.Bind(ctrl)

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
return UI.SetIllustrationPanel