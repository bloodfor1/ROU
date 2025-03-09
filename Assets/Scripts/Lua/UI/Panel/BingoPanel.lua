--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BingoPanel = {}

--lua model end

--lua functions
---@class BingoPanel.BingoNumItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field WenhaoCorner MoonClient.MLuaUICom
---@field WenhaoCant MoonClient.MLuaUICom
---@field WenhaoCan MoonClient.MLuaUICom
---@field UnlockNum MoonClient.MLuaUICom
---@field Unlock MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Progress MoonClient.MLuaUICom
---@field New MoonClient.MLuaUICom
---@field MoneyIcon MoonClient.MLuaUICom
---@field LockNum MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LightEffect MoonClient.MLuaUICom
---@field Countdown MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom

---@class BingoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockBtn MoonClient.MLuaUICom[]
---@field Unlock MoonClient.MLuaUICom[]
---@field Title MoonClient.MLuaUICom[]
---@field StateText MoonClient.MLuaUICom
---@field redpoint MoonClient.MLuaUICom[]
---@field Open MoonClient.MLuaUICom
---@field NumSlider MoonClient.MLuaUICom
---@field LockBtn MoonClient.MLuaUICom[]
---@field lock MoonClient.MLuaUICom[]
---@field Close MoonClient.MLuaUICom
---@field Btn_Wenhao MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field BingoNum MoonClient.MLuaUICom
---@field BingoEffect MoonClient.MLuaUICom
---@field BingoDes MoonClient.MLuaUICom
---@field BingoContent MoonClient.MLuaUICom
---@field AwardTime MoonClient.MLuaUICom
---@field AwardScroll MoonClient.MLuaUICom
---@field AwardPreviewBackBtn MoonClient.MLuaUICom
---@field AwardPreview MoonClient.MLuaUICom
---@field BingoNumItem BingoPanel.BingoNumItem

---@return BingoPanel
---@param ctrl UIBase
function BingoPanel.Bind(ctrl)
	
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
return UI.BingoPanel