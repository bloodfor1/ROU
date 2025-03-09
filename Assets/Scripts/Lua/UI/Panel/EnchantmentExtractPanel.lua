--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EnchantmentExtractPanel = {}

--lua model end

--lua functions
---@class EnchantmentExtractPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field TargetParent MoonClient.MLuaUICom
---@field ShowPreviewButton MoonClient.MLuaUICom
---@field ShowDetailsButton MoonClient.MLuaUICom
---@field SafeRefineButtonOn MoonClient.MLuaUICom
---@field SafeRefineButtonOff MoonClient.MLuaUICom
---@field ReturnRatioText MoonClient.MLuaUICom
---@field PreviewPanel MoonClient.MLuaUICom
---@field PreviewItemParent MoonClient.MLuaUICom
---@field PreviewCloseBtn MoonClient.MLuaUICom
---@field PreviewButton MoonClient.MLuaUICom
---@field NoneEquipTextParent MoonClient.MLuaUICom
---@field MaterialParent MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ExtractButton MoonClient.MLuaUICom
---@field EquipParent MoonClient.MLuaUICom
---@field CommonRefineButtonOn MoonClient.MLuaUICom
---@field CommonRefineButtonOff MoonClient.MLuaUICom
---@field Btn_Hint MoonClient.MLuaUICom
---@field Btn_Group_Switch MoonClient.MLuaUICom

---@return EnchantmentExtractPanel
---@param ctrl UIBase
function EnchantmentExtractPanel.Bind(ctrl)
	
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
return UI.EnchantmentExtractPanel