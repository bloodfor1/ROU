--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SettingSystemPanel = {}

--lua model end

--lua functions
---@class SettingSystemPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Powersaving MoonClient.MLuaUICom
---@field TotalVolume MoonClient.MLuaUICom
---@field TogVolumeSE MoonClient.MLuaUICom
---@field TogVolumeMain MoonClient.MLuaUICom
---@field TogVolumeChat MoonClient.MLuaUICom
---@field TogVolumeBGM MoonClient.MLuaUICom
---@field TogRoleText4 MoonClient.MLuaUICom
---@field TogRoleText3 MoonClient.MLuaUICom
---@field TogRoleText2 MoonClient.MLuaUICom
---@field TogRoleText1 MoonClient.MLuaUICom
---@field TogRole4 MoonClient.MLuaUICom
---@field TogRole3 MoonClient.MLuaUICom
---@field TogRole2 MoonClient.MLuaUICom
---@field TogRole1 MoonClient.MLuaUICom
---@field TogQualityVeryLow MoonClient.MLuaUICom
---@field TogQualityMiddle MoonClient.MLuaUICom
---@field TogQualityLow MoonClient.MLuaUICom
---@field TogQualityHigh MoonClient.MLuaUICom
---@field TogOutlineShow MoonClient.MLuaUICom
---@field TogOutlineHide MoonClient.MLuaUICom
---@field TogHitNum3 MoonClient.MLuaUICom
---@field TogHitNum2 MoonClient.MLuaUICom
---@field TogHitNum1 MoonClient.MLuaUICom
---@field TittleOutline MoonClient.MLuaUICom
---@field TittleHitNum MoonClient.MLuaUICom
---@field TextRoleState MoonClient.MLuaUICom
---@field TextQualityState MoonClient.MLuaUICom
---@field SystemContent MoonClient.MLuaUICom
---@field SliderVolumeSE MoonClient.MLuaUICom
---@field SliderVolumeMain MoonClient.MLuaUICom
---@field SliderVolumeChat MoonClient.MLuaUICom
---@field SliderVolumeBGM MoonClient.MLuaUICom
---@field SEVolume MoonClient.MLuaUICom
---@field MercenaryTeam MoonClient.MLuaUICom
---@field MercenaryMine MoonClient.MLuaUICom
---@field MercenaryAll MoonClient.MLuaUICom
---@field LabelHitNum3 MoonClient.MLuaUICom
---@field LabelHitNum2 MoonClient.MLuaUICom
---@field LabelHitNum1 MoonClient.MLuaUICom
---@field Frame60Tog MoonClient.MLuaUICom
---@field Frame30Tog MoonClient.MLuaUICom
---@field ChatVolume MoonClient.MLuaUICom
---@field BGMVolume MoonClient.MLuaUICom

---@return SettingSystemPanel
---@param ctrl UIBase
function SettingSystemPanel.Bind(ctrl)
	
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
return UI.SettingSystemPanel