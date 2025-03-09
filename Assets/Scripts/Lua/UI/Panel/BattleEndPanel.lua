--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattleEndPanel = {}

--lua model end

--lua functions
---@class BattleEndPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field win MoonClient.MLuaUICom
---@field TxtMostKill MoonClient.MLuaUICom
---@field TxtMostHeal MoonClient.MLuaUICom
---@field TxtMostDamage MoonClient.MLuaUICom
---@field TxtMostAssist MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field ScrollViewRed MoonClient.MLuaUICom
---@field ScrollViewBlue MoonClient.MLuaUICom
---@field SavaBtn MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field MobileBtn MoonClient.MLuaUICom
---@field MainPanel MoonClient.MLuaUICom
---@field lose MoonClient.MLuaUICom
---@field ImageMostKill MoonClient.MLuaUICom
---@field ImageMostHeal MoonClient.MLuaUICom
---@field ImageMostDamage MoonClient.MLuaUICom
---@field ImageMostAssist MoonClient.MLuaUICom
---@field HideBtn MoonClient.MLuaUICom
---@field btn MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field BtnPlayerLeft MoonClient.MLuaUIGroup
---@field BtnPlayerRight MoonClient.MLuaUIGroup

---@return BattleEndPanel
---@param ctrl UIBase
function BattleEndPanel.Bind(ctrl)
	
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
return UI.BattleEndPanel