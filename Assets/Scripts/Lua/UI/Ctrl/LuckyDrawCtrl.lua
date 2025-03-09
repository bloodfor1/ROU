--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LuckyDrawPanel"
require "Data.Model.BagModel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
LuckyDrawCtrl = class("LuckyDrawCtrl", super)
local Mgr = MgrMgr:GetMgr("LuckyDrawMgr")
local TOTAL_COUNT = 5
--lua class define end

--lua functions
function LuckyDrawCtrl:ctor()

    super.ctor(self, CtrlNames.LuckyDraw, UILayer.Function, nil, ActiveType.Exclusive)
    --self:SetBlockOpt(BlockColor.Dark)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function LuckyDrawCtrl:Init()

    self.panel = UI.LuckyDrawPanel.Bind(self)
	super.Init(self)
    self:InitializePanel()

end --func end
--next--
function LuckyDrawCtrl:Uninit()

    self:UnInitializePanel()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function LuckyDrawCtrl:OnActive()


end --func end
--next--
function LuckyDrawCtrl:OnDeActive()


end --func end
--next--
function LuckyDrawCtrl:Update()

    if self.start then
        if Time.realtimeSinceStartup - self.start > Mgr.DungeonLuckyDrawExitTime then
            self.panel.PanelFlop["F3"].Btn.Btn.onClick:Invoke()
            self.start = nil
        end
    end

end --func end





--next--
function LuckyDrawCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

local DaoJuEffect = {
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Green_Boom_01",
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Blue_Boom_01",
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Orange_Purple_01",
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Orange_Boom_01",
}

local GuangEffect = {
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Green_01",
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Blue_01",
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Purple_01",
    "Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_Orange_01",
}

function LuckyDrawCtrl:InitializePanel()
    self.start = Time.realtimeSinceStartup

    if Mgr.g_type == MgrMgr:GetMgr("RollMgr").g_RollContext.RollContextNone then
        self:OnExitPanel()
        return
    end

    -- 播放开始动画 START
    self.fx = nil
    self.panel.Panel.gameObject:SetActiveEx(false)
    self.panel.ImgEffect.gameObject:SetActiveEx(true)
    local l_fxData0 = {}
    l_fxData0.rawImage = self.panel.ImgEffect.RawImg
    l_fxData0.destroyHandler = function()
        self.fx = nil
        self.panel.Panel.gameObject:SetActiveEx(true)
        self.effectWhite = {}
        for l = 1, TOTAL_COUNT do
            self.panel.PanelFlop["F" .. l].ImgFront.gameObject:SetActiveEx(false)
            self.panel.PanelFlop["F" .. l].ImgBack.gameObject:SetActiveEx(false)
            self.panel.PanelFlop["F" .. l].Btn.gameObject:SetActiveEx(false)
            -- 播放白光特效
            local l_fxData1 = {}
            l_fxData1.rawImage = self.panel.PanelFlop["F" .. l].EffectGuang.RawImg
            l_fxData1.destroyHandler = function()
                if l == TOTAL_COUNT then
                    self:InitExtractPanel()
                end
            end
            self.effectWhite[l] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_PinZhiGuang_White_01", l_fxData1)
        end
    end
    self.fx = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_FanPai_QianZhiTeXiao_01", l_fxData0)
    -- 播放开始动画 END
end

function LuckyDrawCtrl:InitExtractPanel()
    -- 抽取界面的逻辑
    self.itemPrefab = {}
    self.effectGuang = {}
    self.effectBoom = {}
    self.tweenScale = {}
    self.tweenRotation = {}
    self.panel.TxtTitle.gameObject:SetActiveEx(true)
    for i = 1, TOTAL_COUNT do
        -- 显示纸牌待抽取状态
        self.panel.PanelFlop["F" .. i].ImgBack.gameObject:SetActiveEx(true)
        self.panel.PanelFlop["F" .. i].Btn.gameObject:SetActiveEx(true)
        self.panel.PanelFlop["F" .. i].Btn.Btn.onClick:AddListener(function()
            -- 抽取之后将所有的点击事件移除
            for j = 1, TOTAL_COUNT do
                self.panel.PanelFlop["F" .. j].Btn.Btn.onClick:RemoveAllListeners()
            end
            -- 播放玩家抽取之后的动画
            -- 设置抽取的和没抽取到的icon
            local l_otherIndex = 1
            local l_itemRow = nil
            for j = 1, TOTAL_COUNT do
                if j == i then
                    l_itemRow = TableUtil.GetItemTable().GetRowByItemID(Mgr.g_realSlot.item_id, true)
                else
                    l_itemRow = TableUtil.GetItemTable().GetRowByItemID(Mgr.g_otherSlot[l_otherIndex].item_id, true)
                    l_otherIndex = l_otherIndex + 1
                end
                if l_itemRow then
                    self.itemPrefab[j] = self:NewTemplate("ItemTemplate", {
                        TemplateParent = self.panel.PanelFlop["F" .. j].ImgIcon.gameObject.transform
                    })
                    self.itemPrefab[j]:SetData({ ID = l_itemRow.ItemID, IsShowCount = false, IsShowTips = false })
                    local l_go = self.itemPrefab[j]:gameObject()
                    l_go:SetLocalScale(1.78, 1.78, 1)
                end
            end

            -- 通过价格查找特效对应Index
            local l_effectIndex = 0
            if Mgr.WeightQuality.Length > 0 then
                local l_price = Mgr.g_realSlot.price or 0
                for k = 0, Mgr.WeightQuality.Length - 1 do
                    if l_price >= tonumber(Mgr.WeightQuality[k][0]) and l_price <= tonumber(Mgr.WeightQuality[k][1]) then
                        l_effectIndex = k + 1
                        break
                    end
                end
            end
            l_effectIndex = (l_effectIndex > 4 or l_effectIndex < 1) and 1 or l_effectIndex

            -- 播放光特效
            local l_fxData2 = {}
            l_fxData2.rawImage = self.panel.PanelFlop["F" .. i].EffectGuang.RawImg
            l_fxData2.loadedCallback = function()
                -- 放大卡牌
                if self.tweenScale[i] then
                    MUITweenHelper.KillTween(self.tweenScale[i])
                    self.tweenScale[i] = nil
                end
                self.tweenScale[i] = MUITweenHelper.TweenScale(self.panel.PanelFlop["F" .. i].LuaUIGroup.gameObject, Vector3.New(1, 1, 1), Vector3.New(1.2, 1.2, 1), 0.1, function()
                    self.tweenScale[i] = MUITweenHelper.TweenScale(self.panel.PanelFlop["F" .. i].LuaUIGroup.gameObject, Vector3.New(1.2, 1.2, 1), Vector3.New(1.1, 1.1, 1), 0.1, function()
                        -- 去除tween动画
                        MUITweenHelper.KillTween(self.tweenScale[i])
                        -- 播放boom特效
                        local l_fxData3 = {}
                        l_fxData3.rawImage = self.panel.PanelFlop["F" .. i].EffectBoom.RawImg
                        l_fxData3.loadedCallback = function(go)
                            -- 旋转卡牌
                            if self.tweenRotation[i] then
                                MUITweenHelper.KillTween(self.tweenRotation[i])
                                self.tweenRotation[i] = nil
                            end
                            local go = self.panel.PanelFlop["F" .. i].Flop
                            self.tweenRotation[i] = MUITweenHelper.TweenRotationByEuler(go.gameObject, go.gameObject.transform.localRotation, Vector3.New(0, 90, 0), 0.25, function()
                                self.panel.PanelFlop["F" .. i].ImgBack.gameObject:SetActiveEx(false)
                                self.panel.PanelFlop["F" .. i].ImgFront.gameObject:SetActiveEx(true)
                                self.tweenRotation[i] = MUITweenHelper.TweenRotationByEuler(go.gameObject, go.gameObject.transform.localRotation, Vector3.New(0, 180, 0), 0.25, function()
                                    local l_opt = {
                                        itemId = Mgr.g_realSlot.item_id,
                                        itemOpts = {num=Mgr.g_realSlot.item_count, icon={size=18, width=1.4}},
                                    }
                                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)

                                    -- 播放其他的卡牌旋转
                                    if self.timer1 then
                                        self:StopUITimer(self.timer1)
                                        self.timer1 = nil
                                    end
                                    self.timer1 = self:NewUITimer(function()
                                        for j = 1, TOTAL_COUNT do
                                            if j ~= i then
                                                if self.tweenRotation[j] then
                                                    MUITweenHelper.KillTween(self.tweenRotation[j])
                                                    self.tweenRotation[j] = nil
                                                end
                                                local go = self.panel.PanelFlop["F" .. j].Flop
                                                self.tweenRotation[j] = MUITweenHelper.TweenRotationByEuler(go.gameObject, go.gameObject.transform.localRotation, Vector3.New(0, 90, 0), 0.25, function()
                                                    self.panel.PanelFlop["F" .. j].ImgBack.gameObject:SetActiveEx(false)
                                                    self.panel.PanelFlop["F" .. j].ImgFront.gameObject:SetActiveEx(true)
                                                    self.tweenRotation[j] = MUITweenHelper.TweenRotationByEuler(go.gameObject, go.gameObject.transform.localRotation, Vector3.New(0, 180, 0), 0.25, function()
                                                        -- 所有流程走完之后 添加退出界面事件
                                                        self.panel.Tips:SetActiveEx(true)
                                                        MUIEventListener.Get(self.panel.Bg.gameObject).onClick = function(go, data)
                                                            self:OnExitPanel()
                                                        end
                                                        -- 玩家不点击退出 到时间自动退出
                                                        if Mgr.g_isTimeLimit then
                                                            if self.timer2 then
                                                                self:StopUITimer(self.timer2)
                                                                self.timer2 = nil
                                                            end
                                                            self.timer2 = self:NewUITimer(function()
                                                                self:OnExitPanel()
                                                            end, Mgr.DungeonLuckyDrawExitTime)
                                                            self.timer2:Start()
                                                        end
                                                    end)
                                                end)
                                            end
                                        end
                                    end, 1)
                                    self.timer1:Start()
                                end)
                            end)
                        end
                        self.effectBoom[i] = self:CreateUIEffect(DaoJuEffect[l_effectIndex], l_fxData3)
                    end)
                end)
            end
            self.effectGuang[i] = self:CreateUIEffect(GuangEffect[l_effectIndex], l_fxData2)
        end)
    end
end

function LuckyDrawCtrl:OnExitPanel()
    UIMgr:DeActiveUI(UI.CtrlNames.LuckyDraw)
    if Mgr.g_callBack then
        Mgr.g_callBack()
    end

    -- MgrProxy:GetQuickUseMgr().OnItemChangeNtf(Mgr.g_info)
    Mgr.OnEnterScene()
end

function LuckyDrawCtrl:UnInitializePanel()
    self.start = nil

    if self.fx ~= nil then
        self:DestroyUIEffect(self.fx)
        self.fx = nil
    end

    if self.effectWhite then
        for i, v in pairs(self.effectWhite) do
            if self.effectWhite[i] and self.effectWhite[i] ~= 0 then
                self:DestroyUIEffect(self.effectWhite[i])
            end
        end
    end
    self.effectWhite = {}

    if self.itemPrefab then
        for i, v in pairs(self.itemPrefab) do
            v:gameObject():SetLocalScale(1,1,1)
            self:UninitTemplate(v)
        end
    end
    self.itemPrefab = {}

    if self.effectGuang then
        for i, v in pairs(self.effectGuang) do
            if self.effectGuang[i] and self.effectGuang[i] ~= 0 then
                self:DestroyUIEffect(self.effectGuang[i])
            end
        end
    end
    self.effectGuang = {}

    if self.effectBoom then
        for i, v in pairs(self.effectBoom) do
            if self.effectBoom[i] and self.effectBoom[i] ~= 0 then
                self:DestroyUIEffect(self.effectBoom[i])
            end
        end
    end
    self.effectBoom = {}

    if self.tweenScale then
        for i, v in pairs(self.tweenScale) do
            if self.tweenScale[i] then
                MUITweenHelper.KillTween(self.tweenScale[i])
                self.tweenScale[i] = nil
            end
        end
    end
    self.tweenScale = {}

    if self.tweenRotation then
        for i, v in pairs(self.tweenRotation) do
            if self.tweenRotation[i] then
                MUITweenHelper.KillTween(self.tweenRotation[i])
                self.tweenRotation[i] = nil
            end
        end
    end
    self.tweenRotation = {}

    if self.timer1 then
        self:StopUITimer(self.timer1)
        self.timer1 = nil
    end

    if self.timer2 then
        self:StopUITimer(self.timer2)
        self.timer2 = nil
    end
end

return LuckyDrawCtrl
--lua custom scripts end
