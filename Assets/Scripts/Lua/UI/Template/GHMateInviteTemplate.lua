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
---@class GHMateInviteTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Score MoonClient.MLuaUICom
---@field RankItemPrefab MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field LvAndJob MoonClient.MLuaUICom
---@field IsSelect MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field FriendBtn MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field ChatBtn MoonClient.MLuaUICom

---@class GHMateInviteTemplate : BaseUITemplate
---@field Parameter GHMateInviteTemplateParameter

GHMateInviteTemplate = class("GHMateInviteTemplate", super)
--lua class define end

--lua functions
function GHMateInviteTemplate:Init()
    super.Init(self)
	self._head = self:NewTemplate("HeadWrapTemplate", {
		TemplateParent = self.Parameter.HeadDummy.transform,
		TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	})
end --func end
--next--
function GHMateInviteTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function GHMateInviteTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function GHMateInviteTemplate:OnSetData(data)
    self.data = data  -- 记录数据 点击回调用
    --初始化选中
    self:SetSelect(data.isSelect or false)
	---@type HeadTemplateParam
	local param = {
		EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.member)
	}

	self._head:SetData(param)
    --姓名 职业 等级 得分
    self.Parameter.PlayerName.LabText = data.member.name
    local l_jobName = DataMgr:GetData("TeamData").GetProfessionNameById(data.member.type)
    self.Parameter.LvAndJob.LabText = StringEx.Format("Lv.{0} {1}", data.member.base_level, l_jobName)
    self.Parameter.Score.LabText = data.score
    self.Parameter.Count.LabText = data.remain
    --点击事件
    self.Parameter.RankItemPrefab:AddClick(function()
        self:MethodCallback()
    end)
    if tostring(MPlayerInfo.UID) == tostring(data.member.role_uid) then
        self.Parameter.FriendBtn:SetActiveEx(false)
        self.Parameter.ChatBtn:SetActiveEx(false)
    else
        self.Parameter.FriendBtn:SetActiveEx(true)
        self.Parameter.ChatBtn:SetActiveEx(true)
        self.Parameter.FriendBtn:AddClick(function()
            MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(data.member.role_uid, function(obj)
                local l_playerInfo = obj
                local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
                if data.member.role_uid and data.member.role_uid ~= -1 then
                    if selfInTeam and not selfIsCaptain then
                        --如果玩家有组队 但是不是队长 那么发出推荐组队
                        MgrMgr:GetMgr("TeamMgr").RecommandMember(data.member.role_uid)
                    else
                        if l_playerInfo ~= nil then
                            MgrMgr:GetMgr("TeamMgr").InviteJoinTeam(data.member.role_uid, l_playerInfo.level)
                        else
                            MgrMgr:GetMgr("TeamMgr").InviteJoinTeam(data.member.role_uid)
                        end
                    end
                end
            end)
        end)
        self.Parameter.ChatBtn:AddClick(function()
            MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(data.member.role_uid, function(obj)
                local l_playerInfo = obj
                if l_playerInfo ~= nil then
                    MgrMgr:GetMgr("FriendMgr").AddTemporaryContacts(l_playerInfo.data)
                    UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
                    MgrMgr:GetMgr("FriendMgr").OpenFriendAndSetUID(l_playerInfo.uid)
                end
            end)
        end)
    end

end --func end
--next--
function GHMateInviteTemplate:BindEvents()
	-- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function GHMateInviteTemplate:SetSelect(isSelect)
    self.data.isSelect = isSelect
    self.Parameter.IsSelect.UObj:SetActiveEx(isSelect)
end
--lua custom scripts end
return GHMateInviteTemplate