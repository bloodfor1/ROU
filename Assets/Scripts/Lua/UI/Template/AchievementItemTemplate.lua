--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/AchievementStepTemplate"
require "UI/Template/AchievementPileTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class AchievementItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleIcon MoonClient.MLuaUICom
---@field StepText MoonClient.MLuaUICom
---@field ShowStepButton MoonClient.MLuaUICom
---@field ShowPileButton MoonClient.MLuaUICom
---@field ShowAchievementDetailsButton2 MoonClient.MLuaUICom
---@field ShowAchievementDetailsButton1 MoonClient.MLuaUICom
---@field ShowAchievementDetailsButton MoonClient.MLuaUICom
---@field ShareButton MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field RedPrompt MoonClient.MLuaUICom
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field NotFocusSign MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Grade MoonClient.MLuaUICom
---@field FxRT MoonClient.MLuaUICom
---@field FocusedSign MoonClient.MLuaUICom
---@field FocusButton MoonClient.MLuaUICom
---@field FinishTime MoonClient.MLuaUICom
---@field FinishRate MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom
---@field Details MoonClient.MLuaUICom
---@field CanAward MoonClient.MLuaUICom
---@field AwardText MoonClient.MLuaUICom
---@field AwardPanel MoonClient.MLuaUICom
---@field AwardIcon MoonClient.MLuaUICom
---@field AwardCellParent MoonClient.MLuaUICom
---@field AchievementStepParent MoonClient.MLuaUICom
---@field AchievementStepPanel MoonClient.MLuaUICom
---@field AchievementPileScroll MoonClient.MLuaUICom
---@field AchievementPileParent MoonClient.MLuaUICom
---@field AchievementPilePanel MoonClient.MLuaUICom
---@field AchievementPilePrefab MoonClient.MLuaUIGroup
---@field AchievementStepPrefab MoonClient.MLuaUIGroup
---@field AchievementCellAwardPrefab MoonClient.MLuaUIGroup

---@class AchievementItemTemplate : BaseUITemplate
---@field Parameter AchievementItemTemplateParameter

AchievementItemTemplate = class("AchievementItemTemplate", super)
--lua class define end

--lua functions
function AchievementItemTemplate:Init()

    super.Init(self)
    self.Data = nil
    self._awardData = nil
    --是否请求获取奖励数据
    self._isGetAwardData = false
    --是否请求得到奖励
    self._isGetAward = false
    --self._lastPileTemplate=nil
    self._lastPileIndex = 0
    self._isShowPilePanel = false
    self._mgr = MgrMgr:GetMgr("AchievementMgr")
    self.PileData = nil
    self.fxId = nil
    self._pileParentStartPosition = self.Parameter.AchievementPileParent.RectTransform.anchoredPosition
    self.Parameter.AchievementPilePanel:SetActiveEx(false)
    self.Parameter.AchievementStepPanel:SetActiveEx(false)
    self.Parameter.AwardPanel:SetActiveEx(false)
    self.Parameter.AchievementStepPrefab.gameObject:SetActiveEx(false)
    self.Parameter.AchievementPilePrefab.gameObject:SetActiveEx(false)
    self.Parameter.RedPrompt:SetActiveEx(false)
    --self.Parameter.FocusSign:SetActiveEx(false)
    self.Parameter.Finish:SetActiveEx(false)
    self.Parameter.FinishTime:SetActiveEx(false)
    self.achievementButtonTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AchievementStepTemplate,
        TemplateParent = self.Parameter.AchievementStepParent.transform,
        TemplatePrefab = self.Parameter.AchievementStepPrefab.gameObject
    })
    self.achievementPileTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AchievementPileTemplate,
        TemplateParent = self.Parameter.AchievementPileParent.transform,
        TemplatePrefab = self.Parameter.AchievementPilePrefab.gameObject
    })
    self.achievementCellAwardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchievementCellAwardTemplate",
        TemplateParent = self.Parameter.AwardCellParent.transform,
        TemplatePrefab = self.Parameter.AchievementCellAwardPrefab.gameObject
    })
    self.Parameter.ShareButton:AddClick(function()
        local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetAchievementDPack("", self.Data.achievementid, tostring(MPlayerInfo.UID), tostring(self.Data.finishtime or 0))
        MgrMgr:GetMgr("AchievementMgr").ShareAchievement(l_msg, l_msgParam, Vector2.New(202.99, 54.9))
    end)
    self.Parameter.FocusButton:AddClick(function()
        if self.Data ~= nil then
            MgrMgr:GetMgr("AchievementMgr").RequestSetAchievementFocus(self.Data.achievementid, not self.Data.isfocus)
        end
    end)
    self.Parameter.ShowPileButton:AddClick(function()
        self:OnSelect()
    end)
    self.Parameter.ShowStepButton:AddClick(function()
        self:showStepPanel()
        self:showSelect()
    end)
    self.Parameter.Finish:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.AchievementDetails, function(ctrl)
            if self.Data ~= nil then
                ctrl:ShowDetails(self.Data.achievementid, MPlayerInfo.UID, self.Data.finishtime, true)
            end
        end)
    end)
    --点击右上角显示详情
    self.Parameter.ShowAchievementDetailsButton:AddClick(function()
        if self.Data ~= nil then
            MgrMgr:GetMgr("AchievementMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("AchievementMgr").AchievementShowItemDetailsEvent, self.Data)
        end
    end)
    self.Parameter.ShowAchievementDetailsButton1:AddClick(function()
        if self.Data ~= nil then
            MgrMgr:GetMgr("AchievementMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("AchievementMgr").AchievementShowItemDetailsEvent, self.Data)
        end
    end)
    self.Parameter.ShowAchievementDetailsButton2:AddClick(function()
        if self.Data ~= nil then
            MgrMgr:GetMgr("AchievementMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("AchievementMgr").AchievementShowItemDetailsEvent, self.Data)
        end
    end)
    --成就领奖
    self.Parameter.CanAward:AddClick(function()
        if self.Data == nil then
            return
        end
        self._isGetAward = true
        MgrMgr:GetMgr("AchievementMgr").RequestAchievementGetItemReward(self.Data.achievementid)
    end)

    self.Parameter.FinishAchievementButton:SetActiveEx(false)

    if Application.isEditor then
        self.Parameter.FinishAchievementButton:SetActiveEx(true)
        self.Parameter.FinishAchievementButton:AddClick(function()
            if self.Data == nil then
                return
            end
            MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("finishachi {0}", tostring(self.Data.achievementid)))
        end)
    end


end --func end
--next--
function AchievementItemTemplate:BindEvents()

    self._mgr = MgrMgr:GetMgr("AchievementMgr")
    --得到全部占比数据
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.GetAllRateEvent, function()
        if self.Data == nil then
            return
        end
        local l_tableInfo = self.Data:GetDetailTableInfo()
        self.Parameter.FinishRate.LabText = self._mgr.GetRateText(self._mgr.GetAchievementRate(l_tableInfo.ID))
    end)
    --领奖成功
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.AchievementGetItemRewardEvent, function()
        if self._isGetAward == false then
            return
        end
        self:_onGetReward()
        --self:_showAwardButton()
    end)
    local l_awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self:BindEvent(l_awardPreviewMgr.EventDispatcher, l_awardPreviewMgr.AWARD_PREWARD_MSG, function(object, data, h, id)
        if self._isGetAwardData == false then
            return
        end
        local l_tableInfo = self.Data:GetDetailTableInfo()
        if l_tableInfo.Award == id then
            self:showAwardText(data.award_list)
        end
    end)

end --func end
--next--
function AchievementItemTemplate:OnDestroy()

    self.achievementButtonTemplatePool = nil
    self.achievementPileTemplatePool = nil
    --self._lastPileTemplate=nil
    self._lastPileIndex = 0
    self._mgr = nil
    if self.fxId ~= nil then
        self:DestroyUIEffect(self.fxId)
        self.fxId = nil
    end

end --func end
--next--
function AchievementItemTemplate:OnSetData(data)

    self:_showAchievementItem(data)

end --func end
--next--
function AchievementItemTemplate:OnDeActive()

    self._isShowPilePanel = false

end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementItemTemplate:_showAchievementItem(achievement)

    self.Data = achievement
    local l_tableInfo = achievement:GetDetailTableInfo()

    self.Parameter.CanAward:SetActiveEx(false)
    self.Parameter.Finish:SetActiveEx(false)

    if l_tableInfo.Group == 0 then
        self.PileData = nil
    else
        self.PileData = self._mgr.GetAchievementWithGroup(l_tableInfo.Group)
    end

    local l_showRewardFx = false
    --没完成
    if not self._mgr.IsFinish(achievement) then

    else
        --可领奖
        if self._mgr.IsAchievementCanAward(achievement) then
            self.Parameter.CanAward:SetActiveEx(true)
            l_showRewardFx = true
        else
            self.Parameter.Finish:SetActiveEx(true)
        end
    end

    --self:UpdateRewardFx(l_showRewardFx)

    self.Parameter.FinishRate.LabText = self._mgr.GetRateText(self._mgr.GetAchievementRate(l_tableInfo.ID))

    if self._mgr.CurrentSelectItemIndex == self.ShowIndex then
        self.Parameter.ShareButton:SetActiveEx(true)
        self.Parameter.Selected:SetActiveEx(true)
        if self._mgr.IsFinish(self.Data) then
            self.Parameter.FocusButton:SetActiveEx(false)
        else
            self.Parameter.FocusButton:SetActiveEx(true)
        end
        if self._isShowPilePanel == false then
            self:showPilePanel()
        end

    else
        self:HidSelect()
    end

    self.Parameter.Icon:SetSprite(l_tableInfo.Atlas, l_tableInfo.Icon, true)

    self.Parameter.Name.LabText = l_tableInfo.Name

    self.Parameter.Details.LabText = self._mgr.GetAchievementDetailsWithTableInfo(l_tableInfo)
    self.Parameter.Grade.LabText = tostring(l_tableInfo.Point)

    local l_stepCount = #self.Data.steps
    if l_stepCount == 0 then
        logError("服务端没有发进度数据")
        return
    end

    if l_stepCount == 1 then
        self.Parameter.ShowStepButton:SetActiveEx(false)

        self.Parameter.ProgressSlider:SetActiveEx(true)
        self.Parameter.ProgressText:SetActiveEx(true)

        local l_step, l_maxStep = self._mgr.GetAchievementProgressCountWithData(self.Data)

        self.Parameter.ProgressSlider.Slider.value = l_step / l_maxStep
        local currentStep
        local maxStemText
        if self._mgr.NeedSegmentationAchievementId(self.Data.achievementid) then
            currentStep = MNumberFormat.GetNumberFormat(l_step)
            maxStemText = MNumberFormat.GetNumberFormat(l_maxStep)
        else
            currentStep = tostring(l_step)
            maxStemText = tostring(l_maxStep)
        end
        self.Parameter.ProgressText.LabText = currentStep .. "/" .. maxStemText
    else
        self.Parameter.ShowStepButton:SetActiveEx(true)

        self.Parameter.ProgressSlider:SetActiveEx(false)
        self.Parameter.ProgressText:SetActiveEx(false)
    end

    if self.Data.isfocus then
        self.Parameter.NotFocusSign:SetActiveEx(false)
        self.Parameter.FocusedSign:SetActiveEx(true)
    else
        self.Parameter.NotFocusSign:SetActiveEx(true)
        self.Parameter.FocusedSign:SetActiveEx(false)
    end

    if l_tableInfo.Award == 0 and l_tableInfo.Title == 0 and l_tableInfo.StickersID == 0 then
        self.Parameter.AwardIcon:SetActiveEx(false)
    else
        self.Parameter.AwardIcon:SetActiveEx(true)
    end

    --self:_showRedSign()


end

function AchievementItemTemplate:_onGetReward()
    local l_nextData = self:_getNextCanShowAchievement(self.Data)
    if l_nextData == nil then
        l_nextData = self.Data
    end
    self:_showAchievementItem(l_nextData)
end

--得到此成就在group里面的下一个可显示的成就
--取相同Group的下一个可领奖的或未完成的成就
function AchievementItemTemplate:_getNextCanShowAchievement(achievement)
    local l_tableInfo = achievement:GetDetailTableInfo()
    if l_tableInfo.Group == 0 then
        return nil
    end
    local l_achievementDatas = self._mgr.GetAchievementWithGroup(l_tableInfo.Group)
    for i = 1, #l_achievementDatas do
        if l_achievementDatas[i].achievementid > achievement.achievementid then
            if self._mgr.IsAchievementCanAward(l_achievementDatas[i]) then
                return l_achievementDatas[i]
            end
            if not self._mgr.IsFinish(l_achievementDatas[i]) then
                return l_achievementDatas[i]
            end
        end
    end
    return l_achievementDatas[#l_achievementDatas]
end

function AchievementItemTemplate:_isShowRedSign()
    if self.Data == nil then
        return false
    end

    if self._mgr.IsAchievementCanAward(self.Data) then
        return true
    end

    if self.PileData == nil then
        return false
    end

    for i = 1, #self.PileData do
        if self._mgr.IsAchievementCanAward(self.PileData[i]) then
            return true
        end
    end

    return false

end

function AchievementItemTemplate:showPilePanel()

    if self._isShowPilePanel then
        self._isShowPilePanel = false
        self.Parameter.AchievementPilePanel:SetActiveEx(false)
        self.Parameter.AwardPanel:SetActiveEx(false)
        --self:_showRedSign()
        return
    end

    if self.Data == nil then
        return
    end

    self:showAwardPanel(self.Data)

    if self.PileData == nil then
        return
    end
    if #self.PileData == 0 then
        return
    end

    self._isShowPilePanel = true

    self.Parameter.AchievementPilePanel:SetActiveEx(true)

    self.Parameter.AchievementPileParent.RectTransform.anchoredPosition = self._pileParentStartPosition

    self.achievementPileTemplatePool:ShowTemplates({
        Datas = self.PileData,
        Method = function(index)
            self:onPileTemplate(index)
        end
    })

    if #self.PileData < 8 then
        self.Parameter.AchievementPileScroll.Scroll.enabled = false
    else
        self.Parameter.AchievementPileScroll.Scroll.enabled = true
    end

    local l_template = self.achievementPileTemplatePool:GetTemplateWithData(self.Data)
    if l_template then
        l_template:ShowSelect()
    end

end

function AchievementItemTemplate:onPileTemplate(index)

    if self._lastPileIndex == index then
        return
    end

    local l_template = self.achievementPileTemplatePool:GetItem(self._lastPileIndex)
    if l_template then
        l_template:HidSelect()
    end
    self._lastPileIndex = index
end

function AchievementItemTemplate:showStepPanel()

    if self.Data == nil then
        return
    end

    self:showAwardPanel(self.Data)

    if #self.Data.steps > 1 then
        if self.Parameter.AchievementStepPanel.gameObject.activeSelf then
            self.Parameter.AchievementStepPanel:SetActiveEx(false)
            return
        end
        self.Parameter.AchievementStepPanel:SetActiveEx(true)

        local l_tableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(self.Data.achievementid)

        if #self.Data.steps ~= l_tableInfo.TargetString.Length then
            logError("AchievementDetailTable表中TargetString字段填的数量与服务端发的step数量不同，id：" .. tostring(self.Data.achievementid))
            logError("请查看TargetString与Target个数是否一样，一样就是服务端发的step不对")
            return
        end

        local l_stepDatas = {}
        for i = 1, #self.Data.steps do
            local l_stepData = {}
            l_stepData.IsFinish = false
            if self.Data.steps[i].step >= self.Data.steps[i].maxstep then
                l_stepData.IsFinish = true
            end
            l_stepData.StepName = l_tableInfo.TargetString[i - 1]
            table.insert(l_stepDatas, l_stepData)
        end

        local l_defaultColor = "<color=$$None$$>"
        local l_finishColor = "<color=$$Gray$$>"
        local l_colorEnd = "</color>"

        local l_texts = {}
        for i = 1, #l_stepDatas do
            if l_stepDatas[i].IsFinish then
                table.insert(l_texts, l_finishColor)
            else
                table.insert(l_texts, l_defaultColor)
            end

            local stepName = (string.gsub(l_stepDatas[i].StepName, "\\n", "\n"))
            stepName = (string.gsub(stepName, "\\b", " "))
            table.insert(l_texts, stepName)
            table.insert(l_texts, l_colorEnd)
        end

        local l_text = table.ro_concat(l_texts, "")
        self.Parameter.StepText.LabText = l_text
    end
end

function AchievementItemTemplate:showAwardPanel(data)


    if data == nil then
        self.Parameter.AwardPanel:SetActiveEx(false)
        return
    end

    self._awardData = data
    local l_tableInfo = self._awardData:GetDetailTableInfo()
    if l_tableInfo.Award == 0 and l_tableInfo.Title == 0 and l_tableInfo.StickersID == 0 then
        self.Parameter.AwardPanel:SetActiveEx(false)
        return
    end

    local l_awardData = self._mgr.GetAchievementAwardDatas(l_tableInfo.Award)
    if l_tableInfo.Award ~= 0 then

        if l_awardData == nil then
            self._isGetAwardData = true
            MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_tableInfo.Award)
            return
        end

    end

    self:showAwardText(l_awardData)

end

function AchievementItemTemplate:showAwardText(AwardData)
    if self._awardData == nil then
        return
    end

    self.Parameter.AwardPanel:SetActiveEx(true)
    local l_awardDatas = {}
    if AwardData ~= nil then
        for i = 1, #AwardData do
            local l_data = {}
            l_data.ItemId = AwardData[i].item_id
            l_data.Count = AwardData[i].count
            table.insert(l_awardDatas, l_data)
        end
    end

    local l_tableInfo = self._awardData:GetDetailTableInfo()

    if l_tableInfo.StickersID ~= 0 then
        local l_data = {}
        l_data.StickersID = l_tableInfo.StickersID
        l_data.Count = 1
        table.insert(l_awardDatas, l_data)
    end

    self.achievementCellAwardTemplatePool:ShowTemplates({
        Datas = l_awardDatas
    })
end

function AchievementItemTemplate:showSelect()
    if self._mgr.IsFinish(self.Data) then
        self.Parameter.FocusButton:SetActiveEx(false)
    else
        self.Parameter.FocusButton:SetActiveEx(true)
    end

    self.Parameter.ShareButton:SetActiveEx(true)
    self.Parameter.Selected:SetActiveEx(true)
    self.MethodCallback(self.ShowIndex)
end

function AchievementItemTemplate:HidSelect()
    self.Parameter.ShareButton:SetActiveEx(false)
    self.Parameter.FocusButton:SetActiveEx(false)
    self.Parameter.Selected:SetActiveEx(false)
    self.Parameter.AchievementPilePanel:SetActiveEx(false)
    self.Parameter.AchievementStepPanel:SetActiveEx(false)
    self.Parameter.AwardPanel:SetActiveEx(false)
    self._isGetAwardData = false
    self._isShowPilePanel = false
end

function AchievementItemTemplate:OnSelect()
    self:showPilePanel()
    self:showSelect()
end

function AchievementItemTemplate:OnDeselect()
    -- do nothing
end

function AchievementItemTemplate:UpdateRewardFx(flag)

    if flag then
        if self.fxId == nil then
            local l_fxData = {}
            l_fxData.scaleFac = Vector3.New(5, 5, 5)
            l_fxData.rawImage = self.Parameter.FxRT.RawImg
            self.Parameter.FxRT.gameObject:SetActiveEx(false)
            l_fxData.destroyHandler = function()
                self.fxId = nil
            end
            l_fxData.loadedCallback = function()
                self.Parameter.FxRT.gameObject:SetActiveEx(true)
            end
            self.fxId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ChengJiuLingQu_01", l_fxData)

        else
            self.Parameter.FxRT.gameObject:SetActiveEx(true)
        end
    else
        if self.fxId ~= nil then
            self:DestroyUIEffect(self.fxId)
            self.fxId = nil
        end
        self.Parameter.FxRT.gameObject:SetActiveEx(false)
    end
end
--lua custom scripts end
return AchievementItemTemplate