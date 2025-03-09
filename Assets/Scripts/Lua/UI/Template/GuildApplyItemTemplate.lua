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
---@class GuildApplyItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipText MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field PlayerHead MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field LvText MoonClient.MLuaUICom
---@field JobText MoonClient.MLuaUICom
---@field BtnIgnore MoonClient.MLuaUICom
---@field BtnAgree MoonClient.MLuaUICom

---@class GuildApplyItemTemplate : BaseUITemplate
---@field Parameter GuildApplyItemTemplateParameter

GuildApplyItemTemplate = class("GuildApplyItemTemplate", super)
--lua class define end

--lua functions
function GuildApplyItemTemplate:Init()

    super.Init(self)
    self.isClicked = false   --防连点
    self._data = nil
    self._head = nil

end --func end
--next--
function GuildApplyItemTemplate:OnDeActive()

    self.isClicked = false
    self._data = nil
    self._head = nil

end --func end
--next--
function GuildApplyItemTemplate:OnSetData(data)

    self._data = data
    self.isClicked = false
    self._head = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.PlayerHead.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
    local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(self._data.baseInfo)
    ---@type HeadTemplateParam
    local param = {
        OnClickSelf = self,
        OnClick = self._onIconClick,
        EquipData = equipData,
    }
    self._head:SetData(param)
    self.Parameter.Name.LabText = data.baseInfo.name
    self.Parameter.LvText.LabText = data.baseInfo.baseLv
    self.Parameter.JobText.LabText = DataMgr:GetData("TeamData").GetProfessionNameById(data.baseInfo.profession)
    --同意按钮点击
    self.Parameter.BtnAgree:AddClick(function()
        if not self.isClicked then
            self.isClicked = true
            MgrMgr:GetMgr("GuildMgr").ReqCheckApply(data.baseInfo.roleId, true)
        end
    end)
    local l_guildData = DataMgr:GetData("GuildData")
    if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.Deacon then
        --普通成员 不显示操作按钮
        self.Parameter.TipText.UObj:SetActiveEx(true)
        self.Parameter.BtnAgree.UObj:SetActiveEx(false)
    end

end --func end
--next--
function GuildApplyItemTemplate:OnDestroy()

    -- do nothing

end --func end
--next--
function GuildApplyItemTemplate:BindEvents()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildApplyItemTemplate:_onIconClick()
    MgrMgr:GetMgr("GuildMgr").ShowMemberDetailInfo(self._data)
end
--lua custom scripts end
return GuildApplyItemTemplate