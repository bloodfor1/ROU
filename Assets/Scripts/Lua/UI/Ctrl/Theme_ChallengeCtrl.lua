--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Theme_ChallengePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TEAM_TARGETID_NORMAL = 11001
TEAM_TARGETID_HARD = 11002
Theme_ChallengeCtrl = class("Theme_ChallengeCtrl", super)
--lua class define end

--lua functions
function Theme_ChallengeCtrl:ctor()
	
	super.ctor(self, CtrlNames.Theme_Challenge, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function Theme_ChallengeCtrl:Init()
	
	self.panel = UI.Theme_ChallengePanel.Bind(self)
	super.Init(self)

    self.themeDungeonMgr = MgrMgr:GetMgr("ThemeDungeonMgr")

    -- 普通奖励
    self.normalRewardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.NormalAwardScroll.LoopScroll
    })

    -- 困难奖励
    self.hardRewardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.HardAwardScroll.LoopScroll
    })

    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Theme_Challenge)
    end)

    -- 首领攻略
    self.panel.GuideBtn:AddClick(function()
        if self.themeDungeonInfo then
            UIMgr:ActiveUI(UI.CtrlNames.Theme_ChiefGuild, {leaderId = self.themeDungeonInfo.tableInfo.LeaderID})
        end
    end)

    -- 开始挑战
    self.panel.BeginBtn:AddClick(function()
        if self.themeDungeonInfo then
            if self.dungeonMode == "normal" then
                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.themeDungeonInfo.tableInfo.NormalDungeonID, 0, 0)
            elseif self.dungeonMode == "hard" then
                MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.themeDungeonInfo.tableInfo.HardDungeonID, 0, 0)
            end
        end
    end)

    self.panel.Help:AddClick(function()
        if self.themeDungeonInfo then
            UIMgr:ActiveUI(UI.CtrlNames.Theme_NewTask, {themeDungeonId = self.themeDungeonInfo.themeDungeonId})
        end
    end)

    -- 战前确认
    self.panel.ConfirmBtn:AddClick(function()
        if self.themeDungeonInfo then
            if self.dungeonMode == "normal" then
                UIMgr:ActiveUI(UI.CtrlNames.Theme_Confirmation, {dungeonId = self.themeDungeonInfo.tableInfo.NormalDungeonID, hardLevel = 0})
            elseif self.dungeonMode == "hard" then
                UIMgr:ActiveUI(UI.CtrlNames.Theme_Confirmation, {dungeonId = self.themeDungeonInfo.tableInfo.HardDungeonID, hardLevel = 1})
            end
        end
    end)

    -- 奖励提示
    self.panel.AwardTips:SetActiveEx(false)
    self.panel.AwardTipBtn:AddClick(function()
        self.panel.AwardTips:SetActiveEx(not self.panel.AwardTips.gameObject.activeSelf);
    end)
    self.panel.TipsBackBtn:AddClick(function()
        self.panel.AwardTips:SetActiveEx(false);
    end)

    -- 普通难度
    self.panel.NormalBg:AddClick(function()
        self:SelectNormal()
    end)

    -- 困难难度
    self.panel.HardBg:AddClick(function()
        self:SelectHard()
    end)

    -- 组队信息
    self.teamTemplate = self:NewTemplate("EmbeddedTeamTemplate",{
        TemplateParent = self.panel.TeamPanel.transform
    })

    -- 次数动画
    self.panel.Award.Tog.onValueChanged:AddListener(function(isOn)
        if self.rewardTween then return end

        self.panel.AwardTips:SetActiveEx(false)

        local l_duration = 0.3
        self.panel.Simple:SetActiveEx(not isOn)
        self.panel.Full:SetActiveEx(isOn)
        if isOn then
            self.rewardTween = self.panel.Award.RectTransform:DOAnchorPosX(0, l_duration)
            self.rewardTween.onComplete = function()
                self.rewardTween = nil
            end
        else
            self.rewardTween = self.panel.Award.RectTransform:DOAnchorPosX(-self.panel.AwardSeparation.RectTransform.anchoredPosition.x, l_duration)
            self.rewardTween.onComplete = function()
                self.rewardTween = nil
            end
        end
    end)
    self.panel.Award.Tog.isOn = false

    self.dungeonMode = "normal"

    self:RefreshCount()

    self:InitEffect()
end --func end
--next--
function Theme_ChallengeCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

    self.rewardTween = nil
    self.dungeonMode = nil

    if self.moveUpTimer then
        self:StopUITimer(self.moveUpTimer)
        self.moveUpTimer = nil
    end
	
end --func end
--next--
function Theme_ChallengeCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.themeDungeonId then
        self:SetInfo(self.uiPanelData.themeDungeonId)

        local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
        if not l_onceSystemMgr.GetAndSetState(l_onceSystemMgr.EClientOnceType.ThemeChallengeFirst, nil, true) then
            UIMgr:ActiveUI(UI.CtrlNames.Theme_Information, {themeDungeonId = -1, isThemeChallengeFirst = true})
        else
            self.themeDungeonMgr.CheckNewTask()
        end
    end

    self.themeDungeonMgr.EventDispatcher:Dispatch(self.themeDungeonMgr.EventType.ThemeDungeonUIClosed)
	
end --func end
--next--
function Theme_ChallengeCtrl:OnDeActive()

    self:DestroyEffect()
end --func end
--next--
function Theme_ChallengeCtrl:Update()
	-- 刷新剩余时间
    if MServerTimeMgr.UtcSeconds_u < tonumber(self.themeDungeonMgr.nextRefreshTime)  then
        self.panel.LeftTime.LabText = Lang("REFRESHTIME", Common.TimeMgr.GetLeftTimeStrEx(tonumber(self.themeDungeonMgr.nextRefreshTime) - MServerTimeMgr.UtcSeconds_u))
    else
        self.panel.LeftTime.LabText = Lang("REFRESHTIME", "0" .. Lang("TIME_SECOND"))

        -- 10s请求一次，防止每帧不停请求
        if not self.lastRequestTime or MServerTimeMgr.UtcSeconds_u - self.lastRequestTime > 10 then
            self.lastRequestTime = MServerTimeMgr.UtcSeconds_u
            self.themeDungeonMgr:RequestGetThemeDungeonInfo()
            self.isTimeOutRequested = true
        end
    end
	
end --func end
--next--
function Theme_ChallengeCtrl:BindEvents()
    self:BindEvent(self.themeDungeonMgr.EventDispatcher,self.themeDungeonMgr.EventType.ThemeDungeonInfoChanged,function()
        self:SetInfo(self.themeDungeonMgr.curThemeId)
    end)


    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, "ThemeDungeonChallengeNormalReward", function(_, ...)
        self:RefreshReward(...)

        -- 收到普通的奖励再请求挑战的，防止同时发送两个同样的协议
        local l_hardDungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(self.themeDungeonInfo.tableInfo.HardDungeonID)
        if l_hardDungeonRow then
            local l_awardId = l_hardDungeonRow.AwardDrop[0] or 0
            if l_awardId > 0 then
                MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_awardId, "ThemeDungeonChallengeHardReward")
            end
        end
    end)

    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, "ThemeDungeonChallengeHardReward", function(_, ...)
        self:RefreshReward(...)
    end)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function Theme_ChallengeCtrl:InitEffect()
    self:RefreshHardNormalState()

    local l_fxData = {}
    l_fxData.rawImage = self.panel.NormalSelectEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1.6, 1.6, 1.6)
    l_fxData.loadedCallback = function()
        self.panel.NormalSelectEffect:SetActiveEx(self.dungeonMode == "normal")
    end
    if self.normalSelectEffect then
        self:DestroyUIEffect(self.normalSelectEffect)
    end
    self.normalSelectEffect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge_1", l_fxData)

    l_fxData.rawImage = self.panel.HardSelectEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1.6, 1.6, 1.6)
    l_fxData.loadedCallback = function()
        self.panel.HardSelectEffect:SetActiveEx(self.dungeonMode == "hard")
    end
    if self.hardSelectEffect then
        self:DestroyUIEffect(self.hardSelectEffect)
    end
    self.hardSelectEffect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge", l_fxData)

    l_fxData.rawImage = self.panel.Effect.RawImg
    l_fxData.scaleFac = Vector3.New(1.6, 1.6, 1.6)
    l_fxData.loadedCallback = nil
    if self.effect then
        self:DestroyUIEffect(self.effect)
    end
    self.effect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge0", l_fxData)

    l_fxData.rawImage = self.panel.Effect2.RawImg
    l_fxData.position = Vector3.New(3, 1.24,0)
    l_fxData.scaleFac = Vector3.New(4, 4, 4)
    l_fxData.loadedCallback = nil
    if self.effect2 then
        self:DestroyUIEffect(self.effect2)
    end
    self.effect2 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Challenge2", l_fxData)

    
end

function Theme_ChallengeCtrl:DestroyEffect()
    if self.effect then
        self:DestroyUIEffect(self.effect)
    end

    if self.effect2 then
        self:DestroyUIEffect(self.effect2)
    end
end

function Theme_ChallengeCtrl:SetInfo(themeDungeonId)
    if themeDungeonId == -1 then return end

    local l_themeDungeonRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(themeDungeonId)
    if not l_themeDungeonRow then return end

    self.themeDungeonInfo = {
        themeDungeonId = themeDungeonId,
        tableInfo = l_themeDungeonRow
    }

    self.currentThemeDungeonInfo = self.currentThemeDungeonInfo or {}
    self.currentThemeDungeonInfo.themeDungeonId = themeDungeonId
    self.currentThemeDungeonInfo.tableInfo = l_themeDungeonRow

    self.panel.DungeonName.LabText = l_themeDungeonRow.ThemeName

    -- 请求奖励
    local l_normalDungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_themeDungeonRow.NormalDungeonID)
    if l_normalDungeonRow then
        local l_awardId = l_normalDungeonRow.AwardDrop[0] or 0
        if l_awardId > 0 then
            MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_awardId, "ThemeDungeonChallengeNormalReward")
        end
    end
    self:SetTeamTarget()
end

-- 选择普通难度
function Theme_ChallengeCtrl:SelectNormal()
    if self.dungeonMode == "normal" then return end
    self.dungeonMode = "normal"
    if self.moveUpTimer then
        self:StopUITimer(self.moveUpTimer)
        self.moveUpTimer = nil
    end
    self.moveUpTimer = self:NewUITimer(function()
        self.panel.NormalBg.transform:SetAsLastSibling()
    end, 0.2)
    self.moveUpTimer:Start()
    self.panel.NormalUpAni.FxAnim:PlayAll()
    self:RefreshHardNormalState()
    self:SetTeamTarget()
end

-- 选择困难难度
function Theme_ChallengeCtrl:SelectHard()
    if self.dungeonMode == "hard" then return end
    self.dungeonMode = "hard"
    if self.moveUpTimer then
        self:StopUITimer(self.moveUpTimer)
        self.moveUpTimer = nil
    end
    self.moveUpTimer = self:NewUITimer(function()
        self.panel.HardBg.transform:SetAsLastSibling()
    end, 0.2)
    self.moveUpTimer:Start()
    self.panel.HardUpAni.FxAnim:PlayAll()
    self:RefreshHardNormalState()
    self:SetTeamTarget()
end

function Theme_ChallengeCtrl:SetTeamTarget(arg1, arg2, arg3)
    local l_TeamTargetId = nil
    if self.dungeonMode == "normal" then
        l_TeamTargetId = TEAM_TARGETID_NORMAL
    else
        l_TeamTargetId = TEAM_TARGETID_HARD 
    end
    self.teamTemplate:SetData({targetTeamId = l_TeamTargetId})
end

function Theme_ChallengeCtrl:RefreshHardNormalState()
    self.panel.NormalSelectEffect:SetActiveEx(self.dungeonMode == "normal")
    -- self.panel.NormalSelect:SetActiveEx(self.dungeonMode == "normal")
    self.panel.NormalMask:SetActiveEx(self.dungeonMode == "hard")

    self.panel.HardSelectEffect:SetActiveEx(self.dungeonMode == "hard")
    -- self.panel.HardSelect:SetActiveEx(self.dungeonMode == "hard")
    self.panel.HardMask:SetActiveEx(self.dungeonMode == "normal")
end

-- 刷新次数信息
function Theme_ChallengeCtrl:RefreshCount()
    local l_dayPassCount, l_dayPassLimit = self.themeDungeonMgr.GetDayPassCountAndLimit()
    local l_weekPassCount, l_weekPassLimit = self.themeDungeonMgr.GetWeekPassCountAndLimit()
    local l_weekAwardCount, l_weekAwardLimit = self.themeDungeonMgr.GetWeekAwardCountAndLimit()
    self.panel.DayLimitImg.Img.fillAmount = l_dayPassCount / l_dayPassLimit
    self.panel.WeekLimitImg.Img.fillAmount = l_weekPassCount / l_weekPassLimit
    self.panel.WeekAwardImg.Img.fillAmount = l_weekAwardCount / l_weekAwardLimit

    self.panel.DayLimitSlider.Slider.value = l_dayPassCount / l_dayPassLimit
    self.panel.WeekLimitSlider.Slider.value = l_weekPassCount / l_weekPassLimit
    self.panel.WeekAwardSlider.Slider.value = l_weekAwardCount / l_weekAwardLimit

    self.panel.DayLimitText.LabText = l_dayPassCount .. "/" .. l_dayPassLimit
    self.panel.WeekLimitText.LabText = l_weekPassCount .. "/" .. l_weekPassLimit
    self.panel.WeekAwardText.LabText = l_weekAwardCount .. "/" .. l_weekAwardLimit
end


function Theme_ChallengeCtrl:RefreshReward(awardInfo, eventName, id)
    if awardInfo then
        if eventName == "ThemeDungeonChallengeNormalReward" then
            local l_datas = {}
            for i, v in ipairs(awardInfo.award_list) do
                local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
                if l_itemRow then
                    table.insert(l_datas, {
                        ID = v.item_id,
                        count = v.count,
                        dropRate = v.drop_rate,
                        isParticular = v.is_particular,
                        IsShowCount = false,
                    })
                end
            end
            self.normalRewardPool:ShowTemplates({Datas = l_datas})
        elseif eventName == "ThemeDungeonChallengeHardReward" then
            local l_datas = {}
            for i, v in ipairs(awardInfo.award_list) do
                local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
                if l_itemRow then
                    table.insert(l_datas, {
                        ID = v.item_id,
                        count = v.count,
                        dropRate = v.drop_rate,
                        isParticular = v.is_particular,
                        IsShowCount = false,
                    })
                end
            end
            self.hardRewardPool:ShowTemplates({Datas = l_datas})

        end
    end
end

--lua custom scripts end
return Theme_ChallengeCtrl