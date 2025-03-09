--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MedalTipsPanel = {}

--lua model end

--lua functions
---@class MedalTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ZenyBtn MoonClient.MLuaUICom
---@field ViewAttrTipPanel MoonClient.MLuaUICom
---@field ViewAttrText MoonClient.MLuaUICom
---@field ViewAttrSelectTitle MoonClient.MLuaUICom
---@field ViewAttrSelectPanel MoonClient.MLuaUICom
---@field ViewAttrSelect MoonClient.MLuaUICom
---@field unlock MoonClient.MLuaUICom
---@field Txt_Slider MoonClient.MLuaUICom
---@field TipPanel MoonClient.MLuaUICom
---@field TextPrestige MoonClient.MLuaUICom
---@field TextMessage MoonClient.MLuaUICom
---@field SliderProgress MoonClient.MLuaUICom
---@field ProgressSliderObj MoonClient.MLuaUICom
---@field PrestigeUsedText MoonClient.MLuaUICom
---@field PrestigeCostText MoonClient.MLuaUICom
---@field PrestigeBtn MoonClient.MLuaUICom
---@field MedalName MoonClient.MLuaUICom
---@field MedalLv MoonClient.MLuaUICom
---@field MedalIconBg MoonClient.MLuaUICom
---@field MedalIcon MoonClient.MLuaUICom
---@field MaskViewAttrBG MoonClient.MLuaUICom
---@field MaskHelpBG MoonClient.MLuaUICom
---@field lock MoonClient.MLuaUICom
---@field IconFx MoonClient.MLuaUICom
---@field IconBgFx MoonClient.MLuaUICom
---@field HelpTipPanel MoonClient.MLuaUICom
---@field HelpPanel MoonClient.MLuaUICom
---@field HelpButton MoonClient.MLuaUICom
---@field HeadText MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field DescMax MoonClient.MLuaUICom
---@field ClassificationViewAttrTip MoonClient.MLuaUICom
---@field ClassificationViewAttrText MoonClient.MLuaUICom
---@field ClassificationViewAttrScroll MoonClient.MLuaUICom
---@field ClassificationViewAttrLab MoonClient.MLuaUICom
---@field ClassificationViewAttr MoonClient.MLuaUICom
---@field ClassificationTitle MoonClient.MLuaUICom
---@field ClassificationPrestige MoonClient.MLuaUICom
---@field ClassificationNextTitle MoonClient.MLuaUICom
---@field ClassificationNextAttrTip MoonClient.MLuaUICom
---@field ClassificationNextAttr MoonClient.MLuaUICom
---@field ClassificationAttrTip MoonClient.MLuaUICom
---@field ClassificationAttrText MoonClient.MLuaUICom
---@field ClassificationAttrNextText MoonClient.MLuaUICom
---@field ClassificationAttr MoonClient.MLuaUICom
---@field ClassificationActiveTipTitle MoonClient.MLuaUICom
---@field ClassificationActiveTip MoonClient.MLuaUICom
---@field ClassificationActiveText MoonClient.MLuaUICom
---@field ClassificationActiveButton MoonClient.MLuaUICom
---@field ClassificationActive MoonClient.MLuaUICom
---@field ButtonsPanel MoonClient.MLuaUICom
---@field ButtonDesc MoonClient.MLuaUICom
---@field BtnViewAttr MoonClient.MLuaUICom
---@field BtnTipTextPlus MoonClient.MLuaUICom
---@field BtnTipText2 MoonClient.MLuaUICom
---@field BtnTipText1 MoonClient.MLuaUICom
---@field BtnTipPlus MoonClient.MLuaUICom
---@field BtnTip2 MoonClient.MLuaUICom
---@field BtnTip1 MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom
---@field BtnCloseViewAttrTip MoonClient.MLuaUICom

---@return MedalTipsPanel
---@param ctrl UIBase
function MedalTipsPanel.Bind(ctrl)
	
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
return UI.MedalTipsPanel