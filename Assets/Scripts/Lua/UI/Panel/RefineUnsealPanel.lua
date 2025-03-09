--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RefineUnsealPanel = {}

--lua model end

--lua functions
---@class RefineUnsealPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnsealSelectEquipButton MoonClient.MLuaUICom
---@field UnsealItemParent MoonClient.MLuaUICom
---@field UnsealEquipItemParent MoonClient.MLuaUICom
---@field UnsealDetail MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field ShowExplainPanelButton MoonClient.MLuaUICom
---@field SealRemoveEquipButton MoonClient.MLuaUICom
---@field RepairPanel MoonClient.MLuaUICom
---@field RepairLevel MoonClient.MLuaUICom
---@field RepairEquipButton MoonClient.MLuaUICom
---@field RefineName MoonClient.MLuaUICom
---@field RawImageSeal MoonClient.MLuaUICom
---@field NonSelectPanel MoonClient.MLuaUICom
---@field NoneText MoonClient.MLuaUICom
---@field NoneInfoButton MoonClient.MLuaUICom
---@field NoneEquipTextParent MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field IconButtonSeal MoonClient.MLuaUICom

---@return RefineUnsealPanel
---@param ctrl UIBase
function RefineUnsealPanel.Bind(ctrl)
	
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
return UI.RefineUnsealPanel