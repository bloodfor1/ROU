--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HeadSelectPanel = {}

--lua model end

--lua functions
---@class HeadSelectPanel.HeadSelectItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field TimeLimit MoonClient.MLuaUICom
---@field ImgMask MoonClient.MLuaUICom
---@field img_default MoonClient.MLuaUICom
---@field IconTrial MoonClient.MLuaUICom
---@field IconSelected MoonClient.MLuaUICom
---@field IconContent MoonClient.MLuaUICom

---@class HeadSelectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field widget_empty MoonClient.MLuaUICom
---@field Weijihuo MoonClient.MLuaUICom
---@field useButton MoonClient.MLuaUICom
---@field Tittle MoonClient.MLuaUICom
---@field TitleCondition MoonClient.MLuaUICom
---@field SearchInput MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field NonProgressText MoonClient.MLuaUICom
---@field NonProgress MoonClient.MLuaUICom
---@field myHead MoonClient.MLuaUICom
---@field Inuse MoonClient.MLuaUICom
---@field InputClearBtn MoonClient.MLuaUICom
---@field FromTips MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ConditionName MoonClient.MLuaUICom
---@field HeadSelectItemTemplate HeadSelectPanel.HeadSelectItemTemplate

---@return HeadSelectPanel
---@param ctrl UIBase
function HeadSelectPanel.Bind(ctrl)
	
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
return UI.HeadSelectPanel