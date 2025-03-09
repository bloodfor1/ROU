--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AdventureDiaryPanel = {}

--lua model end

--lua functions
---@class AdventureDiaryPanel.AdventureSectionItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field SectionName MoonClient.MLuaUICom[]
---@field SectionBoxFxView MoonClient.MLuaUICom
---@field SectionBG MoonClient.MLuaUICom[]
---@field Prefab MoonClient.MLuaUICom
---@field LockMask MoonClient.MLuaUICom
---@field IsHasMissionGet MoonClient.MLuaUICom
---@field BtnSectionBoxImg MoonClient.MLuaUICom[]
---@field BtnSectionBox MoonClient.MLuaUICom[]
---@field BtnOn MoonClient.MLuaUICom
---@field BtnOff MoonClient.MLuaUICom

---@class AdventureDiaryPanel.AdventureMissionItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field NormalBG MoonClient.MLuaUICom
---@field NameBox MoonClient.MLuaUICom
---@field MissionName MoonClient.MLuaUICom
---@field MissionImg MoonClient.MLuaUICom
---@field LockMask MoonClient.MLuaUICom
---@field LockBG MoonClient.MLuaUICom
---@field IsLock MoonClient.MLuaUICom
---@field IsCanGetAward MoonClient.MLuaUICom

---@class AdventureDiaryPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SectionView MoonClient.MLuaUICom
---@field SectionTipUp MoonClient.MLuaUICom
---@field SectionTipDown MoonClient.MLuaUICom
---@field MissionView MoonClient.MLuaUICom
---@field IsCanTake MoonClient.MLuaUICom
---@field BtnPre MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnAward MoonClient.MLuaUICom
---@field AwardProcessText MoonClient.MLuaUICom
---@field AwardProcess MoonClient.MLuaUICom
---@field AwardPart MoonClient.MLuaUICom
---@field AdventureSectionItemPrefab AdventureDiaryPanel.AdventureSectionItemPrefab
---@field AdventureMissionItemPrefab AdventureDiaryPanel.AdventureMissionItemPrefab

---@return AdventureDiaryPanel
---@param ctrl UIBase
function AdventureDiaryPanel.Bind(ctrl)
	
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
return UI.AdventureDiaryPanel