--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MedalPanel"
require "UI/Template/MedalGloryModelTemplate"
require "UI/Template/MedalHolyMedalTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MedalCtrl = class("MedalCtrl", super)
--缓存一个MedalData的引用
local l_medalData = DataMgr:GetData("MedalData")
local l_medalMgr = MgrMgr:GetMgr("MedalMgr")
--lua class define end

--lua functions
function MedalCtrl:ctor()
    super.ctor(self, CtrlNames.Medal, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true
end --func end
--next--
function MedalCtrl:Init()
    self.panel = UI.MedalPanel.Bind(self)
    super.Init(self)

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)
    --光辉勋章池
    self.gloryMedalTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MedalGloryModelTemplate,
        TemplatePrefab = self.panel.MedalGloryModelPrefab.GloryModelPrefab.gameObject,
        ScrollRect = self.panel.GloryMedalScroll.LoopScroll
    })
    --神圣勋章池
    self.holyMedalTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MedalHolyMedalTemplate,
        TemplatePrefab = self.panel.MedalHolyMedalPrefab.HolyMedalPrefab.gameObject,
        ScrollRect = self.panel.HolyMedalScroll.LoopScroll
    })

    self.panel.PrestigePanel:AddClick(function()
        local itemTipsMgr = MgrMgr:GetMgr("ItemTipsMgr")
        itemTipsMgr.ShowTipsDisplayWithId(402, nil, nil, nil, true)
    end)

end --func end
--next--
function MedalCtrl:Uninit()

    self.gloryMedalTemplatePool = nil
    self.holyMedalTemplatePool = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MedalCtrl:OnActive()
    self.panel.PrestigeNumText.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(402))
    --激活神圣勋章动画

    self:CreateMedalScroll()
end --func end
--next--
function MedalCtrl:OnDeActive()

    --关闭时关掉MedalTip
    if UIMgr:IsActiveUI(UI.CtrlNames.MedalTips) then
        UIMgr:DeActiveUI(UI.CtrlNames.MedalTips)
    end

    if self.EffectID then
        self:DestroyUIEffect(self.EffectID)
        self.EffectID = nil
    end

    if self.CurtainEffectID then
        self:DestroyUIEffect(self.CurtainEffectID)
        self.CurtainEffectID = nil
    end

    local tweenScale = self.panel.TweenScale.UObj:GetComponent("DOTweenAnimation")
    tweenScale:DOKill()
    local tweenMove = self.panel.TweenMove.UObj:GetComponent("DOTweenAnimation")
    tweenMove:DOKill()

    local tweenFade_curtain = self.panel.Curtain.UObj:GetComponent("DOTweenAnimation")
    tweenFade_curtain:DOKill()

    local tweenMove_Glory = self.panel.GloryMedalScroll.UObj:GetComponent("DOTweenAnimation")
    tweenMove_Glory:DOKill()
    local tweenFade_Glory = self.panel.GloryMedalContent.UObj:GetComponent("DOTweenAnimation")
    tweenFade_Glory:DOKill()

    local tweenMove_Holy = self.panel.HolyMedalScroll.UObj:GetComponent("DOTweenAnimation")
    tweenMove_Holy:DOKill()
    local tweenFade_Holy = self.panel.HolyMedalContent.UObj:GetComponent("DOTweenAnimation")
    tweenFade_Holy:DOKill()
end --func end
--next--
function MedalCtrl:Update()
    -- do nothing
end --func end

--next--
function MedalCtrl:BindEvents()
    --勋章列表状态改变
    self:BindEvent(l_medalMgr.EventDispatcher, l_medalMgr.MEDAL_STATE_UPGRADE, function(ctrl, medalData)
        if medalData.type == 1 then
            --光辉勋章状态刷新
            local medalItem = self.gloryMedalTemplatePool:GetItem(medalData.MedalId)
            if medalItem then
                medalItem:ShowGloryMedal(medalData)
            end
            --检测是否有神圣勋章解锁了
            for k, v in ipairs(l_medalData.GetHolyMedalData()) do
                local holyMedalItem = self.holyMedalTemplatePool:GetItem(v.MedalId)
                if holyMedalItem then
                    holyMedalItem:ShowHolyMedal(v)
                end
            end
        elseif medalData.type == 2 then
            --改变神圣勋章状态
            local medalItem = self.holyMedalTemplatePool:GetItem(medalData.MedalId)
            if medalItem then
                medalItem:ShowHolyMedal(medalData)
            end
        end
    end)
    self:BindEvent(l_medalMgr.EventDispatcher, l_medalMgr.MEDAL_STATE_ADVANCE, function(ctrl, medalData, isGlory)
        local waitTime = 0
        if isGlory then
            waitTime = 0.5
        end
        local l_timer = self:NewUITimer(function()
            self:CreateActivateMedalAnim(medalData, isGlory)
        end, waitTime)
        l_timer:Start()
    end)
    self:BindEvent(l_medalMgr.EventDispatcher, l_medalMgr.MEDAL_GLORY_UPGRADE, function(mgr, medalData)
        self.panel.PrestigeNumText.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(402))
    end)
    self:BindEvent(Data.PlayerInfoModel.COINCHANGE, Data.onDataChange, function(mgr)
        self.panel.PrestigeNumText.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(402))
    end)
end --func end

--next--
--lua functions end

--lua custom scripts
--创建列表
function MedalCtrl:CreateMedalScroll()
    --光辉勋章
    local gloryMedalTable = l_medalData.GetGloryMedalData()
    self.gloryMedalTemplatePool:ShowTemplates({ Datas = gloryMedalTable })

    --神圣勋章
    local holyMedalTable = l_medalData.GetHolyMedalData()
    self.holyMedalTemplatePool:ShowTemplates({ Datas = holyMedalTable })
end

--激活神圣勋章动画
function MedalCtrl:CreateActivateMedalAnim(medalData, isGlory)
    --复原勋章图片位置
    self.panel.ActivateImage:SetSprite(medalData.Atlas, medalData.Spt)
    --激活神圣勋章动画
    self.panel.ActivateEffectBG:SetActiveEx(true)
    self.panel.ActivateEffect.RawImg.enabled = false
    local l_fxData = {}
    l_fxData.rawImage = self.panel.ActivateEffect.RawImg
    --动画开始
    l_fxData.loadedCallback = function()
        self.panel.ActivateEffect.RawImg.enabled = true
        --还原
        self.panel.TweenMove:SetActiveEx(true)
        self.panel.TweenMove.transform.localPosition = Vector2.New(0, 0)
        self.panel.TweenScale.transform.localScale = Vector3.New(0, 0, 0)
        --图片动画
        local tweenScale = self.panel.TweenScale.UObj:GetComponent("DOTweenAnimation")
        local tweenMove = self.panel.TweenMove.UObj:GetComponent("DOTweenAnimation")
        tweenMove.endValueTransform = l_medalData.GetMedalAdvanceImage().RectTransform
        tweenScale:CreateTween()
        tweenScale:DORestart()
        tweenMove:CreateTween()
        tweenMove:DORestart()
    end
    --结束动画
    l_fxData.destroyHandler = function(isEnd)
        if isEnd then
            l_medalMgr.EventDispatcher:Dispatch(l_medalMgr.MEDAL_STATE_UPGRADE, medalData)
            self.panel.TweenMove:SetActiveEx(false)
            self.panel.ActivateEffectBG:SetActiveEx(false)

            if isGlory then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MEDAL_GLORY_ACTIVATE"), medalData.Name))
            end
        end
    end

    if medalData.type == MedalType.Medal_Type_General then
        self.EffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_MedalActivation_01", l_fxData)
    else
        self.EffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_MedalActivation_02", l_fxData)
    end

end
--lua custom scripts end
return MedalCtrl
