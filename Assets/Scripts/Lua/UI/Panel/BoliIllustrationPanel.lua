--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BoliIllustrationPanel = {}

--lua model end

--lua functions
---@class BoliIllustrationPanel.BoliSelectItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field HeadOn MoonClient.MLuaUICom
---@field HeadOff MoonClient.MLuaUICom

---@class BoliIllustrationPanel.BoliFindRecordItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field SceneName MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field BoliCountIcon MoonClient.MLuaUICom[]

---@class BoliIllustrationPanel.BoliAchieveRewardItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemSlot MoonClient.MLuaUICom[]
---@field ItemBox MoonClient.MLuaUICom[]
---@field IconCanGet MoonClient.MLuaUICom[]
---@field IconAlreadyGet MoonClient.MLuaUICom[]
---@field ClickEventIcon MoonClient.MLuaUICom[]
---@field Arrow MoonClient.MLuaUICom

---@class BoliIllustrationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockBoliImg MoonClient.MLuaUICom
---@field NotFindDescribe MoonClient.MLuaUICom
---@field NextStageNum MoonClient.MLuaUICom
---@field FindRecordView MoonClient.MLuaUICom
---@field FindRecordPart MoonClient.MLuaUICom
---@field FindNum MoonClient.MLuaUICom
---@field BtnInfo MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnAchievement MoonClient.MLuaUICom
---@field BoliView MoonClient.MLuaUICom
---@field BoliShowPart MoonClient.MLuaUICom
---@field BoliSelectView MoonClient.MLuaUICom
---@field BoliNotFind MoonClient.MLuaUICom
---@field BoliName MoonClient.MLuaUICom
---@field BoliFindDetailPart MoonClient.MLuaUICom
---@field BoliDescribe MoonClient.MLuaUICom
---@field BoliBg MoonClient.MLuaUICom
---@field AchievementRewardView MoonClient.MLuaUICom
---@field BoliSelectItemPrefab BoliIllustrationPanel.BoliSelectItemPrefab
---@field BoliFindRecordItemPrefab BoliIllustrationPanel.BoliFindRecordItemPrefab
---@field BoliAchieveRewardItemPrefab BoliIllustrationPanel.BoliAchieveRewardItemPrefab

---@return BoliIllustrationPanel
---@param ctrl UIBaseCtrl
function BoliIllustrationPanel.Bind(ctrl)
	
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
return UI.BoliIllustrationPanel