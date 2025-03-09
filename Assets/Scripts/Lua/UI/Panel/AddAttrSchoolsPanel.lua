--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AddAttrSchoolsPanel = {}

--lua model end

--lua functions
---@class AddAttrSchoolsPanel.AttrRecomItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field StarIcon MoonClient.MLuaUICom[]
---@field Select MoonClient.MLuaUICom
---@field SchoolIcon MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field FeatureTxt MoonClient.MLuaUICom[]
---@field FeatureImg MoonClient.MLuaUICom[]
---@field BG MoonClient.MLuaUICom
---@field AttrInfo MoonClient.MLuaUICom[]

---@class AddAttrSchoolsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field recomBtn MoonClient.MLuaUICom
---@field previewBtn MoonClient.MLuaUICom
---@field PanelName MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field closeBtn MoonClient.MLuaUICom
---@field addPointBtn MoonClient.MLuaUICom
---@field AttrRecomItemTemplate AddAttrSchoolsPanel.AttrRecomItemTemplate

---@return AddAttrSchoolsPanel
---@param ctrl UIBaseCtrl
function AddAttrSchoolsPanel.Bind(ctrl)
	
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
return UI.AddAttrSchoolsPanel