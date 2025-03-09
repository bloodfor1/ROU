--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TaskPanel = {}

--lua model end

--lua functions
---@class TaskPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogS MoonClient.MLuaUICom
---@field TogLOnText MoonClient.MLuaUICom
---@field TogLOffText MoonClient.MLuaUICom
---@field TogL MoonClient.MLuaUICom
---@field TextTips MoonClient.MLuaUICom
---@field TextStart MoonClient.MLuaUICom
---@field TextProgress MoonClient.MLuaUICom
---@field TextCancel MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Templent MoonClient.MLuaUICom
---@field TaskTypeTxt MoonClient.MLuaUICom
---@field TaskParent MoonClient.MLuaUICom
---@field TaskName MoonClient.MLuaUICom
---@field TaskInfo MoonClient.MLuaUICom
---@field TaskDesc MoonClient.MLuaUICom
---@field TaskChild MoonClient.MLuaUICom
---@field Task_Text_talk MoonClient.MLuaUICom
---@field Task_Empty MoonClient.MLuaUICom
---@field TargetTips MoonClient.MLuaUICom
---@field TargetDesc MoonClient.MLuaUICom
---@field ShowRewardAfterAccpted MoonClient.MLuaUICom
---@field RewardList MoonClient.MLuaUICom
---@field RewardItem MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom[]
---@field Content MoonClient.MLuaUICom
---@field CanAccpetToggle MoonClient.MLuaUICom
---@field Btn_Start MoonClient.MLuaUICom
---@field Btn_GM MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Btn_Cancel MoonClient.MLuaUICom

---@return TaskPanel
---@param ctrl UIBase
function TaskPanel.Bind(ctrl)
	
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
return UI.TaskPanel