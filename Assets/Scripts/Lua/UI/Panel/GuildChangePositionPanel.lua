--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildChangePositionPanel = {}

--lua model end

--lua functions
---@class GuildChangePositionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field txtPostion8 MoonClient.MLuaUICom
---@field txtPostion7 MoonClient.MLuaUICom
---@field txtPostion6 MoonClient.MLuaUICom
---@field txtPostion5 MoonClient.MLuaUICom
---@field txtPostion4 MoonClient.MLuaUICom
---@field txtPostion3 MoonClient.MLuaUICom
---@field txtPostion2 MoonClient.MLuaUICom
---@field txtPostion1 MoonClient.MLuaUICom
---@field TxtCurPosition MoonClient.MLuaUICom
---@field TxtCurDescribe MoonClient.MLuaUICom
---@field TogGuildChange8 MoonClient.MLuaUICom
---@field TogGuildChange7 MoonClient.MLuaUICom
---@field TogGuildChange6 MoonClient.MLuaUICom
---@field TogGuildChange5 MoonClient.MLuaUICom
---@field TogGuildChange4 MoonClient.MLuaUICom
---@field TogGuildChange3 MoonClient.MLuaUICom
---@field TogGuildChange2 MoonClient.MLuaUICom
---@field TogGuildChange1 MoonClient.MLuaUICom
---@field Describe5 MoonClient.MLuaUICom
---@field Describe4 MoonClient.MLuaUICom
---@field Describe3 MoonClient.MLuaUICom
---@field Describe2 MoonClient.MLuaUICom
---@field Describe1 MoonClient.MLuaUICom
---@field BtnSure MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return GuildChangePositionPanel
---@param ctrl UIBase
function GuildChangePositionPanel.Bind(ctrl)
	
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
return UI.GuildChangePositionPanel