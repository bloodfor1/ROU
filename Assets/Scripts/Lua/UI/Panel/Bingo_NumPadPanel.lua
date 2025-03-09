--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Bingo_NumPadPanel = {}

--lua model end

--lua functions
---@class Bingo_NumPadPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field NumRangeTip MoonClient.MLuaUICom
---@field Num MoonClient.MLuaUICom[]
---@field InputField MoonClient.MLuaUICom
---@field del MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_Determine MoonClient.MLuaUICom
---@field Btn_Cancel MoonClient.MLuaUICom

---@return Bingo_NumPadPanel
---@param ctrl UIBase
function Bingo_NumPadPanel.Bind(ctrl)
	
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
return UI.Bingo_NumPadPanel