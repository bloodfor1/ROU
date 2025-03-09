--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AvoidPanelPanel"
require "Data/Model/PlayerInfoModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
AvoidPanelCtrl = class("AvoidPanelCtrl", super)
--lua class define end

--lua functions
function AvoidPanelCtrl:ctor()

    super.ctor(self, CtrlNames.AvoidPanel, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function AvoidPanelCtrl:Init()

    self.panel = UI.AvoidPanelPanel.Bind(self)
    super.Init(self)

    self.totalTime = 1
    self.playerHp = 1
    self.allLength = 0  --滑动条总长度
    self.rageTime = {}

    self.initBloodState = false
    self.bloodItem = nil
    self.flagItem = nil
    self.startTime = nil
    self.passTime = nil
    
    self.panel.Slider.Slider.enabled = true
    self.panel.Slider.Slider.value = 0

end --func end
--next--
function AvoidPanelCtrl:Uninit()

    MPlayerInfo:FocusToMyPlayer()
    self.startTime = nil
    if self.bloodItem and #self.bloodItem > 0 then
        for i = 1, #self.bloodItem do
            local l_target = self.bloodItem[i].go
            MResLoader:DestroyObj(l_target)
        end
    end
    self.bloodItem = nil
    if self.flagItem and #self.flagItem > 0 then
        for i = 1, #self.flagItem do
            local l_target = self.flagItem[i]
            MResLoader:DestroyObj(l_target)
        end
    end
    self.flagItem = nil
    self.allLength = 0
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AvoidPanelCtrl:OnActive()


end --func end
--next--
function AvoidPanelCtrl:OnDeActive()


end --func end
--next--
function AvoidPanelCtrl:Update()

    self:UpdateTimerSlider()

end --func end

--next--
function AvoidPanelCtrl:BindEvents()
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    self:BindEvent(Data.PlayerInfoModel.HPPERCENT,Data.onDataChange, function(a, value)
        self:UpdateBlood(value)
    end)
    self:BindEvent(l_dungeonMgr.EventDispatcher,l_dungeonMgr.DUNGEON_COUNT_DOWN_FINISH,function ()
        self:InitTimerSlider()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts


--数据设置
function AvoidPanelCtrl:SetData(totalTime, playerHp, rageTime, waitTime)
    self.totalTime = (totalTime and totalTime > 0) and totalTime or 1
    self.waitTime = waitTime or 0
    self.playerHp = (playerHp and playerHp > 0) and playerHp or 1
    self.rageTime = rageTime or {}
    self:InitBlood()
    self:InitTimerSlider()
end

function AvoidPanelCtrl:InitBlood()
    --如果血量已有不再初始化
    if self.bloodItem then return end

    self.bloodItem = {}
    local l_tp = self.panel.Element.gameObject
    local l_parent = self.panel.Element.gameObject.transform.parent.gameObject.transform
    if self.playerHp > 0 then
        for i = 1, self.playerHp do
            self.bloodItem[i] = {}
            local l_go = self:CloneObj(l_tp)
            self.bloodItem[i].go = l_go
            l_go:SetActiveEx(true)
            l_go.transform:SetParent(l_parent)
            l_go:SetLocalScaleToOther(l_tp)
            self.bloodItem[i].xin = l_go.transform:Find("xin").gameObject:GetComponent("Image")
            self.bloodItem[i].xin.fillAmount = 1
        end
        self.initBloodState = true
        self.singleValue = 1 / self.playerHp
        self.bloodValue = 2
        if MEntityMgr.PlayerEntity ~= nil then
            local l_attr = MEntityMgr.PlayerEntity.AttrRole
            if l_attr~= nil then
                self:UpdateBlood(l_attr.HPPercent)
            end
        end
    end
end

function AvoidPanelCtrl:UpdateBlood(percent)
    if self.initBloodState then
        if math.abs(percent - self.bloodValue) < (self.singleValue / 2) then
            return
        end
        local l_count = #self.bloodItem
        local l_per = 0
        if l_count > 0 then
            for i = 1, l_count do
                if l_per < percent then
                    l_per = l_per + self.singleValue / 2
                    self.bloodItem[i].xin.fillAmount = 0.5
                else
                    self.bloodItem[i].xin.fillAmount = 0
                end
                if l_per < percent then
                    l_per = l_per + self.singleValue / 2
                    self.bloodItem[i].xin.fillAmount = 1
                end
            end
        end
        self.bloodValue = l_per
    end
end

function AvoidPanelCtrl:InitTimerSlider()
    --如果总进度条长度已有不再初始化
    if self.allLength > 0 then return end

    self.NoticeTime = {}
    local l_startPosX = self.panel.Start.gameObject.transform.localPosition.x
    local l_endPosX = self.panel.End.gameObject.transform.localPosition.x
    self.allLength = l_endPosX - l_startPosX
    self.flagItem = {}
    local l_tp = self.panel.Flag.gameObject
    local l_x = l_tp.transform.localPosition.x
    local l_y = l_tp.transform.localPosition.y
    local l_parent = self.panel.Flag.gameObject.transform.parent.gameObject.transform
    self.CursorX = self.panel.Cursor.gameObject.transform.localPosition.x
    self.CursorY = self.panel.Cursor.gameObject.transform.localPosition.y
    if #self.rageTime > 0 then
        for i = 1, #self.rageTime do
            local l_value = tonumber(self.rageTime[i][1])
            if l_value <= self.totalTime then
                self.NoticeTime[#self.NoticeTime+1] = l_value
                local l_per = (l_value / self.totalTime) * self.allLength
                local l_go = self:CloneObj(l_tp)
                l_go:SetActiveEx(true)
                l_go:SetPosToOther(l_tp)
                l_go.transform:SetParent(l_parent)
                l_go:SetLocalScaleToOther(l_tp)
                l_go:SetLocalPos(l_x + l_per, l_y, 0)
                local l_index = #self.flagItem + 1
                self.flagItem[l_index] = l_go
            end
        end
    end
    if MPlayerInfo.PlayerDungeonsInfo.DungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonMaze then
        --迷雾之森 房间开始时间
        self.startTime = tonumber(tostring(MgrMgr:GetMgr("DungeonMgr").GetDungeonsRoomStartTime())) + self.waitTime
    else
        self.startTime = tonumber(tostring(MgrMgr:GetMgr("DungeonMgr").GetDungeonsStartTime())) + self.waitTime
    end
end

function AvoidPanelCtrl:UpdateTimerSlider()
    if self.startTime then
        if not self.passTime then
            self.passTime = Common.TimeMgr.GetNowTimestamp() - self.startTime
            self.passTime = self.passTime < 0 and 0 or self.passTime
            self.panel.Slider.Slider.value = self.passTime / self.totalTime
        end
        if Common.TimeMgr.GetNowTimestamp() - self.startTime > self.passTime + 0.2 then
            self.passTime = Common.TimeMgr.GetNowTimestamp() - self.startTime
            self.panel.Slider.Slider.value = self.passTime / self.totalTime
        end
        if self.allLength and self.CursorX then
            self.panel.Cursor.gameObject:SetLocalPos(self.CursorX + (self.passTime / self.totalTime) * self.allLength, self.CursorY, 0)
        end
        if #self.NoticeTime > 0 then
            if self.passTime > self.NoticeTime[1] then
                table.remove(self.NoticeTime, 1)
                return
            end
            if self.passTime > self.NoticeTime[1] - 2 then
                --MgrMgr:GetMgr("TipsMgr").ShowDungeonTips(Common.Utils.Lang("AVOID_TIPS"))
                table.remove(self.NoticeTime, 1)
            end
        end
        --到时则关闭界面
        if self.passTime > self.totalTime then
            --如果是迷雾之森 则调用迷雾之森的结束
            if MPlayerInfo.PlayerDungeonsInfo.DungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonMaze then
                MgrMgr:GetMgr("MazeDungeonMgr").MazeAvoidRoomEnd()
                return
            end
            UIMgr:DeActiveUI(UI.CtrlNames.AvoidPanel)
        end
    end
end
--lua custom scripts end
