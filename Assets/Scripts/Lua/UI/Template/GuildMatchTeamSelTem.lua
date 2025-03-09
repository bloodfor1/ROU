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
---@class GuildMatchTeamSelTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TeamName MoonClient.MLuaUICom
---@field SubHint MoonClient.MLuaUICom
---@field ShowPanel MoonClient.MLuaUICom
---@field OnChoose MoonClient.MLuaUICom
---@field BtnChoose MoonClient.MLuaUICom

---@class GuildMatchTeamSelTem : BaseUITemplate
---@field Parameter GuildMatchTeamSelTemParameter

GuildMatchTeamSelTem = class("GuildMatchTeamSelTem", super)
--lua class define end

--lua functions
function GuildMatchTeamSelTem:Init()

    super.Init(self)
    self.Parameter.BtnChoose:AddClick(function()
        self.MethodCallback(self.ShowIndex, self.uuid)
    end)

end --func end
--next--
function GuildMatchTeamSelTem:BindEvents()
    -- do nothing
end --func end
--next--
function GuildMatchTeamSelTem:OnDestroy()
    -- do nothing
end --func end
--next--
function GuildMatchTeamSelTem:OnDeActive()
    -- do nothing
end --func end
--next--
function GuildMatchTeamSelTem:OnSetData(data)
    self.uuid = data.uuid
    self.Parameter.OnChoose:SetActiveEx(false)
    if data.TeamName then
        self.Parameter.TeamName.LabText = data.TeamName
        self.Parameter.TeamName.UObj:SetActiveEx(true)
        self.Parameter.TeamName:SetOutLineColor(data.TeamNameOutLineColor)
        self.Parameter.TeamName.LabColor = data.TeamNameColor
    else
        self.Parameter.TeamName.UObj:SetActiveEx(false)
    end

    self.Parameter.SubHint:SetActiveEx(data.isSelect)
    local l_ShowBlockData = {}
    local l_MgrTeamInfo = data.TeamInfo
    if l_MgrTeamInfo then
        for i = 1, table.maxn(l_MgrTeamInfo) do
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
            TemplateParent = self.Parameter.ShowPanel.Transform
        })
    end
    self.MemberBlockTem:ShowTemplates({ Datas = l_ShowBlockData })
    local l_rtTrans = self.Parameter.ShowPanel.Transform
    LayoutRebuilder.ForceRebuildLayoutImmediate(l_rtTrans)

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildMatchTeamSelTem:OnSelect()
    self.Parameter.OnChoose:SetActiveEx(true)
end

function GuildMatchTeamSelTem:OnDeselect()
    self.Parameter.OnChoose:SetActiveEx(false)
end
--lua custom scripts end
return GuildMatchTeamSelTem