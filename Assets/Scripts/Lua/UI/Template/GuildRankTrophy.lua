--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local C_NIL_STR = "NIL"
--lua fields end

--lua class define
---@class GuildRankTrophyParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Rank MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class GuildRankTrophy : BaseUITemplate
---@field Parameter GuildRankTrophyParameter

GuildRankTrophy = class("GuildRankTrophy", super)
--lua class define end

--lua functions
function GuildRankTrophy:Init()

    super.Init(self)

end --func end
--next--
function GuildRankTrophy:BindEvents()


end --func end
--next--
function GuildRankTrophy:OnDestroy()


end --func end
--next--
function GuildRankTrophy:OnDeActive()


end --func end
--next--
---@param data GuildRankTrophyData
function GuildRankTrophy:OnSetData(data)
    if GameEnum.ELuaBaseType.String == type(data) and C_NIL_STR == data then
        self:_setData(nil)
        return
    end

    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts

---@param data GuildRankTrophyData
function GuildRankTrophy:_setData(data)
    if nil == data then
        self:SetGameObjectActive(false)
        return
    end

    self:SetGameObjectActive(true)
    self.Parameter.Text.LabText = data.desc
    self.Parameter.Image:SetSpriteAsync(data.atlasName, data.spName, nil, true)
    self.Parameter.Txt_Rank.LabText = data.rankDesc
end

--lua custom scripts end
return GuildRankTrophy