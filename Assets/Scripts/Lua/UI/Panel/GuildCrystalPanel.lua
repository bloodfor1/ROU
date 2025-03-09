--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildCrystalPanel = {}

--lua model end

--lua functions
---@class GuildCrystalPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleTpl MoonClient.MLuaUICom
---@field Tab_R MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom[]
---@field MainCrystalEffectView MoonClient.MLuaUICom
---@field MagicCircleBg MoonClient.MLuaUICom
---@field IsStudying MoonClient.MLuaUICom[]
---@field IsSelectd MoonClient.MLuaUICom[]
---@field ImgCrystal MoonClient.MLuaUICom[]
---@field CrystalStayEffectView MoonClient.MLuaUICom[]
---@field CrystalLinkEffectView MoonClient.MLuaUICom[]
---@field CrystalFlashEffectView MoonClient.MLuaUICom[]
---@field BtnCrystal MoonClient.MLuaUICom[]
---@field BtnClose MoonClient.MLuaUICom

---@return GuildCrystalPanel
---@param ctrl UIBase
function GuildCrystalPanel.Bind(ctrl)
	
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
return UI.GuildCrystalPanel