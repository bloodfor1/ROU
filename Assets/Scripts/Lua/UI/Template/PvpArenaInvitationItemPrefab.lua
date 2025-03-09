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
---@class PvpArenaInvitationItemPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field InvitationBtn MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field head MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom

---@class PvpArenaInvitationItemPrefab : BaseUITemplate
---@field Parameter PvpArenaInvitationItemPrefabParameter

PvpArenaInvitationItemPrefab = class("PvpArenaInvitationItemPrefab", super)
--lua class define end

--lua functions
function PvpArenaInvitationItemPrefab:Init()
    super.Init(self)
end --func end
--next--
function PvpArenaInvitationItemPrefab:OnDestroy()
    self.head2d = nil
    self.info = nil
end --func end
--next--
function PvpArenaInvitationItemPrefab:OnDeActive()
    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
end --func end
--next--
function PvpArenaInvitationItemPrefab:OnSetData(data)
    self.info = data.info
    self.canInvite = false
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.head.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.info)
    }

    self.head2d:SetData(param)
    self.Parameter.Selected.gameObject:SetActiveEx(false)
    self.Parameter.Name.LabText = data.info.name
    self.Parameter.GenreText.LabText = DataMgr:GetData("TeamData").GetProfessionNameById(data.info.type) or ""
    local l_isOnline = data.is_online
    if l_isOnline == nil then
        l_isOnline = false
    end

    self.Parameter.InvitationBtn:AddClick(function()
        if not l_isOnline then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_ROLE_NOT_ONLINE"))
            return
        end

        if self.canInvite then
            local l_roleID = data.type == 1 and self.info.roleId or self.info.role_uid
            MgrMgr:GetMgr("PvpArenaMgr").ArenaInviteRequet(l_roleID)
            MgrMgr:GetMgr("PvpArenaMgr").m_inviteTimeLimit[l_roleID] = Time.realtimeSinceStartup
            self:UpdateTimer()
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PVP_HAVE_INVITATE"))
        end
    end)

    self:UpdateTimer()
    self.Parameter.InvitationBtn:SetGray(not l_isOnline)
end --func end
--next--
function PvpArenaInvitationItemPrefab:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function PvpArenaInvitationItemPrefab:UpdateTimer()
    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

    if nil == self.info then
        return
    end

    local l_roleID = self.info.role_uid
    local l_last = MgrMgr:GetMgr("PvpArenaMgr").m_inviteTimeLimit[l_roleID]
    local l_limit = MgrMgr:GetMgr("PvpArenaMgr").m_limitTime
    if not l_last or Time.realtimeSinceStartup - l_last > l_limit then
        self.canInvite = true
        self.Parameter.InvitationBtn:SetGray(not self.canInvite)
        return
    end

    self.canInvite = false
    self.Parameter.InvitationBtn:SetGray(not self.canInvite)
    self.timer = self:NewUITimer(function()
        if Time.realtimeSinceStartup - l_last > l_limit then
            if self.timer then
                self:StopUITimer(self.timer)
                self.timer = nil
            end
            self.canInvite = true
            self.Parameter.InvitationBtn:SetGray(not self.canInvite)
        end
    end, 1, -1, true)

    self.timer:Start()
end
--lua custom scripts end
return PvpArenaInvitationItemPrefab