--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildteammanagePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GuildteammanageCtrl = class("GuildteammanageCtrl", super)
--lua class define end

CherringTeamNum = 1

Color_Battle_Text = Color.New(1, 1, 1, 1)
Color_Battle_OutLine = Color.New(102 / 255, 113 / 255, 155 / 255, 1)
Color_Cherr_Text = Color.New(243 / 255, 206 / 255, 57 / 255, 1)
Color_Cherr_OutLine = Color.New(130 / 255, 87 / 255, 44 / 255, 1)

--lua functions
function GuildteammanageCtrl:ctor()

    super.ctor(self, CtrlNames.Guildteammanage, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildteammanageCtrl:Init()

    self.panel = UI.GuildteammanagePanel.Bind(self)
    super.Init(self)
    self.TeamShowTemPool = nil
    self.data = DataMgr:GetData("GuildMatchData")
    self.panel.infoGoBtn:AddClick(function()
        for i = 1, self.data.battleTeamNum do
            if self.data.MgrTeamInfo[i].teamuuid == 0 then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("GUILD_MATCH_TEAM_UPDATE2"), function()
                    UIMgr:DeActiveUI(UI.CtrlNames.Guildteammanage)
                    local l_uuidData = {}
                    for i = 1, self.data.battleTeamNum do
                        table.insert(l_uuidData, self.data.MgrTeamInfo[i].teamuuid)
                    end
                    MgrMgr:GetMgr("GuildMatchMgr").ChangeGuildBattleTeam(l_uuidData)
                end)
                return
            end
        end
        UIMgr:DeActiveUI(UI.CtrlNames.Guildteammanage)
        local l_uuidData = {}
        for i = 1, self.data.battleTeamNum do
            table.insert(l_uuidData, self.data.MgrTeamInfo[i].teamuuid)
        end
        MgrMgr:GetMgr("GuildMatchMgr").ChangeGuildBattleTeam(l_uuidData)
    end)
    self.panel.infoComeBtn:AddClick(function()
        if self.data.GetRefreshBtnCd() == -1 then
            self.data.SetRefreshBtnCd()
            MgrMgr:GetMgr("GuildMatchMgr").GuildMatchConvene()
        else
            --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFRESH_TOO_FAST"))
        end
    end)
    self.panel.BtnClose:AddClick(function()
        local isNeedSave = false
        for i = 1, self.data.battleTeamNum do
            if self.data.MgrTeamInfo[i].teamuuid ~= self.data.MgrTeamUuid[i] then
                isNeedSave = true
            end
        end
        if isNeedSave then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("GUILD_MATCH_TEAM_UPDATE"), function()
                UIMgr:DeActiveUI(UI.CtrlNames.Guildteammanage)
            end)
        else
            UIMgr:DeActiveUI(UI.CtrlNames.Guildteammanage)
        end
    end)

end --func end
--next--
function GuildteammanageCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildteammanageCtrl:OnActive()

    self:SetPanel()
    local l_beginnerGuideChecks = { "GuildMatchGuide" }
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    self.panel.infoComeBtn:SetGray(self.data.GetRefreshBtnCd() ~= -1)
    if self.data.GetRefreshBtnCd() == -1 then
        self.panel.BtnComeTxt.LabText = Lang("TEAM_INVITE")
    else
        self:CountDown()
    end

end --func end
--next--
function GuildteammanageCtrl:OnDeActive()

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

end --func end
--next--
function GuildteammanageCtrl:Update()

    if self.data.GetRefreshBtnCd() ~= -1 and self.data.GetRefreshBtnCd() <= Common.TimeMgr.GetNowTimestamp() then
        self.data.RefreshBtnCd()
        self.panel.infoComeBtn:SetGray(false)
        self.panel.BtnComeTxt.LabText = Lang("TEAM_INVITE")
        if self.timer then
            self:StopUITimer(self.timer)
            self.timer = nil
        end
    end

end --func end
--next--
function GuildteammanageCtrl:Refresh()


end --func end
--next--
function GuildteammanageCtrl:OnLogout()


end --func end
--next--
function GuildteammanageCtrl:OnReconnected(roleData)


end --func end
--next--
function GuildteammanageCtrl:OnShow()

end --func end
--next--
function GuildteammanageCtrl:OnHide()

end --func end
--next--
function GuildteammanageCtrl:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("GuildMatchMgr").EventDispatcher, self.data.ON_REFRESH_TEAM_MGR, self.SetPanel)
    self:BindEvent(MgrMgr:GetMgr("GuildMatchMgr").EventDispatcher, self.data.ON_REFRESH_TEAM_CONVENE, function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_SEND_TOBEFOLLOW"))
        self.panel.infoComeBtn:SetGray(true)
        self:CountDown()
    end)

end --func end
--next--
--next--
--lua functions end

--lua custom scripts
function GuildteammanageCtrl:CountDown()

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end
    local l_time = self.data.GetRefreshBtnCd() - Common.TimeMgr.GetNowTimestamp()
    self.panel.BtnComeTxt.LabText = StringEx.Format("{0:00}:{1:00}", math.modf(l_time / 60), l_time % 60)
    self.timer = self:NewUITimer(function()
        local l_time = self.data.GetRefreshBtnCd() - Common.TimeMgr.GetNowTimestamp()
        self.panel.BtnComeTxt.LabText = StringEx.Format("{0:00}:{1:00}", math.modf(l_time / 60), l_time % 60)
    end, 1, -1, true)
    self.timer:Start()

end

function GuildteammanageCtrl:SetPanel()

    if not self.TeamShowTemPool then
        self.TeamShowTemPool = self:NewTemplatePool({
            TemplateClassName = "GuildTeamShow",
            TemplatePrefab = self.panel.GuildTeamShow.gameObject,
            ScrollRect = self.panel.Scroll.LoopScroll,
        })
    end
    local l_showdata = {}
    for i = 1, self.data.battleTeamNum do
        local oneData = {}
        oneData.TeamName = Common.Utils.Lang("GUILD_MATCH_TEAM" .. i)
        oneData.TeamNameOutLineColor = Color_Battle_OutLine
        oneData.TeamNameColor = Color_Battle_Text
        l_consume = MGlobalConfig:GetVectorSequence("G_MatchBattleTeamSize")
        oneData.BlockNum = l_consume[0][1]
        oneData.TeamType = i
        oneData.isChange = self.data.MgrTeamInfo[i].teamuuid ~= self.data.MgrTeamUuid[i]
        oneData.TeamInfo = self.data.MgrTeamInfo[i].memberList
        table.insert(l_showdata, oneData)
    end
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

end

--lua custom scripts end
return GuildteammanageCtrl