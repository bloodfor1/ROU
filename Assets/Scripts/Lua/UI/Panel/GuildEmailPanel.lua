--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildEmailPanel = {}

--lua model end

--lua functions
---@class GuildEmailPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WordsRemain MoonClient.MLuaUICom
---@field WordsInput MoonClient.MLuaUICom
---@field CostTipText MoonClient.MLuaUICom
---@field BtnSend MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return GuildEmailPanel
function GuildEmailPanel.Bind(ctrl)

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
return UI.GuildEmailPanel