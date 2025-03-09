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
local fxPath = "Effects/Prefabs/Creature/Ui/Fx_ui_dwgl"
--next--
--lua fields end

--lua class define
---@class GuildTeamShowParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTeamName MoonClient.MLuaUICom
---@field SubHint MoonClient.MLuaUICom
---@field ReplaceBtn MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field BtnAward MoonClient.MLuaUICom
---@field BlockPanel MoonClient.MLuaUICom

---@class GuildTeamShow : BaseUITemplate
---@field Parameter GuildTeamShowParameter

GuildTeamShow = class("GuildTeamShow", super)
--lua class define end

--lua functions
function GuildTeamShow:Init()

    super.Init(self)
    self.MemberBlockTem = nil
    self.Parameter.BtnAward:AddClick(function()
        if self.TeamType then
            ---@type ModuleMgr.GuildMatchMgr
            local l_Mgr = MgrMgr:GetMgr("GuildMatchMgr")
            l_Mgr.GetGuildBattleTeamInfo(self.TeamType)
            local l_openData = {
                openType = DataMgr:GetData("GuildMatchData").EUIOpenType.OpenSelPanel,
                teamType = self.TeamType
            }
            UIMgr:ActiveUI(UI.CtrlNames.GuildTeamReplace, l_openData)
        end
    end)
    self.Parameter.ReplaceBtn:AddClick(function()
        if self.TeamType then
            local l_Mgr = MgrMgr:GetMgr("GuildMatchMgr")
            l_Mgr.ReplaceTeamInfo(self.TeamType, self.TeamType + 1)
            l_Mgr.EventDispatcher:Dispatch(l_Mgr.ON_REFRESH_TEAM_MGR)     --抛出选择界面更新事件
        end
    end)

end --func end
--next--
function GuildTeamShow:BindEvents()


end --func end
--next--
function GuildTeamShow:OnDestroy()

    self:ClearEffects()

end --func end
--next--
function GuildTeamShow:OnDeActive()
    -- do nothing
end --func end
--next--
function GuildTeamShow:OnSetData(data)
    self.Parameter.TxtTeamName.LabText = data.TeamName
    self.Parameter.TxtTeamName:SetOutLineColor(data.TeamNameOutLineColor)
    self.Parameter.TxtTeamName.LabColor = data.TeamNameColor
    self.Parameter.ReplaceBtn:SetActiveEx(data.TeamType < DataMgr:GetData("GuildMatchData").battleTeamNum)
    local l_ShowBlockData = {}
    local l_MgrTeamInfo = data.TeamInfo
    if l_MgrTeamInfo then
        if #l_MgrTeamInfo == 0 then
            self:CreateEffects()
        else
            self:ClearEffects()
        end

        for i = 1, #l_MgrTeamInfo do
            local onClick = function()
                MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(l_MgrTeamInfo[i].roleId)
            end

            local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_MgrTeamInfo[i].member_info)
            ---@type HeadTemplateParam
            local headParam = {
                EquipData = equipData,
                ShowProfession = true,
                Profession = l_MgrTeamInfo[i].roleType,
                ShowName = true,
                Name = l_MgrTeamInfo[i].roleName,
                OnClick = onClick
            }

            table.insert(l_ShowBlockData, headParam)
        end
    end

    if not self.MemberBlockTem then
        self.MemberBlockTem = self:NewTemplatePool({
            TemplateClassName = "HeadWrapTemplate",
            TemplatePath = "UI/Prefabs/HeadWrapTemplate",
            TemplateParent = self.Parameter.BlockPanel.Transform
        })
    end

    self.Parameter.SubHint:SetActiveEx(false)
    self.MemberBlockTem:ShowTemplates({ Datas = l_ShowBlockData })
    local l_rtTrans = self.Parameter.BlockPanel.Transform
    LayoutRebuilder.ForceRebuildLayoutImmediate(l_rtTrans)
    self.TeamType = data.TeamType

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildTeamShow:CreateEffects()

    self:ClearEffects()

    local l_fxViewCom = self.Parameter.RawImage
    local l_fxPath = fxPath
    local l_fxData_effect = {}
    l_fxData_effect.rawImage = l_fxViewCom.RawImg
    l_fxData_effect.loadedCallback = function()
        l_fxViewCom.gameObject:SetActiveEx(true)
    end
    l_fxData_effect.destroyHandler = function()
        self.effect = nil
    end
    self.effect = self:CreateUIEffect(l_fxPath, l_fxData_effect)
end

function GuildTeamShow:ClearEffects()

    if self.effect ~= nil then
        self:DestroyUIEffect(self.effect)
        self.effect = nil
    end
    self.Parameter.RawImage:SetActiveEx(false)

end
--lua custom scripts end
return GuildTeamShow