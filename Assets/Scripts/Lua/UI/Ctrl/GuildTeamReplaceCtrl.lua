--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildTeamReplacePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end


Color_Battle_Text = Color.New(1, 1, 1, 1)
Color_Battle_OutLine = Color.New(102 / 255, 113 / 255, 155 / 255, 1)
Color_Cherr_Text = Color.New(243 / 255, 206 / 255, 57 / 255, 1)
Color_Cherr_OutLine = Color.New(130 / 255, 87 / 255, 44 / 255, 1)

--lua class define
GuildTeamReplaceCtrl = class("GuildTeamReplaceCtrl", super)
--lua class define end

--lua functions
function GuildTeamReplaceCtrl:ctor()

    super.ctor(self, CtrlNames.GuildTeamReplace, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function GuildTeamReplaceCtrl:Init()

    self.panel = UI.GuildTeamReplacePanel.Bind(self)
    super.Init(self)
    self.type = nil
    self.mgr = MgrMgr:GetMgr("GuildMatchMgr")
    self.panel.infoGoBtn:AddClick(function()
        --todo send enter team uuid
        if self.type and self.selecetUuid and self.selecetUuid ~= 0 then
            DataMgr:GetData("GuildMatchData").UpdateMgrTeamInfo(self.selecetUuid, self.type)
            self.selecetUuid = 0
            self.mgr.EventDispatcher:Dispatch(self.mgr.ON_REFRESH_TEAM_MGR)     --抛出选择界面更新事件
            UIMgr:DeActiveUI(UI.CtrlNames.GuildTeamReplace)
        else
            local content = Common.Utils.Lang("GUILD_MATCH_TEAM_SLOT_EMPTY")
            CommonUI.Dialog.ShowYesNoDlg(true, nil, content, function()
                UIMgr:DeActiveUI(UI.CtrlNames.GuildTeamReplace)
            end, nil, nil, 0)
        end
    end)
    self.refreshCD = 0
    self.panel.RefreshBtn:AddClick(function()
        if self.refreshCD <= 0 then
            self.refreshCD = MGlobalConfig:GetFloat("G_MatchButtonCD")
            self.mgr.GetGuildBattleTeamInfo(self.type)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("HAVE_UPDATE"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFRESH_TOO_FAST"))
        end
    end)
    self.panel.RewardCloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildTeamReplace)
    end)
    self.TeamShowTemPool = nil

end --func end
--next--
function GuildTeamReplaceCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildTeamReplaceCtrl:OnActive()

    self.type = self.uiPanelData.teamType
    self.selecetUuid = 0
    self.panel.Title.LabText = Common.Utils.Lang("PLEASE_SELECT") .. Common.Utils.Lang("GUILD_MATCH_TEAM" .. self.type)
    self:ShowTemPool()

end --func end
--next--
function GuildTeamReplaceCtrl:OnDeActive()


end --func end
--next--
function GuildTeamReplaceCtrl:Update()

    if self.refreshCD > 0 then
        self.refreshCD = self.refreshCD - UnityEngine.Time.deltaTime
    end

end --func end
--next--
function GuildTeamReplaceCtrl:Refresh()


end --func end
--next--
function GuildTeamReplaceCtrl:OnLogout()


end --func end
--next--
function GuildTeamReplaceCtrl:OnReconnected(roleData)


end --func end
--next--
function GuildTeamReplaceCtrl:Show(withTween)

    if not super.Show(self, withTween) then
        return
    end

end --func end
--next--
function GuildTeamReplaceCtrl:Hide(withTween)

    if not super.Hide(self, withTween) then
        return
    end

end --func end
--next--
function GuildTeamReplaceCtrl:BindEvents()

    self:BindEvent(self.mgr.EventDispatcher, DataMgr:GetData("GuildMatchData").ON_REFRESH_TEAM_SEL, self.ShowTemPool)

end --func end
--next--
--next--
--lua functions end

--lua custom scripts

function GuildTeamReplaceCtrl:ShowTemPool()

    if not self.TeamShowTemPool then
        self.TeamShowTemPool = self:NewTemplatePool({
            TemplateClassName = "GuildMatchTeamSelTem",
            TemplatePrefab = self.panel.GuildMatchTeamSelTem.gameObject,
            ScrollRect = self.panel.ScrollView.LoopScroll,
            Method = function(index, uuid)
                self:SelectTem(index, uuid)
            end
        })
    end
    local l_showdata = {}
    local selectIndex = 0
    local myBattleTeams = DataMgr:GetData("GuildMatchData").AllBattleTeam
    if table.maxn(myBattleTeams) == 0 then
        self.panel.NonePanel.UObj:SetActiveEx(true)
        return
    end
    self.panel.NonePanel.UObj:SetActiveEx(false)
    for i = 1, table.maxn(myBattleTeams) do
        local oneData = {}
        oneData.isChoose = false
        if myBattleTeams[i].round > 0 then
            if self.type == myBattleTeams[i].round then
                selectIndex = i
            end
            oneData.TeamName = Common.Utils.Lang("GUILD_MATCH_TEAM" .. myBattleTeams[i].round)
            oneData.TeamNameOutLineColor = Color_Battle_OutLine
            oneData.TeamNameColor = Color_Battle_Text
        end
        oneData.isSelect = self:CheckIsUpdate(myBattleTeams[i].teamuuid) and (oneData.TeamName == nil)
        oneData.uuid = myBattleTeams[i].teamuuid
        oneData.TeamInfo = myBattleTeams[i].memberList
        l_consume = MGlobalConfig:GetVectorSequence("G_MatchBattleTeamSize")
        oneData.BlockNum = l_consume[0][1]
        oneData.TeamType = i
        table.insert(l_showdata, oneData)
    end
    --啦啦队
    --for i = 1, CherringTeamNum do
    --    local oneData = {}
    --    oneData.TeamName = Common.Utils.Lang("GUILD_MATCH_TEAM_CHERR")
    --    oneData.TeamNameOutLineColor = Color_Cherr_OutLine
    --    oneData.TeamNameColor = Color_Cherr_Text
    --    l_consume = MGlobalConfig:GetVectorSequence("G_MatchCheeringTeamSize")
    --    oneData.BlockNum = l_consume[0][1]
    --    oneData.TeamType = i + BattleTeamNum
    --    table.insert(l_showdata, oneData)
    --end
    self.TeamShowTemPool:ShowTemplates({ Datas = l_showdata })
    if selectIndex ~= 0 then
        self.selecetUuid = selectIndex
        self.TeamShowTemPool:SelectTemplate(selectIndex)
    end

end

function GuildTeamReplaceCtrl:SelectTem(index, uuid)

    if self.TeamShowTemPool then
        self.TeamShowTemPool:SelectTemplate(index)
        self.selecetUuid = uuid
    end

end

function GuildTeamReplaceCtrl:CheckIsUpdate(uuid)

    local l_data = DataMgr:GetData("GuildMatchData")
    for i = 1, #l_data.MgrTeamInfo do
        if uuid == l_data.MgrTeamInfo[i].teamuuid then
            return true
        end
    end
    return false

end
--lua custom scripts end
return GuildTeamReplaceCtrl