--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HeroChallengeResultPanel"
require "UI/Template/ItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
HeroChallengeResultCtrl = class("HeroChallengeResultCtrl", super)
--lua class define end

--lua functions
function HeroChallengeResultCtrl:ctor()

    super.ctor(self, CtrlNames.HeroChallengeResult, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function HeroChallengeResultCtrl:Init()

    self.panel = UI.HeroChallengeResultPanel.Bind(self)
	super.Init(self)
    self:OnInitialize()

end --func end
--next--
function HeroChallengeResultCtrl:Uninit()

    self:UnInitialize()
    super.Uninit(self)
    self.panel = nil

    self.awardTemplatePool = nil
end --func end
--next--
function HeroChallengeResultCtrl:OnActive()


end --func end
--next--
function HeroChallengeResultCtrl:OnDeActive()
    self:DeleteStartTimer()
    local l_pastTime = tonumber(tostring(MServerTimeMgr.UtcSeconds)) - MgrMgr:GetMgr("DungeonMgr").DungeonResultTime
    local l_remainTime = MgrMgr:GetMgr("DungeonMgr").DungeonRemainTime - l_pastTime
    DataMgr:GetData("ThemeDungeonData").RefreshAllDungeonRewardItem()
    if l_remainTime > 0 then
        local l_data =
        {
            startTime = MServerTimeMgr.UtcSeconds,
            remainTime = l_remainTime
        }
        UIMgr:ActiveUI(UI.CtrlNames.CountDown, l_data)
    end
end --func end
--next--
function HeroChallengeResultCtrl:Update()


end --func end



--next--
function HeroChallengeResultCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

local l_timer = nil

function HeroChallengeResultCtrl:OnInitialize()

end

function HeroChallengeResultCtrl:UnInitialize()
    self:DeleteTimer()
    MgrMgr:GetMgr("RollMgr").PlayRollOrLuckyDraw(MgrMgr:GetMgr("RollMgr").g_RollContext.RollContextDungeonsResult, nil,true)
end

--Title1 Title1的文本
--TitleDescription1 TitleDescription1的文本
--Title3 的文本
--TitleDescription3 TitleDescription3的文本
--Title4 的文本
--TitleDescription4 TitleDescription4的文本
--TitleDescription5 TitleDescription5的文本
--IsShowStamp 是否显示印章
--StampDescription 印章里面的文字
--Difficulty 副本难度
--PassTime 通关时间
--IsNewScore 是否显示新记录文本
--SkeletonAnimationName 动画名
function HeroChallengeResultCtrl:ShowWinTween(resultData)

    local l_spine = self.panel.WinSkeletonAnimation.gameObject:GetComponent("SkeletonAnimation")

    local l_skeletonAnimationName
    if resultData.SkeletonAnimationName then
        l_skeletonAnimationName=resultData.SkeletonAnimationName
    else
        l_skeletonAnimationName="VICTORY"
    end

    l_spine.initialSkinName=l_skeletonAnimationName
    l_spine:Initialize(true)

    self.panel.StageVictory.gameObject:SetActiveEx(true)
    self.panel.StageFailed.gameObject:SetActiveEx(false)
    --播放动画
    MLuaClientHelper.PlayFxHelper(self.panel.StageVictory.gameObject)
    MLuaClientHelper.PlayFxHelper(self.panel.bg.gameObject)
    MLuaClientHelper.PlayFxHelper(self.panel.info.gameObject)
    MLuaClientHelper.PlayFxHelper(self.panel.gotoBtn.gameObject)
    --奖励显示
    if not self.awardTemplatePool then
        self.awardTemplatePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.ItemTemplate,
            TemplateParent = self.panel.AwardContent.transform
        })
    end
    self.awardTemplatePool:ShowTemplates({ Datas = MgrMgr:GetMgr("ThemeDungeonMgr").GetAllRewardItems() })
    self.panel.Assist:SetActiveEx(DataMgr:GetData("ThemeDungeonData").IsAssistReward)
    --清空奖励
    DataMgr:GetData("ThemeDungeonData").DungeonRewardItem = {}

    local l_difficulty=resultData.Difficulty
    --难度星星
    if l_difficulty then
        self.panel.degreeStarPanel:SetActiveEx(true)
        self.degreeStars = self.degreeStars or {}
        for _ = 1, l_difficulty do
            local l_degreeStar = self:CloneObj(self.panel.degreeStar.gameObject)
            l_degreeStar.gameObject:SetActiveEx(true)
            l_degreeStar.transform:SetParent(self.panel.degreeStarPanel.gameObject.transform)
            l_degreeStar.transform:SetLocalScaleOne()
        end
    else
        self.panel.degreeStarPanel:SetActiveEx(false)
    end

    if resultData.IsNewScore then
        self.panel.newScore:SetActiveEx(true)
    else
        self.panel.newScore:SetActiveEx(false)
    end

    local l_passTime = ""
    if resultData.PassTime ~= nil then
        l_passTime = Common.Functions.SecondsToTimeStr(resultData.PassTime)
    end
    self.panel.passTimeText.LabText = l_passTime
    self.panel.passTimeText2.LabText = l_passTime


    if resultData.Title1 then
        self.panel.Title1.LabText=resultData.Title1
    else
        self.panel.Title1.LabText=Lang("HeroChallengeResult_DifficultyText")
    end

    if resultData.TitleDescription1 then
        self.panel.TitleDescription1:SetActiveEx(true)
        self.panel.TitleDescription1.LabText=resultData.TitleDescription1
    else
        self.panel.TitleDescription1:SetActiveEx(false)
    end

    if resultData.Title3 then
        self.panel.Title3:SetActiveEx(true)
        self.panel.Title3.LabText=resultData.Title3
    else
        self.panel.Title3:SetActiveEx(false)
    end
    if resultData.TitleDescription3 then
        self.panel.TitleDescription3:SetActiveEx(true)
        self.panel.TitleDescription3.LabText=resultData.TitleDescription3
    else
        self.panel.TitleDescription3:SetActiveEx(false)
    end

    if resultData.Title4 then
        self.panel.Title4.LabText=resultData.Title4
        self.panel.Title4:SetActiveEx(true)
    else
        self.panel.Title4:SetActiveEx(false)
    end

    if resultData.TitleDescription4 then
        self.panel.TitleDescription4:SetActiveEx(true)
        self.panel.TitleDescription4.LabText=resultData.TitleDescription4
    else
        self.panel.TitleDescription4:SetActiveEx(false)
    end

    if resultData.TitleDescription5 then
        self.panel.TitleDescription5:SetActiveEx(true)
        self.panel.TitleDescription5.LabText=resultData.TitleDescription5
    else
        self.panel.TitleDescription5:SetActiveEx(false)
    end

    if resultData.IsShowStamp then
        self.panel.StampDescription.LabText=resultData.StampDescription
        self:DeleteStartTimer()
        self.l_stampStartTimer = self:NewUITimer(function()
            self.panel.Stamp:SetActiveEx(true)
            self:StopUITimer(self.l_stampStartTimer)
        end, 2)
        self.l_stampStartTimer:Start()
    else
        self.panel.Stamp:SetActiveEx(false)
    end

    self.gotoTimer = self:NewUITimer(function()
        self.panel.gotoBtn:AddClick(function()

            if MPlayerInfo.PlayerDungeonsInfo.DungeonType ~= MgrMgr:GetMgr("DungeonMgr").DungeonType.TowerDefenseSingle and
                    MPlayerInfo.PlayerDungeonsInfo.DungeonType ~= MgrMgr:GetMgr("DungeonMgr").DungeonType.TowerDefenseDouble then
                UIMgr:DeActiveUI(UI.CtrlNames.HeroChallengeResult)
                self:DeleteTimer()
            end
            --UIMgr:DeActiveUI(UI.CtrlNames.HeroChallengeResult)
        end)
    end, 7)
    self.gotoTimer:Start()

    self:DeleteTimer()
    local l_index = tonumber(MGlobalConfig:GetInt("DungeonHeroChallengeExitTime")) or 0
    l_index = l_index > 0 and l_index or 10
    l_timer = self:NewUITimer(function()
        l_index = l_index - 1
        self.panel.gotoText.LabText = Lang("HERO_CHALLENGE_EXIT", l_index)
        if l_index <= 0 then
            self:DeleteTimer()
            UIMgr:DeActiveUI(UI.CtrlNames.HeroChallengeResult)
        end
    end, 1, -1, true)
    l_timer:Start()
end

function HeroChallengeResultCtrl:ShowLoseTween()
    self.panel.StageFailed.gameObject:SetActiveEx(true)
    self.panel.StageVictory.gameObject:SetActiveEx(false)
    MLuaClientHelper.PlayFxHelper(self.panel.StageFailed.gameObject)
    local l_index = 2
    l_timer = self:NewUITimer(function()
        l_index = l_index - 1
        if l_index <= 0 then
            self:DeleteTimer()
            UIMgr:DeActiveUI(UI.CtrlNames.HeroChallengeResult)
        end
    end, 1, -1, true)
    l_timer:Start()
end

function HeroChallengeResultCtrl:DeleteTimer()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
end

function HeroChallengeResultCtrl:DeleteStartTimer()
    if self.l_stampStartTimer then
        self:StopUITimer(self.l_stampStartTimer)
        self.l_stampStartTimer = nil
    end
end

return HeroChallengeResultCtrl
--lua custom scripts end
