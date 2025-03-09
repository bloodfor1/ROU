--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/AchievementPandectPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")
--next--
--lua fields end

--lua class define
AchievementPandectHandler = class("AchievementPandectHandler", super)
--lua class define end

--lua functions
function AchievementPandectHandler:ctor()

    super.ctor(self, HandlerNames.AchievementPandect, 0)

end --func end
--next--
function AchievementPandectHandler:Init()

    self.panel = UI.AchievementPandectPanel.Bind(self)
    super.Init(self)

    self._currentBadgeTableInfo = nil

    self._awardInfos = nil

    self._awardIds = {}
    local l_table = TableUtil.GetAchievementBadgeTable().GetTable()
    for i = 1, #l_table do
        if l_table[i].AwardId ~= 0 then
            table.insert(self._awardIds, l_table[i].AwardId)
        end
    end

    self._trophyTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchievementTrophyTemplate",
        TemplateParent = self.panel.AchievementTrophyParent.transform,
        TemplatePrefab = self.panel.AchievementTrophyPrefab.gameObject,
        Method = function(index)
            self:_onTrophyTemplate(index)
        end
    })

    self._trophyStarSelectTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchievementTrophyStarSelectTemplate",
        TemplateParent = self.panel.AchievementTrophyStarSelectParent.transform,
        TemplatePrefab = self.panel.AchievementTrophyStarSelectPrefab.gameObject,
        --SetCountPerFrame = 1,
        --CreateObjPerFrame = 2,
        Method = function(index)
            self:_onTrophyStarSelectTemplate(index)
        end
    })

    self._achievementBadgeProgressTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchievementBadgeProgressTemplate",
        TemplateParent = self.panel.AchievementBadgeProgressParent.transform,
        TemplatePrefab = self.panel.AchievementBadgeProgressPrefab.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
    })

    self._achievementFunctionAwardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchievementPandectFunctionAwardTemplate",
        TemplateParent = self.panel.AchievementPandectFunctionAwardParent.transform,
        TemplatePrefab = self.panel.AchievementPandectFunctionAwardPrefab.gameObject,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
    })

    self._achievementItemAwardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplateParent = self.panel.AchievementPandectItemAwardParent.transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 2,
    })

    self.panel.GetAwardButton:AddClick(function()
        if self._currentBadgeTableInfo == nil then
            return
        end
        if self._currentBadgeTableInfo.Level <= MgrMgr:GetMgr("AchievementMgr").BadgeLevel then
            MgrMgr:GetMgr("AchievementMgr").RequestAchievementGetBadgeReward(self._currentBadgeTableInfo.Level)
        end
    end)

    self.panel.CantGetAwardButton:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Achievement_CantGetAwardButtonText"))
    end)

    self.panel.ShareButton:AddClick(function()
        local l_mgr = MgrMgr:GetMgr("AchievementMgr")
        local l_LinkInputMgr = MgrMgr:GetMgr("LinkInputMgr")
        local l_point = l_mgr.TotalAchievementPoint
        local l_msg, l_msgParam = l_LinkInputMgr.GetAchievementBPack("", l_mgr.BadgeLevel, l_point, l_mgr.BadgeLevel, tostring(MPlayerInfo.UID))
        l_mgr.ShareAchievement(l_msg, l_msgParam, Vector2.New(202.99, 54.9))
    end)

end --func end
--next--
function AchievementPandectHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

    self._awardInfos = nil

end --func end
--next--
function AchievementPandectHandler:OnActive()

    if #self._awardIds > 0 then
        MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(self._awardIds, MgrMgr:GetMgr("AchievementMgr").GetAchievementBatchPreviewAwardEvent)
    end

    local l_table = TableUtil.GetAchievementBadgeTable().GetTable()

    local l_datas = {}
    local l_currentType = 0

    local l_startIndex = 1
    for i = 1, #l_table do
        if l_table[i].Type ~= l_currentType then
            table.insert(l_datas, l_table[i])
            l_currentType = l_table[i].Type


        end
    end

    local l_badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(self:_getCurrentSelectBadgeLevel())
    if l_badgeTableInfo then
        for i = 1, #l_datas do
            if l_badgeTableInfo.Type == l_datas[i].Type then
                l_startIndex = i
            end
        end
    end


    self._trophyTemplatePool:ShowTemplates({
        Datas = l_datas,
        StartScrollIndex = l_startIndex
    })

    self._trophyTemplatePool:SelectTemplate(l_startIndex)
    self:_onTrophyTemplate(l_startIndex)


end --func end
--next--
function AchievementPandectHandler:OnDeActive()


end --func end

function AchievementPandectHandler:OnReconnected()
    super.OnReconnected(self)
    if self._awardInfos == nil then
        if #self._awardIds > 0 then
            MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(self._awardIds, MgrMgr:GetMgr("AchievementMgr").GetAchievementBatchPreviewAwardEvent)
        end
    end
end
--next--
function AchievementPandectHandler:Update()
    if nil ~= self._trophyTemplatePool then
        self._trophyTemplatePool:OnUpdate()
    end

    if nil ~= self._trophyStarSelectTemplatePool then
        self._trophyStarSelectTemplatePool:OnUpdate()
    end

    if nil ~= self._achievementBadgeProgressTemplatePool then
        self._achievementBadgeProgressTemplatePool:OnUpdate()
    end

    if nil ~= self._achievementFunctionAwardTemplatePool then
        self._achievementFunctionAwardTemplatePool:OnUpdate()
    end

    if nil ~= self._achievementItemAwardTemplatePool then
        self._achievementItemAwardTemplatePool:OnUpdate()
    end
end --func end


--next--
function AchievementPandectHandler:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").GetAchievementBatchPreviewAwardEvent, function(selfa, awardInfo)
        if awardInfo == nil then
            return
        end
        self._awardInfos = {}
        for i = 1, #awardInfo do
            self._awardInfos[awardInfo[i].award_id] = awardInfo[i].award_list
        end
        self:_showAward()
    end)
    self:BindEvent(MgrMgr:GetMgr("AchievementMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").AchievementGetBadgeRewardEvent, function()
        self:_showGetAwardButton()
        self:_showAward()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementPandectHandler:_onTrophyTemplate(index)

    self._trophyTemplatePool:SelectTemplate(index)
    local l_currentTrophyData = self._trophyTemplatePool:getData(index)

    local l_startIndex = 1
    local l_datas = {}
    local l_table = TableUtil.GetAchievementBadgeTable().GetTable()
    for i = 2, #l_table do
        if l_table[i].Type == l_currentTrophyData.Type then
            table.insert(l_datas, l_table[i])
        end
    end

    local l_currentSelectBadgeLevel = self:_getCurrentSelectBadgeLevel()

    local l_badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(l_currentSelectBadgeLevel)
    local l_dataCount = #l_datas
    for i = 1, l_dataCount do
        if l_badgeTableInfo.Level == l_datas[i].Level then
            l_startIndex = i
        end
    end

    self._trophyStarSelectTemplatePool:ShowTemplates({
        Datas = l_datas,
        StartScrollIndex = l_startIndex,
        AdditionalData = l_dataCount
    })

    self._trophyStarSelectTemplatePool:SelectTemplate(l_startIndex)
    self:_onTrophyStarSelectTemplate(l_startIndex)

    if l_dataCount == 1 then
        self.panel.AchievementTrophyStarSelectParent:SetActiveEx(false)
    else
        self.panel.AchievementTrophyStarSelectParent:SetActiveEx(true)
    end
end

function AchievementPandectHandler:_onTrophyStarSelectTemplate(index)
    self._trophyStarSelectTemplatePool:SelectTemplate(index)
    local l_currentTrophyData = self._trophyStarSelectTemplatePool:getData(index)
    self._currentBadgeTableInfo = l_currentTrophyData
    self.panel.TrophyName.LabText = l_currentTrophyData.Name
    self.panel.BadgeIcon:SetSpriteAsync(l_currentTrophyData.Atlas, l_currentTrophyData.Icon, nil, true)
    MgrMgr:GetMgr("AchievementMgr").ShowAchievementBadgeStar(self.panel.StarParent, l_currentTrophyData)
    local l_badgeProgressDatas = {}
    local l_data = {}
    l_data.TableInfo = l_currentTrophyData
    table.insert(l_badgeProgressDatas, l_data)
    if l_currentTrophyData.PromotionTaskId ~= 0 then
        local l_data = {}
        l_data.TaskId = l_currentTrophyData.PromotionTaskId
        table.insert(l_badgeProgressDatas, l_data)
    end

    self._achievementBadgeProgressTemplatePool:ShowTemplates({
        Datas = l_badgeProgressDatas,
    })



    local l_isGray
    if self._currentBadgeTableInfo.Level > MgrMgr:GetMgr("AchievementMgr").BadgeLevel then
        l_isGray = true
    else
        l_isGray = false
    end

    if self._currentBadgeTableInfo.Level == MgrMgr:GetMgr("AchievementMgr").BadgeLevel then
        self.panel.ShareButton:SetActiveEx(true)
    else
        self.panel.ShareButton:SetActiveEx(false)
    end

    local l_data = l_achievementMgr.FiltrateAwardIDList(l_currentTrophyData.SystemId)

    MLuaCommonHelper.SetRectTransformPosY(self.panel.AchievementPandectFunctionAwardParent.gameObject, 0)

    if #l_data > 4 then
        self.panel.FunctionAwardMoreImage:SetActiveEx(true)
        self.panel.FunctionAwardScroll.Scroll.enabled = true

    else
        self.panel.FunctionAwardMoreImage:SetActiveEx(false)
        self.panel.FunctionAwardScroll.Scroll.enabled = false
    end

    self._achievementFunctionAwardTemplatePool:ShowTemplates({
        Datas = l_data,
        AdditionalData = l_isGray
    })

    self:_showAward()
    self:_showGetAwardButton()
end

function AchievementPandectHandler:_showGetAwardButton()

    if self._currentBadgeTableInfo == nil then
        return
    end

    self.panel.Finish:SetActiveEx(false)
    self.panel.GetAwardButton:SetActiveEx(false)
    self.panel.CantGetAwardButton:SetActiveEx(false)
    if self._currentBadgeTableInfo.Level > MgrMgr:GetMgr("AchievementMgr").BadgeLevel then
        self.panel.CantGetAwardButton:SetActiveEx(true)
    else
        if MgrMgr:GetMgr("AchievementMgr").IsAchievementBadgeRewarded(self._currentBadgeTableInfo.Level) then
            self.panel.Finish:SetActiveEx(true)
        else
            if self._awardInfos and (not self._awardInfos[self._currentBadgeTableInfo.AwardId] or #self._awardInfos[self._currentBadgeTableInfo.AwardId] == 0) then
                self.panel.GetAwardButton:SetActiveEx(false)
            else
                self.panel.GetAwardButton:SetActiveEx(true)
            end
        end
    end
end

function AchievementPandectHandler:_showAward()

    if self._awardInfos == nil then
        return
    end

    if self._currentBadgeTableInfo == nil then
        return
    end

    local l_awards = self._awardInfos[self._currentBadgeTableInfo.AwardId]
    if l_awards == nil then
        l_awards = {}
    end

    local l_itemDatas = {}
    for i = 1, #l_awards do
        local data = {}
        data.ID = l_awards[i].item_id
        data.Count = l_awards[i].count
        if l_awards[i].count > 1 then
            data.IsShowCount = true
        else
            data.IsShowCount = false
        end
        if MgrMgr:GetMgr("AchievementMgr").IsAchievementBadgeRewarded(self._currentBadgeTableInfo.Level) then
            data.IsGray = false
        else
            data.IsGray = true
        end
        table.insert(l_itemDatas, data)
    end

    if #l_itemDatas > 4 then
        self.panel.ItmeAwardMoreImage:SetActiveEx(true)
        self.panel.ItmeAwardScroll.Scroll.enabled = true

    else
        self.panel.ItmeAwardMoreImage:SetActiveEx(false)
        self.panel.ItmeAwardScroll.Scroll.enabled = false
    end

    MLuaCommonHelper.SetRectTransformPosY(self.panel.AchievementPandectItemAwardParent.gameObject, 0)

    self._achievementItemAwardTemplatePool:ShowTemplates({
        Datas = l_itemDatas,
    })

end

function AchievementPandectHandler:_getCurrentSelectBadgeLevel()
    local currentLevel=MgrMgr:GetMgr("AchievementMgr").CurrentShowBadgeLevel
    if currentLevel then
        return currentLevel
    end
    local nextLevel=MgrMgr:GetMgr("AchievementMgr").BadgeLevel + 1
    local l_badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(nextLevel,true)
    if l_badgeTableInfo then
        return nextLevel
    end
    return 1
end

--lua custom scripts end
return AchievementPandectHandler