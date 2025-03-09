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
---@class TeamMemberSingleParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Duty MoonClient.MLuaUICom
---@field TeamMemberSingle MoonClient.MLuaUICom
---@field Img_Icon MoonClient.MLuaUICom
---@field DummyHead2D MoonClient.MLuaUICom
---@field Change MoonClient.MLuaUICom

---@class TeamMemberSingle : BaseUITemplate
---@field Parameter TeamMemberSingleParameter

TeamMemberSingle = class("TeamMemberSingle", super)
--lua class define end

--lua functions
function TeamMemberSingle:Init()

    super.Init(self)
    self.canPick = false
    self.Parameter.TeamMemberSingle:AddClick(function()
        if self.canPick then
            self.MethodCallback(self.ShowIndex)
        end
    end)
    self.head2d = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.DummyHead2D.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

end --func end
--next--
function TeamMemberSingle:BindEvents()
    -- do nothing
end --func end
--next--
function TeamMemberSingle:OnDestroy()
    self.head2d = nil
end --func end
--next--
function TeamMemberSingle:OnDeActive()
    -- do nothing
end --func end
--next--
function TeamMemberSingle:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param data TeamIconParam
function TeamMemberSingle:_onSetData(data)
    if nil == data then
        logError("[TeamDuty] invalid param")
        return
    end

    self.canPick = data.isEmptyPos and data.canpick
    if not data.isEmptyPos then
        local showIcon = nil ~= data.iconData
        if showIcon then
            local playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
            local equipData = playerInfoMgr.GetEquipData(data.iconData.roleBriefInfo)
            if equipData then
                ---@type HeadTemplateParam
                local param = {
                    ShowProfession = true,
                    Profession = data.iconData.roleType,
                    EquipData = equipData,
                }

                self.head2d:SetData(param)
            end

            self.Parameter.Txt_Duty.LabText = data.iconData.roleName
        end
    else
        self.Parameter.Img_Icon:SetSprite("CommonIcon", MgrMgr:GetMgr("TeamLeaderMatchMgr").GetPngName(data.dutyID))
        self.Parameter.Img_Icon.Img:SetNativeSize()
        self.Parameter.Txt_Duty.LabText = Common.Utils.Lang("TEAM_CAREER_CHOICE_DUTY_" .. data.dutyID)
    end

    self.Parameter.Change:SetActiveEx(self.canPick)
    self:_initMode(data.isEmptyPos)
end

function TeamMemberSingle:_initMode(iconMode)
    self.Parameter.Txt_Duty.gameObject:SetActiveEx(true)
    self.Parameter.DummyHead2D.gameObject:SetActiveEx(not iconMode)
    self.Parameter.Img_Icon.gameObject:SetActiveEx(iconMode)
end
--lua custom scripts end
return TeamMemberSingle