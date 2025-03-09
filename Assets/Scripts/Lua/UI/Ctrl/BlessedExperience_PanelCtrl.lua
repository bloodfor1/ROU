--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BlessedExperience_PanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class BlessedExperience_PanelCtrl:UIBaseCtrl
BlessedExperience_PanelCtrl = class("BlessedExperience_PanelCtrl", super)
--lua class define end

local FightCandyUseGuide = 192
local FightCandyDesGuide = 193

--lua functions
function BlessedExperience_PanelCtrl:ctor()
	
	super.ctor(self, CtrlNames.BlessedExperience_Panel, UILayer.Function, nil, ActiveType.Standalone)
	self.GroupMaskType = UI.GroupMaskType.Show
    self.MaskColor = UI.BlockColor.Transparent
end --func end
--next--
function BlessedExperience_PanelCtrl:Init()
	
	self.panel = UI.BlessedExperience_PanelPanel.Bind(self)
	super.Init(self)

    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.BlessedExperience_Panel)
    end)

    self.panel.TuijianBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.BlessedExperience_Panel)
        UIMgr:ActiveUI(UI.CtrlNames.FarmPrompt, {openCtrlOnClose = UI.CtrlNames.BlessedExperience_Panel})
    end)

    self.panel.MowuBtn:AddClick(function()
        local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
        if l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.MonsterExpel) then
            UIMgr:ActiveUI(UI.CtrlNames.MonsterRepel)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(l_openSystemMgr.eSystemId.MonsterExpel))
        end
    end)

    local l_severOnceSystemMgr = MgrMgr:GetMgr("ServerOnceSystemMgr")
    self.panel.AutoBackTog.Tog.isOn = l_severOnceSystemMgr.GetServerOnceState(l_severOnceSystemMgr.EServerOnceType.AutoRecallOnFive)
    -- 自动回城设置
    self.panel.AutoBackTog.Tog.onValueChanged:AddListener(function(isOn)
        MgrMgr:GetMgr("BackCityMgr").SetAutoRecallOnFive(isOn)
    end)

    self.panel.BattleTimeHelpBtn.Listener.onClick = function(go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("BATTLESTATISTICS_BATTLE_STATE_TIPS"), eventData, Vector2(1, 0.5))
    end

    self.panel.BlessHelpBtn.Listener.onClick = function(go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("BLESS_EXP_TIP"), eventData, Vector2(0, 0.5))
    end

    local l_isMonthCard = MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard()
    self.panel.Txt_LeftShow.LabText = l_isMonthCard and Lang("LEFT_SHOW_BLESS_INFO") or Lang("CUR_SHOW_BLESS_INFO")
    self.panel.Btn_BlessInfo:SetActiveEx(l_isMonthCard)
    self.panel.Btn_BlessInfo:AddClick(function()
        local l_pointEventData = {}
        l_pointEventData.position = Input.mousePosition
        local l_num1 = tonumber(TableUtil.GetGlobalTable().GetRowByName("MonthCardBlessedExperienceTime").Value)*24
        local l_num2 = TableUtil.GetGlobalTable().GetRowByName("MonthCardAutoCombatExpBlessBonus").Value
        local l_num3 = TableUtil.GetGlobalTable().GetRowByName("MonthCardEntrustTicketBlessBonus").Value
        local Txt_1 = Lang("BLESS_TIPS_SHOW_1")
        local Txt_2 = Lang("BLESS_TIPS_SHOW_2",l_num2,l_num3,l_num1)
        MgrMgr:GetMgr("TipsMgr").ShowMarkTips(Txt_1, Txt_2, l_pointEventData, anchorePos or Vector2(0.5, 1), MUIManager.UICamera, true)
    end)

    self.panel.BlessTip.LabText = Lang("BLESS_DESCRIPTION")

    self.panel.Base_txt.LabText = tostring(MPlayerInfo.BlessExp)
    self.panel.Job_txt.LabText = tostring(MPlayerInfo.BlessJobExp)

    self.panel.BlessSpeedUpText:GetRichText().onHrefClick:AddListener(function(hrefName)
        MgrMgr:GetMgr("CapraFAQMgr").ParsHref(hrefName,self.panel.BlessSpeedUpText.gameObject)
    end)

end --func end
--next--
function BlessedExperience_PanelCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BlessedExperience_PanelCtrl:OnActive()
    MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()

    if MgrMgr:GetMgr("BeginnerGuideMgr").CheckGuideMask(FightCandyUseGuide) and not MgrMgr:GetMgr("BeginnerGuideMgr").CheckGuideMask(FightCandyDesGuide)  then
        local l_beginnerGuideChecks = {"FightCandyDesGuide"}
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks,UI.CtrlNames.BlessedExperience_Panel)
    else
        -- 新手引导
        -- 保证在按钮出现之后出现
        if MPlayerInfo.Lv >= MGlobalConfig:GetInt("PrayExpLimitLevel") then
            local l_beginnerGuideChecks = {"DailyExpGuide2"}
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks)
        end
    end

end --func end
--next--
function BlessedExperience_PanelCtrl:OnDeActive()
    if self.battleStatisticsTimer then
        self.battleStatisticsTimer:Stop()
        self.battleStatisticsTimer = nil
    end
	
end --func end
--next--
function BlessedExperience_PanelCtrl:Update()
	
	
end --func end
--next--
function BlessedExperience_PanelCtrl:BindEvents()
    local l_battleStatisticsMgr = MgrMgr:GetMgr("BattleStatisticsMgr")
    self:BindEvent(l_battleStatisticsMgr.EventDispatcher, l_battleStatisticsMgr.OnRefreshBattleRevenue, self.RefreshBattleStatistics)
end --func end
--next--
--lua functions end

--lua custom scripts

function BlessedExperience_PanelCtrl:RefreshBattleStatistics(data)
    if data == nil then
        return
    end
    self:_showBlessedExperiencePanelWithTime(data.Normal.FightTime)
end

function BlessedExperience_PanelCtrl:_showBlessedExperiencePanelWithTime(fightTime)
    if fightTime == nil then
        return
    end
    local l_time = TimeSpan.FromMilliseconds(fightTime).TotalMinutes
    local l_state, l_stateText, l_timeText = MgrMgr:GetMgr("BattleStatisticsMgr").GetBattleStateByTime(l_time)
    self.panel.BattleState.LabText = l_stateText
    self.panel.BattleTime.LabText = l_timeText

    if l_state == GameEnum.EBattleHealthy.VeryTried then
        self.panel.BlessSpeedUpText.LabText = Lang("BlessedExperiencePanel_TriedText")
        self.panel.MowuBtn:SetActiveEx(true)
        local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
        self.panel.MowuBtn:SetGray(not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.MonsterExpel))
    else
        -- 加速buff
        local l_factor = MgrMgr:GetMgr("AutoFightItemMgr").GetJiaJiJiaSuFactor()
        self.panel.BlessSpeedUpText:SetActiveEx(l_factor ~= 0)
        self.panel.BlessSpeedUpText.LabText = Lang("BLESS_EXP_SPEED_UP", l_factor)
        self.panel.MowuBtn:SetActiveEx(false)
    end
end


--lua custom scripts end
return BlessedExperience_PanelCtrl