--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationMonsterTipsPanel = {}

--lua model end

--lua functions
---@class IllustrationMonsterTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field LvNumber MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field ExpNumber MoonClient.MLuaUICom
---@field EntityNumber MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field BelowContent MoonClient.MLuaUICom
---@field AboveContent MoonClient.MLuaUICom

---@return IllustrationMonsterTipsPanel
function IllustrationMonsterTipsPanel.Bind(ctrl)

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
return UI.IllustrationMonsterTipsPanel