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
local C_SPECIAL_IDX_COUNT = 3
local C_NIL_STR = "NIL"
--lua fields end

--lua class define
---@class GuildFullInfoRankTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_RankSpecial MoonClient.MLuaUICom
---@field Txt_RankNormal MoonClient.MLuaUICom
---@field Txt_GuildScore MoonClient.MLuaUICom
---@field Txt_GuildName MoonClient.MLuaUICom
---@field HeadIconPos_3 MoonClient.MLuaUICom
---@field HeadIconPos_2 MoonClient.MLuaUICom
---@field HeadIconPos_1 MoonClient.MLuaUICom

---@class GuildFullInfoRankTemplate : BaseUITemplate
---@field Parameter GuildFullInfoRankTemplateParameter

GuildFullInfoRankTemplate = class("GuildFullInfoRankTemplate", super)
--lua class define end

--lua functions
function GuildFullInfoRankTemplate:Init()
    super.Init(self)

    self:_initTemplatesConfig()
    self:_initWidgets()
end --func end
--next--
function GuildFullInfoRankTemplate:BindEvents()

end --func end
--next--
function GuildFullInfoRankTemplate:OnDestroy()

end --func end
--next--
function GuildFullInfoRankTemplate:OnDeActive()

end --func end
--next--
---@param data GuildRankDataWrap
function GuildFullInfoRankTemplate:OnSetData(data)
    data.onSetDataCb(data.onSetDataSelf, self.ShowIndex)
    self:_setData(data.guildRankData)
end --func end
--next--
--lua functions end

--lua custom scripts

--- 这个地方里面套了一个template
function GuildFullInfoRankTemplate:_initTemplatesConfig()
    self._member1 = {
        name = "HeadWrapTemplate",
        config = {
            TemplateParent = self.Parameter.HeadIconPos_1.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        }
    }
    self._member2 = {
        name = "HeadWrapTemplate",
        config = {
            TemplateParent = self.Parameter.HeadIconPos_2.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        }
    }
    self._member3 = {
        name = "HeadWrapTemplate",
        config = {
            TemplateParent = self.Parameter.HeadIconPos_3.Transform,
            IsActive = true,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        }
    }
end

function GuildFullInfoRankTemplate:_initWidgets()
    ---@type HeadWrapTemplate
    self._memberTemplate1 = self:NewTemplate(self._member1.name, self._member1.config)
    ---@type HeadWrapTemplate
    self._memberTemplate2 = self:NewTemplate(self._member2.name, self._member2.config)
    ---@type HeadWrapTemplate
    self._memberTemplate3 = self:NewTemplate(self._member3.name, self._member3.config)
end

--- 这边有可能存在一个问题，就是工会可能只有一两个人，所以角色可能显示不出来
---@param data GuildRankData
function GuildFullInfoRankTemplate:_setData(data)
    if nil == data then
        logError("[GuildRank] invalid param")
        return
    end

    local idx = self.ShowIndex
    local showSpecial = idx <= C_SPECIAL_IDX_COUNT
    self.Parameter.Txt_RankSpecial.LabText = tostring(idx)
    self.Parameter.Txt_RankNormal.LabText = tostring(idx)
    self.Parameter.Txt_RankSpecial.gameObject:SetActiveEx(showSpecial)
    self.Parameter.Txt_RankNormal.gameObject:SetActiveEx(not showSpecial)
    self.Parameter.Txt_GuildName.LabText = data:GetGuildName()
    self.Parameter.Txt_GuildScore.LabText = tostring(data:GetScore())
    local memberData1 = data:GetMemberDataByIdx(1)
    local memberData2 = data:GetMemberDataByIdx(2)
    local memberData3 = data:GetMemberDataByIdx(3)
    self:_trySetMemberData(self._memberTemplate1, memberData1)
    self:_trySetMemberData(self._memberTemplate2, memberData2)
    self:_trySetMemberData(self._memberTemplate3, memberData3)
end

---@param template HeadWrapTemplate
---@param data GuildMainMemberData
function GuildFullInfoRankTemplate:_trySetMemberData(template, data)
    if nil == data then
        template:SetGameObjectActive(false)
        return
    end

    local guildRankMgr = MgrMgr:GetMgr("GuildRankMgr")
    template:SetGameObjectActive(true)
    local onClick = function()
        guildRankMgr.OnSingleIconClick(data.UID)
    end

    ---@type HeadTemplateParam
    local param = {
        ShowName = true,
        Name = data.Name,
        ShowLv = true,
        Level = data.Level,
        ShowProfession = true,
        Profession = data.Profession,
        EquipData = guildRankMgr.ParsePlayerIconData(data),
        OnClick = onClick
    }

    template:SetData(param)
end

--lua custom scripts end
return GuildFullInfoRankTemplate