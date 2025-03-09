--this file is gen by script
--you can edit this file in custom part

-- 获得奖励

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementGetBadgeAwardPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")
--next--
--lua fields end

--lua class define
AchievementGetBadgeAwardCtrl = class("AchievementGetBadgeAwardCtrl", super)
local _hideTime = 4.5
local _awardEventName = "AchievementGetAwardCtrlShow"

--游戏评价:显示的消息
local l_rateMessage=Common.Utils.Lang(MGlobalConfig:GetString("GameRateAchiMessge"))
--领取初心者奖励的level
local l_achievementAchiLevel=5
--lua class define end

--lua functions
function AchievementGetBadgeAwardCtrl:ctor()
    super.ctor(self, CtrlNames.AchievementGetBadgeAward, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function AchievementGetBadgeAwardCtrl:Init()
    self.panel = UI.AchievementGetBadgeAwardPanel.Bind(self)
    super.Init(self)


    self._showTime = 0
    self._isAutoHide = false

    self.panel.CloseButton:AddClick(function()
        --self._showTime = _hideTime
        self:_showBadgeFinish()
    end)


    self._achievementItemAwardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplateParent = self.panel.AchievementItemAwardParent.transform,
    })

end --func end
--next--
function AchievementGetBadgeAwardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AchievementGetBadgeAwardCtrl:OnActive()
end --func end
--next--
function AchievementGetBadgeAwardCtrl:OnDeActive()
end --func end
--next--
function AchievementGetBadgeAwardCtrl:Update()

    if self._isAutoHide then
        if self._showTime == nil then
            self._showTime = 0
        else
            self._showTime = self._showTime + UnityEngine.Time.deltaTime

            if self._showTime > _hideTime then
                self:_showBadgeFinish()

            end
        end
    end

end --func end

--next--
function AchievementGetBadgeAwardCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, _awardEventName, function(_, awardInfo)
        self:_showAward(awardInfo)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementGetBadgeAwardCtrl:_showBadgeFinish()
    self._showTime = 0
    self._isAutoHide = false

    UIMgr:DeActiveUI(UI.CtrlNames.AchievementGetBadgeAward)
    
end

function AchievementGetBadgeAwardCtrl:GetBadgeAwardFinish(level)
    local l_badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(level, false)
    if nil == l_badgeTableInfo then
        logError("[AchievementBadgeTable] invalid key: " .. tostring(level))
        return
    end

    self.panel.Name.LabText = l_badgeTableInfo.Name
    self.panel.TxtTitle.LabText = Lang("Achievement_GetBadgeAwardText")

    self.panel.OKButton:SetActiveEx(true)
    self.panel.GotoButton:SetActiveEx(false)
    self.panel.OKButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AchievementGetBadgeAward)
        --游戏评价:领取初心者V奖励后弹出评价窗口
        if level==l_achievementAchiLevel then
            MgrMgr:GetMgr("RateAppMgr").ShowRateDialog(nil,l_rateMessage)
        end
    end)

    self.panel.ItemAwardScroll:SetActiveEx(true)
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_badgeTableInfo.AwardId, _awardEventName)
end

function AchievementGetBadgeAwardCtrl:GetAchievementAwardFinish(achievementTableInfo)
    self.panel.Name.LabText = Lang("Achievement_GetBadgeGetAwardText")
    self.panel.TxtTitle.LabText = Lang("Achievement_GetBadgeAwardText")

    self.panel.OKButton:SetActiveEx(true)
    self.panel.GotoButton:SetActiveEx(false)
    self.panel.OKButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.AchievementGetBadgeAward)
    end)

    self.panel.ItemAwardScroll:SetActiveEx(true)
    MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(achievementTableInfo.Award, _awardEventName)

end

function AchievementGetBadgeAwardCtrl:_showAward(awardInfo)
    if awardInfo == nil then
        return
    end

    local l_datas = {}
    for i, v in ipairs(awardInfo.award_list) do
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
        if l_itemRow then
            local data = {}
            data.ID = v.item_id
            data.Count = v.count
            table.insert(l_datas, data)

        end
    end

    self._achievementItemAwardTemplatePool:ShowTemplates({ Datas = l_datas })
end
--lua custom scripts end
return AchievementGetBadgeAwardCtrl