--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GMPayPanel = {}

--lua model end

--lua functions
---@class GMPayPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleEnv MoonClient.MLuaUICom
---@field ShopDropdown MoonClient.MLuaUICom
---@field RichTextAnnounce2 MoonClient.MLuaUICom
---@field RichTextAnnounce1 MoonClient.MLuaUICom
---@field RewardInfo2 MoonClient.MLuaUICom
---@field RewardInfo1 MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field ItemName2 MoonClient.MLuaUICom
---@field Input3 MoonClient.MLuaUICom
---@field Input2 MoonClient.MLuaUICom
---@field Input1 MoonClient.MLuaUICom
---@field Diamond MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field Btn8 MoonClient.MLuaUICom
---@field Btn7 MoonClient.MLuaUICom
---@field Btn6 MoonClient.MLuaUICom
---@field Btn5 MoonClient.MLuaUICom
---@field Btn4 MoonClient.MLuaUICom
---@field Btn3 MoonClient.MLuaUICom
---@field Btn2 MoonClient.MLuaUICom
---@field Btn1 MoonClient.MLuaUICom

---@return GMPayPanel
function GMPayPanel.Bind(ctrl)

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
return UI.GMPayPanel