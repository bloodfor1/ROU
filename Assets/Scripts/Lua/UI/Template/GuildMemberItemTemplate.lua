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
---@class GuildMemberItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedEnvelopeFlag MoonClient.MLuaUICom
---@field Profession MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Position MoonClient.MLuaUICom
---@field MemberName MoonClient.MLuaUICom
---@field MemberLv MoonClient.MLuaUICom
---@field IsOnline MoonClient.MLuaUICom
---@field HeadImg MoonClient.MLuaUICom
---@field ContributionUp MoonClient.MLuaUICom
---@field ContributionDown MoonClient.MLuaUICom
---@field ChampagneFlag MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field ActivityNum MoonClient.MLuaUICom
---@field Achievement MoonClient.MLuaUICom

---@class GuildMemberItemTemplate : BaseUITemplate
---@field Parameter GuildMemberItemTemplateParameter

GuildMemberItemTemplate = class("GuildMemberItemTemplate", super)
--lua class define end

--lua functions
function GuildMemberItemTemplate:Init()

    super.Init(self)
    self._head = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadImg.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end --func end
--next--
function GuildMemberItemTemplate:OnDeActive()

    -- do nothing

end --func end
--next--
function GuildMemberItemTemplate:OnSetData(data)

    self.data = data  -- 记录数据 点击回调用
    local l_guildData = DataMgr:GetData("GuildData")
    ---@type HeadTemplateParam
    local param = {
        OnClick = self._onIconClick,
        OnClickSelf = self,
        EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.baseInfo)
    }
    self._head:SetData(param)
    self.Parameter.MemberName.LabText = data.baseInfo.name
    self.Parameter.MemberLv.LabText = data.baseInfo.baseLv
    self.Parameter.Profession.LabText = DataMgr:GetData("TeamData").GetProfessionNameById(data.baseInfo.profession)
    self.Parameter.Position.LabText = l_guildData.GetPositionName(data.position)
    self.Parameter.ContributionUp.LabText = tostring(data.curContribute)
    self.Parameter.ContributionDown.LabText = tostring(data.totalContribute)
    self.Parameter.Achievement.LabText = data.achievement
    self.Parameter.ActivityNum.LabText = math.floor(data.activeChat / 2) + data.activeFight
    --是否在线区分
    local l_isOnlineLab = self.Parameter.IsOnline
    if data.isOnline then
        l_isOnlineLab.LabText = Lang("OFFLINE_STATE_ONLINE")
        l_isOnlineLab.LabColor = Color.New(95 / 255.0, 183 / 255.0, 31 / 255.0)
        self.Parameter.Prefab.Img.color = RoColor.Hex2Color("FFFFFFFF")
    else
        l_isOnlineLab.LabColor = Color.New(175 / 255.0, 182 / 255.0, 208 / 255.0)
        if l_guildData.GetSelfGuildPosition() < l_guildData.EPositionType.Deacon then
            if data.lastOfflineTime ~= 0 then
                l_isOnlineLab.LabText = Common.Functions.CalculateOfflineTimeToStr(data.lastOfflineTime)
            else
                l_isOnlineLab.LabText = "--"
            end
        else
            l_isOnlineLab.LabText = Lang("OFFLINE_STATE_COMMON")
        end
        self.Parameter.Prefab.Img.color = RoColor.Hex2Color("E0F0F8FF")
    end
    --红包标志显示
    if data.redEnvelopeList and #data.redEnvelopeList > 0 then
        self.Parameter.RedEnvelopeFlag.UObj:SetActiveEx(true)
        local l_hasNew = false
        for i = 1, #data.redEnvelopeList do
            if not data.redEnvelopeList[i].is_received then
                l_hasNew = true
                break
            end
        end
        if l_hasNew then
            self.Parameter.RedEnvelopeFlag:SetSprite(MGlobalConfig:GetString("REIconAtlas"), MGlobalConfig:GetString("REIconHongbao01"))
        else
            self.Parameter.RedEnvelopeFlag:SetSprite(MGlobalConfig:GetString("REIconAtlas"), MGlobalConfig:GetString("REIconHongbao02"))
        end
    else
        self.Parameter.RedEnvelopeFlag.UObj:SetActiveEx(false)
    end
    if data.isOpenChampagne then
        local l_champagneResItem = TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetChampagneIcon")
        if not MLuaCommonHelper.IsNull(l_champagneResItem) then
            local l_resSplit = ParseString(l_champagneResItem.Value, "|", 2)
            if l_resSplit ~= nil then
                self.Parameter.ChampagneFlag:SetSprite(l_resSplit[1], l_resSplit[2])
            end
        end
    end
    self.Parameter.ChampagneFlag:SetActiveEx(data.isOpenChampagne)
    --红包标志
    self.Parameter.RedEnvelopeFlag:AddClick(function()
        self:MethodCallback(1)
    end)
    -- 标签处理
    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, data.baseInfo.tag)

end --func end
--next--
function GuildMemberItemTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function GuildMemberItemTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildMemberItemTemplate:_onIconClick()
    self:MethodCallback(0)
end

--设置成员的职位
function GuildMemberItemTemplate:SetPosition(positionId)
    self.Parameter.Position.LabText = DataMgr:GetData("GuildData").GetPositionName(positionId)
end
--lua custom scripts end
return GuildMemberItemTemplate