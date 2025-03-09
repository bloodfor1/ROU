--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeginnerBookPanel = {}

--lua model end

--lua functions
---@class BeginnerBookPanel.PostCardDisplay
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnknownDesc MoonClient.MLuaUICom
---@field Unknown MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Task MoonClient.MLuaUICom
---@field Postcard MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field ImageRT MoonClient.MLuaUICom
---@field card MoonClient.MLuaUICom

---@class BeginnerBookPanel.BeginnerReward
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Reward01 MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class BeginnerBookPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextPage MoonClient.MLuaUICom
---@field TaskName MoonClient.MLuaUICom
---@field TaskDesc MoonClient.MLuaUICom
---@field scrollview MoonClient.MLuaUICom
---@field scrollbar MoonClient.MLuaUICom
---@field RightButtonFx MoonClient.MLuaUICom
---@field right MoonClient.MLuaUICom
---@field RewardContent MoonClient.MLuaUICom
---@field Reward MoonClient.MLuaUICom
---@field Postcard MoonClient.MLuaUICom
---@field left MoonClient.MLuaUICom
---@field ImageUp MoonClient.MLuaUICom
---@field ImageLine MoonClient.MLuaUICom
---@field ImageDown MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field ContextScroll MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Clear MoonClient.MLuaUICom
---@field ButtonForward MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BlackMask MoonClient.MLuaUICom
---@field BGText MoonClient.MLuaUICom
---@field PostCardDisplay BeginnerBookPanel.PostCardDisplay
---@field BeginnerReward BeginnerBookPanel.BeginnerReward

---@return BeginnerBookPanel
---@param ctrl UIBaseCtrl
function BeginnerBookPanel.Bind(ctrl)
	
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
return UI.BeginnerBookPanel