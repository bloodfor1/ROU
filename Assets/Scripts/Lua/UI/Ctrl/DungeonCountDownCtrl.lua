--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungeonCountDownPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
DungeonCountDownCtrl = class("DungeonCountDownCtrl", super)
--lua class define end

--lua functions
function DungeonCountDownCtrl:ctor()

    super.ctor(self, CtrlNames.DungeonCountDown, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function DungeonCountDownCtrl:Init()

    self.panel = UI.DungeonCountDownPanel.Bind(self)
    super.Init(self)

end --func end
--next--
function DungeonCountDownCtrl:Uninit()

    self:StopTimer()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function DungeonCountDownCtrl:OnActive()


end --func end
--next--
function DungeonCountDownCtrl:OnDeActive()


end --func end
--next--
function DungeonCountDownCtrl:Update()


end --func end





--next--
function DungeonCountDownCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

local l_timer = nil

function DungeonCountDownCtrl:Play(startTime, sec, title)

    self.countSec = sec
    self.start = tonumber(tostring(startTime))
    self.endTime = self.start + self.countSec
    self.remainTime = math.ceil(self.endTime - Common.TimeMgr.GetNowTimestamp())
    if self.remainTime > self.countSec then self.remainTime = self.countSec end  --防止切后台引起的取时间不准
    --如果已超时 则关闭
    if self.remainTime < 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.DungeonCountDown)
        return
    end
    self.title = title
    self:StopTimer()
    self.panel.LabPanel.gameObject:SetActiveEx(false)
    self.panel.NumPanel.gameObject:SetActiveEx(false)
    l_timer = self:NewUITimer(function()
        self.remainTime = math.ceil(self.endTime - Common.TimeMgr.GetNowTimestamp())
        if self.remainTime > self.countSec then self.remainTime = self.countSec end  --防止切后台引起的取时间不准
        self:UpdateLab()
    end, 1, -1, true)
    l_timer:Start()
    self:UpdateLab()
end

function DungeonCountDownCtrl:UpdateLab()
    if self.remainTime <= -1 then
        UIMgr:DeActiveUI(UI.CtrlNames.DungeonCountDown)
        local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
        l_dungeonMgr.EventDispatcher:Dispatch(l_dungeonMgr.DUNGEON_COUNT_DOWN_FINISH)
        return
    end
    if self.remainTime <= 0 then
        self.panel.LabPanel.gameObject:SetActiveEx(false)
        self.panel.NumPanel.gameObject:SetActiveEx(false)
        self.panel.DesLab.LabText = self.title
        self.panel.LabPanel.gameObject:SetActiveEx(true)
        return
    end
    self.panel.NumPanel.gameObject:SetActiveEx(false)
    self.panel.NumLab.LabText = self.remainTime
    self.panel.NumPanel.gameObject:SetActiveEx(true)
end

function DungeonCountDownCtrl:StopTimer()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
end
--lua custom scripts end
