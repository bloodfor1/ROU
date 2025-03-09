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
---@class TeamSearchLineTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field XieTong MoonClient.MLuaUICom
---@field TplTeam MoonClient.MLuaUICom
---@field TeamTarget MoonClient.MLuaUICom
---@field TeamName MoonClient.MLuaUICom
---@field TeamLv MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field CapName MoonClient.MLuaUICom
---@field btnText MoonClient.MLuaUICom
---@field BtnApply MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom
---@field BG5 MoonClient.MLuaUICom
---@field BG4 MoonClient.MLuaUICom
---@field BG3 MoonClient.MLuaUICom
---@field BG2 MoonClient.MLuaUICom

---@class TeamSearchLineTem : BaseUITemplate
---@field Parameter TeamSearchLineTemParameter

TeamSearchLineTem = class("TeamSearchLineTem", super)
--lua class define end

--lua functions
function TeamSearchLineTem:Init()

    super.Init(self)
    self.headComp = nil
    self.TeamId = 0
    self.Parameter.XieTong.Listener:SetActionClick(function(_self, go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("TEAM_XIE_TONG"), eventData, Vector2(0, 0))
    end, self)

end --func end
--next--
function TeamSearchLineTem:BindEvents()


end --func end
--next--
function TeamSearchLineTem:OnDestroy()

    self.headComp = nil
    self.Parameter.XieTong.Listener.onClick = nil

end --func end
--next--
function TeamSearchLineTem:OnDeActive()


end --func end
--next--
function TeamSearchLineTem:OnSetData(data)
    self.TeamId = data.team_id
    local newProTb = self:GetNewProfessTbExceptCap(data.captain.type, data.profession_ids)
    self.Parameter.TeamName.LabText = Common.Utils.Lang("TEAM_LEVEL_LIMIT") .. "Lv" .. data.min_level .. "-Lv" .. data.max_level
    self.Parameter.CapName.LabText = Common.Utils.PlayerName(data.captain.name)
    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, data.captain.tag)
    self.Parameter.XieTong:SetActiveEx(data.show_cooperation == 1)
    self.Parameter.TeamTarget.LabText = Common.Utils.Lang("TEAM_TARGET") .. DataMgr:GetData("TeamData").GetTargetNameById(data.target)
    self.Parameter.btnText.LabText = Lang("TEAM_JOIN_TITLE")
    local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.captain)
    local param = {
        EquipData = equipData,
        ShowProfession = true,
        Profession = data.captain.type,
        ShowLv = true,
        Level = data.captain.base_level
    }
    if self.headComp == nil then
        self.headComp = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.HeadDummy.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end
    self.headComp:SetData(param)
    for i = 2, 5 do
        if newProTb[i - 1] then
            local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(newProTb[i - 1].value)
            if imageName then
                self.Parameter["BG" .. i]:SetSpriteAsync("Common", imageName)
            end
        else
            self.Parameter["BG" .. i]:SetSpriteAsync("Common", "UI_Common_Boardmid22.png")
        end
    end
    self.Parameter.BtnApply:AddClickWithLuaSelf(self.BegInTeam, self)

end --func end
--next--
--lua functions end

--lua custom scripts
function TeamSearchLineTem:GetNewProfessTbExceptCap(cpType, typeTb)
    local newTb = {}
    local num = 0
    for i = 1, table.maxn(typeTb) do
        if typeTb[i].value == cpType then
            num = i
            break
        end
    end

    for z = 1, table.maxn(typeTb) do
        if z ~= num then
            table.insert(newTb, typeTb[z])
        end
    end

    return newTb
end

function TeamSearchLineTem:BegInTeam()
    MgrMgr:GetMgr("TeamMgr").BegInTeamByTeamId(self.TeamId)
end
--lua custom scripts end
return TeamSearchLineTem