--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FunctionPreviewPanel = {}

--lua model end

--lua functions
---@class FunctionPreviewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ToggleGroup_ChooseFunc MoonClient.MLuaUICom
---@field TaskPreviewText MoonClient.MLuaUICom
---@field TaskPreviewFinish MoonClient.MLuaUICom
---@field TaskPreview MoonClient.MLuaUICom
---@field ShowServerTipsButton MoonClient.MLuaUICom
---@field ServerLevelTipsParent MoonClient.MLuaUICom
---@field ServerLevelPreviewFinish MoonClient.MLuaUICom
---@field ServerLevelPreview MoonClient.MLuaUICom
---@field NoticeTitleText MoonClient.MLuaUICom
---@field NoticeTitle2Text MoonClient.MLuaUICom
---@field funcMovie MoonClient.MLuaUICom
---@field DescTxt MoonClient.MLuaUICom
---@field CloseSeverLevelButton MoonClient.MLuaUICom
---@field CloseMovie MoonClient.MLuaUICom
---@field BtnPlay MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BGc MoonClient.MLuaUICom
---@field BGb MoonClient.MLuaUICom
---@field BGa MoonClient.MLuaUICom
---@field BaseLevelPreviewFinish MoonClient.MLuaUICom
---@field BaseLevelPreview MoonClient.MLuaUICom
---@field Toggle_FunctionBtn MoonClient.MLuaUIGroup

---@return FunctionPreviewPanel
---@param ctrl UIBase
function FunctionPreviewPanel.Bind(ctrl)
	
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
return UI.FunctionPreviewPanel