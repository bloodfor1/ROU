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
--lua fields end

--lua class define
---@class GuildOraganizationRankTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_RankSpecial MoonClient.MLuaUICom
---@field Txt_RankNormal MoonClient.MLuaUICom
---@field Txt_PlayerName MoonClient.MLuaUICom
---@field Txt_GuildOrganizationHanor MoonClient.MLuaUICom
---@field Obj_headParent MoonClient.MLuaUICom
---@field Img_Profession MoonClient.MLuaUICom
---@field Img_PlayerHead MoonClient.MLuaUICom

---@class GuildOraganizationRankTemplate : BaseUITemplate
---@field Parameter GuildOraganizationRankTemplateParameter

GuildOraganizationRankTemplate = class("GuildOraganizationRankTemplate", super)
--lua class define end

--lua functions
function GuildOraganizationRankTemplate:Init()
    super.Init(self)
    self.head2D = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.Obj_headParent.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function GuildOraganizationRankTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function GuildOraganizationRankTemplate:OnDestroy()
    self.head2D = nil
    self.headMemberInfo = nil
end --func end
--next--
function GuildOraganizationRankTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function GuildOraganizationRankTemplate:OnSetData(data)
    ---@type GuildMemberOrganizationList
    local l_rankInfo = data
    if l_rankInfo == nil then
        return
    end

    if l_rankInfo.rank < 4 then
        self.Parameter.Txt_RankNormal.LabText = l_rankInfo.rank
    else
        self.Parameter.Txt_RankSpecial.LabText = l_rankInfo.rank
    end

    self.Parameter.Txt_RankNormal:SetActiveEx(l_rankInfo.rank < 4)
    self.Parameter.Txt_RankSpecial:SetActiveEx(l_rankInfo.rank >= 4)
    self.Parameter.Txt_GuildOrganizationHanor.LabText = l_rankInfo.organization_contribute
    self.Parameter.Txt_PlayerName.LabText = l_rankInfo.member_base_info.name
    local l_playerProfessionType = 0
    if l_rankInfo.member_base_info.role_uid == MPlayerInfo.UID then
        ---@type HeadTemplateParam
        local param = {
            ShowProfession = true,
            IsPlayerSelf = true,
        }

        self.head2D:SetData(param)
    else
        l_playerProfessionType = l_rankInfo.member_base_info.type
        self.headMemberInfo = MgrMgr:GetMgr("PlayerInfoMgr").CreatMemberData(l_rankInfo.member_base_info)
        local onClick = function()
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(l_rankInfo.member_base_info.role_uid)
        end

        ---@type HeadTemplateParam
        local param = {
            ShowProfession = true,
            Profession = l_playerProfessionType,
            EquipData = self.headMemberInfo:GetEquipData(),
            OnClick = onClick,
        }

        self.head2D:SetData(param)
    end

    self.Parameter.Img_Profession:SetActiveEx(false)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildOraganizationRankTemplate