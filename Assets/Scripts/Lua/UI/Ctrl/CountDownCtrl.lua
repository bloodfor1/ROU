--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CountDownPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CountDownCtrl = class("CountDownCtrl", super)
--lua class define end

local l_defultNumColor --数字默认颜色
local l_timer     --定时器

--lua functions
function CountDownCtrl:ctor()

    super.ctor(self, CtrlNames.CountDown, UILayer.Tips, nil, ActiveType.Normal)
    self.overrideSortLayer = UILayerSort.Normal - 1

end --func end
--next--
function CountDownCtrl:Init()

    self.panel = UI.CountDownPanel.Bind(self)
    super.Init(self)
    l_defultNumColor = Color.New(245/255.0, 223/255.0, 78/255.0)
    self.remainTime = 0

    self.panel.Center:SetActiveEx(true)
    self.panel.Right:SetActiveEx(false)
    self.panel.Txt_Tip:SetActiveEx(true)

end --func end
--next--
function CountDownCtrl:Uninit()

    l_defultNumColor = nil
    self.remainTime = 0

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CountDownCtrl:OnActive()

    if self.uiPanelData then
        self:ShowTimer(self.uiPanelData.startTime, self.uiPanelData.remainTime, self.uiPanelData.tipText,
                self.uiPanelData.numColor, self.uiPanelData.callback)
        if self.uiPanelData.isShowToBtnExit then
            self:SetPositionToBtnExit()
        end
    end

end --func end
--next--
function CountDownCtrl:OnDeActive()

    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

end --func end
--next--
function CountDownCtrl:Update()


end --func end



--next--
function CountDownCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--展示倒计时(屏幕正上方)
--startTime   开始时间(传0的话 就是获取当前服务器事件)
--remainTime   剩余持续时间
--tipText   文字提示 为空不显示
--numColor  倒计时数字的颜色  为空取默认
function CountDownCtrl:ShowTimer(startTime, remainTime, tipText, numColor, callback)

    if startTime == nil then
        startTime=0
        logError("传递的startTime是空的")
    end

    if remainTime == nil then
        remainTime=0
        logError("传递的remainTime是空的")
    end

    startTime=tonumber(tostring(startTime))

    if startTime == nil then
        logError("startTime转number的时候出错，startTime："..tostring(startTime))
        startTime=0
    end

    remainTime=tonumber(remainTime)

    if remainTime ==nil then
        logError("remainTime转number的时候出错，remainTime："..tostring(remainTime))
        remainTime=0
    end

    --文字提示设置
    if tipText then
        self.panel.Txt_Tip.LabText = tipText
        self.panel.Txt_Tip.UObj:SetActiveEx(true)
    else
        self.panel.Txt_Tip.UObj:SetActiveEx(false)
    end
    --字体颜色设置
    if numColor then
        self.panel.Text.LabColor = numColor
    else
        self.panel.Text.LabColor = l_defultNumColor
    end

    --利用开始时间和剩余时间 计算结束时间  计时使用结束时间减去当前时间做运算 防止切后台导致错误
    self.endTime = startTime + remainTime

    --计时器设置
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

    --初始倒计时文本设置
    self.remainTime = self.endTime - tonumber(tostring(MServerTimeMgr.UtcSeconds))
    self:SetCountDownText()
    l_timer = self:NewUITimer(function()
        self.remainTime = self.endTime - tonumber(tostring(MServerTimeMgr.UtcSeconds))
        self:SetCountDownText()
        if self.remainTime < 1 then
            if l_timer then
                self:StopUITimer(l_timer)
                l_timer = nil
            end
            UIMgr:DeActiveUI(UI.CtrlNames.CountDown)
            if callback ~= nil then
                callback()
            end
        end
    end,1,-1,true)
    l_timer:Start()

end

--设置倒计时文字
function CountDownCtrl:SetCountDownText()
    local l_seconds = self.remainTime % 60
    local l_mins = math.floor(self.remainTime / 60)
    if self.panel then
        self.panel.Text.LabText = StringEx.Format("{0:00}:{1:00}", l_mins, l_seconds)
    end
end

--增加倒计时的时长
function CountDownCtrl:AddCountDownTime(addTime)
    self.endTime = self.endTime + (addTime or 0)
end

-- 将计时移动到退出按钮旁边
function CountDownCtrl:SetPositionToBtnExit()
    self.panel.Center:SetActiveEx(false)
    self.panel.Right:SetActiveEx(true)
    self.panel.Txt_Tip:SetActiveEx(false)
    local l_btnExitPos = nil
    local l_mainCtrl = UIMgr:GetUI(UI.CtrlNames.Main)
    if l_mainCtrl then
        l_btnExitPos = l_mainCtrl:GetBtnExitPosition()
    end
    if l_btnExitPos then
        self.panel.TimePanel.transform.position = l_btnExitPos
    end
end

--lua custom scripts end
return CountDownCtrl
