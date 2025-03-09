--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BarberShopPanel = {}

--lua model end

--lua functions
---@class BarberShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UseCostIcon MoonClient.MLuaUICom[]
---@field UnlockItem MoonClient.MLuaUICom
---@field UnlockBt_text MoonClient.MLuaUICom
---@field UnlockBt MoonClient.MLuaUICom
---@field UesTxCost MoonClient.MLuaUICom[]
---@field UesImgCost MoonClient.MLuaUICom[]
---@field TxName MoonClient.MLuaUICom
---@field TxMoney MoonClient.MLuaUICom
---@field TxCost MoonClient.MLuaUICom[]
---@field TogHide MoonClient.MLuaUICom
---@field SliderCameraSize MoonClient.MLuaUICom
---@field ScBarber MoonClient.MLuaUICom
---@field NotAward MoonClient.MLuaUICom
---@field Money MoonClient.MLuaUICom
---@field LockCondition MoonClient.MLuaUICom
---@field ItemContent MoonClient.MLuaUICom
---@field ImgCostIcon MoonClient.MLuaUICom[]
---@field ImgCost MoonClient.MLuaUICom[]
---@field ImgContent MoonClient.MLuaUICom
---@field GO3 MoonClient.MLuaUICom
---@field GO2 MoonClient.MLuaUICom
---@field GO1 MoonClient.MLuaUICom
---@field Condition3 MoonClient.MLuaUICom
---@field Condition2 MoonClient.MLuaUICom
---@field Condition1 MoonClient.MLuaUICom
---@field Condition MoonClient.MLuaUICom
---@field Colors MoonClient.MLuaUICom
---@field BtOpUnEnable MoonClient.MLuaUICom
---@field BtOpGray MoonClient.MLuaUICom
---@field BtOp MoonClient.MLuaUICom
---@field BtClose MoonClient.MLuaUICom
---@field BtBarberProt MoonClient.MLuaUICom
---@field BGbtn MoonClient.MLuaUICom

---@return BarberShopPanel
---@param ctrl UIBase
function BarberShopPanel.Bind(ctrl)
	
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
return UI.BarberShopPanel