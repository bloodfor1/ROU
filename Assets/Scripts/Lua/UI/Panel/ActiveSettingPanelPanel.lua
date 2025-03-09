--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ActiveSettingPanelPanel = {}

--lua model end

--lua functions
---@class ActiveSettingPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field BtnVTransparentFXSet MoonClient.MLuaUICom
---@field BtnSceneSet MoonClient.MLuaUICom
---@field BtnSceneFXSet MoonClient.MLuaUICom
---@field BtnRole MoonClient.MLuaUICom
---@field BtnReSet MoonClient.MLuaUICom
---@field BtnOther MoonClient.MLuaUICom
---@field BtnNPC MoonClient.MLuaUICom
---@field BtnMonster MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnAllEntity MoonClient.MLuaUICom
---@field Btn720 MoonClient.MLuaUICom
---@field Btn640 MoonClient.MLuaUICom
---@field Btn1080 MoonClient.MLuaUICom

---@return ActiveSettingPanelPanel
---@param ctrl UIBaseCtrl
function ActiveSettingPanelPanel.Bind(ctrl)
	
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
return UI.ActiveSettingPanelPanel