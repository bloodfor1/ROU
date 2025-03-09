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
---@class SelectCharHeadTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtRoleName MoonClient.MLuaUICom
---@field TxtLevel MoonClient.MLuaUICom
---@field TogRole MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Revert MoonClient.MLuaUICom
---@field ImgRoleJob MoonClient.MLuaUICom
---@field ImgRole MoonClient.MLuaUICom
---@field CurInfo MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom
---@field Anchor MoonClient.MLuaUICom

---@class SelectCharHeadTemplate : BaseUITemplate
---@field Parameter SelectCharHeadTemplateParameter

SelectCharHeadTemplate = class("SelectCharHeadTemplate", super)
--lua class define end

--lua functions
function SelectCharHeadTemplate:Init()
    super.Init(self)
    self.timer = nil
    self.data = nil
end --func end
--next--
function SelectCharHeadTemplate:OnDestroy()
    self.head2d = nil
    self:ClearTImers()
    self.data = nil
end --func end
--next--
function SelectCharHeadTemplate:OnDeActive()
    self:ClearTImers()
end --func end
--next--
function SelectCharHeadTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function SelectCharHeadTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function SelectCharHeadTemplate:CustomSetData(data)
    self:ClearTImers()
    self.data = data
    if data.empty then
        self.Parameter.Background:SetSprite("role", "UI_role_headBG_1.png")
        self.Parameter.Checkmark.gameObject:SetActiveEx(false)
        self.Parameter.ImgRole.gameObject:SetActiveEx(false)
        self.Parameter.Revert.gameObject:SetActiveEx(false)
        self.Parameter.CurInfo.gameObject:SetActiveEx(false)
    else
        self.Parameter.Background:SetSprite("role", "UI_role_headBG_2.png")
        self.Parameter.TogRole.Tog.isOn = data.selected
        self.Parameter.ImgRole.gameObject:SetActiveEx(true)

        self:UpdateCurInfo(data.selected)

        if not self.head2d then
            self.head2d = self:NewTemplate("HeadWrapTemplate", {
                TemplateParent = self.Parameter.ImgRole.transform,
                TemplatePath = "UI/Prefabs/HeadWrapTemplate"
            })
        end

        local l_equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipDataByRoleBriefInfo(data.roleInfo)
        ---@type HeadTemplateParam
        local param = {
            EquipData = l_equipData,
            ShowMask = true,
            ShowFrame = false,
            ShowBg = false,
        }

        self.head2d:SetData(param)
        local l_countDownFlag = false
        if data.roleInfo.status == RoleStatusType.Role_Status_Deleting then
            local l_deleteCountDownTime = tonumber(TableUtil.GetGlobalTable().GetRowByName("DeleteCountdown").Value)
            local l_nowStamp = Common.TimeMgr.GetNowTimestamp()
            local l_remainingTime = data.roleInfo.delete_time - l_nowStamp + l_deleteCountDownTime + 2
            if l_remainingTime > 0 then
                l_countDownFlag = true
                self:UpdateCountDown(l_remainingTime)
            end
        end

        if l_countDownFlag then
            self.Parameter.Revert.gameObject:SetActiveEx(true)
        else
            self.Parameter.Revert.gameObject:SetActiveEx(false)
        end
    end

    self.Parameter.TogRole:OnToggleChanged(function(value)
        if value then
            if not self.data.empty then
                self.Parameter.TogRole.Tog.isOn = true
            end
            if self.MethodCallback then
                self.MethodCallback(self.data.empty, self.data.roleIndex, self.data.index)
            end
        end
    end)
end

function SelectCharHeadTemplate:UpdateCurInfo(selected)

    if selected then
        self.Parameter.TxtRoleName.LabText = Common.Utils.PlayerName(self.data.roleInfo.name)
        self.Parameter.TxtLevel.LabText = "Lv." .. self.data.roleInfo.level

        local l_proRow = TableUtil.GetProfessionTable().GetRowById(self.data.roleInfo.type)
        if l_proRow ~= nil then
            self.Parameter.ImgRoleJob:SetSprite("Common", l_proRow.ProfessionIcon)
        end
        self.Parameter.CurInfo.gameObject:SetActiveEx(true)
    else
        self.Parameter.CurInfo.gameObject:SetActiveEx(false)
    end
end

function SelectCharHeadTemplate:ClearTImers()
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
end

function SelectCharHeadTemplate:OnCountTimeEnd()
    MgrMgr:GetMgr("SelectRoleMgr").GetAccountRoleData()
end

function SelectCharHeadTemplate:UpdateCountDown(time)
    self:ClearTImers()
    local _, l_text = self:GetRemainingTimeFormat(time)
    self.Parameter.Text.LabText = l_text
    local l_startTime = Time.realtimeSinceStartup
    self.timer = self:NewUITimer(function()
        time = time - Time.realtimeSinceStartup + l_startTime
        l_startTime = Time.realtimeSinceStartup
        local l_flag, l_text = self:GetRemainingTimeFormat(time)
        self.Parameter.Text.LabText = l_text
        if not l_flag then
            self:OnCountTimeEnd()
            self:ClearTImers()
        end
    end, 1, -1, true)
    self.timer:Start()
end

function SelectCharHeadTemplate:GetRemainingTimeFormat(time)
    return MgrMgr:GetMgr("SelectRoleMgr").GetDeletingCountDownTimeFormat(time)
end

function SelectCharHeadTemplate:GetRootGameObject()
    return self.Parameter.Anchor.gameObject
end
--lua custom scripts end
return SelectCharHeadTemplate