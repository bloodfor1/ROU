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
---@class RankRowNameTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RankRowName MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom

---@class RankRowNameTem : BaseUITemplate
---@field Parameter RankRowNameTemParameter
RankRowNameTem = class("RankRowNameTem", super)
--lua class define end

--lua functions
function RankRowNameTem:Init()

    super.Init(self)

end --func end
--next--
function RankRowNameTem:BindEvents()


end --func end
--next--
function RankRowNameTem:OnDestroy()


end --func end
--next--
function RankRowNameTem:OnDeActive()


end --func end
--next--

function RankRowNameTem:OnSetData(data)
    MLuaCommonHelper.SetRectTransformWidth(self:gameObject(), data.columnWidth)
    self.Parameter.PlayerName.LabText = data.value
    self.Parameter.PlayerName.LabColor = data.color
    --data.membersInfo = nil
    self.Parameter.RankRowName:AddClick(function()
        if data.membersInfo[1].id ~= 0 and data.showMemberType == DataMgr:GetData("RankData").EShowMemberType.Single then
            local l_uid = data.membersInfo[1].id
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(l_uid)
        elseif data.membersInfo[1].id ~= 0 and data.showMemberType == DataMgr:GetData("RankData").EShowMemberType.Team then
            local IdTb = {}
            for _, v in ipairs(data.membersInfo) do
                table.insert(IdTb, { value = v.id })
            end
            --UIMgr:ActiveUI(UI.CtrlNames.ShowTeamMember)
            MgrMgr:GetMgr("TeamMgr").GetRoleInfoListByIds(IdTb, DataMgr:GetData("TeamData").ERoleInfoType.Rank)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RankRowNameTem