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
---@class EmbeddedTeamTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Remove MoonClient.MLuaUICom[]
---@field ProfessionImg MoonClient.MLuaUICom[]
---@field Name MoonClient.MLuaUICom[]
---@field Level MoonClient.MLuaUICom[]
---@field Info MoonClient.MLuaUICom[]
---@field HeadDummy MoonClient.MLuaUICom[]
---@field Head MoonClient.MLuaUICom[]
---@field AddText MoonClient.MLuaUICom[]
---@field Add MoonClient.MLuaUICom[]

---@class EmbeddedTeamTemplate : BaseUITemplate
---@field Parameter EmbeddedTeamTemplateParameter

EmbeddedTeamTemplate = class("EmbeddedTeamTemplate", super)
--lua class define end

--lua functions
function EmbeddedTeamTemplate:Init()
    super.Init(self)
    self._playerIconHeads = {}
    self.teamData = DataMgr:GetData("TeamData")
    self:Refresh()
end --func end
--next--
function EmbeddedTeamTemplate:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, function()
        self:Refresh()
    end)
end --func end
--next--
function EmbeddedTeamTemplate:OnDestroy()
    self._playerIconHeads = nil
end --func end
--next--
function EmbeddedTeamTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function EmbeddedTeamTemplate:OnSetData(data)
    self.targetTeamId = data.targetTeamId or -1
end --func end
--next--
--lua functions end

--lua custom scripts
EmbeddedTeamTemplate.TemplatePath = "UI/Prefabs/EmbeddedTeamTemplate"
function EmbeddedTeamTemplate:Refresh()
    ---@type ClientTeamInfo
    local l_teamData = DataMgr:GetData("TeamData").myTeamInfo
    local l_memberList = l_teamData.memberList
    local l_inTeam, l_isCaptain = self.teamData.GetPlayerTeamInfo()
    if 0 >= #self._playerIconHeads then
        for i = 1, 5 do
            self._playerIconHeads[i] = self:NewTemplate("HeadWrapTemplate", {
                TemplateParent = self.Parameter.HeadDummy[i].transform,
                TemplatePath = "UI/Prefabs/HeadWrapTemplate"
            })
        end
    end

    for i = 1, 5 do
        local l_memberInfo = l_memberList[i]
        self.Parameter.Info[i]:SetActiveEx(l_inTeam and l_memberInfo ~= nil)
        self.Parameter.Add[i]:SetActiveEx(not l_inTeam or not l_memberInfo)
        self.Parameter.AddText[i].LabText = l_inTeam and Lang("CAN_ADD") or Lang("CAN_TEAM")
        self.Parameter.Remove[i]:SetActiveEx(l_inTeam and l_isCaptain and i ~= 1 and l_memberInfo ~= nil)
        self.Parameter.Remove[i]:AddClick(function()
            MgrMgr:GetMgr("TeamMgr").SetLeaveTeamByCaptainFunc(l_memberInfo.roleId)
        end)

        local click = function()
            if l_memberInfo and MPlayerInfo.UID ~= l_memberInfo.roleId then
                MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(l_memberInfo.roleId)
            end
        end

        self.Parameter.Add[i]:AddClick(function()
            if l_inTeam then
                MgrMgr:GetMgr("TeamMgr").ShowTeamView()
            else
                UIMgr:ActiveUI(UI.CtrlNames.TeamSearch, function(ctrl)
                    ctrl:SetTeamTargetId(self.targetTeamId)
                end)
            end
        end)

        -- 设置角色信息
        local hasRoleInfo = false ~= l_inTeam and nil ~= l_memberInfo
        self.Parameter.HeadDummy[i]:SetActiveEx(hasRoleInfo)
        if hasRoleInfo then
            self.Parameter.Level[i].LabText = "Lv." .. l_memberInfo.roleLevel
            self.Parameter.Name[i].LabText = Common.Utils.GetCutOutText(l_memberInfo.roleName, 4)
            local l_imageName = DataMgr:GetData("TeamData").GetProfessionImageById(l_memberInfo.roleType)
            self.Parameter.ProfessionImg[i]:SetSprite("Common", l_imageName)
            ---@type HeadTemplateParam
            local param = {
                EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_memberInfo.roleBriefInfo),
                OnClick = click,
            }

            self._playerIconHeads[i]:SetData(param)
        end
    end
end
--lua custom scripts end
return EmbeddedTeamTemplate