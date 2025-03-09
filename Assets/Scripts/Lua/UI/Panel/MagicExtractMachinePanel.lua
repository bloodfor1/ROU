--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MagicExtractMachinePanel = {}

--lua model end

--lua functions
---@class MagicExtractMachinePanel.ItemShowPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemShowPrefab MoonClient.MLuaUICom

---@class MagicExtractMachinePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field TxtRemainTimes MoonClient.MLuaUICom
---@field TxtPriceCount MoonClient.MLuaUICom
---@field TxtPreview MoonClient.MLuaUICom
---@field TxtCoin MoonClient.MLuaUICom
---@field TxtArrow MoonClient.MLuaUICom
---@field TogEquipRare MoonClient.MLuaUICom
---@field TogEquipNormal MoonClient.MLuaUICom
---@field TogCardGray MoonClient.MLuaUICom
---@field TogCardBlue MoonClient.MLuaUICom
---@field TextMessage MoonClient.MLuaUICom
---@field TabEquip MoonClient.MLuaUICom
---@field TabCard MoonClient.MLuaUICom
---@field ScrollViewItem MoonClient.MLuaUICom
---@field PanelNoItem MoonClient.MLuaUICom
---@field PanelHelp MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field ImgCoin MoonClient.MLuaUICom
---@field IconPrice MoonClient.MLuaUICom
---@field BtnHelp MoonClient.MLuaUICom
---@field BtnExtract MoonClient.MLuaUICom
---@field BtnCloseHelp MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnBox MoonClient.MLuaUICom
---@field BtnArrow MoonClient.MLuaUICom
---@field Btn_Probabilty MoonClient.MLuaUICom
---@field ItemShowPrefab MagicExtractMachinePanel.ItemShowPrefab

---@return MagicExtractMachinePanel
---@param ctrl UIBase
function MagicExtractMachinePanel.Bind(ctrl)
	
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
return UI.MagicExtractMachinePanel