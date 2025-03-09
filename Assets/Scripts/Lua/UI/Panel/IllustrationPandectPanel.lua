--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationPandectPanel = {}

--lua model end

--lua functions
---@class IllustrationPandectPanel.HandBookItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field LockTxt MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class IllustrationPandectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Scroll MoonClient.MLuaUICom
---@field Right MoonClient.MLuaUICom
---@field Left MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field HandBookItemTemplate IllustrationPandectPanel.HandBookItemTemplate

---@return IllustrationPandectPanel
function IllustrationPandectPanel.Bind(ctrl)

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
return UI.IllustrationPandectPanel