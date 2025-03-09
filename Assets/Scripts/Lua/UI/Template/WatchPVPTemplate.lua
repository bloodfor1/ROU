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
---@class WatchPVPTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TeamName02 MoonClient.MLuaUICom
---@field TeamName01 MoonClient.MLuaUICom
---@field Team02P MoonClient.MLuaUICom
---@field Team02 MoonClient.MLuaUICom
---@field Team01P MoonClient.MLuaUICom
---@field Team01 MoonClient.MLuaUICom
---@field Single2 MoonClient.MLuaUICom
---@field Single1 MoonClient.MLuaUICom
---@field Head2D2 MoonClient.MLuaUICom
---@field Head2D1 MoonClient.MLuaUICom
---@field Btn_N_S01 MoonClient.MLuaUICom

---@class WatchPVPTemplate : BaseUITemplate
---@field Parameter WatchPVPTemplateParameter

WatchPVPTemplate = class("WatchPVPTemplate", super)
--lua class define end

--lua functions
function WatchPVPTemplate:Init()
    super.Init(self)
    self.head2d_1 = nil
    self.head2d_2 = nil
    self.professionTemplate1 = nil
    self.professionTemplate2 = nil
    self.membersProfeessionTemplatePool1 = nil
    self.membersProfeessionTemplatePool2 = nil
end --func end
--next--
function WatchPVPTemplate:OnDestroy()
    self.head2d_1 = nil
    self.head2d_2 = nil
    self.professionTemplate1 = nil
    self.professionTemplate2 = nil
    self.membersProfeessionTemplatePool1 = nil
    self.membersProfeessionTemplatePool2 = nil
end --func end
--next--
function WatchPVPTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function WatchPVPTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function WatchPVPTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function WatchPVPTemplate:CustomSetData(data)
    local l_teamInfo1 = data.orginalData.team[1]
    local l_teamInfo2 = data.orginalData.team[2]
    if l_teamInfo1 == nil or l_teamInfo2 == nil then
        logError("WatchPVPTemplate found teaminfo is nil", ToString(data.orginalData))
        return
    end

    self:EnsureCreateHead2D()
    self:EnsureCreateProTemplates(data)
    local onHead1Click = function()
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(l_teamInfo1.captain.role_uid)
    end

    local onHead2Click = function()
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(l_teamInfo2.captain.role_uid)
    end

    ---@type HeadTemplateParam
    local param1 = {}
    local equipData1 = nil
    local l_hide1 = self:IsCaptainHideOutlook(l_teamInfo1)
    if l_hide1 then
        equipData1 = MgrMgr:GetMgr("PlayerInfoMgr").GetDefaultEquip(l_teamInfo1.captain.type, l_teamInfo1.captain.sex or 0)
        param1.EquipData = equipData1
    else
        equipData1 = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_teamInfo1.captain)
        param1.EquipData = equipData1
        param1.OnClick = onHead1Click
    end

    self.head2d_1:SetData(param1)
    ---@type HeadTemplateParam
    local param2 = {}
    local equipData2 = nil
    local l_hide2 = self:IsCaptainHideOutlook(l_teamInfo2)
    if l_hide2 then
        equipData2 = MgrMgr:GetMgr("PlayerInfoMgr").GetDefaultEquip(l_teamInfo2.captain.type, l_teamInfo2.captain.sex or 0)
        param2.EquipData = equipData2
    else
        equipData2 = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_teamInfo2.captain)
        param2.EquipData = equipData2
        param2.OnClick = onHead2Click
    end

    self.head2d_2:SetData(param2)
    self.Parameter.TeamName01.LabText = self:GetTeamTitle(l_teamInfo1, l_hide1)
    self.Parameter.TeamName02.LabText = self:GetTeamTitle(l_teamInfo2, l_hide2)
    self:UpdateMembersProfession(l_teamInfo1, l_teamInfo2)
    self.Parameter.Btn_N_S01:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(true, "", Lang("ENSURE_WATCHWAR", Common.CommonUIFunc.GetDungonNameByDungonID(data.orginalData.dungeon_id)), function()
            MgrMgr:GetMgr("WatchWarMgr").RequestWatchRoom(data.orginalData.sequence_uid)
        end)
    end)

    self.Parameter.Btn_N_S01.gameObject:SetActiveEx(not data.frezze)
end

function WatchPVPTemplate:UpdateOneTeamProfession(key1, key2, info)
    self[key1]:SetData(info.captain.type)
    local l_captainUid = tostring(info.captain.role_uid)
    local l_membersData = {}
    for i, v in ipairs(info.members) do
        if tostring(v.uid) ~= l_captainUid then
            table.insert(l_membersData, v.type)
        end
    end

    for i = #l_membersData + 1, 4 do
        table.insert(l_membersData, 0)
    end

    self[key2]:ShowTemplates({ Datas = l_membersData })
end

function WatchPVPTemplate:UpdateMembersProfession(teamInfo1, teamInfo2)
    self:UpdateOneTeamProfession("professionTemplate1", "membersProfeessionTemplatePool1", teamInfo1)
    self:UpdateOneTeamProfession("professionTemplate2", "membersProfeessionTemplatePool2", teamInfo2)
end

function WatchPVPTemplate:EnsureCreateHead2D()
    if not self.head2d_1 then
        self.head2d_1 = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Single1.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    if not self.head2d_2 then
        self.head2d_2 = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Single2.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end
end

function WatchPVPTemplate:CreateOneProTemplate(key, parent, posX, func)
    self[key] = self:NewTemplate("WatchProTemplate", {
        TemplatePrefab = func(),
        TemplateParent = parent,
    })

    self[key]:AddLoadCallback(function()
        local l_go = self[key]:gameObject()
        MLuaCommonHelper.SetRectTransformPos(l_go, posX, -26)
        MLuaCommonHelper.SetLocalScale(l_go, 1, 1, 1)
    end)
end

function WatchPVPTemplate:CreateOneProTemplatePool(key, parent, func)

    self[key] = self:NewTemplatePool({
        TemplatePrefab = func(),
        UITemplateClass = UITemplate.WatchProTemplate,
        TemplateParent = parent,
    })
end

function WatchPVPTemplate:EnsureCreateProTemplates(data)

    if not self.professionTemplate1 then
        self:CreateOneProTemplate("professionTemplate1", self.Parameter.Team01.transform, 24, data.proFunc)
    end

    if not self.professionTemplate2 then
        self:CreateOneProTemplate("professionTemplate2", self.Parameter.Team02.transform, 236, data.proFunc)
    end

    if not self.membersProfeessionTemplatePool1 then
        self:CreateOneProTemplatePool("membersProfeessionTemplatePool1", self.Parameter.Team01P.transform, data.proFunc)
    end

    if not self.membersProfeessionTemplatePool2 then
        self:CreateOneProTemplatePool("membersProfeessionTemplatePool2", self.Parameter.Team02P.transform, data.proFunc)
    end
end

-- 没有队伍时，返回"某某某的队伍"
function WatchPVPTemplate:GetTeamTitle(teamInfo, hide)
    if teamInfo.team_name and string.len(teamInfo.team_name) > 0 then
        return teamInfo.team_name
    else
        if hide then
            return Lang("TEAM_DEFAULT_NAME", Lang("Mysterious_Adventurer"))
        end
        return Lang("TEAM_DEFAULT_NAME", teamInfo.captain.name)
    end
end

function WatchPVPTemplate:IsCaptainHideOutlook(teaminfo)
    local captainUid = tostring(teaminfo.captain.role_uid)
    for i, v in ipairs(teaminfo.members) do
        if tostring(v.uid) == captainUid then
            return v.is_hit_outlook
        end
    end
    return false
end
--lua custom scripts end
return WatchPVPTemplate