--this file is gen by script
--you can edit this file in custom part


--lua model
---@class UI
---@field MainGuildMatchPanel UI.MainGuildMatchPanel

---@module UI.MainGuildMatchPanel
module("UI.MainGuildMatchPanel", package.seeall)
--lua model end

--lua functions
---@class MainGuildMatchPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WarnTipTxt MoonClient.MLuaUICom[]
---@field WarnTip MoonClient.MLuaUICom[]
---@field WaitTipTxt MoonClient.MLuaUICom
---@field WaitTip MoonClient.MLuaUICom
---@field WaitPanel MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field TipBg MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Round MoonClient.MLuaUICom
---@field RedScore MoonClient.MLuaUICom
---@field RedPoint MoonClient.MLuaUICom[]
---@field RedFlowers MoonClient.MLuaUICom
---@field PrePare MoonClient.MLuaUICom
---@field pkObject MoonClient.MLuaUICom
---@field CountDown MoonClient.MLuaUICom
---@field BlueScore MoonClient.MLuaUICom
---@field BluePoint MoonClient.MLuaUICom[]
---@field BlueFlowers MoonClient.MLuaUICom
---@field Alarm MoonClient.MLuaUICom

---@return MainGuildMatchPanel
function Bind(ctrl)

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
return UI.MainGuildMatchPanel