--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MaterialMakePanel = {}

--lua model end

--lua functions
---@class MaterialMakePanel.MaterialMakeItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockText MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field MaterialIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field CanMakeFlag MoonClient.MLuaUICom

---@class MaterialMakePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogIsBindFirst MoonClient.MLuaUICom
---@field SucceedEffect MoonClient.MLuaUICom
---@field SelectDrop MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field ProbabilityNum MoonClient.MLuaUICom
---@field ItemScroll MoonClient.MLuaUICom
---@field InputCount MoonClient.MLuaUICom
---@field IconButton MoonClient.MLuaUICom
---@field EffectParent MoonClient.MLuaUICom
---@field CostContent MoonClient.MLuaUICom
---@field BtnMake MoonClient.MLuaUICom
---@field AimStuffName MoonClient.MLuaUICom
---@field AimStuffIcon MoonClient.MLuaUICom
---@field MaterialMakeItemPrefab MaterialMakePanel.MaterialMakeItemPrefab

---@return MaterialMakePanel
function MaterialMakePanel.Bind(ctrl)

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
return UI.MaterialMakePanel