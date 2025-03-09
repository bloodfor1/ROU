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
---@class SettingPlayerTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Template MoonClient.MLuaUICom
---@field Revert MoonClient.MLuaUICom
---@field PlayerHeadGo MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class SettingPlayerTemplate : BaseUITemplate
---@field Parameter SettingPlayerTemplateParameter

SettingPlayerTemplate = class("SettingPlayerTemplate", super)
--lua class define end

--lua functions
function SettingPlayerTemplate:Init()
    super.Init(self)
end --func end
--next--
function SettingPlayerTemplate:OnDestroy()
    self.head2d = nil
    if self.Parameter and self.Parameter.PlayerProfessImg then
        self.Parameter.PlayerProfessImg:ResetSprite()
    end

    self:ClearTimers()
end --func end
--next--
function SettingPlayerTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function SettingPlayerTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function SettingPlayerTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function SettingPlayerTemplate:CustomSetData(data)
    self:ClearTimers()
    local proID = 0
    local playerLv = 0
    if data.roleInfo then
        proID = data.roleInfo.type
        playerLv = data.roleInfo.level
        if data.roleInfo.status == RoleStatusType.Role_Status_Deleting then
            self:StartCountDown(data.roleInfo)
            self.Parameter.Revert.gameObject:SetActiveEx(true)
        else
            self.Parameter.Revert.gameObject:SetActiveEx(false)
        end

        self.Parameter.Name.LabText = data.ignoreName and "" or Common.Utils.PlayerName(data.roleInfo.name)
    else
        proID = MPlayerInfo.ProID
        playerLv = MPlayerInfo.Lv
        self.Parameter.Revert.gameObject:SetActiveEx(false)
        self.Parameter.Name.LabText = ""
    end

    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.PlayerHeadGo.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    local onClick = function()
        if self.MethodCallback and data.index then
            self.MethodCallback(data.index)
        end
    end

    if data.roleInfo then
        self.Parameter.PlayerHeadGo:SetActiveEx(true)
        local l_equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipDataByRoleBriefInfo(data.roleInfo)
        ---@type HeadTemplateParam
        local param = {
            OnClick = onClick,
            EquipData = l_equipData,
            ShowProfession = true,
            Profession = proID,
            ShowLv = true,
            Level = playerLv,
        }

        self.head2d:SetData(param)
    else
        ---@type HeadTemplateParam
        local param = {
            OnClick = onClick,
            IsPlayerSelf = true,
            ShowProfession = true,
            ShowLv = true,
        }

        self.head2d:SetData(param)
        self.Parameter.PlayerHeadGo:SetActiveEx(false)
    end
end

function SettingPlayerTemplate:StartCountDown(roleInfo)
    local l_deleteCountDownTime = MGlobalConfig:GetFloat("DeleteCountdown")
    local l_nowStamp = Common.TimeMgr.GetNowTimestamp()
    local l_remainingTime = roleInfo.delete_time - l_nowStamp + l_deleteCountDownTime + 2
    local _, l_text = MgrMgr:GetMgr("SelectRoleMgr").GetDeletingCountDownTimeFormat(l_remainingTime)
    self.Parameter.Text.LabText = l_text
    local l_startTime = Time.realtimeSinceStartup
    self.timer = self:NewUITimer(function()
        l_remainingTime = l_remainingTime - Time.realtimeSinceStartup + l_startTime
        l_startTime = Time.realtimeSinceStartup
        local l_flag, l_text = MgrMgr:GetMgr("SelectRoleMgr").GetDeletingCountDownTimeFormat(l_remainingTime)
        self.Parameter.Text.LabText = l_text
        if not l_flag then
            self:OnCountTimeEnd()
            self:ClearTimers()
        end
    end, 1, -1, true)
    self.timer:Start()
end

function SettingPlayerTemplate:ClearTimers()
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
end

function SettingPlayerTemplate:OnCountTimeEnd()

    MgrMgr:GetMgr("SelectRoleMgr").GetAccountRoleData()
end
--lua custom scripts end
return SettingPlayerTemplate