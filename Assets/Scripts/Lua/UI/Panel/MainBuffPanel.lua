--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainBuffPanel = {}

--lua model end

--lua functions
---@class MainBuffPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field timeLab3 MoonClient.MLuaUICom
---@field timeLab2 MoonClient.MLuaUICom
---@field TextMeshPro3 MoonClient.MLuaUICom
---@field TextMeshPro2 MoonClient.MLuaUICom
---@field reduceBuff MoonClient.MLuaUICom
---@field Image3 MoonClient.MLuaUICom
---@field Image2 MoonClient.MLuaUICom
---@field icon3 MoonClient.MLuaUICom
---@field icon2 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field buffPanel MoonClient.MLuaUICom
---@field buffList MoonClient.MLuaUICom
---@field bossBuff MoonClient.MLuaUICom

---@return MainBuffPanel
---@param ctrl UIBase
function MainBuffPanel.Bind(ctrl)
	
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
return UI.MainBuffPanel