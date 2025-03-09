--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildMatchSettlementPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GuildMatchSettlementCtrl = class("GuildMatchSettlementCtrl", super)
--lua class define end
--lua functions
function GuildMatchSettlementCtrl:ctor()

    super.ctor(self, CtrlNames.GuildMatchSettlement, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildMatchSettlementCtrl:Init()

    self.panel = UI.GuildMatchSettlementPanel.Bind(self)
    super.Init(self)
    self.BlueTeamTemPool = nil
    self.RedTeamTemPool = nil
    self.panel.infoGoBtn:AddClick(function()
        self:Exit()
    end)
end --func end
--next--
function GuildMatchSettlementCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildMatchSettlementCtrl:OnActive()

    self.autoExitTime = MgrMgr:GetMgr("ArenaMgr").ArenaResultCountDown
    self.exitTime = self.autoExitTime
    self.exitTimer = self:NewUITimer(handler(self, self.OnExitTimer), 1, -1)
    self.exitTimer:Start()
    if not self.BlueTeamTemPool then
        self.BlueTeamTemPool = self:NewTemplatePool({
            TemplateClassName = "GuildMatchResultTeamTem",
            TemplatePrefab = self.panel.GuildMatchResultTeamTem.gameObject,
            TemplateParent = self.panel.TeamParentBlue.Transform,
        })
    end
    if not self.RedTeamTemPool then
        self.RedTeamTemPool = self:NewTemplatePool({
            TemplateClassName = "GuildMatchResultTeamTem",
            TemplatePrefab = self.panel.GuildMatchResultTeamTem.gameObject,
            TemplateParent = self.panel.TeamParentRed.Transform,
        })
    end

    local dataBlue = {}
    local dataRed = {}
    ---@type ModuleData.GuildMatchData
    local l_Data = DataMgr:GetData("GuildMatchData")

    self.panel.GuildNameBlue.LabText = l_Data.camp1Info.guildName
    self.panel.GuildNameRed.LabText = l_Data.camp2Info.guildName
    local BlueIconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(l_Data.camp1Info.iconId)
    self.panel.GuildIconBlue:SetSprite(BlueIconData.GuildIconAltas, BlueIconData.GuildIconName)
    local RedIconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(l_Data.camp2Info.iconId)
    self.panel.GuildIconRed:SetSprite(RedIconData.GuildIconAltas, RedIconData.GuildIconName)
    local l_score1 = 0
    local l_score2 = 0
    local scoreTb = { 2, 0, 1 }
    for i = 1, table.maxn(l_Data.camp1Info.teamResult) do

        l_score1 = l_score1 + scoreTb[l_Data.camp1Info.teamResult[i].win]
        l_score2 = l_score2 + scoreTb[l_Data.camp2Info.teamResult[i].win]

        local oneBlue = {}
        local oneRed = {}
        oneBlue.BGType = "Blue"
        oneBlue.isWin = l_Data.camp1Info.teamResult[i].win
        oneBlue.MvpName = l_Data.camp1Info.teamResult[i].mvp
        oneBlue.Score = l_Data.camp1Info.teamResult[i].score
        table.insert(dataBlue, oneBlue)
        oneRed.BGType = "Red"
        oneRed.isWin = l_Data.camp2Info.teamResult[i].win
        oneRed.MvpName = l_Data.camp2Info.teamResult[i].mvp
        oneRed.Score = l_Data.camp2Info.teamResult[i].score
        table.insert(dataRed, oneRed)
    end
    self.BlueTeamTemPool:ShowTemplates({ Datas = dataBlue })
    self.RedTeamTemPool:ShowTemplates({ Datas = dataRed })
    self.panel.winTitle:SetActiveEx(l_score1 > l_score2)
    self.panel.loseTitle:SetActiveEx(l_score1 <= l_score2)
end --func end
--next--
function GuildMatchSettlementCtrl:OnDeActive()

    if self.exitTimer then
        self:StopUITimer(self.exitTimer)
        self.exitTimer = nil
    end
end --func end
--next--
function GuildMatchSettlementCtrl:Update()


end --func end
--next--
function GuildMatchSettlementCtrl:Refresh()


end --func end
--next--
function GuildMatchSettlementCtrl:OnLogout()


end --func end
--next--
function GuildMatchSettlementCtrl:OnReconnected(roleData)


end --func end
--next--
function GuildMatchSettlementCtrl:Show(withTween)

    if not super.Show(self, withTween) then
        return
    end

end --func end
--next--
function GuildMatchSettlementCtrl:Hide(withTween)

    if not super.Hide(self, withTween) then
        return
    end

end --func end
--next--
function GuildMatchSettlementCtrl:BindEvents()


end --func end
--next--
--next--
--lua functions end

--lua custom scripts

function GuildMatchSettlementCtrl:Exit()
    UIMgr:DeActiveUI(UI.CtrlNames.GuildMatchSettlement)
    --MgrMgr:GetMgr("DungeonMgr").SendLeaveSceneReq()
end

function GuildMatchSettlementCtrl:OnExitTimer()
    self.exitTime = self.exitTime - 1
    self.panel.CloseTip.LabText = Lang("ARENA_RESULT_CLOSE_TIP", self.exitTime)
    if self.exitTime <= 0 then
        return self:Exit()
    end
end
--lua custom scripts end
return GuildMatchSettlementCtrl