--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeautyShopPanel = {}

--lua model end

--lua functions
---@class BeautyShopPanel
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
---@field LockCondition MoonClient.MLuaUICom
---@field ItemPanel MoonClient.MLuaUICom
---@field ImgCostIcon MoonClient.MLuaUICom[]
---@field ImgCost MoonClient.MLuaUICom[]
---@field ImgContent MoonClient.MLuaUICom
---@field Img_huafei MoonClient.MLuaUICom
---@field Colors MoonClient.MLuaUICom
---@field BtOpGray1 MoonClient.MLuaUICom
---@field BtOpGray MoonClient.MLuaUICom
---@field BtOp MoonClient.MLuaUICom
---@field BtClose MoonClient.MLuaUICom
---@field BtBarberProt MoonClient.MLuaUICom
---@field BGbtn MoonClient.MLuaUICom

---@return BeautyShopPanel
---@param ctrl UIBase
function BeautyShopPanel.Bind(ctrl)
	
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
return UI.BeautyShopPanel