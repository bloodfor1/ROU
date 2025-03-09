--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HeroChallengePanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
HeroChallengeCtrl = class("HeroChallengeCtrl", super)
--lua class define end

--lua functions
function HeroChallengeCtrl:ctor()

	super.ctor(self, CtrlNames.HeroChallenge, UILayer.Function, nil, ActiveType.Exclusive)

    self.teamMgr = MgrMgr:GetMgr("TeamMgr")
    self.awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self.heroChallengeMgr = MgrMgr:GetMgr("HeroChallengeMgr")

end --func end
--next--
function HeroChallengeCtrl:Init()

	self.panel = UI.HeroChallengePanel.Bind(self)
	super.Init(self)

    self.ringScrollRect=nil

    self.curNandu = 1
    self.timers = {}

    self:InitPanel()

end --func end
--next--
function HeroChallengeCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil
    self.rewardItems = nil

    if self.ringScrollRect then
        self.ringScrollRect.OnStartDrag=nil
        self.ringScrollRect.OnEndDrag=nil
        self.ringScrollRect.OnItemIndexChanged=nil
        self.ringScrollRect.onInitItem=nil
        self.ringScrollRect=nil
    end


    --销毁模型
    if self.monsterCards then
        for _, card in pairs(self.monsterCards) do
            self:DestroyUIModel(card.model)
        end
        self.monsterCards = nil
    end


end --func end
--next--
function HeroChallengeCtrl:OnActive()

end --func end
--next--
function HeroChallengeCtrl:OnDeActive()
    for i = 1, #self.timers do
        self:StopUITimer(self.timers[i])
    end
    self.timers = nil

    if self.itemTween then
        MUITweenHelper.KillTweenDeleteCallBack(self.itemTween)
        self.itemTween = nil
    end

end --func end
--next--
function HeroChallengeCtrl:Update()


end --func end

--next--
function HeroChallengeCtrl:BindEvents()
    self:BindEvent(self.teamMgr.EventDispatcher,DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, self.RefreshBtnState)
    self:BindEvent(self.awardPreviewMgr.EventDispatcher,self.awardPreviewMgr.AWARD_PREWARD_MSG, self.RefreshPreviewAwards)
end --func end
--next--
--lua functions end

--lua custom scripts

--初始面板信息
function HeroChallengeCtrl:InitPanel()
    --关闭
    self.panel.BtnClose:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.HeroChallenge)
    end)
    self.panel.TotalScoreInfoBtn.Listener.onDown=function(go,eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("HERO_HIGH_SCORE_DESC"), eventData, Vector2(1, 1))
    end
    self.panel.DungeonInfoBtn.Listener.onDown=function(go,eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("HERO_LEVEL_STATS_DESC"), eventData, Vector2(1, 1))
    end
    self.panel.RewardInfoBtn.Listener.onDown=function(go,eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("HERO_CHALLENGE_REWARD_DESC"), eventData, Vector2(1, 1))
    end
    --难度选择
    self.nanduTogs = {self.panel.Nandu1Tog.TogEx, self.panel.Nandu2Tog.TogEx, self.panel.Nandu3Tog.TogEx}
    for i = 1, #self.nanduTogs do
        local l_nandu = i
        self.nanduTogs[i].onValueChanged:AddListener(function(isOn)
            if isOn then
                self.curNandu = l_nandu
                self:RefreshLevelInfo()
            end
        end)
    end
    --关卡选择
    self.ringScrollRect = self.panel.ScrollView.gameObject:GetComponent("MoonClient.MRingScrollRect")
    local l_count = #self.heroChallengeMgr.g_challengeInfo
    self.ringScrollRect.OnStartDrag = function()
        self.isDragging = true
    end
    self.ringScrollRect.OnEndDrag = function()
        self.isDragging = false
    end
    self.ringScrollRect.OnItemIndexChanged = function()
        --保存选中的index，以便恢复
        self.heroChallengeMgr.g_lastSelectedIndex = self.ringScrollRect.CurItemIndex
        self:RefreshLevelInfo()
    end
    self.ringScrollRect.onInitItem = function(go,index)
        self.monsterCards = self.monsterCards or {}
        self.monsterCards[index] = {}
        self.monsterCards[index].index = index
        self.monsterCards[index].go = go
        self.monsterCards[index].bossRawImage = go.transform:Find("BossImg"):GetComponent("RawImage")
        self.monsterCards[index].bossBtn = go.transform:Find("BossBtn"):GetComponent("MLuaUICom")
        self.monsterCards[index].rewardReceived = go.transform:Find("RewardReceived"):GetComponent("MLuaUICom")

        local l_challengeInfo = self.heroChallengeMgr.g_challengeInfo[index+1]
        self.monsterCards[index].challengeInfo = l_challengeInfo

        self.monsterCards[index].rewardReceived:SetActiveEx(l_challengeInfo.pass)
        --设置模型
        self.monsterCards[index].idleClipPath = MAnimationMgr:GetClipPath(l_challengeInfo.table.BossAnimIdle)
        self.monsterCards[index].poseClipPath = MAnimationMgr:GetClipPath(l_challengeInfo.table.BossAnimPose)
        local l_modelData = 
        {
            prefabPath = "Prefabs/" .. l_challengeInfo.table.BossModelName,
            rawImage = self.monsterCards[index].bossRawImage,
            defaultAnim = self.monsterCards[index].idleClipPath
        }
        self.monsterCards[index].model = self:CreateUIModelByPrefabPath(l_modelData)
        local l_animInfo = self.monsterCards[index].model.Ator:OverrideAnim("Special", self.monsterCards[index].poseClipPath)
        self.monsterCards[index].poseLength = l_animInfo and l_animInfo.Length or 0
        self.monsterCards[index].model:AddLoadGoCallback(function(go)
            self.monsterCards[index].isLoaded = true
            self.monsterCards[index].bossBtn:AddClick(function()
                if self.ringScrollRect.CurItemIndex == index then
                    self:ShowModelPose(index)
                else
                    self.ringScrollRect:SelectIndex(index,true)
                end
            end)

            --保证模型高度一致
            self.monsterCards[index].normalScale = 1.2 / self.monsterCards[index].model.ColHeight
            self.monsterCards[index].bigScale = 1.2 * 1.3 / self.monsterCards[index].model.ColHeight
            --设置模型大小
            self.monsterCards[index].isNormal = true
            local l_scale = self.monsterCards[index].normalScale
            if index == 0 then
                self.monsterCards[index].isNormal = false
                l_scale = self.monsterCards[index].bigScale
            else
                self.monsterCards[index].model.Ator.Speed = 0
            end
            self.monsterCards[index].model.Trans:SetLocalScale(l_scale, l_scale, l_scale)
        end)
    end
    self.ringScrollRect:SetCount(l_count)

    --开始
    self.panel.StartBtn:AddClick(function()
        if not self.isDragging then
            if MgrMgr:GetMgr("DailyTaskMgr").IsActivityOpend(MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_HeroChallenge) then
                local l_curIndex = self.ringScrollRect.CurItemIndex
                self.heroChallengeMgr.g_curIndex = l_curIndex
                local l_challengeInfo =  self.monsterCards[l_curIndex].challengeInfo
                local l_degree = self.curNandu
                self.heroChallengeMgr.g_curDegree = l_degree
                local l_dungeonInfo = l_challengeInfo.dungeon[l_degree]
                if l_dungeonInfo then
                    if l_challengeInfo.pass then
                        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("HERO_CHALLENGE_STAGE_ALREADY_CLEARED"),function()
                            self.heroChallengeMgr.EnterDungeons(l_dungeonInfo.dungeonID,l_degree)
                        end)
                    else
                        self.heroChallengeMgr.EnterDungeons(l_dungeonInfo.dungeonID,l_degree)
                    end

                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PVP_WARNING_EVENT_UNAVAILABLE"))
            end
        end
    end)
    --控制箭头的点击间隔
    local l_btnInterval = 0.6
    local l_isOperationEnabled = true
    --左箭头
    self.panel.LeftBtn:AddClick(function()
        if not self.isDragging and l_isOperationEnabled then
            l_isOperationEnabled = false
            local l_timer = self:NewUITimer(function()
                l_isOperationEnabled = true
            end, l_btnInterval)
            l_timer:Start()
            table.insert(self.timers,l_timer)
            local index = self.ringScrollRect.CurItemIndex
            if  index==0 then
                index = l_count-1
            else
                index = index -1
            end
            self.ringScrollRect:SelectIndex(index,true)
        end
    end)
    --右箭头
    self.panel.RightBtn:AddClick(function()
        if not self.isDragging and l_isOperationEnabled then
            l_isOperationEnabled = false
            local l_timer = self:NewUITimer(function()
                l_isOperationEnabled = true
            end, l_btnInterval)
            l_timer:Start()
            table.insert(self.timers,l_timer)
            local index = self.ringScrollRect.CurItemIndex
            if  index==(l_count-1) then
                index = 0
            else
                index = index +1
            end
            self.ringScrollRect:SelectIndex(index,true)
        end
    end)
    
    --默认选中第一个难度
    self:SelectNandu(1)
    self:RefreshLevelInfo()
end

function HeroChallengeCtrl:SelectIndex(index)
    self.ringScrollRect:SelectIndex(index,false)
end

--选择难度[1, 3]
function HeroChallengeCtrl:SelectNandu(nandu)
    if self.nanduTogs and self.nanduTogs[nandu] then
        self.nanduTogs[nandu].isOn = true
    end
end

--刷新当前关卡信息
function HeroChallengeCtrl:RefreshLevelInfo()
    local l_curIndex = self.ringScrollRect.CurItemIndex
    local l_challengeInfo =  self.monsterCards[l_curIndex].challengeInfo
    self.panel.StageName.LabText = l_challengeInfo.table.LevelName
    self.panel.AlreadyReceived:SetActiveEx(l_challengeInfo.pass)
    if l_challengeInfo.passTime == 0 then
        self.panel.PassTimeText.LabText = "--"
    else
        self.panel.PassTimeText.LabText = Common.Functions.SecondsToTimeStr(l_challengeInfo.passTime)
    end
    if l_challengeInfo.grade == 0 then
        self.panel.ScoreText.LabText = "--"
    else
        self.panel.ScoreText.LabText = l_challengeInfo.grade
    end

    --总得分
    local l_allScore = 0
    for _, v in pairs(self.heroChallengeMgr.g_challengeInfo) do
        l_allScore = l_allScore + v.grade
    end
    if l_allScore == 0 then
        self.panel.TotalScoreText.LabText = "--"
    else
        self.panel.TotalScoreText.LabText = l_allScore
    end

    self:RefreshCurDungeonTableData()
    self:RefreshNanduInfo()
    self:RequestPreviewAwards()
    self:RefreshBtnState()

    --刷新模型大小
    for i = 0, #self.heroChallengeMgr.g_challengeInfo - 1 do
        self:RefreshModelScale(i)
    end
end

--刷新模型大小
function HeroChallengeCtrl:RefreshModelScale(index)
    if not self.monsterCards[index] or not self.monsterCards[index].isLoaded then return end

    local l_isSelected = false
    local l_isChanged = false
    local l_fromScale = 1
    local l_toScale = 1
    if self.ringScrollRect.CurItemIndex == index then
        if  self.monsterCards[index].isNormal then
            self.monsterCards[index].isNormal = false
            l_isChanged = true
            l_isSelected = true
            l_fromScale = self.monsterCards[index].normalScale
            l_toScale = self.monsterCards[index].bigScale
        end

    else
        if not self.monsterCards[index].isNormal then
            self.monsterCards[index].isNormal = true
            l_isChanged = true
            l_toScale = self.monsterCards[index].normalScale
            l_fromScale = self.monsterCards[index].bigScale
        end
    end
    if l_isChanged then
        if l_isSelected then
            self.monsterCards[index].model.Ator.Speed = 1
        else
            self.monsterCards[index].model.Ator:CrossFade("Idle", 0.2)
            local l_timer = self:NewUITimer(function()
                self.monsterCards[index].model.Ator.Speed = 0
            end, 0.2)
            l_timer:Start()
            table.insert(self.timers,l_timer)
        end
        self.itemTween = MUITweenHelper.TweenScale(self.monsterCards[index].model.UObj, Vector3.New(l_fromScale, l_fromScale, l_fromScale), Vector3.New(l_toScale, l_toScale, l_toScale), 0.2,
                function()
                    --if l_isSelected then
                    --    self:ShowModelPose(index)
                    --end
                end)
    end
end

--处理模型点击
function HeroChallengeCtrl:ShowModelPose(index)
    if self.monsterCards[index].isPlaying then return end
    self.monsterCards[index].model.Ator:CrossFade("Special", 0.2)
    self.monsterCards[index].isPlaying = true
    local l_timer = self:NewUITimer(function()
        if not self.monsterCards then return end
        self.monsterCards[index].isPlaying = false
        self.monsterCards[index].model.Ator:CrossFade("Idle", 0.2)
    end, self.monsterCards[index].poseLength)
    l_timer:Start()
    table.insert(self.timers,l_timer)
end

--刷新难度信息
function HeroChallengeCtrl:RefreshNanduInfo()
    self.panel.DifficultText.LabText = Lang("HERO_CHALLENGE_DIFFICULTY_" .. self.curNandu)
end

--刷新奖励信息
function HeroChallengeCtrl:RefreshPreviewAwards(awardPreviewRes)
    local l_rewardList = awardPreviewRes and awardPreviewRes.award_list
    local l_previewCount = awardPreviewRes.preview_count == -1 and #l_rewardList or awardPreviewRes.preview_count
    local l_previewNum = awardPreviewRes.preview_num
    local l_curIndex = self.ringScrollRect.CurItemIndex
    local l_challengeInfo =  self.monsterCards[l_curIndex].challengeInfo
    if self.rewardItems then
        for _, v in ipairs(self.rewardItems) do
            self:UninitTemplate(v)
        end
    end
    self.rewardItems = {}
    if #l_rewardList > 0 and l_previewCount > 0 then
        for i, v in ipairs(l_rewardList) do
            if i > l_previewCount then break end
            local l_id = v.item_id
            local l_count = v.count
            local l_showCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(l_previewNum, v.count)
            local l_itemTemplate = self:NewTemplate("ItemTemplate",{
                TemplateParent = self.panel.RewardContent.gameObject.transform,
            })
            MLuaCommonHelper.SetLocalScale(l_itemTemplate:transform(), 0.8, 0.8, 1)
            l_itemTemplate:SetData({ID = l_id, IsShowCount = l_showCount, Count = l_count, IsShowTips = true, IsGray = l_challengeInfo.pass})
            table.insert(self.rewardItems, l_itemTemplate)
        end
    end
end


--刷新按钮状态
function HeroChallengeCtrl:RefreshBtnState()
    local l_isEnabled = true
    if self.curDungeonTableData then
        local l_hasTeam = table.ro_size(DataMgr:GetData("TeamData").myTeamInfo.memberList) > 0
        if l_hasTeam then
            l_teamNum = table.ro_size(DataMgr:GetData("TeamData").myTeamInfo.memberList)
            if l_teamNum < self.curDungeonTableData.NumbersLimit[0] or l_teamNum > self.curDungeonTableData.NumbersLimit[1] then
                l_isEnabled = false
            else
                l_isCaptain = MPlayerInfo.UID:tostring() == tostring(DataMgr:GetData("TeamData").myTeamInfo.captainId)
                if not l_isCaptain then
                    l_isEnabled = false
                end
            end
        else
            l_isEnabled = false
        end
    end
    self.panel.StartBtn:SetGray(not l_isEnabled)
end

--刷新当前副本表信息
function HeroChallengeCtrl:RefreshCurDungeonTableData()
    if self.ringScrollRect then
        local l_curIndex = self.ringScrollRect.CurItemIndex
        local l_challengeInfo =  self.monsterCards[l_curIndex].challengeInfo
        if l_challengeInfo and l_challengeInfo.dungeon[self.curNandu] then
            local l_dungeonID = l_challengeInfo.dungeon[self.curNandu].dungeonID
            local l_dungeonTableData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonID)
            if l_dungeonTableData then
                self.curDungeonTableData = l_dungeonTableData
            end
        end
    end
end

--获取奖励信息
function HeroChallengeCtrl:RequestPreviewAwards()
    if self.curDungeonTableData then
        local l_rewardId = self.curDungeonTableData.FirstAward[0]
        if l_rewardId ~= nil and l_rewardId ~= 0 then
            MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_rewardId)
        end
    end
end

--lua custom scripts end
return HeroChallengeCtrl
