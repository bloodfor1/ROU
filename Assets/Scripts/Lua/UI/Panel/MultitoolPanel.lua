--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MultitoolPanel = {}

--lua model end

--lua functions
---@class MultitoolPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TalkScroll MoonClient.MLuaUICom
---@field StarParent MoonClient.MLuaUICom
---@field SkillScroll MoonClient.MLuaUICom
---@field ShowCupBtn MoonClient.MLuaUICom
---@field SearchButton MoonClient.MLuaUICom
---@field Search MoonClient.MLuaUICom
---@field RedEnvelopePanel MoonClient.MLuaUICom
---@field QuickTalk MoonClient.MLuaUICom
---@field QuickPagesGroup MoonClient.MLuaUICom
---@field QuickPageItem MoonClient.MLuaUICom
---@field Potion MoonClient.MLuaUICom
---@field PasswordRedEnvelope MoonClient.MLuaUICom
---@field PagesGroup MoonClient.MLuaUICom
---@field PageItem MoonClient.MLuaUICom
---@field MultitoolPanel MoonClient.MLuaUICom
---@field Material MoonClient.MLuaUICom
---@field LuckRedEnvelope MoonClient.MLuaUICom
---@field ItemScroll MoonClient.MLuaUICom
---@field ItemPanel MoonClient.MLuaUICom
---@field FuncShowScroll MoonClient.MLuaUICom
---@field FuncShowPagesGroup MoonClient.MLuaUICom
---@field FuncShowPageItem MoonClient.MLuaUICom
---@field Equip MoonClient.MLuaUICom
---@field EmojPanel MoonClient.MLuaUICom
---@field EmojiModel MoonClient.MLuaUICom
---@field EmojiContent MoonClient.MLuaUICom
---@field CupText MoonClient.MLuaUICom
---@field CupScroll MoonClient.MLuaUICom
---@field CupImg MoonClient.MLuaUICom
---@field Card MoonClient.MLuaUICom
---@field BuildPlan MoonClient.MLuaUICom
---@field BtnClose1 MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field AttScroll MoonClient.MLuaUICom
---@field All MoonClient.MLuaUICom
---@field AchiPagesGroup MoonClient.MLuaUICom
---@field AchiPageItem MoonClient.MLuaUICom
---@field Achievement MoonClient.MLuaUICom
---@field FuncBtn MoonClient.MLuaUIGroup
---@field AchiBtn MoonClient.MLuaUIGroup
---@field QuickTalkBtn MoonClient.MLuaUIGroup
---@field AttPlan MoonClient.MLuaUIGroup
---@field SkillPlan MoonClient.MLuaUIGroup

---@return MultitoolPanel
---@param ctrl UIBase
function MultitoolPanel.Bind(ctrl)
	
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
return UI.MultitoolPanel