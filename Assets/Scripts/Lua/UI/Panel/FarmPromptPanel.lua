--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FarmPromptPanel = {}

--lua model end

--lua functions
---@class FarmPromptPanel.FarmPromptItem.FarmPromptMonsterItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field icon MoonClient.MLuaUICom

---@class FarmPromptPanel.FarmPromptItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropmtTip MoonClient.MLuaUICom
---@field monsterContent MoonClient.MLuaUICom
---@field MapName MoonClient.MLuaUICom
---@field Lv MoonClient.MLuaUICom
---@field loopScroll MoonClient.MLuaUICom
---@field goBtn MoonClient.MLuaUICom
---@field FarmPromptMonsterItem FarmPromptPanel.FarmPromptItem.FarmPromptMonsterItem

---@class FarmPromptPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field itemScroll MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field closeBtn MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field FarmPromptItem FarmPromptPanel.FarmPromptItem

---@return FarmPromptPanel
function FarmPromptPanel.Bind(ctrl)

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
return UI.FarmPromptPanel