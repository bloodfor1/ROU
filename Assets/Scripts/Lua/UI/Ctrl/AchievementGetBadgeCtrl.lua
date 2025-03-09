--this file is gen by script
--you can edit this file in custom part

-- 勋章 view

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementGetBadgePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
AchievementGetBadgeCtrl = class("AchievementGetBadgeCtrl", super)
local _hideTime = 4.5
--lua class define end

--lua functions
function AchievementGetBadgeCtrl:ctor()

    super.ctor(self, CtrlNames.AchievementGetBadge, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function AchievementGetBadgeCtrl:Init()
    self.panel = UI.AchievementGetBadgePanel.Bind(self)
    super.Init(self)
    self._showTime = 0
    self.currentLevel=0

    self._achievementStarTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchievementGetBadgeStarTemplate",
        TemplateParent = self.panel.StarParent.transform,
        TemplatePrefab = self.panel.AchievementGetBadgeStarPrefab.gameObject,
    })

    self._achievementFunctionAwardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchievementBadgeAwardTemplate",
        TemplateParent = self.panel.AchievementBadgeAwardParent.transform,
        TemplatePrefab = self.panel.AchievementBadgeAwardPrefab.gameObject,
    })

    self.panel.BG:PlayDynamicEffect()
    self.panel.Bottom:PlayDynamicEffect()

    self.panel.CloseBtn:AddClick(function()
        self:_showBadgeFinish()
    end)

end --func end
--next--
function AchievementGetBadgeCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self._achievementStarTemplatePool=nil
    self._achievementFunctionAwardTemplatePool=nil



end --func end
--next--
function AchievementGetBadgeCtrl:OnActive()
    self:_showBadge()
end --func end
--next--
function AchievementGetBadgeCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function AchievementGetBadgeCtrl:Update()
    if self._showTime == nil then
        self._showTime = 0
    else
        self._showTime = self._showTime + UnityEngine.Time.deltaTime

        if self._showTime > _hideTime then
            self:_showBadgeFinish()

        end
    end

end --func end




--next--
function AchievementGetBadgeCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function AchievementGetBadgeCtrl:_showBadge()
    local l_badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(MgrMgr:GetMgr("AchievementMgr").AchievementGetCacheLevel)
    if l_badgeTableInfo == nil then
        return
    end
    self.panel.Icon:SetSprite(l_badgeTableInfo.Atlas, l_badgeTableInfo.Icon)
    self.panel.Name.LabText = l_badgeTableInfo.Name
    self:_showEffectOnLightStarWithTableInfo(l_badgeTableInfo)

    self:_showGetBadgeAward(l_badgeTableInfo)
end

function AchievementGetBadgeCtrl:_showEffectOnLightStarWithTableInfo(badgeTableInfo)

    local l_starCount=badgeTableInfo.StarType
    local l_starDataList={}
    for i = 1, l_starCount do
        local l_starData={}
        if i<=badgeTableInfo.LightNumber then
            l_starData.IsLight=true
        end
        table.insert(l_starDataList,l_starData)
    end

    self._achievementStarTemplatePool:ShowTemplates({
        Datas = l_starDataList,
    })

end

function AchievementGetBadgeCtrl:_showBadgeFinish()
    self._showTime = 0
    local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")

    if nil == l_achievementMgr then
        logError("[Achievement] Mgr is nil, plis check")
        return
    end

    l_achievementMgr.AchievementGetCacheLevel = 0
    UIMgr:DeActiveUI(UI.CtrlNames.AchievementGetBadge)

end

function AchievementGetBadgeCtrl:_showGetBadgeAward(badgeTableInfo)

    self.currentLevel = badgeTableInfo.Level

    self.panel.Btn_GO:AddClickWithLuaSelf(self._goAchievement,self)

    if 0 == badgeTableInfo.SystemId.Length then
        return
    end

    local l_data = MgrMgr:GetMgr("AchievementMgr").FiltrateAwardIDList(badgeTableInfo.SystemId)
    self._achievementFunctionAwardTemplatePool:ShowTemplates({
        Datas = l_data,
    })

end

function AchievementGetBadgeCtrl:_goAchievement()
    self:_showBadgeFinish()
    MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, self.currentLevel)
end
--lua custom scripts end
return AchievementGetBadgeCtrl