--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AnnouncePanel = {}

--lua model end

--lua functions
---@class AnnouncePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleText MoonClient.MLuaUICom
---@field RichTextAnnounce MoonClient.MLuaUICom
---@field DownArrow MoonClient.MLuaUICom
---@field BtnOKAnnounce MoonClient.MLuaUICom
---@field AnnounceViewport MoonClient.MLuaUICom
---@field AnnounceScrollView MoonClient.MLuaUICom
---@field AnnounceContent MoonClient.MLuaUICom
---@field Announce MoonClient.MLuaUICom

---@return AnnouncePanel
---@param ctrl UIBaseCtrl
function AnnouncePanel.Bind(ctrl)
	
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
return UI.AnnouncePanel