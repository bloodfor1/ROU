--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildMemberPanel = {}

--lua model end

--lua functions
---@class GuildMemberPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field TipNoResult MoonClient.MLuaUICom
---@field SortIcon MoonClient.MLuaUICom[]
---@field SearchInput MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field OnlineNumberBox MoonClient.MLuaUICom
---@field OnlineNumber MoonClient.MLuaUICom
---@field LetterText MoonClient.MLuaUICom[]
---@field BtnSendMsgToAll MoonClient.MLuaUICom
---@field BtnSearchCancel MoonClient.MLuaUICom
---@field BtnSearch MoonClient.MLuaUICom
---@field BtnQuit MoonClient.MLuaUICom
---@field BtnLetter MoonClient.MLuaUICom[]
---@field BtnEdit MoonClient.MLuaUICom
---@field BtnApplyList MoonClient.MLuaUICom
---@field BeautyToggle MoonClient.MLuaUICom
---@field BeautyOnlyBtn MoonClient.MLuaUICom
---@field BeautyChoose MoonClient.MLuaUICom
---@field GuildMemberItemPrefab MoonClient.MLuaUIGroup

---@return GuildMemberPanel
---@param ctrl UIBase
function GuildMemberPanel.Bind(ctrl)

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
return UI.GuildMemberPanel