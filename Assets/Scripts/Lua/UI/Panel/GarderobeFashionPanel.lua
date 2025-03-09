--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GarderobeFashionPanel = {}

--lua model end

--lua functions
---@class GarderobeFashionPanel.PanelRank
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field MyScore MoonClient.MLuaUICom
---@field MyRank MoonClient.MLuaUICom
---@field MyName MoonClient.MLuaUICom
---@field Model MoonClient.MLuaUICom
---@field Group MoonClient.MLuaUICom
---@field FashionRankDescribe MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Choose MoonClient.MLuaUICom
---@field BtnScreen MoonClient.MLuaUICom
---@field BtnQuestion MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field FashionRank MoonClient.MLuaUIGroup

---@class GarderobeFashionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UpgradeLimit MoonClient.MLuaUICom
---@field TogRank MoonClient.MLuaUICom
---@field TogFashion MoonClient.MLuaUICom
---@field RightView MoonClient.MLuaUICom
---@field RightLevel MoonClient.MLuaUICom
---@field progress MoonClient.MLuaUICom
---@field OtherRewardicon MoonClient.MLuaUICom
---@field OtherReward MoonClient.MLuaUICom
---@field NoAttrTips MoonClient.MLuaUICom
---@field LevelText MoonClient.MLuaUICom
---@field LevelContent MoonClient.MLuaUICom
---@field LevelAttributesScrollRect MoonClient.MLuaUICom
---@field LevelAttribute MoonClient.MLuaUICom[]
---@field LeftView MoonClient.MLuaUICom
---@field LeftLevel MoonClient.MLuaUICom
---@field LeftIcon MoonClient.MLuaUICom
---@field leftfashionnum MoonClient.MLuaUICom
---@field leftfashionhelp MoonClient.MLuaUICom
---@field ItemFashionLevel MoonClient.MLuaUICom[]
---@field IsSelectedpanel MoonClient.MLuaUICom[]
---@field isGeted MoonClient.MLuaUICom
---@field havReward MoonClient.MLuaUICom[]
---@field FootView MoonClient.MLuaUICom
---@field FashionLevelItemScrollRectContent MoonClient.MLuaUICom
---@field FashionLevelItemScrollRect MoonClient.MLuaUICom
---@field FashionLevelChange MoonClient.MLuaUICom[]
---@field FashionLevel MoonClient.MLuaUICom
---@field CurrentContent MoonClient.MLuaUICom
---@field CurAttributesScrollRect MoonClient.MLuaUICom
---@field Close MoonClient.MLuaUICom
---@field ClicktoGet MoonClient.MLuaUICom
---@field BtnTab MoonClient.MLuaUICom
---@field GarderobeFashionAttr MoonClient.MLuaUIGroup
---@field PanelRank GarderobeFashionPanel.PanelRank

---@return GarderobeFashionPanel
---@param ctrl UIBase
function GarderobeFashionPanel.Bind(ctrl)
	
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
return UI.GarderobeFashionPanel