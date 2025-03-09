--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LuckyDrawPanel = {}

--lua model end

--lua functions
---@class LuckyDrawPanel.PanelFlop.F1
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgIcon MoonClient.MLuaUICom
---@field ImgFront MoonClient.MLuaUICom
---@field ImgBack MoonClient.MLuaUICom
---@field Flop MoonClient.MLuaUICom
---@field EffectGuang MoonClient.MLuaUICom
---@field EffectBoom MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LuckyDrawPanel.PanelFlop.F2
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgIcon MoonClient.MLuaUICom
---@field ImgFront MoonClient.MLuaUICom
---@field ImgBack MoonClient.MLuaUICom
---@field Flop MoonClient.MLuaUICom
---@field EffectGuang MoonClient.MLuaUICom
---@field EffectBoom MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LuckyDrawPanel.PanelFlop.F3
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgIcon MoonClient.MLuaUICom
---@field ImgFront MoonClient.MLuaUICom
---@field ImgBack MoonClient.MLuaUICom
---@field Flop MoonClient.MLuaUICom
---@field EffectGuang MoonClient.MLuaUICom
---@field EffectBoom MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LuckyDrawPanel.PanelFlop.F4
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgIcon MoonClient.MLuaUICom
---@field ImgFront MoonClient.MLuaUICom
---@field ImgBack MoonClient.MLuaUICom
---@field Flop MoonClient.MLuaUICom
---@field EffectGuang MoonClient.MLuaUICom
---@field EffectBoom MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LuckyDrawPanel.PanelFlop.F5
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgIcon MoonClient.MLuaUICom
---@field ImgFront MoonClient.MLuaUICom
---@field ImgBack MoonClient.MLuaUICom
---@field Flop MoonClient.MLuaUICom
---@field EffectGuang MoonClient.MLuaUICom
---@field EffectBoom MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LuckyDrawPanel.PanelFlop
---@field PanelRef MoonClient.MLuaUIPanel
---@field F1 LuckyDrawPanel.PanelFlop.F1
---@field F2 LuckyDrawPanel.PanelFlop.F2
---@field F3 LuckyDrawPanel.PanelFlop.F3
---@field F4 LuckyDrawPanel.PanelFlop.F4
---@field F5 LuckyDrawPanel.PanelFlop.F5

---@class LuckyDrawPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field ImgEffect MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field PanelFlop LuckyDrawPanel.PanelFlop

---@return LuckyDrawPanel
function LuckyDrawPanel.Bind(ctrl)

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
return UI.LuckyDrawPanel