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
--next--
--lua fields end

--lua class define
---@class GuildTeamBlankParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtPlayerName MoonClient.MLuaUICom
---@field RoleInfoImg MoonClient.MLuaUICom
---@field Img_Profession MoonClient.MLuaUICom
---@field Img_PlayerHead MoonClient.MLuaUICom

---@class GuildTeamBlank : BaseUITemplate
---@field Parameter GuildTeamBlankParameter

GuildTeamBlank = class("GuildTeamBlank", super)
--lua class define end

--lua functions
function GuildTeamBlank:Init()

    super.Init(self)
    self.targetUid = 0

end --func end
--next--
function GuildTeamBlank:BindEvents()


end --func end
--next--
function GuildTeamBlank:OnDestroy()

    self.head2d = nil

end --func end
--next--
function GuildTeamBlank:OnDeActive()

    self.targetUid = 0

end --func end
--next--
function GuildTeamBlank:OnSetData(data)

    if not data.hasShow then
        self.Parameter.RoleInfoImg.UObj:SetActiveEx(false)
        return
    end
    self.Parameter.RoleInfoImg.UObj:SetActiveEx(true)
    self.Parameter.TxtPlayerName.LabText = data.memberInfo.roleName
    if data.memberInfo.roleType then
        self.Parameter.Img_Profession:SetSpriteAsync("Common", DataMgr:GetData("TeamData").GetProfessionImageById(data.memberInfo.roleType))
    end
    if not self.head2d then
        self.head2d = self:CreateHead2D(self.Parameter.Img_PlayerHead.transform)
    end
    local l_info = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.memberInfo.member_info)
    self.head2d:SetRoleHead(l_info)
    self.targetUid = data.memberInfo.roleId
    self.Parameter.Img_PlayerHead:AddClick(function()
        if self.targetUid ~= 0 then
            local l_uid = self.targetUid
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(l_uid)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildTeamBlank