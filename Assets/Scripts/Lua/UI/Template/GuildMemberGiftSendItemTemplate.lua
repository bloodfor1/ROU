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
---@class GuildMemberGiftSendItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Profession MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Position MoonClient.MLuaUICom
---@field MemberName MoonClient.MLuaUICom
---@field MemberLv MoonClient.MLuaUICom
---@field IsSend MoonClient.MLuaUICom
---@field HeadImg MoonClient.MLuaUICom
---@field Contribution MoonClient.MLuaUICom
---@field BtnSelect MoonClient.MLuaUICom
---@field BlockImg MoonClient.MLuaUICom
---@field Activity_Fight MoonClient.MLuaUICom
---@field Activity_Chat MoonClient.MLuaUICom
---@field Achievement MoonClient.MLuaUICom

---@class GuildMemberGiftSendItemTemplate : BaseUITemplate
---@field Parameter GuildMemberGiftSendItemTemplateParameter

GuildMemberGiftSendItemTemplate = class("GuildMemberGiftSendItemTemplate", super)
--lua class define end

--lua functions
function GuildMemberGiftSendItemTemplate:Init()

    super.Init(self)
    self._head = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.HeadImg.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end --func end
--next--
function GuildMemberGiftSendItemTemplate:OnDestroy()

    -- do nothing

end --func end
--next--
function GuildMemberGiftSendItemTemplate:OnDeActive()

    -- do nothing

end --func end
--next--
function GuildMemberGiftSendItemTemplate:OnSetData(data)

    self.data = data  -- 记录数据 点击回调用
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
    self.Parameter.Position.LabText = DataMgr:GetData("GuildData").GetPositionName(data.position)
    self.Parameter.Contribution.LabText = StringEx.Format("{0}/{1}", data.curContribute, data.totalContribute)
    self.Parameter.Achievement.LabText = data.achievement
    self.Parameter.Activity_Chat.LabText = data.activeChat
    self.Parameter.Activity_Fight.LabText = data.activeFight
    self.Parameter.IsSend.Tog.isOn = DataMgr:GetData("GuildData").guildGiftSendMemberIds[data.baseInfo.roleId] or data.giftIsGet
    self.Parameter.BlockImg.UObj:SetActiveEx(data.giftIsGet)
    self.Parameter.BtnSelect:AddClick(function()
        self.Parameter.IsSend.Tog.isOn = self:MethodCallback(1, self.Parameter.IsSend.Tog.isOn)
    end)

end --func end
--next--
function GuildMemberGiftSendItemTemplate:BindEvents()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildMemberGiftSendItemTemplate:_onIconClick()
    self:MethodCallback(0)
end
--lua custom scripts end
return GuildMemberGiftSendItemTemplate