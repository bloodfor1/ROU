--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DeadDlgPanel = {}

--lua model end

--lua functions
---@class DeadDlgPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLoss MoonClient.MLuaUICom
---@field TxtKiller MoonClient.MLuaUICom
---@field ReviveTimesTxt MoonClient.MLuaUICom
---@field QuestionBtn MoonClient.MLuaUICom
---@field Offset MoonClient.MLuaUICom
---@field FuncTxt MoonClient.MLuaUICom
---@field FuncImage MoonClient.MLuaUICom
---@field DeathNormal MoonClient.MLuaUICom
---@field DeathGuild MoonClient.MLuaUICom
---@field DeadTip MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ButtonFunc MoonClient.MLuaUICom
---@field BubbleText MoonClient.MLuaUICom
---@field Bubble MoonClient.MLuaUICom
---@field BtnInfo MoonClient.MLuaUICom
---@field BtnConfirm MoonClient.MLuaUICom
---@field Btn_Resurrection MoonClient.MLuaUICom
---@field Btn_Monthcard MoonClient.MLuaUICom

---@return DeadDlgPanel
---@param ctrl UIBase
function DeadDlgPanel.Bind(ctrl)
	
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
return UI.DeadDlgPanel