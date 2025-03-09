--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/QuickItemPanel"
require "Data/Model/BagModel"

require "UI/Template/QuickUseTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
QuickItemCtrl = class("QuickItemCtrl", super)
local quickPageCount = 2
local gameEventMgr = MgrProxy:GetGameEventMgr()
--------cd
local l_preSecTime

--lua class define end

--lua functions
function QuickItemCtrl:ctor()
    super.ctor(self, CtrlNames.QuickItem, UILayer.Normal, UITweenType.Left, ActiveType.Normal)
    self.cacheGrade = EUICacheLv.VeryLow
    self.items = {}
end --func end
--next--
function QuickItemCtrl:Init()
    self.fadeAction = nil
    self.panel = UI.QuickItemPanel.Bind(self)
    super.Init(self)
    self.quickItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.QuickUseTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.QuickUseTemplate.LuaUIGroup.gameObject
    })

    self.init_x = self.panel.PageView.RectTransform.anchoredPosition.x
    self.initMarkX = self.panel.MarkBg.RectTransform.anchoredPosition.x
end --func end
--next--
function QuickItemCtrl:Uninit()
    if not self.panel then
        return
    end

    self.quickItemPool = nil
    self:ClearFadeAction()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function QuickItemCtrl:OnActive()
    self:ShowData()
    self:FreshQuick()
    self:CheckShow()
    self.uObj.transform:SetAsFirstSibling()
end --func end
--next--
function QuickItemCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function QuickItemCtrl:Update()
    self:FreshCd()
end --func end

--next--
function QuickItemCtrl:BindEvents()
    local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")
    self:BindEvent(l_mainUIMgr.EventDispatcher, l_mainUIMgr.FadeQuickItemEvent, function(self, isOut, time)
        self:FadeAction(isOut, time)
    end)
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnShortCutItemUpdate, self.FreshQuick)
end --func end

--next--
--lua functions end

--lua custom scripts
function QuickItemCtrl:ShowData()
    local datas = {}
    for i = 1, quickPageCount do
        table.insert(datas, { page = i })
    end
    self.quickItemPool:ShowTemplates({ Datas = datas })

    self.items = self.quickItemPool:GetItems()
    local objs = GameObjectList.New()
    for i, v in ipairs(self.items) do
        objs:Add(v:gameObject())
    end
    self.panel.PageView.PageView.OnPageChanged = function(idx)
        idx = idx + 1
        for i, v in ipairs(self.panel.PageMark) do
            v:SetSprite("main", i == idx and "UI_iconitem_huadong01.png" or "UI_iconitem_frame.png")
        end
    end
    self.panel.PageView.PageView:InitWithTemplates(objs, handler(self, self.OnUpdateItem))
end
function QuickItemCtrl:FreshQuick()
    if not self.panel then
        return
    end

    local items = self.quickItemPool:GetItems()
    for i, v in ipairs(items) do
        v:Refresh(i)
    end
end

function QuickItemCtrl:FreshCd()
    if self.panel ~= nil then
        for i, v in ipairs(self.items) do
            if not IsNil(v:gameObject()) then
                v:RefreshCd()
            end
        end
    end
end

function QuickItemCtrl:CheckShow()
    local lOffseX = self.init_x
    local offsetMarkX = self.initMarkX
    local lAlpha = 1
    if not MgrMgr:GetMgr("MainUIMgr").IsShowSkill then
        lOffseX = self.init_x + 100
        offsetMarkX = self.initMarkX + 200
        lAlpha = 0
    end

    local l_pos = self.panel.PageView.RectTransform.anchoredPosition
    l_pos.x = lOffseX
    self.panel.PageView.RectTransform.anchoredPosition = l_pos
    self.panel.PageView:GetComponent("CanvasGroup").alpha = lAlpha
    self.panel.PageView:GetComponent("CanvasGroup").blocksRaycasts = MgrMgr:GetMgr("MainUIMgr").IsShowSkill
    l_pos = self.panel.MarkBg.RectTransform.anchoredPosition
    l_pos.x = offsetMarkX
    self.panel.MarkBg.RectTransform.anchoredPosition = l_pos
    self.panel.MarkBg:GetComponent("CanvasGroup").alpha = lAlpha
end

function QuickItemCtrl:FadeAction(isOut, time)
    self:ClearFadeAction()
    self.fadeAction = DOTween.Sequence()

    local lOffseX = self.init_x
    local offsetMarkX = self.initMarkX
    local lAlpha = 1
    if isOut then
        lOffseX = self.init_x + 100
        offsetMarkX = self.initMarkX + 200
        lAlpha = 0
    end
    self.panel.PageView.gameObject:GetComponent("CanvasGroup").blocksRaycasts = not isOut
    self.panel.PageView.RectTransform:DOAnchorPosX(lOffseX, time)
    self.panel.PageView.gameObject:GetComponent("CanvasGroup"):DOFade(lAlpha, time)
    self.panel.MarkBg.RectTransform:DOAnchorPosX(offsetMarkX, time)
    self.panel.MarkBg.gameObject:GetComponent("CanvasGroup"):DOFade(lAlpha, time)
end

function QuickItemCtrl:ClearFadeAction()
    if self.fadeAction then
        self.fadeAction:Kill(true)
        self.fadeAction = nil
    end
end

function QuickItemCtrl:OnUpdateItem(obj, idx)

end
--lua custom scripts end
