--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GarderobePanel = {}

--lua model end

--lua functions
---@class GarderobePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName_Ornament MoonClient.MLuaUICom
---@field TxtName_EyeHair MoonClient.MLuaUICom
---@field TxtInfoFashion MoonClient.MLuaUICom
---@field TxtInfo MoonClient.MLuaUICom
---@field TxtGarderobeRewardFashion MoonClient.MLuaUICom
---@field TxtEquiping MoonClient.MLuaUICom
---@field TxtCollectionInfo MoonClient.MLuaUICom
---@field TxtCollection4 MoonClient.MLuaUICom
---@field TxtCollection3 MoonClient.MLuaUICom
---@field TxtCollection2 MoonClient.MLuaUICom
---@field TxtCollection1 MoonClient.MLuaUICom
---@field TxFashionName MoonClient.MLuaUICom
---@field TxFashionDesc MoonClient.MLuaUICom
---@field TogStrength MoonClient.MLuaUICom
---@field TogStore MoonClient.MLuaUICom
---@field TogSelectAll MoonClient.MLuaUICom
---@field TogMouth MoonClient.MLuaUICom
---@field TogHead MoonClient.MLuaUICom
---@field TogHair MoonClient.MLuaUICom
---@field TogFashion MoonClient.MLuaUICom
---@field TogFace MoonClient.MLuaUICom
---@field TogEye MoonClient.MLuaUICom
---@field TogBack MoonClient.MLuaUICom
---@field TogAutoBattleInTask MoonClient.MLuaUICom
---@field TextSearch MoonClient.MLuaUICom
---@field SwitchTog MoonClient.MLuaUICom
---@field ShowMoreArrow MoonClient.MLuaUICom
---@field ShareButton MoonClient.MLuaUICom
---@field SearchInput MoonClient.MLuaUICom
---@field Scrollbar MoonClient.MLuaUICom
---@field RewardClosePanel MoonClient.MLuaUICom
---@field RewardCloseButton MoonClient.MLuaUICom
---@field PropertyTxt MoonClient.MLuaUICom
---@field PropertyInfo MoonClient.MLuaUICom
---@field Placeholder MoonClient.MLuaUICom
---@field PanelReward MoonClient.MLuaUICom
---@field PanelLock MoonClient.MLuaUICom
---@field PanelFashionStore MoonClient.MLuaUICom
---@field ModelTouchArea MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field LeftPanel MoonClient.MLuaUICom
---@field ItemName2 MoonClient.MLuaUICom
---@field InputText MoonClient.MLuaUICom
---@field InfoScroll MoonClient.MLuaUICom
---@field Information MoonClient.MLuaUICom
---@field InfoItemName MoonClient.MLuaUICom
---@field ImgFashionName MoonClient.MLuaUICom
---@field ImgEffectLight MoonClient.MLuaUICom
---@field ImgEffectLeftDown MoonClient.MLuaUICom
---@field ImgEffectCollection MoonClient.MLuaUICom
---@field ImgCollectionFill MoonClient.MLuaUICom
---@field ImgApply MoonClient.MLuaUICom
---@field ImageFilter MoonClient.MLuaUICom
---@field HeadColors MoonClient.MLuaUICom
---@field HeadColorInfo MoonClient.MLuaUICom
---@field Go6 MoonClient.MLuaUICom
---@field Go5 MoonClient.MLuaUICom
---@field Go4 MoonClient.MLuaUICom
---@field Go3 MoonClient.MLuaUICom
---@field Go2 MoonClient.MLuaUICom
---@field Go1 MoonClient.MLuaUICom
---@field GardrobeScroll MoonClient.MLuaUICom
---@field GarderobeStoreScroll MoonClient.MLuaUICom
---@field GarderobeAwardScrollView MoonClient.MLuaUICom
---@field FormulaInfo MoonClient.MLuaUICom
---@field FashionPointTxt2 MoonClient.MLuaUICom
---@field FashionPointTxt MoonClient.MLuaUICom
---@field EyeColorInfo MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field ExplainClosePanel MoonClient.MLuaUICom
---@field EffectJiaXing MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Condition6 MoonClient.MLuaUICom
---@field Condition5 MoonClient.MLuaUICom
---@field Condition4 MoonClient.MLuaUICom
---@field Condition3 MoonClient.MLuaUICom
---@field Condition2 MoonClient.MLuaUICom
---@field Condition1 MoonClient.MLuaUICom
---@field ColourContent MoonClient.MLuaUICom
---@field Colors MoonClient.MLuaUICom
---@field CollectionPoint MoonClient.MLuaUICom
---@field CollectionInfo MoonClient.MLuaUICom
---@field ClosePanel MoonClient.MLuaUICom
---@field BtQuit MoonClient.MLuaUICom
---@field BtnStore MoonClient.MLuaUICom
---@field BtnSetting MoonClient.MLuaUICom
---@field BtnSearchCancel MoonClient.MLuaUICom
---@field BtnSearch MoonClient.MLuaUICom
---@field BtnRecover MoonClient.MLuaUICom
---@field BtnOut MoonClient.MLuaUICom
---@field btnMark2 MoonClient.MLuaUICom
---@field BtnMark1 MoonClient.MLuaUICom
---@field BtnLock MoonClient.MLuaUICom
---@field BtnGotoHair MoonClient.MLuaUICom
---@field BtnGotoEye MoonClient.MLuaUICom
---@field BtnGM MoonClient.MLuaUICom
---@field BtnGetOld MoonClient.MLuaUICom
---@field BtnGet MoonClient.MLuaUICom
---@field BtnFashionApply MoonClient.MLuaUICom
---@field BtnCollectionBlank MoonClient.MLuaUICom
---@field BtnCollection MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnCancel MoonClient.MLuaUICom
---@field BtnApply MoonClient.MLuaUICom
---@field Btn_LockSure MoonClient.MLuaUICom
---@field Btn_GM_GET MoonClient.MLuaUICom
---@field GardrobeCell MoonClient.MLuaUIGroup
---@field GardrobeLeftInfoItemPrefab MoonClient.MLuaUIGroup
---@field GarderobeAwardCell MoonClient.MLuaUIGroup
---@field GardrobeStoreCell MoonClient.MLuaUIGroup

---@return GarderobePanel
---@param ctrl UIBase
function GarderobePanel.Bind(ctrl)
	
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
return UI.GarderobePanel