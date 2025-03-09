--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PollyMyNotePanel = {}

--lua model end

--lua functions
---@class PollyMyNotePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ProgressSlider MoonClient.MLuaUICom
---@field PollyName MoonClient.MLuaUICom
---@field ModelView MoonClient.MLuaUICom
---@field ModelBG MoonClient.MLuaUICom
---@field LockImage MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field AwardContent MoonClient.MLuaUICom
---@field PollyTypeHead MoonClient.MLuaUIGroup
---@field AwardNode MoonClient.MLuaUIGroup

---@return PollyMyNotePanel
function PollyMyNotePanel.Bind(ctrl)

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
return UI.PollyMyNotePanel