--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/WatchProTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class WatchSingleTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TeamName01 MoonClient.MLuaUICom
---@field Team01 MoonClient.MLuaUICom
---@field Single MoonClient.MLuaUICom
---@field Head2D MoonClient.MLuaUICom
---@field Btn_N_S01 MoonClient.MLuaUICom

---@class WatchSingleTemplate : BaseUITemplate
---@field Parameter WatchSingleTemplateParameter

WatchSingleTemplate = class("WatchSingleTemplate", super)
--lua class define end

--lua functions
function WatchSingleTemplate:Init()

    super.Init(self)
    self.Head2D = nil

end --func end
--next--
function WatchSingleTemplate:OnDestroy()

    self.head2d = nil
    self.professionTemplate = nil
    self.membersProfeessionTemplatePool = nil

end --func end
--next--
function WatchSingleTemplate:OnDeActive()


end --func end
--next--
function WatchSingleTemplate:OnSetData(data)

    self:CustomSetData(data)

end --func end
--next--
function WatchSingleTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function WatchSingleTemplate:CustomSetData(data)

    local l_teamInfo = data.orginalData.team[1]
    if l_teamInfo == nil then
        logError("WatchSingleTemplate found teaminfo is nil", ToString(data.orginalData))
        return
    end

    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Single.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    local onClick = function()
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(l_teamInfo.captain.role_uid)
    end

    self:EnsureCreateProTemplates(data)
    local l_hide = self:IsCaptainHideOutlook(l_teamInfo)
    local equipData = nil
    if l_hide then
        equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetDefaultEquip(l_teamInfo.captain.type, l_teamInfo.captain.sex or 0)
    else
        equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_teamInfo.captain)
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = equipData,
    }
    if not l_hide then
        param.OnClick = onClick
    end
    self.head2d:SetData(param)
    self.Parameter.TeamName01.LabText = self:GetTeamTitle(l_teamInfo, l_hide)
    self:UpdateMembersProfession(l_teamInfo)
    self.Parameter.Btn_N_S01:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(true, "", Lang("ENSURE_WATCHWAR", Common.CommonUIFunc.GetDungonNameByDungonID(data.orginalData.dungeon_id)), function()
            MgrMgr:GetMgr("WatchWarMgr").RequestWatchRoom(data.orginalData.sequence_uid)
        end)
    end)

    self.Parameter.Btn_N_S01.gameObject:SetActiveEx(not data.frezze)
end

function WatchSingleTemplate:EnsureCreateProTemplates(data)

    if not self.professionTemplate then
        self.professionTemplate = self:NewTemplate("WatchProTemplate", {
            TemplatePrefab = data.proFunc(),
            TemplateParent = self.Parameter.LuaUIGroup.transform,
        })
        self.professionTemplate:AddLoadCallback(function()
            local l_go = self.professionTemplate:gameObject()
            MLuaCommonHelper.SetRectTransformPos(l_go, 26, -23)
            MLuaCommonHelper.SetLocalScale(l_go, 1, 1, 1)
        end)
    end

    if not self.membersProfeessionTemplatePool then
        self.membersProfeessionTemplatePool = self:NewTemplatePool({
            TemplatePrefab = data.proFunc(),
            UITemplateClass = UITemplate.WatchProTemplate,
            TemplateParent = self.Parameter.Team01.transform,
        })
    end
end

function WatchSingleTemplate:UpdateMembersProfession(teamInfo)
    self.professionTemplate:SetData(teamInfo.captain.type)
    local l_captainUid = tostring(teamInfo.captain.role_uid)
    local l_membersData = {}
    for i, v in ipairs(teamInfo.members) do
        if tostring(v.uid) ~= l_captainUid then
            table.insert(l_membersData, v.type)
        end
    end
    for i = #l_membersData + 1, 4 do
        table.insert(l_membersData, 0)
    end
    self.membersProfeessionTemplatePool:ShowTemplates({ Datas = l_membersData })
end

-- 没有队伍时，返回"某某某的队伍"
function WatchSingleTemplate:GetTeamTitle(teamInfo, hide)
    if teamInfo.team_name and string.len(teamInfo.team_name) > 0 then
        return teamInfo.team_name
    else
        if hide then
            return Lang("TEAM_DEFAULT_NAME", Lang("Mysterious_Adventurer"))
        end
        return Lang("TEAM_DEFAULT_NAME", teamInfo.captain.name)
    end
end

function WatchSingleTemplate:IsCaptainHideOutlook(teaminfo)
    local captainUid = tostring(teaminfo.captain.role_uid)
    for i, v in ipairs(teaminfo.members) do
        if tostring(v.uid) == captainUid then
            return v.is_hit_outlook
        end
    end
    return false
end
--lua custom scripts end
return WatchSingleTemplate