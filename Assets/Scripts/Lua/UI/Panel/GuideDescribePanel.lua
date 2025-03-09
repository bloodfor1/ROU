--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuideDescribePanel = {}

--lua model end

--lua functions
---@class GuideDescribePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalkText MoonClient.MLuaUICom
---@field NpcTalkBg MoonClient.MLuaUICom
---@field NpcSpineSlot MoonClient.MLuaUICom
---@field NpcNameText MoonClient.MLuaUICom
---@field NpcNameBox MoonClient.MLuaUICom
---@field NpcHead MoonClient.MLuaUICom
---@field NpcArrowPart MoonClient.MLuaUICom
---@field NpcArrowGroup MoonClient.MLuaUICom
---@field NpcArrow MoonClient.MLuaUICom[]
---@field NoNpcArrowPart MoonClient.MLuaUICom
---@field InfoText MoonClient.MLuaUICom
---@field InfoBg MoonClient.MLuaUICom
---@field Img_Zhezhao MoonClient.MLuaUICom
---@field HeadImg MoonClient.MLuaUICom
---@field EffectPart MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom[]
---@field DragArrow MoonClient.MLuaUICom
---@field AttrTipBorder MoonClient.MLuaUICom
---@field AttrTip MoonClient.MLuaUICom[]
---@field Arrow MoonClient.MLuaUICom[]

---@return GuideDescribePanel
---@param ctrl UIBase
function GuideDescribePanel.Bind(ctrl)
	
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
return UI.GuideDescribePanel