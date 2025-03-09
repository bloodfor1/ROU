--this file is gen by script
--you can edit this file in custom part
--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainArenaPanel"
require "Data/Model/PlayerInfoModel"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MainArenaCtrl = class("MainArenaCtrl", super)
--lua class define end

--lua functions
function MainArenaCtrl:ctor()

    super.ctor(self, CtrlNames.MainArena, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function MainArenaCtrl:Init()

    self.panel = UI.MainArenaPanel.Bind(self)
    super.Init(self)
    self.pvpArenaMgr = MgrMgr:GetMgr("PvpArenaMgr")
    if StageMgr:GetCurStageEnum() == MStageEnum.Arena then
        MgrMgr:GetMgr("ArenaMgr").m_fightOver = false
    end
end --func end
--next--
function MainArenaCtrl:Uninit()

    if StageMgr:GetCurStageEnum() == MStageEnum.Arena then
        MgrMgr:GetMgr("ArenaMgr").m_fightOver = false
        self.pvpArenaMgr.OnLogout()
    end
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MainArenaCtrl:OnActive()

    self:OnInit()

end --func end
--next--
function MainArenaCtrl:OnDeActive()

    self:OnUninit()

end --func end

function MainArenaCtrl:OnShow()

end

function MainArenaCtrl:OnHide()

end

--next--
function MainArenaCtrl:Update()

    self:UpdateBeat()

end --func end

--next--
function MainArenaCtrl:BindEvents()

    self:BindEvent(self.pvpArenaMgr.EventDispatcher,self.pvpArenaMgr.UPDATE_ARENA_ROOM_INFO_NTF, function()
        if StageMgr:GetCurStageEnum() == MStageEnum.ArenaPre then
            self:InitOwnerState()
            self:InitPreNumberPanel()
            self:InitPreBtnPanel()
            self:InitPreStatePanel()
        end
        if StageMgr:GetCurStageEnum() == MStageEnum.Arena then
            self:InitScorePanel()
        end
    end)
    local l_arenaMgr = MgrMgr:GetMgr("ArenaMgr")
    self:BindEvent(l_arenaMgr.EventDispatcher,l_arenaMgr.ArenaUpdateScoreEvent,function()
        if StageMgr:GetCurStageEnum() == MStageEnum.Arena then
            self:InitScorePanel()
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

local m_timerState = false

function MainArenaCtrl:OnInit()
    self.panel.pKPanel.gameObject:SetActiveEx(false)
    self.panel.preObject.gameObject:SetActiveEx(false)
    m_timerState = false

    --ArenaPre init
    if StageMgr:GetCurStageEnum() == MStageEnum.ArenaPre then
        self.panel.preObject.gameObject:SetActiveEx(true)
        self.panel.setPanel.gameObject:SetActiveEx(false)
        self.panel.timerLab.gameObject:SetActiveEx(false)
        self:InitOwnerState()
        self:InitPreStatePanel()
        self:InitPreBtnPanel()
        self:InitPreNumberPanel()
    end

    --Arena init
    if StageMgr:GetCurStageEnum() == MStageEnum.Arena then
        self.panel.pKPanel.gameObject:SetActiveEx(true)
        self:InitScorePanel()
        self:InitTimerPanel()
    end
end

function MainArenaCtrl:OnUninit()

    m_timerState = false

end

--颜色的更改:hud名字颜色+准备场景人数颜色+(战斗场景分数颜色+结束面板左右颜色区分)(默认蓝色在右)+hud血条颜色+kill提示颜色
local m_colorGreen = Color.New(49 / 255, 161 / 255, 255 / 255, 1) --green;
local m_colorYellow = Color.New(255 / 255, 58 / 255, 58 / 255, 1) --yellow;

---------------------------------------------------pre----------------------------------------------------

function MainArenaCtrl:InitPreBtnPanel()
    self.panel.setBtn:AddClick(function()
        self.panel.setBtn.gameObject:SetActiveEx(false)
        self.panel.setPanel.gameObject:SetActiveEx(true)
    end)
    self.panel.closePanelBtn:AddClick(function()
        self.panel.setBtn.gameObject:SetActiveEx(true)
        self.panel.setPanel.gameObject:SetActiveEx(false)
    end)
    local l_isOwner = self.pvpArenaMgr.JudgeIsOwner(MPlayerInfo.UID)
    local l_inviteState = self.pvpArenaMgr.m_canInvite or l_isOwner
    self.panel.inviteBtn:AddClick(function()
        if l_inviteState then
            UIMgr:ActiveUI(UI.CtrlNames.PvpArenaInvitation)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PVP_NOT_INVITATION"))
        end
    end)
    self.panel.inviteBtn:SetGray(not l_inviteState)
    self.panel.inviteIcon:SetGray(not l_inviteState)
    self.panel.openBtn:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
    end)
    self.panel.openBtn:SetGray(true)
    self.panel.recruitBtn:AddClick(function()
        if l_isOwner then
            UIMgr:ActiveUI(CtrlNames.PvpArenaRecruit)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PVP_NOT_RECRUIT"))
        end
    end)
    self.panel.recruitBtn.gameObject:SetActiveEx(l_isOwner)
    self.panel.openBtn.gameObject:SetActiveEx(l_isOwner)
    self.panel.openBtn:SetGray(not l_isOwner)
    self.panel.openIcon:SetGray(not l_isOwner)
    self.panel.startBtn:AddClick(function()
        if table.ro_size(self.pvpArenaMgr.m_memberInfo) < 2 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PVP_WARNING_CANNOT_START_BATTLE"))
            return
        end
        if self.pvpArenaMgr.m_arenaRoomInfo.play_mode == ArenaRoomPlayMode.CUSTOM_OPTIONAL then
            local l_tempGroup = -1
            for k, v in pairs(self.pvpArenaMgr.m_memberInfo) do
                if l_tempGroup ~= -1 and l_tempGroup ~= v.FightGroup then
                    self.pvpArenaMgr.PushIntoArenaPvpCustom()
                    return
                end
                l_tempGroup = v.FightGroup
            end
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PVP_WARNING_CANNOT_START_BATTLE"))
        else
            self.pvpArenaMgr.PushIntoArenaPvpCustom()
        end
    end)
    self.panel.freeBtn:AddClick(function()
        if l_isOwner then
            self.pvpArenaMgr.ChangeArenaRoomCondition(nil, nil, ArenaRoomPlayMode.RANDOM_SHUFFLE)
        end
    end)
    self.panel.randomBtn:AddClick(function()
        if l_isOwner then
            self.pvpArenaMgr.ChangeArenaRoomCondition(nil, nil, ArenaRoomPlayMode.CUSTOM_OPTIONAL)
        end
    end)
    self.panel.randomBtn.Btn.enabled = l_isOwner
end

--[[
阵营人数刷新
--]]
function MainArenaCtrl:InitPreNumberPanel()
    if self.pvpArenaMgr.m_arenaRoomInfo ~= nil then
        if self.pvpArenaMgr.m_arenaRoomInfo.play_mode == ArenaRoomPlayMode.RANDOM_SHUFFLE then
            local numInt, numRem = math.modf(table.ro_size(self.pvpArenaMgr.m_memberInfo) / 2)
            if numRem > 0 then
                self.panel.redCountLab.LabText = tostring(numInt + 1)
            else
                self.panel.redCountLab.LabText = tostring(numInt)
            end
            self.panel.blueCountLab.LabText = tostring(numInt)
            self.panel.redCountLab.LabColor = m_colorGreen
            self.panel.blueCountLab.LabColor = m_colorYellow
        end
        if self.pvpArenaMgr.m_arenaRoomInfo.play_mode == ArenaRoomPlayMode.CUSTOM_OPTIONAL then
            local l_member1 = 0
            local l_member2 = 0
            local l_tempGroup = 1
            local l_color1 = m_colorGreen
            local l_color2 = m_colorYellow
            --Common.Functions.DumpTable(self.pvpArenaMgr.m_memberInfo, "<var>", 6)
            for k, v in pairs(self.pvpArenaMgr.m_memberInfo) do
                if l_tempGroup == v.FightGroup then
                    l_member1 = l_member1 + 1
                else
                    l_member2 = l_member2 + 1
                end
                if tostring(v.RoleId) == tostring(MPlayerInfo.UID) then
                    local l_state = v.FightGroup == l_tempGroup
                    l_color1 = l_state and m_colorGreen or m_colorYellow
                    l_color2 = l_state and m_colorYellow or m_colorGreen
                end
            end
            self.panel.redCountLab.LabText = tostring(l_member1)
            self.panel.blueCountLab.LabText = tostring(l_member2)
            self.panel.redCountLab.LabColor = l_color1
            self.panel.blueCountLab.LabColor = l_color2
        end
    else
        self.panel.redCountLab.LabText = "0"
        self.panel.blueCountLab.LabText = "0"
    end
end

--[[
模式按钮状态
--]]
function MainArenaCtrl:InitPreStatePanel()
    if self.pvpArenaMgr.m_arenaRoomInfo ~= nil then
        local state = self.pvpArenaMgr.m_arenaRoomInfo.play_mode
        self.panel.freeBtn.gameObject:SetActiveEx(state == ArenaRoomPlayMode.CUSTOM_OPTIONAL)
        self.panel.randomBtn.gameObject:SetActiveEx(state == ArenaRoomPlayMode.RANDOM_SHUFFLE)
    else
        self.panel.freeBtn.gameObject:SetActiveEx(false)
        self.panel.randomBtn.gameObject:SetActiveEx(false)
    end
end

--[[
房间状态
--]]
function MainArenaCtrl:InitOwnerState()
    local randomCom = self.panel.randomBtn.gameObject:GetComponent("MLuaUICom")
    local freeCom = self.panel.freeBtn.gameObject:GetComponent("MLuaUICom")
    if self.pvpArenaMgr.JudgeIsOwner(MPlayerInfo.UID) then
        self.panel.startBtn.gameObject:SetActiveEx(true)
        randomCom:SetGray(true)
        freeCom:SetGray(true)
        if table.ro_size(self.pvpArenaMgr.m_memberInfo) < 2 then
            self:SetStartBtnState(true)
        else
            if self.pvpArenaMgr.m_arenaRoomInfo.play_mode == ArenaRoomPlayMode.CUSTOM_OPTIONAL then
                local l_tempGroup = -1
                local l_canStart = false
                for k, v in pairs(self.pvpArenaMgr.m_memberInfo) do
                    if l_tempGroup ~= -1 and l_tempGroup ~= v.FightGroup then
                        l_canStart = true
                        break
                    end
                    l_tempGroup = v.FightGroup
                end
                self:SetStartBtnState(not l_canStart)
            else
                self:SetStartBtnState(false)
            end
        end
    else
        self.panel.startBtn.gameObject:SetActiveEx(false)
        randomCom:SetGray(false)
        freeCom:SetGray(false)
    end
end

--[[
设置按钮状态
--]]
function MainArenaCtrl:SetStartBtnState(state)
    local startCom = self.panel.startBtn.gameObject:GetComponent("MLuaUICom")
    startCom:SetGray(state)
    self.panel.startEnableLab.gameObject:SetActiveEx(not state)
    self.panel.startDisableLab.gameObject:SetActiveEx(state)
end

--exp:MgrMgr:GetMgr("TipsMgr").ShowCommonTips("111111","22222",self.info,self.info,self.info)  -- info is a function
function MainArenaCtrl:ShowCommonTips(info, title, sureCallBack, cancelCallBack)
    UIMgr:ActiveUI(CtrlNames.TipsCommon)
    local l_ui = UIMgr:GetUI(CtrlNames.TipsCommon)
    if l_ui ~= nil then
        l_ui:SetCommonTips(info, title, sureCallBack, cancelCallBack)
    end
end
-----------------------------------------------------pk----------------------------------------------------

--[[
分数面板初始化
--]]
function MainArenaCtrl:InitScorePanel()
    local l_tempGroup = 1
    self.panel.redScoreLab.LabText = tostring(0)
    self.panel.blueScoreLab.LabText = tostring(0)
    self.panel.redScoreLab.LabColor = m_colorGreen
    self.panel.blueScoreLab.LabColor = m_colorYellow
    --[[
    for k, v in pairs(self.pvpArenaMgr.m_memberInfo) do
        if tostring(v.RoleId) == tostring(MPlayerInfo.UID) then
            local l_state = v.FightGroup == l_tempGroup
            local l_s1 = tostring(MPlayerDungeonsInfo.EnemyCampDeadCount)
            local l_s2 = tostring(MPlayerDungeonsInfo.PlayerCampDeadCount)
            self.panel.redScoreLab.LabText = l_state and l_s1 or l_s2
            self.panel.blueScoreLab.LabText = l_state and l_s2 or l_s1
            self.panel.redScoreLab.LabColor = l_state and m_colorGreen or m_colorYellow
            self.panel.blueScoreLab.LabColor = l_state and m_colorYellow or m_colorGreen
            break
        end
    end
    ]]--
    local arenaMgr=MgrMgr:GetMgr("ArenaMgr")
    self.panel.redScoreLab.LabText = arenaMgr.BattleRedScore
    self.panel.blueScoreLab.LabText = arenaMgr.BattleBlueScore
end

function MainArenaCtrl:UpdateBeat()
    if not m_timerState then
        return
    end
    local nowInterval = Time.realtimeSinceStartup - self.startTime
    local temp = math.modf(nowInterval - self.interval)
    if temp >= 1 then
        self.interval = self.interval + temp
        self.panel.pkTimerLab.LabText = self:GetTimerStr()
    end
end
--[[
时间面板
--]]
function MainArenaCtrl:InitTimerPanel()
    local l_passTime = MgrMgr:GetMgr("DungeonMgr").GetDungeonsPassTime()
    local dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerDungeonsInfo.DungeonID)
    local l_allTime = 0
    local l_type = nil
    if dungeonData and dungeonData.TimeLimit then
        local l_dataType = dungeonData.TimeLimit:get_Item(0)
        local l_dataSec = dungeonData.TimeLimit:get_Item(1)
        l_allTime = l_dataSec - l_passTime
        l_type = l_dataType
    end
    if l_allTime <= 0 then
        self.panel.pkTimerLab.LabText = "00:00"
        m_timerState = false
    else
        self.min, temp = math.modf(l_allTime / 60)
        self.secod = l_allTime - self.min * 60
        self.startTime = Time.realtimeSinceStartup
        self.interval = 0
        m_timerState = true
        self.panel.pkTimerLab.LabText = self:GetTimerStr()
    end
end

function MainArenaCtrl:GetTimerStr()
    local l_remain = self.min * 60 + self.secod - self.interval
    if l_remain < 1 then
        m_timerState = false
        return "00:00"
    end
    if l_remain < 60 then
        if l_remain < 10 then
            return "00:0" .. tostring(l_remain)
        else
            return "00:" .. tostring(l_remain)
        end
    end
    local l_m, temp = math.modf(l_remain / 60)
    local l_s = l_remain - l_m * 60
    local l_mstr
    local l_sStr
    if l_m < 10 then
        l_mstr = "0" .. tostring(l_m)
    else
        l_mstr = tostring(l_m)
    end
    if l_s < 10 then
        l_sStr = "0" .. tostring(l_s)
    else
        l_sStr = tostring(l_s)
    end
    return l_mstr .. ":" .. l_sStr
end

--lua custom scripts end
