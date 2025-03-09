--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EmblemPanel"
require "UI/Template/EmblemItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local lastClickIdx = -1
--next--
--lua fields end

--lua class define
EmblemCtrl = class("EmblemCtrl", super)
--lua class define end

--lua functions
function EmblemCtrl:ctor()

    super.ctor(self, CtrlNames.Emblem, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
    --self:SetParent(UI.CtrlNames.DelegatePanel)

    self.InsertPanelName = UI.CtrlNames.DelegatePanel

    self.awardMgr = MgrMgr:GetMgr("AwardPreviewMgr")

end --func end
--next--q
function EmblemCtrl:Init()

    self.panel = UI.EmblemPanel.Bind(self)
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("DelegateModuleMgr")
    self.emblemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.EmblemItemTemplate,
        ScrollRect = self.panel.RewardScroll.LoopScroll,
        TemplatePrefab = self.panel.EmblemItemTemplate.LuaUIGroup.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
        Method = function(index)
            self:onSelectOne(index)
        end
    })

    self.awardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.rewardContent.transform,
        TemplatePath = "UI/Prefabs/ItemPrefab",
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
    })

    self.panel.BtnClose:AddClick(handler(self, self.Close))
    self.panel.BtnBg:AddClick(handler(self, self.Close))
    MgrMgr:GetMgr("DailyTaskMgr").UpdateDailyTaskInfo()
    local l_table = TableUtil.GetDailyActivitiesTable().GetRowById(MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_WeekParty)
    if l_table then
        self.panel.InfoTittle.LabText = l_table.ActivityName
        self.panel.InfoContext.LabText = l_table.AcitiveText
        self.panel.InfoMod.LabText = l_table.ModeTextDisplay
        self.panel.InfoCondition.LabText = Common.Utils.Lang("DELEGATE_CONDITION_DES")
    end
end --func end
--next--
function EmblemCtrl:Uninit()
    self.emblemPool = nil
    super.Uninit(self)
    self.panel = nil
    self.awardItemPool = nil

end --func end
--next--
function EmblemCtrl:OnActive()
    self.panel.AttendLimitTip.LabText = Lang("ATTEND_THEME_PARTY_LIMLIT")
    self.panel.EmblemItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self:RefreshEmblems()
    self:UpdateBtnState()
end --func end
--next--
function EmblemCtrl:OnDeActive()


end --func end
--next--
function EmblemCtrl:Update()
    self.awardItemPool:OnUpdate()
    self.emblemPool:OnUpdate()
end --func end

--next--
function EmblemCtrl:BindEvents()
    local l_mgr = MgrMgr:GetMgr("DailyTaskMgr")
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.DAILY_ACTIVITY_UPDATE_EVENT, function()
        self:UpdateBtnState()
    end)
    self:BindEvent(self.awardMgr.EventDispatcher, self.awardMgr.AWARD_PREWARD_MSG, self.OnGetReward)
end --func end

--next--
--lua functions end

--lua custom scripts

function EmblemCtrl:UpdateBtnState()
    self.panel.TmpTxt.LabText = Lang("DELEGATE_EMBLEM_TEMP_WORD")
    local l_mgr = MgrMgr:GetMgr("DailyTaskMgr")
    local id = l_mgr.g_ActivityType.activity_WeekParty
    local isOpen = l_mgr.IsActivityOpend(id)
    self.panel.infoGoBtn:SetGray(not isOpen)
    self.panel.LuckStarBtn:AddClick(function()
        MgrMgr:GetMgr("ThemePartyMgr").OpenPartyLuckStar()
    end)

    if isOpen then
        self.panel.infoGoBtn:AddClick(function()
            if l_mgr.GotoDailyTask(id) then
                UIMgr:DeActiveUI(UI.CtrlNames.DelegatePanel)
            end
        end)
        self.panel.TmpTxt.LabText = Common.Utils.Lang("GO_NOW")
    else
        self.panel.infoGoBtn:AddClick(function()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EMBLEM_TMP_TIP"))
        end)
        local l_table = TableUtil.GetDailyActivitiesTable().GetRowById(id)
        if l_table then
            local l_time = tostring(l_table.TimePass[0][0])
            local l_str = ""
            local cnt = StringEx.Length(l_time)
            if cnt >= 4 then
                l_str = StringEx.SubString(l_time, 0, 2) .. ":" .. StringEx.SubString(l_time, 2, 2)
            end
            self.panel.TmpTxt.LabText = Common.Utils.Lang("ACTIVITY_TYPE_" .. tostring(l_table.ActiveType)) ..
                    Common.Utils.Lang(tostring(l_table.TimeCycle[0])) .. "\n" .. l_str .. Common.Utils.Lang("OPEN_TARGET")
        end
    end

    local sdata = TableUtil.GetDailyActivitiesTable().GetRowById(id)
    if sdata then
        self.awardMgr.GetPreviewRewards(sdata.AwardText)
    end
end

function EmblemCtrl:RefreshEmblems()
    local datas = {}
    local emblemIds = self.mgr.GetEmblemIds()
    for i, v in ipairs(emblemIds) do
        table.insert(datas, { id = v, count = Data.BagModel:GetCoinOrPropNumById(v) })
    end

    self.emblemPool:ShowTemplates({ Datas = datas })
end

function EmblemCtrl:Close()
    UIMgr:DeActiveUI(UI.CtrlNames.Emblem)
end

function EmblemCtrl:OnGetReward(awardPreviewRes)
    local datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardPreviewRes)
    self.awardItemPool:ShowTemplates({ Datas = datas })
end

function EmblemCtrl:onSelectOne(index)
    self.emblemPool:SelectTemplate(index)
end

--lua custom scripts end

return EmblemCtrl