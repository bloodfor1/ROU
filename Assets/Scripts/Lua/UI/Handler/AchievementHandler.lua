--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/AchievementPanel"
require "UI/Template/AchievementButtonTemplate"
require "UI/Template/AchievementItemTemplate"
require "UI/Template/SearchTextTemplate"
require "UI/Template/ProgressItemTemplate"
require "Common/CommonCharUtil"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
AchievementHandler = class("AchievementHandler", super)

---@type Common.CommonCharUtil
local l_charUtil = Common.CommonCharUtil
---@type number
local l_achieveSearchLenMax = MGlobalConfig:GetInt("AchieveSearchLenMax")
--lua class define end

--lua functions
function AchievementHandler:ctor()

    super.ctor(self, HandlerNames.Achievement, 0)

end --func end
--next--
function AchievementHandler:Init()
    self.panel = UI.AchievementPanel.Bind(self)
    super.Init(self)
    self.lastButtonIndex = 0
    self.lastDetailsButton = nil
    self._mgr = MgrMgr:GetMgr("AchievementMgr")
    -- self.panel.SearchInput.Input.characterLimit = l_achieveSearchLenMax
    self.panel.SearchInput.Input.onValidateInput = _onValidateInputChar

    local l_achievementDetailTable = TableUtil.GetAchievementDetailTable().GetTable()
    self._awardIds = {}
    for i = 1, #l_achievementDetailTable do
        if l_achievementDetailTable[i].Award ~= 0 then
            table.insert(self._awardIds, l_achievementDetailTable[i].Award)
        end
    end

    if #self._awardIds > 0 then
        MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(self._awardIds, self._mgr.GetAchievementAwardEvent)
    end

    self.panel.ClassifyAchievementPanel:SetActiveEx(false)
    self.panel.SearchPanel:SetActiveEx(false)
    self.panel.PandectPanel:SetActiveEx(false)
    self.panel.AchievementItemPanel:SetActiveEx(false)

    self.panel.AchievementButton.gameObject:SetActiveEx(false)
    self.panel.AchievementItem.gameObject:SetActiveEx(false)
    self.panel.SearchTextTemplate.gameObject:SetActiveEx(false)
    self.panel.ProgressItemPrefab.gameObject:SetActiveEx(false)

    self.panel.AchievementDetailsPanel.LuaUIGroup.gameObject:SetActiveEx(false)
    self.achievementButtonTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AchievementButtonTemplate,
        TemplateParent = self.panel.AchievementButtonParent.transform,
        TemplatePrefab = self.panel.AchievementButton.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
    })

    self.achievementItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AchievementItemTemplate,
        TemplatePrefab = self.panel.AchievementItem.gameObject,
        ScrollRect = self.panel.AchievementItemScroll.LoopScroll,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
        NeedAutoSelected = true,
        Method = function(index)
            self:onAchievementItemButton(index)
        end
    })

    self.searchTextTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SearchTextTemplate,
        TemplateParent = self.panel.SearchTextParent.transform,
        TemplatePrefab = self.panel.SearchTextTemplate.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
        Method = function(text)
            self:onSearchTextButton(text)
        end
    })

    self.panel.ShowBadgeButton:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.AchievementBadge, function(ctrl)
            ctrl:ShowBadge(self._mgr.TotalAchievementPoint, self._mgr.BadgeLevel, MPlayerInfo.UID, true)
        end)
    end)

    self.panel.ShowAwardButton:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.AchievementReward)
    end)
    self.panel.ShowAwardButton1:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.AchievementReward)
    end)

    self.panel.ClearSearchButton:AddClick(function()
        self.panel.SearchInput.Input.text = ""
    end)
    self.panel.SearchInput:OnInputFieldChange(function(value)

        if value == "" then
            self.panel.ClearSearchButton:SetActiveEx(false)
            self.panel.AchievementItemPanel:SetActiveEx(false)
            self.panel.SearchTextPanel:SetActiveEx(true)
            self:showSearchTexts()
            return
        else
            value = StringEx.DeleteRichText(value)
            self.panel.SearchInput.Input.text = value
            self.panel.ClearSearchButton:SetActiveEx(true)
        end

    end)

    self.panel.SearchButton:AddClick(function()
        self:_onSearchButton()
    end)

    self.panel.AchievementDetailsPanel.DetailsPanelCloseButton:AddClick(function()
        self.panel.AchievementDetailsPanel.LuaUIGroup.gameObject:SetActiveEx(false)
    end)

end --func end

function AchievementHandler:showClassifyPanel(index, achievements)
    self.panel.ClassifyAchievementPanel:SetActiveEx(true)
    self.panel.SearchPanel:SetActiveEx(false)
    self.panel.PandectPanel:SetActiveEx(false)
    self.panel.AchievementItemPanel:SetActiveEx(true)

    self.panel.AchievementItemScroll.UObj:SetRectTransformPosY(-4.8)
    self.panel.AchievementItemScroll.UObj:SetRectTransformHeight(402)

    self:_showPointAwardRedSign()

    self:showachievementItem(achievements)

    --self:showTagName(index)
end

function AchievementHandler:showTagName(index)
    local l_tableInfo = TableUtil.GetAchievementIndexTable().GetRowByIndex(index)
    self.panel.TagName1.LabText = l_tableInfo.Name
end

function AchievementHandler:showPandectPanel()

    self.panel.ClassifyAchievementPanel:SetActiveEx(false)
    self.panel.SearchPanel:SetActiveEx(false)
    self.panel.PandectPanel:SetActiveEx(true)
    self.panel.AchievementItemPanel:SetActiveEx(false)

    self.panel.AchievementItemScroll.UObj:SetRectTransformPosY(-4.8)
    self.panel.AchievementItemScroll.UObj:SetRectTransformHeight(439)

    local l_currentTableInfo = self._mgr.GetBadgeTableInfo(self._mgr.TotalAchievementPoint)
    self.panel.BadgeIcon:SetSprite(l_currentTableInfo.Atlas, l_currentTableInfo.Icon, true)

    local l_totalPoint = self:_getTotalPoint()

    local l_sliderValue = self._mgr.TotalAchievementPoint / l_totalPoint
    local l_textValue = tostring(self._mgr.TotalAchievementPoint) .. "/" .. tostring(l_totalPoint)
    self.panel.TotalProgressSlider2.Slider.value = l_sliderValue
    self.panel.TotalProgressText2.LabText = l_textValue

    local l_badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(self._mgr.BadgeLevel)
    if l_badgeTableInfo then
        self.panel.TagName2.LabText = l_badgeTableInfo.Name
    end

    self:_showPointAwardRedSign()

    self.panel.Star2:SetActiveEx(false)
    self.panel.Star3:SetActiveEx(false)
    self.panel.Star5:SetActiveEx(false)

    local l_currentStar
    local l_starCount = 0
    if l_currentTableInfo.StarType == 2 then
        l_currentStar = self.panel.Star2
        l_starCount = 2
        self.panel.Star2:SetActiveEx(true)
    elseif l_currentTableInfo.StarType == 3 then
        l_currentStar = self.panel.Star3
        l_starCount = 3
        self.panel.Star3:SetActiveEx(true)
    else
        l_currentStar = self.panel.Star5
        l_starCount = 5
        self.panel.Star5:SetActiveEx(true)
    end

    if l_currentStar ~= nil then
        local l_star
        for i = 1, l_starCount do
            l_star = l_currentStar.transform:Find("star" .. i)
            if l_star ~= nil then
                if i <= l_currentTableInfo.LightNumber then
                    l_star.gameObject:SetActiveEx(true)
                else
                    l_star.gameObject:SetActiveEx(false)
                end

            end
        end
    end
end

function AchievementHandler:_getTotalPoint()
    local l_table = TableUtil.GetAchievementBadgeTable().GetTable()
    local l_totalPoint = 0
    for i = 1, #l_table do
        l_totalPoint = l_totalPoint + l_table[i].Point
    end
    return l_totalPoint
end

function AchievementHandler:showSearchPanel()

    self.panel.ClassifyAchievementPanel:SetActiveEx(false)
    self.panel.SearchPanel:SetActiveEx(true)
    self.panel.PandectPanel:SetActiveEx(false)
    self.panel.AchievementItemPanel:SetActiveEx(false)
    self.panel.SearchTextPanel:SetActiveEx(true)
    self.panel.ClearSearchButton:SetActiveEx(false)
    self.panel.AchievementItemScroll.UObj:SetRectTransformPosY(16)
    self.panel.AchievementItemScroll.UObj:SetRectTransformHeight(474.66)

    self:showSearchTexts()
end

function AchievementHandler:showSearchTexts()
    self.searchTextTemplatePool:ShowTemplates({
        Datas = self._mgr.SearchTexts,
    })
end

function AchievementHandler:onSearchTextButton(text)
    self.panel.SearchInput.Input.text = text
    self:_onSearchButton()
end

function AchievementHandler:showachievementItem(datas)

    local l_totalPoint = 0
    local l_achievementBadgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(self._mgr.BadgeLevel + 1, true)
    if l_achievementBadgeTableInfo == nil then
        l_achievementBadgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(self._mgr.BadgeLevel, true)
    end
    if l_achievementBadgeTableInfo then
        l_totalPoint = l_achievementBadgeTableInfo.Point
    end
    --local l_totalPoint=self:_getTotalPoint()

    local l_sliderValue = self._mgr.TotalAchievementPoint / l_totalPoint
    local l_textValue = tostring(self._mgr.TotalAchievementPoint) .. "/" .. tostring(l_totalPoint)

    self.panel.TotalProgressSlider1.Slider.value = l_sliderValue
    self.panel.TotalProgressText1.LabText = l_textValue

    local l_currentTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(MgrMgr:GetMgr("AchievementMgr").BadgeLevel)
    self.panel.ImageTag:SetSprite(l_currentTableInfo.Atlas, l_currentTableInfo.Icon, true)

    MgrMgr:GetMgr("AchievementMgr").ShowAchievementBadgeStar(self.panel.StarParent, l_currentTableInfo)

    local l_currentDatas = self:dealWithAchievementDatas(datas)

    self._mgr.CurrentSelectItemIndex = 0
    local l_startIndex = 1
    if self._mgr.CurrentShowAchievementId ~= nil then
        local l_achievementData = self._mgr.GetAchievementWithId(self._mgr.CurrentShowAchievementId)
        if l_achievementData ~= nil then
            local l_achievementDataGroup = l_achievementData:GetDetailTableInfo().Group
            for i = 1, #l_currentDatas do
                if l_achievementDataGroup == 0 then
                    if l_currentDatas[i].achievementid == self._mgr.CurrentShowAchievementId then
                        l_startIndex = i
                        break
                    end
                else
                    if l_currentDatas[i]:GetDetailTableInfo().Group == l_achievementDataGroup then
                        l_startIndex = i
                        break
                    end
                end
            end
        end
    end

    self.achievementItemTemplatePool:ShowTemplates({
        Datas = l_currentDatas,
        StartScrollIndex = l_startIndex
    })

    self.achievementItemTemplatePool:SelectTemplate(l_startIndex)
    self._mgr.CurrentShowAchievementId = nil
end

function AchievementHandler:dealWithAchievementDatas(datas)
    local l_currentDatas = {}
    local l_groups = {}
    --遍历，把所有一组的放在一起
    for i = 1, #datas do
        if self._mgr.IsAchievementCanShow(datas[i]) then
            local l_groupId = datas[i]:GetDetailTableInfo().Group
            if l_groupId ~= 0 then
                if l_groups[l_groupId] == nil then
                    l_groups[l_groupId] = {}
                end
                table.insert(l_groups[l_groupId], datas[i])
            end
        end
    end

    local l_showAchievementWithGroup = {}

    local l_achievements
    --遍历所有的组的成就，取出一个当前要显示的成就
    for l_groupId, l_group in pairs(l_groups) do
        if l_groupId ~= 0 then
            --由于前面的数据一组的数据不是全部的，只能再取一次
            l_achievements = self._mgr.GetAchievementWithGroup(l_groupId)
            l_showAchievementWithGroup[l_groupId] = self:_getShowAchievement(l_achievements)
        end
    end

    local l_groupId

    local l_addedGroups = {}
    --遍历，按原来的数据顺序，把真实要显示的成就数据设好
    --原来的逻辑是在上面两次遍历就可以做好，但是为了保证数据顺序不变，只能再加一次遍历
    for i = 1, #datas do
        if self._mgr.IsAchievementCanShow(datas[i])  then
            l_groupId = datas[i]:GetDetailTableInfo().Group
            if l_groupId ~= 0 then
                --只有没加过的group才会加进去
                if not table.ro_contains(l_addedGroups, l_groupId) then

                    table.insert(l_addedGroups, l_groupId)

                    local l_achievementWithGroup = l_showAchievementWithGroup[l_groupId]
                    if l_achievementWithGroup then
                        table.insert(l_currentDatas, l_achievementWithGroup)
                    end
                end

            else
                table.insert(l_currentDatas, datas[i])
            end
        end
    end

    return l_currentDatas

end

--取最前面的可以领奖的成就，如果都不可领奖，取最前面正在进行的
function AchievementHandler:_getShowAchievement(achievements)
    local l_data
    for i = 1, #achievements do
        if self._mgr.IsAchievementCanAward(achievements[i]) then
            l_data = achievements[i]
            break
        end
        if not self._mgr.IsFinish(achievements[i]) then
            l_data = achievements[i]
            break
        end
    end

    if l_data == nil then
        l_data = achievements[#achievements]
    end
    return l_data
end

--next--
function AchievementHandler:Uninit()
    self.achievementButtonTemplatePool = nil
    self.achievementItemTemplatePool = nil
    self.searchTextTemplatePool = nil
    self._mgr.CurrentShowAchievementId = nil
    self._mgr = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AchievementHandler:OnActive()

    self._mgr.RequestAchievementGetInfo()

    local l_buttonId = self._mgr.GetAchievementButtonId()
    self.achievementButtonTemplatePool:ShowTemplates({
        Datas = l_buttonId,
    })
end --func end
--next--
function AchievementHandler:OnDeActive()
    -- todo CLX：这边的生命周期会有问题，是先调用的onUnInit，后调用的这个函数，所以回报空指针
    if nil == self._mgr then
        return
    end

    self._mgr.CurrentShowAchievementId = nil
end --func end
--next--
function AchievementHandler:Update()
    if nil ~= self.achievementButtonTemplatePool then
        self.achievementButtonTemplatePool:OnUpdate()
    end

    if nil ~= self.achievementItemTemplatePool then
        self.achievementItemTemplatePool:OnUpdate()
    end

    if nil ~= self.searchTextTemplatePool then
        self.searchTextTemplatePool:OnUpdate()
    end
end --func end

--next--
function AchievementHandler:BindEvents()

    self:BindEvent(self._mgr.EventDispatcher, self._mgr.OnButtonEvent, function(selfa, template)
        if self.lastButtonIndex ~= 0 and self.lastButtonIndex ~= template.ShowIndex then
            local l_template = self.achievementButtonTemplatePool:GetItem(self.lastButtonIndex)
            if l_template then
                l_template:HidDetailsButton()
            end
        end
        self.lastButtonIndex = template.ShowIndex
        if self.lastDetailsButton ~= nil then
            self.lastDetailsButton:Hid()
            self.lastDetailsButton = nil
        end

        if template.Data == self._mgr.SearchIndex then
            self:showSearchPanel()
        elseif template.Data == self._mgr.PandectIndex then
            --self:showPandectPanel()
        else
            local l_achievements = self._mgr.GetAchievementWithMainIndex(template.Data)
            self:showClassifyPanel(template.Data, l_achievements)
        end
    end)

    self:BindEvent(self._mgr.EventDispatcher, self._mgr.OnDetailsButtonEvent, function(selfa, template)
        if self.lastDetailsButton ~= nil and self.lastDetailsButton ~= template then
            self.lastDetailsButton:Hid()
        end
        self.lastDetailsButton = template
        local l_achievements = self._mgr.GetAchievementWithIndex(template.Data)
        self:showClassifyPanel(template.Data, l_achievements)
    end)

    self:BindEvent(self._mgr.EventDispatcher, self._mgr.OnAchievementChangeEvent, function()
        self.achievementItemTemplatePool:RefreshCells()
    end)

    self:BindEvent(self._mgr.EventDispatcher, self._mgr.AchievementShowItemDetailsEvent, function(selfa, achievementData)
        self.panel.AchievementDetailsPanel.LuaUIGroup.gameObject:SetActiveEx(true)
        local l_tableInfo = achievementData:GetDetailTableInfo()
        if l_tableInfo.Award == 0 then
            logGreen("l_tableInfo.Award==0")
            self.panel.AchievementDetailsPanel.AwardTextPrefab:SetActiveEx(false)
        else
            local l_award = self._mgr.GetAchievementAwardDatas(l_tableInfo.Award)
            if l_award == nil then
                logGreen("l_award==nil")
                self.panel.AchievementDetailsPanel.AwardTextPrefab:SetActiveEx(false)
            else
                local l_awardText = ""
                for i = 1, #l_award do
                    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(l_award[i].item_id)
                    local l_text = l_itemTableInfo.ItemName .. "×" .. l_award[i].count
                    l_awardText = l_awardText .. l_text
                    if i < #l_award then
                        l_awardText = l_awardText .. "、"
                    end
                end
                self.panel.AchievementDetailsPanel.AwardText.LabText = StringEx.Format(Lang("Achievement_AwardText"), l_awardText)
                self.panel.AchievementDetailsPanel.AwardTextPrefab:SetActiveEx(true)
            end

        end
        if l_tableInfo.Title == 0 then
            self.panel.AchievementDetailsPanel.TitlePrefab:SetActiveEx(false)
        else
            self.panel.AchievementDetailsPanel.Title.LabText = StringEx.Format(Lang("Achievement_TitleText"), "[" .. l_tableInfo.Title .. "]")
            self.panel.AchievementDetailsPanel.TitlePrefab:SetActiveEx(true)
        end

        if l_tableInfo.StickersID == 0 then
            self.panel.AchievementDetailsPanel.StickersPrefab:SetActiveEx(false)
            self.panel.AchievementDetailsPanel.PointLine:SetActiveEx(false)
        else
            local l_data = TableUtil.GetStickersTable().GetRowByStickersID(l_tableInfo.StickersID)
            if l_data then
                self.panel.AchievementDetailsPanel.Stickers.LabText = StringEx.Format(Lang("Achievement_StickersText"), l_data.StickersName)
                self.panel.AchievementDetailsPanel.StickersPrefab:SetActiveEx(true)
                self.panel.AchievementDetailsPanel.PointLine:SetActiveEx(true)
                --self.panel.AchievementDetailsPanel.StickersLine:SetActiveEx(false)
            end

        end
        local l_rate = self._mgr.GetAchievementRate(achievementData.achievementid)
        self.panel.AchievementDetailsPanel.RateText.LabText = StringEx.Format(Lang("Achievement_RateText"), MgrMgr:GetMgr("AchievementMgr").GetRateText(l_rate))
        self.panel.AchievementDetailsPanel.Point.LabText = StringEx.Format(Lang("Achievement_PointText"), l_tableInfo.Point)
    end)
    --获取成就的奖励
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, self._mgr.GetAchievementAwardEvent, function(selfa, awardInfo)
        self._mgr.SetAchievementAwardDatas(awardInfo)
    end)

    --成就奖励领取后奖励上的红点显示
    self:BindEvent(self._mgr.EventDispatcher, self._mgr.AchievementGetPointRewardEvent, function(selfa, awardInfo)
        self:_showPointAwardRedSign()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

-- 标注一下，input的回调参数类型如上
---@param str string
---@param index number
---@param char number
---@return number
function _onValidateInputChar(str, index, char)
    local l_num = l_charUtil.CalcCharCount(str, true)
    if l_num >= l_achieveSearchLenMax then
        return 0
    end

    return tonumber(char)
end

function AchievementHandler:_showPointAwardRedSign()
    if self._mgr.IsHavePointAward() then
        self.panel.PointAwardRedPrompt:SetActiveEx(true)
        self.panel.PointAwardRedPrompt1:SetActiveEx(true)
    else
        self.panel.PointAwardRedPrompt:SetActiveEx(false)
        self.panel.PointAwardRedPrompt1:SetActiveEx(false)
    end
end

function AchievementHandler:onAchievementItemButton(showIndex)
    if self._mgr.CurrentSelectItemIndex == showIndex then
        return
    end
    if self._mgr.CurrentSelectItemIndex ~= 0 then
        local l_template = self.achievementItemTemplatePool:GetItem(self._mgr.CurrentSelectItemIndex)
        if l_template ~= nil then
            l_template:HidSelect()
        end
    end
    self._mgr.CurrentSelectItemIndex = showIndex
end

function AchievementHandler:_onSearchButton()
    local l_value = self.panel.SearchInput.Input.text
    if l_value == "" then
        return
    end

    local l_achievements = self._mgr.GetAchievementWithSearch(l_value)
    if #l_achievements > 0 then
        self._mgr.SetSearchText(l_value)
        self.panel.AchievementItemPanel:SetActiveEx(true)
        self.panel.SearchTextPanel:SetActiveEx(false)
        self:showachievementItem(l_achievements)
    else
        self.panel.AchievementItemPanel:SetActiveEx(false)
        self.panel.SearchTextPanel:SetActiveEx(true)
        self:showSearchTexts()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Achievement_NotSearchText"))
    end
end
--lua custom scripts end
