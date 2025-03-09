--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AdventureDiaryTaskPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl

--next--
--lua fields end

--lua class define
AdventureDiaryTaskCtrl = class("AdventureDiaryTaskCtrl", super)
--lua class define end

--lua functions
function AdventureDiaryTaskCtrl:ctor()
    
    super.ctor(self, CtrlNames.AdventureDiaryTask, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.ClosePanelNameOnClickMask=UI.CtrlNames.AdventureDiaryTask
    self.MaskDelayClickTime=0.3
 
end --func end
--next--
function AdventureDiaryTaskCtrl:Init()
    
    self.panel = UI.AdventureDiaryTaskPanel.Bind(self)
    super.Init(self)

    self.needClose = false  --容错关界面标志

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiaryTask)
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    end)
    --前一个按钮点击
    self.panel.BtnPre:AddClick(function ()
        self:SwitchMissionData(0)
    end)
    --下一个按钮点击
    self.panel.BtnNext:AddClick(function ()
        self:SwitchMissionData(1)
    end)

    self.awardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.AwardScroll.LoopScroll,
        TemplatePath = "UI/Prefabs/ItemPrefab"
    })
end --func end
--next--
function AdventureDiaryTaskCtrl:Uninit()

    self.missionInfo = nil
    self.awardId =nil
    self.needClose = false

    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function AdventureDiaryTaskCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("AdventureDiaryData").EUIOpenType.AdventureDiaryTask then
            self:SetAdventureMissionInfo(self.uiPanelData.missionInfo, 
                self.uiPanelData.isNeedAnim, 
                self.uiPanelData.isShowing)
        end
    end

    if not (self.uiPanelData and self.uiPanelData.isShowing) then
        MLuaClientHelper.PlayFxHelper(self.panel.ContentPart.UObj)
    end
    
end --func end
--next--
function AdventureDiaryTaskCtrl:OnDeActive()

    if self.delayPalyCompleteAnimationTimer then
        self:StopUITimer(self.delayPalyCompleteAnimationTimer)
        self.delayPalyCompleteAnimationTimer = nil
    end
end --func end
--next--
function AdventureDiaryTaskCtrl:Update()
    
    if self.needClose then
        UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiaryTask)
    end
    
end --func end


--next--
function AdventureDiaryTaskCtrl:BindEvents()
    
    --奖励预览回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AwardPreviewMgr").AWARD_PREWARD_MSG,
        function(object, awardPreviewRes, customData, awardId)
            self:RefreshPreviewAwards(awardPreviewRes, awardId)
        end)
    
end --func end
--next--
--lua functions end

--lua custom scripts

--奖励预览显示
--missionInfo  冒险日记子任务数据
--needPlayCompleteAnimation 是否需要播放领取完成的动画
--isShowing 当前界面是否已经正在展示
function AdventureDiaryTaskCtrl:SetAdventureMissionInfo(missionInfo, needPlayCompleteAnimation, isShowing)

    if not missionInfo then
        self.needClose = true
        return
    end
    --记录当前的子任务数据
    self.missionInfo = missionInfo

    --依据冒险子任务的目标任务ID获取对应任务信息
    local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(missionInfo.missionData.Target)

    --获取进度信息
    self.panel.TargetText.LabText = l_taskInfo.targetDesc[1] or ""
    self.panel.TargetDescribeText.LabText = l_taskInfo.taskDesc

    self.panel.MissionImg:SetSprite(missionInfo.missionData.SmallPicAtlas, missionInfo.missionData.SmallPicIcon, true)
    self.panel.MissionName.LabText = l_taskInfo.name

    --设置前往按钮或领取提示
    self:SetBtnGoOrTip(l_taskInfo)
    --设置领奖按钮
    self:SetBtnGetAward()
    --已完成标志 与 完成动画设置
    self:SetCompleteFlag(needPlayCompleteAnimation, isShowing)
    --左右切换按钮设置
    self:SetSwitchButtonShow()
    --奖励预览请求
    self.awardItemPool:ShowTemplates({ Datas = {} })  --清除原有列表展示 防弱网
    self.awardId = missionInfo.missionData.Awardid
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(self.awardId)
    
end

--设置前往按钮或领取提示
--taskInfo  任务数据
function AdventureDiaryTaskCtrl:SetBtnGoOrTip(taskInfo)
    --子任务已完成 则 前往按钮和领取提示都关闭
    if self.missionInfo.isFinish then
        self.panel.BtnGo.UObj:SetActiveEx(false)
        self.panel.CanTakeTip.UObj:SetActiveEx(false)
        return
    end

    --判断是否达到领取登记
    --如果未达到任务领取登记则显示提示
    if MPlayerInfo.Lv < taskInfo.minBaseLevel then
        self.panel.BtnGo.UObj:SetActiveEx(false)
        self.panel.CanTakeTip.UObj:SetActiveEx(true)
        self.panel.CanTakeTipText.LabText = Lang("BASE_LEVEL_LIMIT_3", taskInfo.minBaseLevel)
    else
        --如果任务已领取则根据配置判断是否显示前往
        self.panel.CanTakeTip.UObj:SetActiveEx(false)
        self.panel.BtnGo.UObj:SetActiveEx(self.missionInfo.missionData.ShowMoveButton)
        self.panel.BtnGo:AddClick(function()
            --依次获取追踪任务ID列表的数据
            --获取第一个可导航的任务 进行导航
            local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
            local l_trackTaskIds = self.missionInfo.missionData.TrackTaskIds
            for i = 0, l_trackTaskIds.Count - 1 do
                local l_taskData = l_taskMgr.GetTaskData(l_trackTaskIds[i])
                --存在任务数据 且不是不可接、废弃、已完成状态  进入导航判断
                if l_taskData and 
                    l_taskData.taskStatus ~= l_taskMgr.ETaskStatus.NotTake and
                    l_taskData.taskStatus ~= l_taskMgr.ETaskStatus.Abandoned and
                    l_taskData.taskStatus ~= l_taskMgr.ETaskStatus.Finished then
                    --如果是已接取的 判断不是父子任务的父任务 则进行导航
                    if not (l_taskData.taskStatus == l_taskMgr.ETaskStatus.Taked and
                        l_taskData.currentTaskTarget.targetType == l_taskMgr.ETaskTargetType.ParentTask) then
                        --先还原到主界面再导航 防止导航是打开某个界面
                        game:ShowMainPanel()
                        --请求任务导航
                        l_taskMgr.OnQuickTaskClickWithTaskId(l_trackTaskIds[i])
                        break
                    end
                end
            end
        end)
    end
end

--设置领奖按钮
function AdventureDiaryTaskCtrl:SetBtnGetAward()
    self.panel.BtnGetAward.UObj:SetActiveEx(self.missionInfo.isFinish and not self.missionInfo.isGetAward)
    self.panel.BtnGetAward:AddClick(function()
        MgrMgr:GetMgr("AdventureDiaryMgr").ReqGetMissionAward(self.missionInfo.missionData.ID)
    end)
end

--设置完成标志
--needPlayCompleteAnimation 是否需要播放领取完成的动画
--isShowing 当前界面是否已经正在展示
function AdventureDiaryTaskCtrl:SetCompleteFlag(needPlayCompleteAnimation, isShowing)
    self.panel.Complete.UObj:SetActiveEx(false)  --默认不展示
    if self.missionInfo.isFinish and self.missionInfo.isGetAward then
        if needPlayCompleteAnimation then
            if isShowing then
                --如果当前界面已经正在展示 则直接播放完成动画
                self.panel.Complete.UObj:SetActiveEx(true)  --播放动画前展示
                MLuaClientHelper.PlayFxHelper(self.panel.Complete.UObj)
            else
                --如果当前界面是新打开 等待入场动画结束
                self.delayPalyCompleteAnimationTimer = self:NewUITimer(function ()
                    self.panel.Complete.UObj:SetActiveEx(true)  --播放动画前展示
                    MLuaClientHelper.PlayFxHelper(self.panel.Complete.UObj)
                end, 0.3)
                self.delayPalyCompleteAnimationTimer:Start()
            end
        else
            self.panel.Complete.UObj:SetActiveEx(true) 
        end
    end
end

--设置左右切换按钮展示
function AdventureDiaryTaskCtrl:SetSwitchButtonShow()
    --获取子任务对应章节
    self.curChapter = self.missionInfo.missionData.Chapter
    self.curIndex = 0
    --对应章节数据 和 子任务对应索引获取
    local l_adventureDiaryInfo = DataMgr:GetData("AdventureDiaryData").adventureDiaryInfo
    local l_chapterData = nil
    if l_adventureDiaryInfo then
        l_chapterData = l_adventureDiaryInfo[self.curChapter]
        if l_chapterData then
            for i = 1, #l_chapterData.missionInfos do
                if l_chapterData.missionInfos[i].missionData.ID == self.missionInfo.missionData.ID then
                    self.curIndex = i
                    break
                end
            end
        end
    end
    --根据子任务对应索引 和 章节的子任务数 判定左右切换按钮是否可点击
    self.panel.BtnPre.Btn.interactable = self.curIndex > 1
    self.panel.BtnNext.Btn.interactable = l_chapterData and self.curIndex > 0 and self.curIndex < #l_chapterData.missionInfos
end

--切换子任务数据
--switchType  切换类型 0前一个 1后一个
function AdventureDiaryTaskCtrl:SwitchMissionData(switchType)
    local l_aimIndex = self.curIndex
    if switchType == 0 then
        l_aimIndex = self.curIndex - 1
    else
        l_aimIndex = self.curIndex + 1
    end

    local l_adventureDiaryInfo = DataMgr:GetData("AdventureDiaryData").adventureDiaryInfo

    if l_adventureDiaryInfo then
        local l_aimData = l_adventureDiaryInfo[self.curChapter].missionInfos[l_aimIndex]
        if l_aimData then
            self:SetAdventureMissionInfo(l_aimData)
        end
    end
end

--奖励预览数据接收
--awardPreviewRes  奖励预览数据
--awardId   奖励预览ID
function AdventureDiaryTaskCtrl:RefreshPreviewAwards(awardPreviewRes, awardId)
    --判断是否是需求的奖励ID 防止弱网乱穿
    if not self.awardId or self.awardId ~= awardId then
        return
    end
    local l_datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardPreviewRes)
    local l_isCompleted = self.missionInfo.isGetAward
    for _, data in ipairs(l_datas) do
        data.IsGray = l_isCompleted
    end
    self.awardItemPool:ShowTemplates({ Datas = l_datas })

end
--lua custom scripts end
return AdventureDiaryTaskCtrl