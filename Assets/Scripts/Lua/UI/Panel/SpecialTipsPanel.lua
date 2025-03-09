--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SpecialTipsPanel = {}

--lua model end

--lua functions
---@class SpecialTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_GetItem MoonClient.MLuaUICom
---@field Text02 MoonClient.MLuaUICom
---@field Text01 MoonClient.MLuaUICom
---@field Text_Next MoonClient.MLuaUICom
---@field ShowTxtInfo MoonClient.MLuaUICom
---@field RewardName MoonClient.MLuaUICom
---@field RewardModel MoonClient.MLuaUICom
---@field RewardIcon MoonClient.MLuaUICom
---@field Raw_MultipleEffectBg MoonClient.MLuaUICom
---@field Raw_EffBg MoonClient.MLuaUICom
---@field Panel_ShowText MoonClient.MLuaUICom
---@field Panel_Prop MoonClient.MLuaUICom
---@field Panel_Item MoonClient.MLuaUICom
---@field Panel_Card MoonClient.MLuaUICom
---@field Panel_AwardList MoonClient.MLuaUICom
---@field Obj_Bg MoonClient.MLuaUICom
---@field NameBG MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field InfoUI MoonClient.MLuaUICom
---@field InforBG MoonClient.MLuaUICom
---@field Img MoonClient.MLuaUICom
---@field CardBG MoonClient.MLuaUICom
---@field Btn_Share MoonClient.MLuaUICom
---@field Btn_Ok MoonClient.MLuaUICom
---@field BthOkText MoonClient.MLuaUICom
---@field Attr MoonClient.MLuaUICom

---@return SpecialTipsPanel
---@param ctrl UIBase
function SpecialTipsPanel.Bind(ctrl)
	
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
return UI.SpecialTipsPanel