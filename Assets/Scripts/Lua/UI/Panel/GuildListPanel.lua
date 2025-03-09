--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildListPanel = {}

--lua model end

--lua functions
---@class GuildListPanel.GuildItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field MemberNum MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IsApplied MoonClient.MLuaUICom
---@field GuildName MoonClient.MLuaUICom
---@field GuildLv MoonClient.MLuaUICom
---@field GuildIcon MoonClient.MLuaUICom
---@field ChairmanSexIcon MoonClient.MLuaUICom
---@field ChairmanName MoonClient.MLuaUICom

---@class GuildListPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipText MoonClient.MLuaUICom
---@field TipNoCreate MoonClient.MLuaUICom
---@field SearchInput MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field RecruitWords MoonClient.MLuaUICom
---@field InfoTitle MoonClient.MLuaUICom
---@field GuildItemParent MoonClient.MLuaUICom
---@field BtnSearchCancel MoonClient.MLuaUICom
---@field BtnSearch MoonClient.MLuaUICom
---@field BtnGroup MoonClient.MLuaUICom
---@field BtnCreate MoonClient.MLuaUICom
---@field BtnContact MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnApplyText MoonClient.MLuaUICom
---@field BtnApplyAllText MoonClient.MLuaUICom
---@field BtnApplyAll MoonClient.MLuaUICom
---@field BtnApply MoonClient.MLuaUICom
---@field GuildItemPrefab GuildListPanel.GuildItemPrefab

---@return GuildListPanel
function GuildListPanel.Bind(ctrl)

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
return UI.GuildListPanel