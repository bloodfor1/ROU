--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AnnouncementPanel = {}

--lua model end

--lua functions
---@class AnnouncementPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field titleImg MoonClient.MLuaUICom
---@field node MoonClient.MLuaUICom[]
---@field choose MoonClient.MLuaUICom[]
---@field BtnText MoonClient.MLuaUICom
---@field BtnRight MoonClient.MLuaUICom
---@field BtnLeft MoonClient.MLuaUICom
---@field BtnGo MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return AnnouncementPanel
---@param ctrl UIBase
function AnnouncementPanel.Bind(ctrl)
	
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
return UI.AnnouncementPanel