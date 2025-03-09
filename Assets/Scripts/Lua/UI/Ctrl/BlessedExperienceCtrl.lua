--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BlessedExperiencePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
BlessedExperienceCtrl = class("BlessedExperienceCtrl", super)
--lua class define end

--lua functions
function BlessedExperienceCtrl:ctor()
	
	super.ctor(self, CtrlNames.BlessedExperience, UILayer.Normal, nil, ActiveType.Normal)
    self.overrideSortLayer = UILayerSort.Normal + 2
end --func end
--next--
function BlessedExperienceCtrl:Init()
	
	self.panel = UI.BlessedExperiencePanel.Bind(self)
	super.Init(self)

    self.panel.Confirm_btn:AddClick(function()
        self:PlayMoveAnimation()
    end)
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

end --func end
--next--
function BlessedExperienceCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BlessedExperienceCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.healthExpData then
        self:SetData(self.uiPanelData.healthExpData)
    end
end --func end
--next--
function BlessedExperienceCtrl:OnDeActive()
	self:KillTweens()
	
end --func end
--next--
function BlessedExperienceCtrl:Update()
	
	
end --func end
--next--
function BlessedExperienceCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

---@param healthExpData HealthExpData
function BlessedExperienceCtrl:SetData(healthExpData)
    -- logError(StringEx.Format("{0}, {1}", healthExpData.battle_base_exp, healthExpData.battle_job_exp))
    local l_hasBattleExp = healthExpData.battle_base_exp ~= 0 or healthExpData.battle_job_exp ~= 0
    local l_hasTicket = healthExpData.delegate_ticket ~= 0
    local l_expStr = ""
    local l_ticketStr = ""
    if l_hasBattleExp then
        l_expStr = StringEx.Format("<size=22><color=#494373> {0} </color></size>", Lang("BATTLE_EXP"))
    end
    if l_hasTicket then
        l_ticketStr = StringEx.Format("<size=22><color=#494373> {0} </color></size>", Lang("DELEGATE_TICKET"))
    end

    local l_str = ""
    if l_expStr ~= "" and l_ticketStr ~= "" then
        l_str = Lang("AND", l_expStr, l_ticketStr)
    else
        l_str = l_expStr..l_ticketStr
    end

    self.panel.Btn_BlessInfo:SetActiveEx(MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard())
    local l_num = tonumber(TableUtil.GetGlobalTable().GetRowByName("MonthCardBlessedExperienceTime").Value)*24
    local l_isMonthCard = MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard()
    self.panel.Tip_txt.LabText = healthExpData.month_card and Lang("BLESS_TIPS_MONTHCARD",l_num) or Lang("BLESS_TIPS")
    self.panel.Info_txt.LabText = Lang("BLESS_INFO", l_str)
    self.panel.Base_txt.LabText = RoColor.FormatWord(Lang("BLESS_BASE_INFO", tostring(healthExpData.extra_base_exp)))
    self.panel.Job_txt.LabText = RoColor.FormatWord(Lang("BLESS_JOB_INFO", tostring(healthExpData.extra_job_exp)))
end

function BlessedExperienceCtrl:PlayMoveAnimation()
    self.scaleTween = MUITweenHelper.TweenScale(self.panel.Panel.gameObject, Vector3.New(1, 1, 1), Vector3.New(0.1, 0.1, 0.1), 0.2, function()
        local l_endPosition = Vector3(0, 0, 0)
        local l_btnCtrl = UIMgr:GetUI(UI.CtrlNames.RoleNurturance_TipsBtn)
        if l_btnCtrl then
            l_endPosition = l_btnCtrl:GetExpBtnPosition()
        end

        self.posTween = MUITweenHelper.TweenWorldPos(self.panel.Panel.gameObject, self.panel.Panel.transform.position, l_endPosition, 0.8, function()
            UIMgr:DeActiveUI(UI.CtrlNames.BlessedExperience)
        end)
    end)
end

function BlessedExperienceCtrl:KillTweens()
    if self.scaleTween then
        MUITweenHelper.KillTween(self.scaleTween)
        self.scaleTween = nil
    end
    if self.posTween then
        MUITweenHelper.KillTween(self.posTween)
        self.posTween = nil
    end
end

--lua custom scripts end
return BlessedExperienceCtrl