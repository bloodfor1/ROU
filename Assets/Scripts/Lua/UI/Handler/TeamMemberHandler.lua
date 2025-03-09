require "UI/UIBaseHandler"
require "UI/Panel/TeamMemberPanel"

module("UI", package.seeall)

local super = UI.UIBaseHandler
TeamMemberHandler = class("TeamMemberHandler", super)

local l_rt = nil

function TeamMemberHandler:ctor()
    super.ctor(self, "TeamMember")
end

function TeamMemberHandler:Init()
    self.panel = UI.TeamMemberPanel.Bind(self)
    super.Init(self)

    self._commonMsg = nil
    self.memberTemPool = nil
    self.panel.ButtonQuit:AddClick(function()
        local stageEnum = StageMgr:GetCurStageEnum()
        if stageEnum == MStageEnum.RingPre then
            local _, round = MgrMgr:GetMgr("DailyTaskMgr").GetRoundFightInfo()
            if round > 0 and round <= MgrMgr:GetMgr("ArenaMgr").ArenaBattleRounds then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("ARENA_LEAVE_TEAM_IN_WAITING"), function()
                    MgrMgr:GetMgr("TeamMgr").LeaveTeam()
                end)
            else
                MgrMgr:GetMgr("TeamMgr").LeaveTeam()
            end
        else
            MgrMgr:GetMgr("TeamMgr").LeaveTeam()
        end
    end)

    self:InitTeamMemberPanel()
    self.hasInit = true
    --用于动画
    self.startPlayAni = false
    self.remainTime = 1
    self.maxPoint = 0

    self.panel.ButtonQuit.gameObject:SetActiveEx(true)

    self:RefreshPairBtn()
    self.panel.ButtonAutoTeam:AddClick(function()

        if DataMgr:GetData("TeamData").GetTeamNum() == DataMgr:GetData("TeamData").maxTeamNumber then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_SHOUT_FAIL_AUTOPAIR"))
            return
        end

        local teamSetting = DataMgr:GetData("TeamData").myTeamInfo.teamSetting
        if teamSetting.target == 1000 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHOOSE_TEAMTARGET_FIRST"))
            return
        end

        local data = DataMgr:GetData("TeamData").myTeamInfo
        if data then
            if not DataMgr:GetData("TeamData").isAutoPair then
                local isFreeMatch = TableUtil.GetTeamTargetTable().GetRowByID(teamSetting.target).IsDuty
                if not isFreeMatch then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_MATCH_FREE"))
                    MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, teamSetting.target)
                else
                    local teamSetting = data.teamSetting
                    local l_opendata = {
                        state = GameEnum.ETeamMatchOption.MatchMember,
                    }
                    UIMgr:ActiveUI(UI.CtrlNames.TeamCareerChoice1, l_opendata)
                end
                --MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, teamSetting.target)
            else
                local teamSetting = data.teamSetting
                MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeEnd, teamSetting.target)
            end
        end
    end)
    self.panel.ExpShowPanel.gameObject:SetActiveEx(false)
    self.panel.CloseExpBtn.gameObject:SetActiveEx(false)
    self.panel.CloseExpBtn:AddClick(function()
        self.panel.CloseExpBtn.gameObject:SetActiveEx(false)
        self.panel.ExpShowPanel.gameObject:SetActiveEx(false)
    end)
    self.panel.obj_ProfessionList.gameObject:SetActiveEx(false)
    for i = 1, 5 do
        self.panel.Img_ProIcon[i].gameObject:SetActiveEx(false)
    end
    self.panel.BtnExp:AddClick(function()
        local l_professionList = MgrMgr:GetMgr("TeamMgr").GetTeamTotalProfession()
        self.panel.expTips[1].LabText = Common.Utils.Lang("TEAM_MEMBER_NUM_EXP1")
        for i = 2, 5 do
            self.panel.expTips[i].LabColor = UIDefineColor.DeclarativeColor
            self.panel.expTips[i].LabText = Common.Utils.Lang("TEAM_MEMBER_NUM_EXP2", i, tonumber(TableUtil.GetTeamExpBonus().GetRowByTeamNum(i).Bonus) - 100)
        end
        local l_memberNum = DataMgr:GetData("TeamData").GetTeamNum()
        self.panel.ExpShowPanel.gameObject:SetActiveEx(true)
        self.panel.CloseExpBtn.gameObject:SetActiveEx(true)
        local l_professionNum = table.ro_size(l_professionList)
        if l_memberNum > 1 then
            self.panel.expTips[l_memberNum].LabColor = Color.New(0x51 / 255, 0xbe / 255, 0x91 / 255);
        end
        -- self.panel.obj_ProfessionList.gameObject:SetActiveEx(l_professionNum>0)
        -- for l_num = 1, l_professionNum do
        --     local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(l_professionList[l_num])
        --     if imageName then
        --         self.panel.Img_ProIcon[l_num].gameObject:SetActiveEx(true)
        --         self.panel.Img_ProIcon[l_num]:SetSpriteAsync("Common", imageName)
        --     end
        -- end
    end)
    self.panel.ButtonOneKeyTalk:AddClick(function()

        if DataMgr:GetData("TeamData").GetTeamNum() == DataMgr:GetData("TeamData").maxTeamNumber then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_SHOUT_FAIL_ONEKEYTALK"))
            return
        end

        local teamSetting = DataMgr:GetData("TeamData").myTeamInfo.teamSetting
        if teamSetting.target == 1000 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHOOSE_TEAMTARGET_FIRST_THENSEND"))
            return
        end
        MgrMgr:GetMgr("TeamMgr").TeamShout()
    end)

    self.panel.ButtonOneKeyFollow:AddClick(function()
        MgrMgr:GetMgr("TeamMgr").ToBeFollowedAll()
    end)

    self.panel.ButtonFollowCaptain:AddClick(function()
        MgrMgr:GetMgr("TeamMgr").FollowOtherPeople(DataMgr:GetData("TeamData").myTeamInfo.captainId)
    end)
    self:SetTeamInfo()

    --self.panel.ButtonSuit:AddClick(function()
    --    if TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).MerceneryNotAllow == nil or TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).MerceneryNotAllow == 0 then
    --        UIMgr:ActiveUI(UI.CtrlNames.MercenarySelection, function()
    --            --MgrMgr:GetMgr("TeamMgr").ResetSelectMercenaryTb()
    --            MgrMgr:GetMgr("TeamMgr").GetTeamAllMercenary()
    --        end)
    --    elseif TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).MerceneryNotAllow == 2 then
    --        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Mercenary_Fight_Tips2"))
    --    else
    --        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Mercenary_Fight_Tips1"))
    --    end
    --
    --end)
end

function TeamMemberHandler:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.memberTemPool = nil
end

function TeamMemberHandler:OnActive()
    MgrMgr:GetMgr("TeamMgr").GetTeamInfo()
    MgrMgr:GetMgr("TeamMgr").QueryAutoPairStatus()
end

function TeamMemberHandler:OnDeActive()

end

function TeamMemberHandler:Update()
    if self.startPlayAni then
        self.remainTime = self.remainTime - UnityEngine.Time.deltaTime
        if self.remainTime <= 0 then
            if self.maxPoint < 3 then
                self.maxPoint = self.maxPoint + 1
                self.panel.TextAutoTeam.LabText = self.panel.TextAutoTeam.LabText .. "."
            else
                self.panel.TextAutoTeam.LabText = Common.Utils.Lang("TEAM_AUTO_PAIRING")
                self.maxPoint = 0
            end
            self.remainTime = 1
        end
    end
end

function TeamMemberHandler:RefreshPairBtn()
    local data = DataMgr:GetData("TeamData").myTeamInfo
    if data then
        if not DataMgr:GetData("TeamData").isAutoPair then
            self.panel.TextAutoTeam.LabText = Common.Utils.Lang("TEAM_AUTO_PAIR")
            self.startPlayAni = false
        else
            self.panel.TextAutoTeam.LabText = Common.Utils.Lang("TEAM_AUTO_PAIRING")
            self.startPlayAni = true
        end
    end
end

function TeamMemberHandler:InitTeamMemberPanel()
    if self.memberTemPool == nil then
        self.memberTemPool = self:NewTemplatePool({
            TemplateClassName = "TeamMemberPerTem",
            TemplatePrefab = self.panel.TeamMemberPerTem.gameObject,
            TemplateParent = self.panel.TeamMemberPerTem.transform.parent.transform,
        })
    end
end

function TeamMemberHandler:RefreshUIByTeamInfo()

    if not self.hasInit then
        return
    end

    self:SetTeamInfo()
    self.memberTemPool:ShowTemplates({ Datas = self:GetTeamData() })
    local _, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
    self.panel.ButtonOneKeyTalk.gameObject:SetActiveEx(selfIsCaptain)
    self.panel.ButtonOneKeyFollow.gameObject:SetActiveEx(selfIsCaptain)
    self.panel.ButtonAutoTeam.gameObject:SetActiveEx(selfIsCaptain)
    self.panel.ButtonFollowCaptain.gameObject:SetActiveEx(not selfIsCaptain)
    self.panel.ButtonSuit.gameObject:SetActiveEx(false)
end

function TeamMemberHandler:SetTeamInfo()

    if not DataMgr:GetData("TeamData").myTeamInfo.isInTeam then
        return
    end
    ---@type TeamData
    local teamdata = DataMgr:GetData("TeamData")
    local data = teamdata.myTeamInfo
    local teamSetting = data.teamSetting
    local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()

    --todo nyq 文字放到配置里
    self.panel.TameName.LabText = teamSetting.name
    local targetName = Common.Utils.Lang("TEAM_TARGET_SET") .. DataMgr:GetData("TeamData").GetTargetNameById(teamSetting.target)
    local lvName = ""

    self.panel.BtnSet:AddClick(function()
        if selfIsCaptain then
            UIMgr:ActiveUI(UI.CtrlNames.TeamTarget, function()
            end)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MUST_BEEN_CAPTAIN"))
        end
    end)

    if teamSetting.target == 1000 then
        lvName = ""
    else
        lvName = "（Lv." .. tostring(teamSetting.min_lv) .. "~Lv." .. tostring(teamSetting.max_lv) .. "）"
    end
    self.panel.Target.LabText = targetName .. lvName

    self.panel.ButtonOneKeyTalk.gameObject:SetActiveEx(selfIsCaptain)
    self.panel.ButtonOneKeyFollow.gameObject:SetActiveEx(selfIsCaptain)
    self.panel.ButtonAutoTeam.gameObject:SetActiveEx(selfIsCaptain)
    self.panel.ButtonFollowCaptain.gameObject:SetActiveEx(not selfIsCaptain)
end

function TeamMemberHandler:OnLogout()

end

function TeamMemberHandler:BindEvents()
    local TeamInfoUpdate = function()
        self:RefreshUIByTeamInfo()
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, TeamInfoUpdate)
    --self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_BASIC_INFO_UPDATE, TeamInfoUpdate)
    local TeamAutoPairState = function()
        self:RefreshPairBtn()
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_AUTOPAIR_STATUS, TeamAutoPairState)


end


function TeamMemberHandler.IsNil(uobj)
    return uobj == nil or uobj:Equals(nil)
end

function TeamMemberHandler:GetTeamData()
    local teamData = DataMgr:GetData("TeamData")
    local myTeamInfo = teamData.myTeamInfo
    local data = {}

    for i = 1, table.maxn(myTeamInfo.memberList) do
        local oneLua = {}
        oneLua.info = myTeamInfo.memberList[i]
        oneLua.posType = teamData.ETeamPosType.Role
        table.insert(data, oneLua)
    end
    for i = 1, table.maxn(myTeamInfo.mercenaryList) do
        if #data >= teamData.maxTeamNumber then
            break
        end
        local oneLua = {}
        oneLua.info = myTeamInfo.mercenaryList[i]
        oneLua.posType = teamData.ETeamPosType.Mercenary
        table.insert(data, oneLua)
    end
    local index = #data + 1
    for i = index, teamData.maxTeamNumber do
        local oneLua = {}
        oneLua.info = {}
        oneLua.posType = teamData.ETeamPosType.Empty
        table.insert(data, oneLua)
    end
    return data
end

return TeamMemberHandler