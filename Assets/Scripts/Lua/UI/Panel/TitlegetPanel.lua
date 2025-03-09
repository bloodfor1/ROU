--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TitlegetPanel = {}

--lua model end

--lua functions
---@class TitlegetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleName MoonClient.MLuaUICom
---@field TitleLine MoonClient.MLuaUICom
---@field StickerIcon MoonClient.MLuaUICom
---@field Sticker MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom

---@return TitlegetPanel
---@param ctrl UIBase
function TitlegetPanel.Bind(ctrl)
	
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
return UI.TitlegetPanel