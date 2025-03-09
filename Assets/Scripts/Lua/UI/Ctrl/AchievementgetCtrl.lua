--this file is gen by script
--you can edit this file in custom part

-- 获得成就

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementgetPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
AchievementgetCtrl = class("AchievementgetCtrl", super)

HideTime = 4.5
--lua class define end

--lua functions
function AchievementgetCtrl:ctor()
    super.ctor(self, CtrlNames.Achievementget, UILayer.Tips, nil, ActiveType.Standalone)
end --func end
--next--
function AchievementgetCtrl:Init()
    self.panel = UI.AchievementgetPanel.Bind(self)
    super.Init(self)

    self._mgr = MgrMgr:GetMgr("AchievementMgr")
    self.showTime = 0
    self._showAchievementIds = {}
    self._cacheAchievementIds = {}

    self.panel.CloseBtn1:AddClick(function()
        self:_showAchievementFinish()
        --self.showTime = HideTime
    end)
    self.panel.CloseBtn2:AddClick(function()
        self:_showAchievementFinish()
        --self.showTime = HideTime
    end)

    self.fxId = nil
end --func end
--next--
-- destroy
function AchievementgetCtrl:Uninit()

    if self.fxId ~= nil then
        self:DestroyUIEffect(self.fxId)
        self.fxId = nil
    end

    super.Uninit(self)
    self.panel = nil
    self._mgr = nil
end --func end

--next--
function AchievementgetCtrl:OnActive()
    self._showAchievementIds = {}
    self:_showAchievementGet()
end --func end

--next--
function AchievementgetCtrl:OnDeActive()
    self.showTime = 0
    MgrMgr:GetMgr("AchievementMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("AchievementMgr").AchievementShowGetPanelFinishEvent, self._showAchievementIds)
    self._showAchievementIds = {}
end --func end
--next--
function AchievementgetCtrl:Update()
    if self.showTime ~= nil then
        self.showTime = self.showTime + UnityEngine.Time.deltaTime

        if self.showTime > HideTime then
            self:_showAchievementFinish()

        end
    else
        self.showTime = 0
    end


end --func end



--next--
function AchievementgetCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function AchievementgetCtrl:_showAchievementFinish()
    self:_showAchievementGet()
end

function AchievementgetCtrl:_showAchievementGet()
    --  重置时间
    self.showTime = 0

    -- 如果队列中还有数据，就继续显示，并且将数据移除
    if #self._mgr.AchievementGetCacheAchievementDatas ~= 0 then
        self:_showAchievement()
        table.remove(self._mgr.AchievementGetCacheAchievementDatas, 1)
        return
    end
    UIMgr:DeActiveUI(UI.CtrlNames.Achievementget)

    -- 做个标注，默认是在禁用的时候会调用销毁的，销毁的时候mgr会被置空，这个时候会出现空指针，所以这里重新取一下
    local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")

    -- 如果队列中已经没有数据，就弹出勋章
    if 0 >= l_achievementMgr.AchievementGetCacheLevel then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.AchievementGetBadge)
end

function AchievementgetCtrl:_showAchievement()
    local l_achievementData = self._mgr.AchievementGetCacheAchievementDatas[1]
    local l_achievementId = l_achievementData.achievementid
    local l_tableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(l_achievementId)
    if l_tableInfo == nil then
        return
    end
    table.insert(self._showAchievementIds, l_achievementId)
    self.panel.Icon:SetSprite(l_tableInfo.Atlas, l_tableInfo.Icon, true)
    self.panel.Name.LabText = l_tableInfo.Name
    self.panel.Details.LabText = self._mgr.GetAchievementDetailsWithTableInfo(l_tableInfo)
    self.panel.Grade.LabText = tostring(l_tableInfo.Point)
    --self:ShowFx()
end

function AchievementgetCtrl:ShowFx()

    if self.fxId ~= nil then
        self:DestroyUIEffect(self.fxId)
        self.fxId = nil
    end

    local l_fxData = {}
    l_fxData.scaleFac = Vector3.New(0.4, 0.4, 0.4)
    l_fxData.position = Vector3.New(0, 0.1, 0)
    l_fxData.rawImage = self.panel.Effect.RawImg
    self.panel.Effect.gameObject:SetActiveEx(false)
    l_fxData.destroyHandler = function()
        self.fxId = nil
    end
    l_fxData.loadedCallback = function()
        self.panel.Effect.gameObject:SetActiveEx(true)
    end
    self.fxId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_XunZhangHuoQu_01", l_fxData)
    
end

--lua custom scripts end
