--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FishMainPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FishMainCtrl = class("FishMainCtrl", super)
--lua class define end

local l_fishMgr = nil  --钓鱼管理类
local l_fishState = 0  --钓鱼状态 0普通钓鱼 1自动钓鱼
local l_screenSize = Vector2.New(1136, 640)
local l_baitId = 3050003  --鱼饵id这里先写个默认的 实际会读表

--lua functions
function FishMainCtrl:ctor()

    super.ctor(self, CtrlNames.FishMain, UILayer.Normal, nil, ActiveType.Normal)
    --self.forceHideUI = { MUIManager.MOVE_CONTROLLER }

end --func end
--next--
function FishMainCtrl:Init()

    self.panel = UI.FishMainPanel.Bind(self)
    super.Init(self)
    --鱼饵id获取
    l_baitId = MGlobalConfig:GetInt("FishingBaitItemID")
    --面板初始化 防止别的界面打开关闭 重启该界面的时候出现界面混乱
    self.panel.OperatePanel.CanvasGroup.blocksRaycasts = false
    self.panel.OperatePanel.CanvasGroup.alpha = 0
    --钓鱼状态初始化
    l_fishState = 0
    --管理类赋值
    l_fishMgr = MgrMgr:GetMgr("FishMgr")
    --初始化动画
    self.fadeAction = nil
    --UI屏幕大小获取
    l_screenSize = MUIManager:GetUIScreenSize()
    --鱼饵介绍面板 内容赋值
    local l_baitInfo = TableUtil.GetItemTable().GetRowByItemID(l_baitId)
    self.panel.ExplainTextMessage.LabText = l_baitInfo.ItemDescription
    --按钮点击事件绑定
    self:ButtonClickEventAdd()

    --动画坐标获取
    self.init_x = self.panel.OperatePanel.RectTransform.anchoredPosition.x - 100
    --初始关闭浮标
    self:ClosePullRodTip()

end --func end
--next--
function FishMainCtrl:Uninit()
    --动画清理
    self:ClearFadeAction()

    if self.fishWaterFmodInstance then
        MAudioMgr:StopFModInstance(self.fishWaterFmodInstance)
        self.fishWaterFmodInstance = nil
    end

    l_fishMgr = nil
    l_fishState = 0

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FishMainCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("LifeProfessionData").EUIOpenType.FishMain then
            self:ShowOperatePanel()
        end
    end

    if MgrMgr:GetMgr("MainUIMgr").IsShowSkill then
        self:FadeAction(false, MgrMgr:GetMgr("MainUIMgr").ANI_TIME)
    end

    --判断自动钓鱼BUFF是否存在
    local l_isAutoFishing = MEntityMgr.PlayerEntity.IsAutoFishing
    self.panel.BtnAutoStart.UObj:SetActiveEx(not l_isAutoFishing)
    self.panel.BtnAutoEnd.UObj:SetActiveEx(l_isAutoFishing)
    self.panel.BtnAutoSetting.UObj:SetActiveEx(l_isAutoFishing)
    self.panel.AutoFishingTip.UObj:SetActiveEx(l_isAutoFishing)

    --背包中鱼饵数量获取
    local l_baitNum = Data.BagModel:GetBagItemCountByTid(l_baitId)
    self.panel.BaitNumText.LabText = tostring(l_baitNum)
end --func end
--next--
function FishMainCtrl:OnDeActive()


end --func end
--next--
function FishMainCtrl:Update()


end --func end



--next--
function FishMainCtrl:BindEvents()

    --事件绑定
    self:EventInit()

end --func end
--next--
--lua functions end

--lua custom scripts
--按钮点击事件添加
function FishMainCtrl:ButtonClickEventAdd()
    --退出钓鱼按钮
    self.panel.BtnExit:AddClick(function()
        MEventMgr:LuaFireEvent(MEventType.MEvent_StopFish, MEntityMgr.PlayerEntity)
    end)
    --道具按钮点击
    self.panel.BtnProp:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.FishProp)
    end)
    --鱼饵数量展示框点击效果
    self.panel.BaitNumBg:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
    end)
    --鱼饵介绍面板背景点击关闭
    self.panel.CloseExplainPanelButton:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(false)
    end)
    --开始自动钓鱼按钮点击
    self.panel.BtnAutoStart:AddClick(function()
        --判断自动钓鱼BUFF是否存在
        local l_maxOnceFishTime = MGlobalConfig:GetFloat("AutoFishingCycleTimeMax")
        if math.floor(MEntityMgr.PlayerEntity.AutoFishLeftTime) > l_maxOnceFishTime then
            --如果存在则直接进入自动钓鱼
            MgrMgr:GetMgr("FishMgr").ReqFish(FishingType.FISHING_TYPE_AUTO_FISH, 0, false)
        else
            UIMgr:ActiveUI(UI.CtrlNames.FishAutoSetting)
        end
    end)
    --结束自动钓鱼按钮点击
    self.panel.BtnAutoEnd:AddClick(function()
        MgrMgr:GetMgr("FishMgr").ReqFish(FishingType.FISHING_TYPE_STOP_AUTO_FISH, 0, false)
    end)
    --开启钓鱼设置按钮点击
    self.panel.BtnAutoSetting:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.FishAutoSetting)
    end)
end

--事件绑定
function FishMainCtrl:EventInit()
    --鱼饵数量更新事件绑定
    self:BindEvent(l_fishMgr.EventDispatcher, l_fishMgr.ON_UPDATE_BAIT_NUM, function(self)
        local l_baitNum = Data.BagModel:GetBagItemCountByTid(l_baitId)
        self.panel.BaitNumText.LabText = tostring(l_baitNum)
        if 0 >= l_baitNum then
            --鱼饵为0时红色显示
            self.panel.BaitNumText.LabColor = Color.New(1, 0, 0)
        else
            self.panel.BaitNumText.LabColor = Color.New(1, 1, 1)
        end
    end)

    --拉杆提示展示事件绑定
    self:BindEvent(l_fishMgr.EventDispatcher, l_fishMgr.ON_SHOW_PULL_ROD_TIP, function(self, pos, lastTimeValue)
        --播放鱼划水的声音
        if not self.fishWaterFmodInstance then
            self.fishWaterFmodInstance = MAudioMgr:StartFModInstance("event:/UI/Skills/Fishing_GetFish")
        end
        self:ShowPullRodTip(pos, lastTimeValue)
    end)

    --拉杆提示关闭事件绑定
    self:BindEvent(l_fishMgr.EventDispatcher, l_fishMgr.ON_CLOSE_PULL_ROD_TIP, function(self)
        --关闭鱼划水的声音
        if self.fishWaterFmodInstance then
            MAudioMgr:StopFModInstance(self.fishWaterFmodInstance)
            self.fishWaterFmodInstance = nil
        end
        self:ClosePullRodTip()
    end)

    --自动钓鱼开始事件绑定
    self:BindEvent(l_fishMgr.EventDispatcher, l_fishMgr.ON_START_AUTO_FISHING, function(self)
        l_fishState = 1
        self.panel.BtnAutoStart.UObj:SetActiveEx(false)
        self.panel.BtnAutoEnd.UObj:SetActiveEx(true)
        self.panel.BtnAutoSetting.UObj:SetActiveEx(true)
        self.panel.AutoFishingTip.UObj:SetActiveEx(true)
    end)

    --自动钓鱼结束事件绑定
    self:BindEvent(l_fishMgr.EventDispatcher, l_fishMgr.ON_END_AUTO_FISHING, function(self)
        l_fishState = 0
        self.panel.BtnAutoStart.UObj:SetActiveEx(true)
        self.panel.BtnAutoEnd.UObj:SetActiveEx(false)
        self.panel.BtnAutoSetting.UObj:SetActiveEx(false)
        self.panel.AutoFishingTip.UObj:SetActiveEx(false)
    end)

    local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")

    self:BindEvent(l_mainUIMgr.EventDispatcher, l_mainUIMgr.FadeFishMainEvent, function(self, isOut, time)
        self:FadeAction(isOut, time)
    end)
end

--钓鱼主界面面板展示
function FishMainCtrl:ShowOperatePanel()
    MgrMgr:GetMgr("MainUIMgr").SwitchUIToSpecial() --如果切换时时功能按钮界面 则做一次切换
    local ui = UIMgr:GetUI(UI.CtrlNames.MainArrows)
    if ui then
        ui:FadeAction(true, MgrMgr:GetMgr("MainUIMgr").ANI_TIME)
    end
    --self:FadeAction(false, MgrMgr:GetMgr("MainUIMgr").ANI_TIME)
    --这里利用什么周期 callback 在OnActive之前 所以动画放入OnActive
    --同时防止别的界面 将钓鱼压入栈 之后 钓鱼主界面的主按钮出不来
end

--展示拉杆提示
function FishMainCtrl:ShowPullRodTip(pos, lastTimeValue)
    self.panel.PullRodTip.UObj:SetActiveEx(true)
    local l_tipSize = self.panel.PullRodTip.RectTransform.sizeDelta
    --提示的位置极限边框获取
    local l_minX = l_tipSize.x / 2
    local l_maxX = l_screenSize.x - l_minX
    local l_minY = 0
    local l_maxY = l_screenSize.y - l_tipSize.y
    --提示位置获取
    local l_x = l_screenSize.x * pos.x
    local l_y = l_screenSize.y * pos.y
    if l_x > l_maxX then
        l_x = l_maxX
    end
    if l_x < l_minX then
        l_x = l_minX
    end
    if l_y > l_maxY then
        l_y = l_maxY
    end
    if l_y < l_minY then
        l_y = l_minY
    end
    --设置坐标 因为lua设置都是按中心点算的 所以要减去一半的分辨率
    MLuaCommonHelper.SetLocalPos(self.panel.PullRodTip.UObj, l_x - l_screenSize.x / 2, l_y - l_screenSize.y / 2, 0)
    --设置进度
    self.panel.TipProcess.Slider.value = lastTimeValue
end

--关闭拉杆提示
function FishMainCtrl:ClosePullRodTip()
    self.panel.PullRodTip.UObj:SetActiveEx(false)
end

--淡入淡出动画
function FishMainCtrl:FadeAction(isOut, time)
    self:ClearFadeAction()
    if self.panel then
        --如果存在界面才播动画 若已销毁则不播动画
        self.panel.ExplainPanel.UObj:SetActiveEx(false) --切换时 鱼饵介绍关闭
        self.fadeAction = DOTween.Sequence()

        local lOffseX = self.init_x
        local lAlpha = 1
        if isOut then
            lOffseX = self.init_x + 100
            lAlpha = 0
        end
        self.panel.OperatePanel.CanvasGroup.blocksRaycasts = not isOut
        local l_act_move = self.panel.OperatePanel.RectTransform:DOAnchorPosX(lOffseX, time)
        local l_act_fade = self.panel.OperatePanel.gameObject:GetComponent("CanvasGroup"):DOFade(lAlpha, 0.1)
    end
end
--淡入淡出动画清理
function FishMainCtrl:ClearFadeAction()
    if self.fadeAction ~= nil then
        self.fadeAction:Kill(true)
        self.fadeAction = nil
    end
end
--lua custom scripts end
