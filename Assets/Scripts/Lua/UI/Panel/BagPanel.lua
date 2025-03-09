--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BagPanel = {}

--lua model end

--lua functions
---@class BagPanel.PotPagePrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtPotPageName MoonClient.MLuaUICom
---@field PrefabPotPage MoonClient.MLuaUICom
---@field BtnPotPage MoonClient.MLuaUICom
---@field BtnPotLock MoonClient.MLuaUICom

---@class BagPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtWeight MoonClient.MLuaUICom
---@field TxtQuickNum MoonClient.MLuaUICom[]
---@field TxtNowPgName MoonClient.MLuaUICom
---@field TxtCarItemWeight MoonClient.MLuaUICom
---@field TxtCarItemNum MoonClient.MLuaUICom
---@field TogShoe MoonClient.MLuaUICom
---@field TogRide MoonClient.MLuaUICom
---@field TogQuick MoonClient.MLuaUICom[]
---@field TogOrnaR MoonClient.MLuaUICom
---@field TogOrnaL MoonClient.MLuaUICom
---@field TogMouth MoonClient.MLuaUICom
---@field TogMainWeap MoonClient.MLuaUICom
---@field TogHead MoonClient.MLuaUICom
---@field TogFashion MoonClient.MLuaUICom
---@field TogFace MoonClient.MLuaUICom
---@field TogCloth MoonClient.MLuaUICom
---@field TogCloak MoonClient.MLuaUICom
---@field TogBeiluz MoonClient.MLuaUICom
---@field TogBattleVehicle MoonClient.MLuaUICom
---@field TogBattleBird MoonClient.MLuaUICom
---@field TogBarrow MoonClient.MLuaUICom
---@field TogBagCly MoonClient.MLuaUICom[]
---@field TogBack MoonClient.MLuaUICom
---@field TogAssist MoonClient.MLuaUICom
---@field TitleNormalPot MoonClient.MLuaUICom
---@field TitleCarPot MoonClient.MLuaUICom
---@field StorgechangeBg MoonClient.MLuaUICom
---@field StorageScrollParent MoonClient.MLuaUICom
---@field ScrollProp MoonClient.MLuaUICom
---@field ScrollPot MoonClient.MLuaUICom
---@field RecycleItemsButton MoonClient.MLuaUICom
---@field QuickBack MoonClient.MLuaUICom[]
---@field QualityGroup MoonClient.MLuaUICom
---@field PanelWeight MoonClient.MLuaUICom
---@field PanelWeapon MoonClient.MLuaUICom
---@field PanelQuick MoonClient.MLuaUICom
---@field PanelPotPage MoonClient.MLuaUICom
---@field PanelPot MoonClient.MLuaUICom
---@field PanelLeftBg MoonClient.MLuaUICom
---@field PanelLeft MoonClient.MLuaUICom
---@field PanelDrag MoonClient.MLuaUICom
---@field PageView MoonClient.MLuaUICom
---@field PageMark MoonClient.MLuaUICom[]
---@field PageItems MoonClient.MLuaUICom[]
---@field MultiTalentsSelectButtonParent MoonClient.MLuaUICom
---@field ModelTouchArea MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field InfoPropPos MoonClient.MLuaUICom
---@field InfoPotPos MoonClient.MLuaUICom
---@field ImgShoeOrg MoonClient.MLuaUICom
---@field ImgShoe MoonClient.MLuaUICom
---@field ImgRideOrg MoonClient.MLuaUICom
---@field ImgRide MoonClient.MLuaUICom
---@field ImgQuickItem MoonClient.MLuaUICom[]
---@field ImgOrnaROrg MoonClient.MLuaUICom
---@field ImgOrnaR MoonClient.MLuaUICom
---@field ImgOrnaLOrg MoonClient.MLuaUICom
---@field ImgOrnaL MoonClient.MLuaUICom
---@field ImgMouthOrg MoonClient.MLuaUICom
---@field ImgMouth MoonClient.MLuaUICom
---@field ImgMainWeapOrg MoonClient.MLuaUICom
---@field ImgMainWeap MoonClient.MLuaUICom
---@field ImgHeadOrg MoonClient.MLuaUICom
---@field ImgHead MoonClient.MLuaUICom
---@field ImgFashionOrg MoonClient.MLuaUICom
---@field ImgFashion MoonClient.MLuaUICom
---@field ImgFaceOrg MoonClient.MLuaUICom
---@field ImgFace MoonClient.MLuaUICom
---@field ImgDragEps MoonClient.MLuaUICom
---@field ImgDragBg MoonClient.MLuaUICom
---@field ImgDrag MoonClient.MLuaUICom
---@field ImgClothOrg MoonClient.MLuaUICom
---@field ImgCloth MoonClient.MLuaUICom
---@field ImgCloakOrg MoonClient.MLuaUICom
---@field ImgCloak MoonClient.MLuaUICom
---@field ImgBgWeight MoonClient.MLuaUICom
---@field ImgBeiluzOrg MoonClient.MLuaUICom
---@field ImgBeiluz MoonClient.MLuaUICom
---@field ImgBattleVehicleOrg MoonClient.MLuaUICom
---@field ImgBattleVehicle MoonClient.MLuaUICom
---@field ImgBattleBirdOrg MoonClient.MLuaUICom
---@field ImgBattleBird MoonClient.MLuaUICom
---@field ImgBarrowOrg MoonClient.MLuaUICom
---@field ImgBarrow MoonClient.MLuaUICom
---@field ImgBackOrg MoonClient.MLuaUICom
---@field ImgBack MoonClient.MLuaUICom
---@field ImgAssistOrg MoonClient.MLuaUICom
---@field ImgAssist MoonClient.MLuaUICom
---@field ClosePotButton MoonClient.MLuaUICom
---@field BtnWeight MoonClient.MLuaUICom
---@field BtnWeapon MoonClient.MLuaUICom
---@field BtnSort3 MoonClient.MLuaUICom
---@field BtnSort2 MoonClient.MLuaUICom
---@field BtnSort1 MoonClient.MLuaUICom
---@field BtnQuickOpen MoonClient.MLuaUICom
---@field BtnQuickKill MoonClient.MLuaUICom[]
---@field BtnQuickClose MoonClient.MLuaUICom
---@field BtnPot MoonClient.MLuaUICom
---@field BtnNowPage MoonClient.MLuaUICom
---@field BtnEdiClf MoonClient.MLuaUICom
---@field BtnCloseAll MoonClient.MLuaUICom
---@field AssistMask MoonClient.MLuaUICom
---@field AddQuick MoonClient.MLuaUICom[]
---@field PotPagePrefab BagPanel.PotPagePrefab

---@return BagPanel
---@param ctrl UIBase
function BagPanel.Bind(ctrl)
	
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
return UI.BagPanel