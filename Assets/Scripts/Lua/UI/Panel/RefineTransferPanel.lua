--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RefineTransferPanel = {}

--lua model end

--lua functions
---@class RefineTransferPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TransferPanel MoonClient.MLuaUICom
---@field transferholo2 MoonClient.MLuaUICom
---@field transferholo1 MoonClient.MLuaUICom
---@field TransferDetail MoonClient.MLuaUICom
---@field TogGrp MoonClient.MLuaUICom
---@field Toggle2 MoonClient.MLuaUICom
---@field Toggle1 MoonClient.MLuaUICom
---@field TextName MoonClient.MLuaUICom
---@field ShowExplainPanelButton MoonClient.MLuaUICom
---@field RightSelectEquipButton MoonClient.MLuaUICom
---@field RightRemoveEquipButton MoonClient.MLuaUICom
---@field RightEquipItemParent MoonClient.MLuaUICom
---@field RefineTransferItemParent MoonClient.MLuaUICom
---@field RefineEquipButton MoonClient.MLuaUICom
---@field NonSelectPanel MoonClient.MLuaUICom
---@field NoneText MoonClient.MLuaUICom
---@field NoneInfoButton MoonClient.MLuaUICom
---@field NoneEquipTextParent MoonClient.MLuaUICom
---@field NoneEquipText MoonClient.MLuaUICom
---@field MaxPropertyCount MoonClient.MLuaUICom
---@field MaterialChooseScroll MoonClient.MLuaUICom
---@field MaterialChoosePanel MoonClient.MLuaUICom
---@field LeftSelectEquipButton MoonClient.MLuaUICom
---@field LeftRemoveEquipButton MoonClient.MLuaUICom
---@field LeftEquipItemParent MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field Img_Bg02 MoonClient.MLuaUICom
---@field IconButtonRight MoonClient.MLuaUICom
---@field IconButtonLeft MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnMaterialChooseClose MoonClient.MLuaUICom
---@field RefineTransferItem MoonClient.MLuaUIGroup

---@return RefineTransferPanel
function RefineTransferPanel.Bind(ctrl)

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
return UI.RefineTransferPanel