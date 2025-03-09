--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BingoPanel"
require "UI/Template/BingoNumItem"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
BingoCtrl = class("BingoCtrl", super)
--lua class define end

--lua functions
function BingoCtrl:ctor()
	
	super.ctor(self, CtrlNames.Bingo, UILayer.Function, nil, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function BingoCtrl:Init()
	
	self.panel = UI.BingoPanel.Bind(self)
	super.Init(self)

    self.sliderValueList = {0.085, 0.309, 0.53, 0.758, 1}

    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Bingo)
    end)

    self.panel.AwardPreviewBackBtn:AddClick(function()
        self:HideAwardPreview()
    end)

    self.panel.Btn_Wenhao:AddClick(function()
        local l_pointEventData=PointerEventData.New(EventSystem.current)
        l_pointEventData.position = Input.mousePosition
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("BINGO_DETAILS"), l_pointEventData, Vector2(0, 0.8), false,nil,MUIManager.UICamera,true)
    end)

    self.bingoNumPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BingoNumItem,
        TemplateParent = self.panel.BingoContent.transform,
        TemplatePrefab = self.panel.BingoNumItem.LuaUIGroup.gameObject,
    })

    self.awardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.AwardScroll.LoopScroll
    })


    -- 每一分钟检测一次活动状态
    self.stateTimer = self:NewUITimer(function()
        self:RefreshActivityState()
    end, 60, -1, true)
    self.stateTimer:Start()

    self.actId = MgrMgr:GetMgr("FestivalMgr").GetIdByType(EnmBackstageDetailType.EnmBackstageDetailTypeBingo)
    self.numAwardList = {}

    local l_activityData = DataMgr:GetData("FestivalData").GetDataById(self.actId)
    --logError(ToString(l_activityData))
    if l_activityData then
        self.panel.AwardTime.LabText = Lang("AWARD_GET_TIME",
                Common.TimeMgr.GetDataShowTime(tonumber(l_activityData.fetch_award_time.first) + 1),
                Common.TimeMgr.GetDataShowTime(tonumber(l_activityData.fetch_award_time.second) - 1))

        for _, awardInfo in ipairs(l_activityData.awardInfos) do
            table.insert(self.numAwardList, {
                awardId = awardInfo.awardId,
                num = awardInfo.param
            })
        end
        table.sort(self.numAwardList, function(a, b)
            return a.num < b.num
        end)
    end

    for i = 1, 5 do
        self.panel.Title[i].LabText = Lang("BING_NUM_CONTION", self.numAwardList[i] and self.numAwardList[i].num or 0)
        self.panel.LockBtn[i]:AddClick(function()
            local l_bingoNum = MgrMgr:GetMgr("BingoMgr").GetBingoSucceedNum()
            if self.numAwardList[i] then
                local l_canReceive = self.numAwardList[i].num <= l_bingoNum
                if l_canReceive then
                    MgrMgr:GetMgr("BingoMgr").GetAward(self.numAwardList[i].awardId)
                else
                    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(self.numAwardList[i].awardId, "BingoAwardPreview")
                end
            end
        end)
        self.panel.UnlockBtn[i]:AddClick(function()
            if self.numAwardList[i] then
                MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(self.numAwardList[i].awardId, "BingoAwardPreview")
            end
        end)
    end

    self:HideAwardPreview()
	self:RefreshRewardState()
    self:RefreshBingoNums()
    self:RefreshActivityState()
end --func end
--next--
function BingoCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BingoCtrl:OnActive()
	MgrMgr:GetMgr("BingoMgr").RequestBingoZone()
end --func end
--next--
function BingoCtrl:OnDeActive()
	
	
end --func end
--next--
function BingoCtrl:Update()
	
	
end --func end
--next--
function BingoCtrl:BindEvents()
	local l_bingoMgr = MgrMgr:GetMgr("BingoMgr")
    self:BindEvent(l_bingoMgr.EventDispatcher, l_bingoMgr.EventType.RefreshBingoSucceedNum, function(_, getBingo)
        if getBingo then
            local l_bingoNum = MgrMgr:GetMgr("BingoMgr").GetBingoSucceedNum()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BINGO_NEW_NUM", l_bingoNum))
            self:PlayBingoEffect()
        end

        self:RefreshRewardState()
    end)

    self:BindEvent(l_bingoMgr.EventDispatcher, l_bingoMgr.EventType.RefreshNum, function()
        self:RefreshBingoNums()
    end)

    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, "BingoAwardPreview", function(_, ...)
        self:RefreshPreviewAwards(...)
    end)

    self:BindEvent(l_bingoMgr.EventDispatcher, l_bingoMgr.EventType.RefreshReward, function()
        self:RefreshRewardState()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function BingoCtrl:RefreshActivityState()
    local l_isEnd = MgrMgr:GetMgr("FestivalMgr").IsActivityEnd(self.actId)
    self.panel.Open:SetActiveEx(not l_isEnd)
    self.panel.Close:SetActiveEx(l_isEnd)
    if l_isEnd then
        self.panel.StateText.LabText = Lang("ACTIVITY_END")
        self.panel.BingoDes.LabText = Lang("BINGO_END_DESCRIPTION")
    else
        self.panel.StateText.LabText = Lang("ACTIVITY_GOING")
        self.panel.BingoDes.LabText = Lang("BINGO_DESCRIPTION")
    end

    local l_activityData = DataMgr:GetData("FestivalData").GetDataById(self.actId)
    if l_activityData then
        if l_isEnd then
            self.panel.AwardTime.LabText = Lang("AWARD_GET_TIME",
                    Common.TimeMgr.GetDataShowTime(tonumber(l_activityData.fetch_award_time.first) + 1),
                    Common.TimeMgr.GetDataShowTime(tonumber(l_activityData.fetch_award_time.second) - 1))
        else
            self.panel.AwardTime.LabText = Lang("ACTIVITY_TIME",
                    Common.TimeMgr.GetDataShowTime(tonumber(l_activityData.startTimeStamp)),
                    Common.TimeMgr.GetDataShowTime(tonumber(l_activityData.endTimeStamp) - 1))
        end
    end
end

function BingoCtrl:RefreshRewardState()
    local l_bingoNum = MgrMgr:GetMgr("BingoMgr").GetBingoSucceedNum()
    self.panel.BingoNum.LabText = l_bingoNum

    local l_greaterIndex = 1
    while l_greaterIndex < #self.numAwardList and l_bingoNum > self.numAwardList[l_greaterIndex].num do
        l_greaterIndex = l_greaterIndex + 1
    end
    local l_lessNum = self.numAwardList[l_greaterIndex-1] and self.numAwardList[l_greaterIndex-1].num or 0
    local l_greaterNum = self.numAwardList[l_greaterIndex] and self.numAwardList[l_greaterIndex].num or 0
    local l_lessSliderValue = self.sliderValueList[l_greaterIndex-1] or 0
    local l_greaterSliderValue = self.sliderValueList[l_greaterIndex]
    local l_finalSliderValue = l_lessSliderValue + (l_greaterSliderValue - l_lessSliderValue) * (l_bingoNum - l_lessNum) / (l_greaterNum - l_lessNum)

    self.panel.NumSlider.Slider.value = l_finalSliderValue

    for i = 1, 5 do
        local l_canReceive = false
        local l_isReceived = false
        if self.numAwardList[i] then
            l_canReceive = self.numAwardList[i].num <= l_bingoNum
            l_isReceived = MgrMgr:GetMgr("BingoMgr").IsAwardReceived(self.numAwardList[i].num)
        end
        self.panel.redpoint[i]:SetActiveEx(l_canReceive and not l_isReceived)
        self.panel.lock[i]:SetActiveEx(not l_isReceived)
        self.panel.Unlock[i]:SetActiveEx(l_isReceived)
    end
end

function BingoCtrl:RefreshBingoNums()
    local l_bingoNums = MgrMgr:GetMgr("BingoMgr").GetBingoNums()
    -- logError(ToString(l_bingoNums))
    self.bingoNumPool:ShowTemplates({Datas = l_bingoNums})
end


function BingoCtrl:ShowAwardPreview()
    local l_ret, l_pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.AwardPreview.transform.parent, Input.mousePosition, MUIManager.UICamera, nil)
    self.panel.AwardPreview.RectTransform.anchoredPosition = l_pos
    self.panel.AwardPreview:SetActiveEx(true)
end

function BingoCtrl:HideAwardPreview()
    self.panel.AwardPreview:SetActiveEx(false)
end

function BingoCtrl:RefreshPreviewAwards(awardPreviewRes)
    local l_datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardPreviewRes)
    self.awardItemPool:ShowTemplates({ Datas = l_datas })

    self:ShowAwardPreview()
end

function BingoCtrl:PlayBingoEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.BingoEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1, 1, 1)
    if self.bingoEffect then
        self:DestroyUIEffect(self.bingoEffect)
    end
    self.bingoEffect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_BingGo_ZiTi_01", l_fxData)
end

--lua custom scripts end
return BingoCtrl