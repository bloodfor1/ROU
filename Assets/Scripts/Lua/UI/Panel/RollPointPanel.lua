--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RollPointPanel = {}

--lua model end

--lua functions
---@class RollPointPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tips MoonClient.MLuaUICom
---@field Shake MoonClient.MLuaUICom
---@field SelfBg MoonClient.MLuaUICom
---@field RollGan MoonClient.MLuaUICom
---@field RollBall MoonClient.MLuaUICom
---@field Roll MoonClient.MLuaUICom
---@field Reward MoonClient.MLuaUICom
---@field NumRight2 MoonClient.MLuaUICom
---@field NumRight1 MoonClient.MLuaUICom
---@field NumRight MoonClient.MLuaUICom
---@field NumLeft2 MoonClient.MLuaUICom
---@field NumLeft1 MoonClient.MLuaUICom
---@field NumLeft MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field ItemSec MoonClient.MLuaUICom
---@field ItemNormal MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemEmpty MoonClient.MLuaUICom
---@field ItemBest MoonClient.MLuaUICom
---@field ImgHeadExpression MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field HeadIcon MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field FriendBtn MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field BtnExpressionInstance MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom

---@return RollPointPanel
---@param ctrl UIBase
function RollPointPanel.Bind(ctrl)
	
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
return UI.RollPointPanel