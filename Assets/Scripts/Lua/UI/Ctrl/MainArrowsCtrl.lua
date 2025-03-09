--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainArrowsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MainArrowsCtrl = class("MainArrowsCtrl", super)
local PanelState = { open = 1, close = 2 }

ArrowPanelUI = {
    [0] = "UI_common_ArrowSetup_Frame01.png",
    [1] = "UI_common_ArrowSetup_Frame06.png",
    [2] = "UI_common_ArrowSetup_Frame07.png",
    [3] = "UI_common_ArrowSetup_Frame04.png",
    [4] = "UI_common_ArrowSetup_Frame05.png",
}
--lua class define end

--lua functions
function MainArrowsCtrl:ctor()

    self.mgr = MgrMgr:GetMgr("ArrowMgr")
    super.ctor(self, CtrlNames.MainArrows, UILayer.Normal, nil, ActiveType.Normal)
    self.state = PanelState.close
    self.lastPlayerPos = nil
    self.overrideSortLayer = UILayerSort.Normal - 1

end --func end
--next--
function MainArrowsCtrl:Init()

    self.panel = UI.MainArrowsPanel.Bind(self)
    super.Init(self)
    self.firstDir = self.panel.DoubleOpen.transform:GetChild(3).localPosition
    self.tweens = {}
    self.classicsArrowInitX = self.panel.ClassicsArrows.RectTransform.anchoredPosition.x
    self.doubleArrowInitX = self.panel.DoubleArrows.RectTransform.anchoredPosition.x
    self.panel.DoubleDefault:AddClick(handler(self, self.OnClickDefault))
    self.panel.ClassicsDefault:AddClick(handler(self, self.OnClickDefault))
    self.panel.DoubleSetup:AddClick(handler(self, self.OnClickSetUp))
    self.panel.ClassicSetup:AddClick(handler(self, self.OnClickSetUp))

end --func end
--next--
function MainArrowsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MainArrowsCtrl:OnActive()

    if not MgrMgr:GetMgr("MainUIMgr").IsShowSkill then
        UIMgr:DeActiveUI(UI.CtrlNames.MainArrows)
    else
        self:RefreshArrows()
        self:SetClose()
    end

end --func end
--next--
function MainArrowsCtrl:OnDeActive()


end --func end
--next--
function MainArrowsCtrl:Update()
    -- do nothing
end --func end

--next--
function MainArrowsCtrl:BindEvents()

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self.RefreshArrows)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.REFRESH_SLOTS, self.RefreshArrows)
    self:BindEvent(GlobalEventBus, EventConst.Names.BeginTouchJoyStack, self.Packup)

end --func end
--next--
--lua functions end

--lua custom script
function MainArrowsCtrl:Packup()

    if self.state == PanelState.close then
        return
    end
    self:DoAction(false)

end

function MainArrowsCtrl:RefreshArrows()

    self.panel.DoubleArrows:SetActiveEx(not MPlayerSetting.IsClassic)
    self.panel.ClassicsArrows:SetActiveEx(MPlayerSetting.IsClassic)
    local arrows_ui = MPlayerSetting.IsClassic and self.panel.classicsArrows or self.panel.doubleArrows
    for i = 1, 3 do
        self:InitSelectArrow(arrows_ui[i], i)
        arrows_ui[i]:AddClick(function()
            self.mgr.SetUpArrow(i)
        end)
    end
    arrows_ui[4]:AddClick(function()
        for i = 1, 3 do
            if self.mgr.IsEquipArrow(i) then
                self.mgr.CancleArrow(i)
            end
        end
    end)
    local default_ui = MPlayerSetting.IsClassic and self.panel.ClassicsDefault or self.panel.DoubleDefault
    self:InitSelectArrow(default_ui, 0)

end

function MainArrowsCtrl:InitSelectArrow(go, idx)

    local arrows = self.mgr.g_arrows
    local mainArrow = arrows[0]
    local equipArrow = arrows[idx]
    local imgCom = go.transform:Find("Image"):GetComponent("MLuaUICom")
    local numImgCom = go.transform:Find("NumImage") and go.transform:Find("NumImage"):GetComponent("MLuaUICom")
    local textCom = go.transform:Find("Text"):GetComponent("MLuaUICom")
    local shadowCom = go.transform:Find("Shadow") and go.transform:Find("Shadow"):GetComponent("MLuaUICom")
    local bgImg = go.transform:GetComponent("MLuaUICom")
    local bagArrows = self.mgr.GetBagArrows()

    if equipArrow and equipArrow > 0 then
        imgCom:SetActiveEx(equipArrow ~= nil)
        textCom:SetActiveEx(equipArrow ~= nil)
        local arrowNum = bagArrows[equipArrow] or 0
        textCom.LabText = tostring(arrowNum)
        shadowCom:SetActiveEx(idx ~= 0)
        imgCom:SetGray(0 >= arrowNum)
        local itemSdata = TableUtil.GetItemTable().GetRowByItemID(equipArrow)
        if not itemSdata then
            return logError("find item sdata fail ", equipArrow)
        end
        imgCom:SetSprite(itemSdata.ItemAtlas, itemSdata.ItemIcon)
        if numImgCom then
            numImgCom:SetActiveEx(false)
        end
        if idx ~= 0 then
            bgImg:SetSprite("Common", ArrowPanelUI[idx])
        else
            for i = 1, 3 do
                if arrows[i] == equipArrow then
                    bgImg:SetSprite("Common", ArrowPanelUI[i])
                end
            end
        end
    elseif idx == 0 then
        imgCom:SetActiveEx(true)
        imgCom:SetSprite("Icon_ItemMaterial02", "UI_icon_item_shenzhijinshujianshi.png")
        imgCom:SetGray(false)
        textCom:SetActiveEx(false)
        if numImgCom then
            numImgCom:SetActiveEx(true)
        end
        shadowCom:SetActiveEx(true)
        bgImg:SetSprite("Common", ArrowPanelUI[4])
    else
        imgCom:SetActiveEx(false)
        textCom:SetActiveEx(false)
        if numImgCom then
            numImgCom:SetActiveEx(false)
        end
        bgImg:SetSprite("Common", ArrowPanelUI[0])
    end

end

function MainArrowsCtrl:SetClose()

    local isOut = false
    self.state = isOut and PanelState.open or PanelState.close
    if self.panel == nil then
        return
    end                --防止UI在播放动画的瞬间被动关闭UI
    local rec = MPlayerSetting.IsClassic and -85 or 0
    local open = MPlayerSetting.IsClassic and self.panel.ClassicsOpen or self.panel.DoubleOpen
    local src, dest, tweenId, srcAlpha, dstAlpha, child
    for i = 0, open.transform.childCount - 1 do
        child = open.transform:GetChild(i)
        dest = isOut and self.firstDir * Quaternion.Euler(0, 0, -50 * i + rec) or Vector3.zero
        src = isOut and Vector3.zero or child.transform.localPosition
        srcAlpha = isOut and 0 or 1
        dstAlpha = isOut and 1 or 0
        tweenId = MUITweenHelper.TweenPosAlpha(child.gameObject, src, dest, srcAlpha, dstAlpha, 0)
    end

end

function MainArrowsCtrl:DoAction(isOut)

    self:ClearTweens()
    self.state = isOut and PanelState.open or PanelState.close
    if self.panel == nil then
        return
    end
    local open = MPlayerSetting.IsClassic and self.panel.ClassicsOpen or self.panel.DoubleOpen
    local rec = MPlayerSetting.IsClassic and -85 or 0
    local src, dest, tweenId, srcAlpha, dstAlpha, child
    for i = 0, open.transform.childCount - 1 do
        child = open.transform:GetChild(i)
        dest = isOut and self.firstDir * Quaternion.Euler(0, 0, -50 * i + rec) or Vector3.zero
        src = isOut and Vector3.zero or child.transform.localPosition
        srcAlpha = isOut and 0 or 1
        dstAlpha = isOut and 1 or 0
        tweenId = MUITweenHelper.TweenPosAlpha(child.gameObject, src, dest, srcAlpha, dstAlpha, 0.25)
        table.insert(self.tweens, tweenId)
    end

end

function MainArrowsCtrl:ClearTweens()

    array.each(self.tweens, function(v)
        MUITweenHelper.KillTween(v)
    end)
    self.tweens = {}

end

function MainArrowsCtrl:OnClickDefault()

    if self.state == PanelState.open then
        self.state = PanelState.close
        self:DoAction(false)
    else
        self.state = PanelState.open
        self:DoAction(true)
    end

end

function MainArrowsCtrl:OnClickSetUp()
    UIMgr:ActiveUI(UI.CtrlNames.ArrowSetup)
end

function MainArrowsCtrl:FadeAction(isOut, time)

    if self.panel then
        local destX = 0
        local lAlpha = 1
        if MPlayerSetting.IsClassic then
            destX = isOut and self.classicsArrowInitX + 100 or self.classicsArrowInitX
            lAlpha = isOut and 0 or 1
            self.panel.ClassicsArrows.RectTransform:DOAnchorPosX(destX, time)
            self.panel.ClassicsArrows:GetComponent("CanvasGroup"):DOFade(lAlpha, time)
        else
            destX = isOut and self.doubleArrowInitX + 100 or self.doubleArrowInitX
            lAlpha = isOut and 0 or 1
            self.panel.DoubleArrows.RectTransform:DOAnchorPosX(destX, time)
            self.panel.DoubleArrows:GetComponent("CanvasGroup"):DOFade(lAlpha, time)
        end
    end

end

--lua custom scripts end
return MainArrowsCtrl