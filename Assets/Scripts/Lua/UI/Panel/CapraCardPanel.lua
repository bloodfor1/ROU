--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CapraCardPanel = {}

--lua model end

--lua functions
---@class CapraCardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WidgetRemainTimeVIP MoonClient.MLuaUICom
---@field WidgetRemainingTimeNormal MoonClient.MLuaUICom
---@field Txt_VipCardRemainTime MoonClient.MLuaUICom
---@field Txt_touchNum MoonClient.MLuaUICom
---@field Txt_rewardRemainNum MoonClient.MLuaUICom
---@field Txt_RemainTime MoonClient.MLuaUICom
---@field Text_Title_VIP MoonClient.MLuaUICom
---@field Text_Title MoonClient.MLuaUICom
---@field Text_Effective MoonClient.MLuaUICom
---@field Panel_VIPCard MoonClient.MLuaUICom
---@field Panel_MembershipCard MoonClient.MLuaUICom
---@field Obj_ExplainPosMark MoonClient.MLuaUICom
---@field LoopScroll_Privilege MoonClient.MLuaUICom
---@field Label_VipCardLabel MoonClient.MLuaUICom
---@field Btn_Share MoonClient.MLuaUICom
---@field Btn_Explain MoonClient.MLuaUICom
---@field Btn_BG MoonClient.MLuaUICom
---@field Template_Privilege MoonClient.MLuaUIGroup

---@return CapraCardPanel
---@param ctrl UIBase
function CapraCardPanel.Bind(ctrl)
	
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
return UI.CapraCardPanel