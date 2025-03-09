--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ThemeDungeonArroundPanel = {}

--lua model end

--lua functions
---@class ThemeDungeonArroundPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpText MoonClient.MLuaUICom
---@field UpBtn MoonClient.MLuaUICom
---@field ThemeNameItem MoonClient.MLuaUICom[]
---@field ScrollView MoonClient.MLuaUICom
---@field PageText MoonClient.MLuaUICom
---@field Page MoonClient.MLuaUICom
---@field NotOpen MoonClient.MLuaUICom[]
---@field NameBg MoonClient.MLuaUICom[]
---@field LockText MoonClient.MLuaUICom[]
---@field Lock MoonClient.MLuaUICom[]
---@field ImageBox MoonClient.MLuaUICom
---@field Fx MoonClient.MLuaUICom
---@field EffectBox MoonClient.MLuaUICom
---@field DungeonName MoonClient.MLuaUICom[]
---@field DownText MoonClient.MLuaUICom
---@field DownBtn MoonClient.MLuaUICom
---@field Collider MoonClient.MLuaUICom[]
---@field CloseBtn MoonClient.MLuaUICom
---@field ChapterName MoonClient.MLuaUICom[]
---@field ChallengeDungeonBtn MoonClient.MLuaUICom
---@field ButtonHelp MoonClient.MLuaUICom
---@field Award MoonClient.MLuaUICom
---@field ActivePanel MoonClient.MLuaUICom

---@return ThemeDungeonArroundPanel
---@param ctrl UIBase
function ThemeDungeonArroundPanel.Bind(ctrl)
	
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
return UI.ThemeDungeonArroundPanel