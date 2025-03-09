--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildGiftBoxGrantPanel = {}

--lua model end

--lua functions
---@class GuildGiftBoxGrantPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field StockNum MoonClient.MLuaUICom
---@field SortIcon MoonClient.MLuaUICom[]
---@field ScrollView MoonClient.MLuaUICom
---@field LetterText MoonClient.MLuaUICom[]
---@field GetNum MoonClient.MLuaUICom
---@field ExplainStockText MoonClient.MLuaUICom
---@field ExplainPanel MoonClient.MLuaUICom
---@field ExplainGetText MoonClient.MLuaUICom
---@field ExplainBubbleStock MoonClient.MLuaUICom
---@field ExplainBubbleGet MoonClient.MLuaUICom
---@field BtnStockInfo MoonClient.MLuaUICom
---@field BtnLetter MoonClient.MLuaUICom[]
---@field BtnGrant MoonClient.MLuaUICom
---@field BtnGetInfo MoonClient.MLuaUICom
---@field BtnFull MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field GuildMemberGiftSendItemPrefab MoonClient.MLuaUIGroup

---@return GuildGiftBoxGrantPanel
---@param ctrl UIBase
function GuildGiftBoxGrantPanel.Bind(ctrl)

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
return UI.GuildGiftBoxGrantPanel