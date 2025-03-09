--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CollectAutoSettingPanel = {}

--lua model end

--lua functions
---@class CollectAutoSettingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_TogLab MoonClient.MLuaUICom
---@field Txt_Title MoonClient.MLuaUICom
---@field Txt_TimeRemainTip MoonClient.MLuaUICom
---@field Txt_TimeAddTip MoonClient.MLuaUICom
---@field Txt_RemainTime MoonClient.MLuaUICom
---@field Txt_helpTips MoonClient.MLuaUICom
---@field Txt_CollectScopeDis MoonClient.MLuaUICom
---@field Toggle_SelfDefine MoonClient.MLuaUICom
---@field Toggle_AutoContinueTime MoonClient.MLuaUICom
---@field Toggle_AllMap MoonClient.MLuaUICom
---@field Slider_CollectScope MoonClient.MLuaUICom
---@field Root MoonClient.MLuaUICom
---@field Listener_Handler MoonClient.MLuaUICom
---@field Img_SlideFill MoonClient.MLuaUICom
---@field Img_NeedProp MoonClient.MLuaUICom
---@field Dropdown_Root MoonClient.MLuaUICom
---@field Dropdown_AddRemainTime MoonClient.MLuaUICom
---@field CostItem MoonClient.MLuaUICom
---@field Btn_Help MoonClient.MLuaUICom
---@field Btn_Confirm MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom

---@return CollectAutoSettingPanel
---@param ctrl UIBase
function CollectAutoSettingPanel.Bind(ctrl)
	
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
return UI.CollectAutoSettingPanel