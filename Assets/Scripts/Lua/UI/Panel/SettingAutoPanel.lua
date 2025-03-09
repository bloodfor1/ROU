--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SettingAutoPanel = {}

--lua model end

--lua functions
---@class SettingAutoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpDownArea MoonClient.MLuaUICom
---@field TogText MoonClient.MLuaUICom[]
---@field TogPickup MoonClient.MLuaUICom
---@field tipCloseBtn MoonClient.MLuaUICom
---@field SliderPickup MoonClient.MLuaUICom
---@field skillSlot MoonClient.MLuaUICom[]
---@field skillSetLockText MoonClient.MLuaUICom
---@field skillSetLockImg MoonClient.MLuaUICom
---@field skillSetLock MoonClient.MLuaUICom
---@field skillName5Text MoonClient.MLuaUICom[]
---@field skillName5 MoonClient.MLuaUICom[]
---@field skillName3Text MoonClient.MLuaUICom[]
---@field skillName3 MoonClient.MLuaUICom[]
---@field skillLvText MoonClient.MLuaUICom[]
---@field SkillLvBg MoonClient.MLuaUICom[]
---@field skillBtn MoonClient.MLuaUICom[]
---@field SemiAutoTog MoonClient.MLuaUICom
---@field rangeTipText MoonClient.MLuaUICom
---@field rangeTip MoonClient.MLuaUICom
---@field RangeText MoonClient.MLuaUICom
---@field RangeSlider MoonClient.MLuaUICom
---@field RangeNum MoonClient.MLuaUICom
---@field rangeLockText MoonClient.MLuaUICom
---@field rangeLockImg MoonClient.MLuaUICom
---@field rangeLock MoonClient.MLuaUICom
---@field rangeHelpBtn MoonClient.MLuaUICom
---@field RangeHandle MoonClient.MLuaUICom
---@field RangeFill MoonClient.MLuaUICom
---@field PickupSub MoonClient.MLuaUICom
---@field PickupAdd MoonClient.MLuaUICom
---@field pickLockText MoonClient.MLuaUICom
---@field pickLockImg MoonClient.MLuaUICom
---@field pickLock MoonClient.MLuaUICom
---@field pickHelpBtn MoonClient.MLuaUICom
---@field passiveImg MoonClient.MLuaUICom[]
---@field NotMoveTip MoonClient.MLuaUICom
---@field normalImg MoonClient.MLuaUICom[]
---@field LabPickupPercent MoonClient.MLuaUICom
---@field halfScreenTog MoonClient.MLuaUICom
---@field gotoSetBtn MoonClient.MLuaUICom
---@field FullyAutoTog MoonClient.MLuaUICom
---@field fullScreenTog MoonClient.MLuaUICom
---@field fullMapTog MoonClient.MLuaUICom
---@field customTog MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom[]
---@field BtnDrinkMedicine MoonClient.MLuaUICom
---@field autoStateLockText MoonClient.MLuaUICom
---@field autoStateLockImg MoonClient.MLuaUICom
---@field autoStateLock MoonClient.MLuaUICom

---@return SettingAutoPanel
---@param ctrl UIBase
function SettingAutoPanel.Bind(ctrl)
	
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
return UI.SettingAutoPanel