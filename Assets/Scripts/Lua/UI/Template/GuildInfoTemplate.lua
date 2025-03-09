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
---@class GuildInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Member2 MoonClient.MLuaUICom
---@field Txt_Member1 MoonClient.MLuaUICom
---@field Txt_GuildScore MoonClient.MLuaUICom
---@field Txt_GuildName MoonClient.MLuaUICom
---@field Panel_Head2 MoonClient.MLuaUICom
---@field Panel_Head1 MoonClient.MLuaUICom
---@field Img_Rank4 MoonClient.MLuaUICom
---@field Img_Rank3 MoonClient.MLuaUICom
---@field Img_Rank2 MoonClient.MLuaUICom
---@field Img_Rank1 MoonClient.MLuaUICom
---@field Img_GuildIcon MoonClient.MLuaUICom
---@field Img_Figure MoonClient.MLuaUICom
---@field HeadDummy2 MoonClient.MLuaUICom
---@field HeadDummy1 MoonClient.MLuaUICom
---@field Btn_Member2 MoonClient.MLuaUICom
---@field Btn_Member1 MoonClient.MLuaUICom

---@class GuildInfoTemplate : BaseUITemplate
---@field Parameter GuildInfoTemplateParameter

GuildInfoTemplate = class("GuildInfoTemplate", super)
--lua class define end

--lua functions
function GuildInfoTemplate:Init()
    super.Init(self)
    self.dataMgr = DataMgr:GetData("GuildData")

    self.head_1 = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadDummy1.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    self.head_2 = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadDummy2.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function GuildInfoTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function GuildInfoTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function GuildInfoTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function GuildInfoTemplate:OnSetData(data)
    if data == nil then
        return
    end

    self.Parameter.Txt_GuildScore.LabText = data.guildScore
    self.Parameter.Txt_GuildName.LabText = data.guildName
    self:SetRank(data.rank)
    local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(data.guildIconId)
    if not MLuaCommonHelper.IsNull(l_iconData) then
        self.Parameter.Img_GuildIcon:SetSpriteAsync(l_iconData.GuildIconAltas, l_iconData.GuildIconName)
    end

    if not MLuaCommonHelper.IsNull(data.member1BaseInfo) then
        local onClick = function()
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(data.member1BaseInfo.role_uid)
        end

        self.Parameter.Panel_Head1:SetActiveEx(true)
        self.Parameter.Txt_Member1.LabText = data.member1BaseInfo.name
        self:SetHeadByRoleId(self.head_1, data.member1BaseInfo, onClick)
    else
        self.Parameter.Panel_Head1:SetActiveEx(false)
    end

    if not MLuaCommonHelper.IsNull(data.member2BaseInfo) then
        local onClick = function()
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(data.member2BaseInfo.role_uid)
        end

        self.Parameter.Panel_Head2:SetActiveEx(true)
        self.Parameter.Txt_Member2.LabText = data.member2BaseInfo.name
        self:SetHeadByRoleId(self.head_2, data.member2BaseInfo, onClick)
    else
        self.Parameter.Panel_Head2:SetActiveEx(false)
    end
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildInfoTemplate:SetRank(rank)
    if rank < 1 then
        rank = 1
    end

    local l_guildColor = self.dataMgr.GetGuildCookScoreColor(rank)
    self.Parameter.Img_Figure.Img.color = l_guildColor
    self.Parameter.Img_Rank1:SetActiveEx(rank == 1)
    self.Parameter.Img_Rank2:SetActiveEx(rank == 2)
    self.Parameter.Img_Rank3:SetActiveEx(rank == 3)
    self.Parameter.Img_Rank4:SetActiveEx(rank == 4)
end

--- 这里穿的回调时匿名函数
function GuildInfoTemplate:SetHeadByRoleId(headCom, memberBaseInfo, onClick)
    local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(memberBaseInfo)
    ---@type HeadTemplateParam
    local param = {
        onClick = onClick,
        EquipData = equipData
    }

    headCom:SetData(param)
end
--lua custom scripts end
return GuildInfoTemplate