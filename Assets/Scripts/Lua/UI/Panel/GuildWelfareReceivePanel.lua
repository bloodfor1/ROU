--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildWelfareReceivePanel = {}

--lua model end

--lua functions
---@class GuildWelfareReceivePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ReceiveTitle MoonClient.MLuaUICom
---@field ReceiveText MoonClient.MLuaUICom
---@field BtnNone MoonClient.MLuaUICom
---@field BtnConfirm MoonClient.MLuaUICom
---@field BgButton MoonClient.MLuaUICom

---@return GuildWelfareReceivePanel
function GuildWelfareReceivePanel.Bind(ctrl)

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
return UI.GuildWelfareReceivePanel