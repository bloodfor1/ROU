--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungenAlarmPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
DungenAlarmCtrl = class("DungenAlarmCtrl", super)
--lua class define end

--lua functions
function DungenAlarmCtrl:ctor()

    super.ctor(self, CtrlNames.DungenAlarm, UILayer.Tips, nil, ActiveType.Normal)

end --func end
--next--
function DungenAlarmCtrl:Init()

    self.panel = UI.DungenAlarmPanel.Bind(self)
	super.Init(self)
    self.canvasGroup = self.panel.PanelRef.gameObject:GetComponent("CanvasGroup")
    if self.panel then
        self.panel.Alarm.gameObject:SetActiveEx(false)
    end
   
end --func end
--next--
function DungenAlarmCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function DungenAlarmCtrl:OnActive()

end --func end
--next--
function DungenAlarmCtrl:OnDeActive()

    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

end --func end
--next--
function DungenAlarmCtrl:Update()


end --func end

--next--
function DungenAlarmCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("DungeonMgr").EventDispatcher,MgrMgr:GetMgr("DungeonMgr").SHOW_DUNGEON_ALARM,function(self,id,announceData,param)
        self:UpdatePanel(id,announceData,param)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

local l_duration = 0    --持续时间
local l_countdown = -1  --倒计时
local l_timer = nil     --定时器

--参数2 有值则为服务器传过来的数据 默认填空 
function DungenAlarmCtrl:ShowTips(id, announceData, ... )
    --log("叙事性提示============="..id)
    if self.panel == nil then
        return
    end
    if id == -1 then
        self:HideTips()
    end
    local l_info = TableUtil.GetMessageTable().GetRowByID(id)
    if l_info == nil then
        return
    end

    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

    -- 倒计时相关提示
    l_duration = l_info.Duration
    if l_duration == nil or l_duration == 0 then
        return
    end
    l_countdown = l_info.CountDown
    if l_countdown == nil then
        l_countdown = -1
    end
    
    local l_str = { ... }
    if l_countdown >= 1 then
        self.panel.Text.LabText = StringEx.Format(l_info.Content, l_countdown)
    else
        if #l_str > 0 then
            self.panel.Text.LabText = StringEx.Format(l_info.Content, l_str)
        else
            self.panel.Text.LabText = Common.Utils.Lang(l_info.Content)
        end
    end
    self.panel.Alarm.gameObject:SetActiveEx(true)
    MLuaClientHelper.StopFxHelper(self.panel.PanelRef.gameObject)
    self.canvasGroup.alpha = 1
    MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)
    l_timer = self:NewUITimer(function()
        if self.panel == nil then
            return
        end
        l_duration = l_duration - 1
        l_countdown = l_countdown - 1
        if l_countdown >= 1 then
            self.panel.Text.LabText = StringEx.Format(l_info.Content, l_countdown)
        end
        if l_duration < 1 then
            self:HideTips()
        elseif l_duration < 2 then
            MLuaClientHelper.PlayFxHelper(self.panel.PanelRef.gameObject)
        end
    end, 1, -1, true)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Alarm.transform)
    l_timer:Start()

end

function DungenAlarmCtrl:HideTips()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
    if l_timerEx then
        self:StopUITimer(l_timerEx)
        l_timerEx = nil
    end
    self.panel.Alarm.gameObject:SetActiveEx(false)
    MLuaCommonHelper.SetLocalPos(self.panel.PanelRef.gameObject,0,0,0)
    self.panel.PanelRef.gameObject:GetComponent("CanvasGroup").alpha = 1
end

function DungenAlarmCtrl:UpdatePanel(id,announceData,param)
    if id < 1 then
        self:HideTips()
        return
    end
    self:ShowTips(id,announceData,param)
end

--根据字符串展示内容
--contenStr 字符串内容
--isFirstIconShow 第一个感叹号图标是否显示
--isSecondIconShow 第二个感叹号图标是否显示
--duration 持续时间
--countDown  倒计时
function DungenAlarmCtrl:ShowAlarmByString(contenStr, isFirstIconShow, isSecondIconShow, duration, countDown)

    if self.panel == nil then
        return
    end

    if string.ro_isEmpty(contenStr) then
        UIMgr:DeActiveUI(UI.CtrlNames.DungenAlarm)
        return
    end

    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end

    l_duration = 0
    l_countdown = -1

    if countDown then
        l_countdown = countDown
    else
        l_countdown = -1
    end
    if l_countdown>1 then
        self.panel.Text.LabText = StringEx.Format(contenStr, l_countdown)
    else
        self.panel.Text.LabText = contenStr
    end

    if duration then
        l_duration = duration
    else
        l_duration = 0
    end

    if isFirstIconShow ~= nil then
        self.panel.Alarm.Transform:GetChild(0).gameObject:SetActiveEx(isFirstIconShow)
    end
    if isSecondIconShow ~= nil then
        self.panel.Alarm.Transform:GetChild(2).gameObject:SetActiveEx(isSecondIconShow)
    end
    self.panel.Alarm.gameObject:SetActiveEx(true)
    MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)

    if l_duration and l_duration > 0 then
        l_timer = self:NewUITimer(function()
            if self.panel == nil then
                return
            end
            l_duration = l_duration -1
            if l_countdown>1 then
                l_countdown = l_countdown -1
                self.panel.Text.LabText = StringEx.Format(contenStr, l_countdown)
            else
                self.panel.Text.LabText = contenStr
            end
            if l_duration<1 then
                self:HideTips()
                UIMgr:DeActiveUI(UI.CtrlNames.DungenAlarm)
            elseif l_duration<2 then
                MLuaClientHelper.PlayFxHelper(self.panel.PanelRef.gameObject)
            end
        end,1,-1,true)

        l_timer:Start()
    end
end
--lua custom scripts end
