--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattlePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

local l_last = 0
local string_format = StringEx.Format
--lua class define
local super = UI.UIBaseCtrl
BattleCtrl = class("BattleCtrl", super)
--lua class define end

--lua functions
function BattleCtrl:ctor()
    super.ctor(self, CtrlNames.Battle, UILayer.Function, nil, ActiveType.Normal)
end --func end
--next--
function BattleCtrl:Init()
    self.panel = UI.BattlePanel.Bind(self)
    super.Init(self)
    self.showEffect = false
    self.last_left_num = 0
    self.last_right_num = 0
    self.initialize = false
    self.tweenId = 0

    self._selfKillNum = 0
    self._enemyKillNum = 0
    -- 默认值为1，这里可能会有除0问题
    self.C_NUM_KILL_COUNT = 1
    local killCountConfig = MGlobalConfig:GetSequenceOrVectorInt("BgKillNumRecharge")
    if nil ~= killCountConfig then
        self.C_NUM_KILL_COUNT = killCountConfig[0]
        if nil == self.C_NUM_KILL_COUNT or 0 >= self.C_NUM_KILL_COUNT then
            logError("[BattleCtrl] invalid param, reset default kill count")
            self.C_NUM_KILL_COUNT = 5
        end
    end

    self:NewRedSign({
        Key = eRedSignKey.BattleFieldHintEffect,
        ClickButton = self.panel.HintBtn
    })
end --func end
--next--
function BattleCtrl:Uninit()
    self:OnUnInitPanel()
    self.last_left_num = 0
    self.last_right_num = 0
    self.initialize = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function BattleCtrl:OnActive()
    UIMgr:ShowNormalContainer()
    --- 新手引导
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "BattleFieldFirstTimeEnter" })
    self:OnInitPanel()
end --func end
--next--
function BattleCtrl:OnDeActive()
    UIMgr:ShowNormalContainer()
end --func end
--next--
function BattleCtrl:Update()
    self:UpdateFx()
    if StageMgr:GetCurStageEnum() == MStageEnum.Battle and Time.realtimeSinceStartup - l_last > 0.2 then
        self:UpdateSkill()
        l_last = Time.realtimeSinceStartup
    end
end --func end
--next--
function BattleCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBattleFieldKDAUpdated, self._onKdaUpdate)
    local l_mgr = MgrMgr:GetMgr("BattleMgr")
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_BATTLE_ENTER, self.OnInitPanel)
    self:BindEvent(MgrMgr:GetMgr("DailyTaskMgr").EventDispatcher, MgrMgr:GetMgr("DailyTaskMgr").DAILY_ACTIVITY_UPDATE_EVENT, function()
        self:OnDailyTaskInfoUpdate()
        self:OnTeamInfoUpdate()
    end)

    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, function()
        local l_inPipei = l_mgr.InQueue
        self:OnTeamInfoUpdate()
        --提示队友离开准备场景，退出排队
        if l_inPipei and not l_mgr.InQueue then
            local l_teamInfo = DataMgr:GetData("TeamData").myTeamInfo
            local l_reqNum = MGlobalConfig:GetInt("BgMinTeamSize")
            if l_teamInfo.isInTeam then
                if l_reqNum > #l_teamInfo.memberList then
                    return
                end

                local l_targetInfo
                for i = 1, #l_teamInfo.memberList do
                    -- 不在等待区且不在战场内
                    local stageEnum = StageMgr:GetCurStageEnum()
                    if not l_mgr.CanInBattlePre(l_teamInfo.memberList[i].sceneId) and stageEnum ~= MStageEnum.Battle then
                        if l_targetInfo == nil then
                            l_targetInfo = l_teamInfo.memberList[i]
                        else
                            return
                        end
                    end
                end

                if l_targetInfo then
                    CommonUI.Dialog.ShowOKDlg(true, nil, Lang("BattleHintExitWait", l_targetInfo.roleName)) --%s离开了等候区，退出匹配
                end
            end
        end
    end)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_QUIT_TEAM_MEMBER, function(self, roleInfo)
        if roleInfo ~= nil then
            CommonUI.Dialog.ShowOKDlg(true, nil, Lang("BattleHintExitTeam", roleInfo.roleName)) --%s离开了队伍，退出匹配
        end
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_MONSTER_HP_UPDATE, function(self, roleId, hpValue, entityId)
        self:OnUpdateHP(roleId, hpValue, entityId)
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_UPDATE_NUMBER, function()
        self:UpdateNumber()
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_PI_PEI_SUCCESS, function()
        self:OnStartBattle()
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_PI_PEI_START, function()
        self:OnTeamInfoUpdate()
        self:StartPiPei()
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_PI_PEI_STOP, function()
        self:OnTeamInfoUpdate()
        self:StopPipei()
    end)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_FIGHT_GROUP_CHANGE, self.InitEntityInfoPanel)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_INIT_TIME_INFO, self.IninBattle)
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_BATTLEFIELD_TEAM_REQUIRENUM_UPDATE, function()
        self:OnTeamInfoUpdate()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

local l_mgr = MgrMgr:GetMgr("BattleMgr")
local l_timer
local l_slider = {}
local l_uiTimer
local L_PIPEI_TIME = 30
local l_initTimer
local l_effect1 = "Effects/Prefabs/Creature/Ui/Fx_Ui_ZhanChangZhengYingAttack_01"
local l_effect2 = "Effects/Prefabs/Creature/Ui/Fx_Ui_ZhanChangZhengYingAttack_02"
local l_effect3 = "Effects/Prefabs/Creature/Ui/Fx_Ui_ZhanChangZhengYingAttack_03"
local l_fx = {}

function BattleCtrl:_onKdaUpdate()
    local battleMgr = MgrMgr:GetMgr("BattleMgr")
    local leftKillData = battleMgr.GetTotalKills(GameEnum.EBattleFieldCamp.CampLeft)
    local rightKillData = battleMgr.GetTotalKills(GameEnum.EBattleFieldCamp.CampRight)
    self.panel.TxtLeftKillNum.LabText = tostring(leftKillData)
    self.panel.TxtRightKillNum.LabText = tostring(rightKillData)
    self:_tryShowFire(self._selfKillNum, leftKillData, GameEnum.EBattleFieldCamp.CampLeft)
    self:_tryShowFire(self._enemyKillNum, rightKillData, GameEnum.EBattleFieldCamp.CampRight)
    self._selfKillNum = leftKillData
    self._enemyKillNum = rightKillData
end

function BattleCtrl:_tryShowFire(preNum, curNum, type)
    if nil == preNum or nil == curNum or nil == type then
        logError("[BattleCtrl] invalid param")
        return
    end

    if 0 == preNum then
        return
    end

    if 0 == preNum % self.C_NUM_KILL_COUNT or 0 ~= curNum % self.C_NUM_KILL_COUNT then
        return
    end

    if GameEnum.EBattleFieldCamp.CampLeft == type then
        self.panel.RawImageLeft:PlayDynamicEffect()
        self.panel.Fx_BlueFire_Fly:SetActiveEx(false)
        self.panel.Fx_BlueFire_Fly:SetActiveEx(true)
    elseif GameEnum.EBattleFieldCamp.CampRight == type then
        self.panel.RawImageRight:PlayDynamicEffect()
        self.panel.Fx_RedFire_Fly:SetActiveEx(false)
        self.panel.Fx_RedFire_Fly:SetActiveEx(true)
    end
end

function BattleCtrl:OnInitPanel()
    --- 提示按钮一直显示，无论是否已经开战了
    self.panel.ObjHint:SetActiveEx(true)
    self.panel.HintBtn:AddClickWithLuaSelf(self._onHintClick, self)
    self.panel.MatchObj:SetActiveEx(false)
    self.panel.WaitPanel:SetActiveEx(false)
    self.panel.BattlePanel:SetActiveEx(false)
    self.panel.Alarm:SetActiveEx(false)
    self.panel.Txt_Time:GetText().resizeTextForBestFit = true
    self.panel.Time:GetText().resizeTextForBestFit = true
    if StageMgr:GetCurStageEnum() == MStageEnum.BattlePre then
        self:IninBattlePre()
    end

    if StageMgr:GetCurStageEnum() == MStageEnum.Battle then
        self:IninBattle()
    end
end

function BattleCtrl:OnUnInitPanel()
    self:StopTimer()
    self:StopPipei()

    if l_uiTimer then
        self:StopUITimer(l_uiTimer)
        l_uiTimer = nil
    end
    if l_initTimer then
        self:StopUITimer(l_initTimer)
        l_initTimer = nil
    end

    MEntityMgr.onEntityCreate = nil

    if self.PiPeiEffectID then
        self:DestroyUIEffect(self.PiPeiEffectID)
        self.PiPeiEffectID = nil
    end
end

function BattleCtrl:ShowLeftTimer(sec, isBattle, lab, callback, des)
    self.startTiks = Common.TimeMgr.GetNowTimestamp()
    self.panel.WaitPanel.gameObject:SetActiveEx(not isBattle)
    self.panel.BattlePanel.gameObject:SetActiveEx(isBattle)
    local l_seconds = sec % 60
    local l_mins = math.floor(sec / 60)
    if des then
        lab.LabText = StringEx.Format(des, l_seconds)
    else
        lab.LabText = StringEx.Format("{0:00}:{1:00}", l_mins, l_seconds)
    end
    self:StopTimer()
    l_timer = self:NewUITimer(function()


        l_duration = sec - math.modf(Common.TimeMgr.GetNowTimestamp() - self.startTiks + 0.5)
        if StageMgr:GetCurStageEnum() == MStageEnum.Battle then
            self:UpdateNumber()
            if l_duration <= 3 and l_duration > 2 then
                --UIMgr:ActiveUI(UI.CtrlNames.BattleCountDown)
            end
        end
        local l_seconds = l_duration % 60
        local l_mins = math.floor(l_duration / 60)

        local l_timeText
        if des then
            l_timeText = StringEx.Format(des, l_seconds)
        else
            l_timeText = StringEx.Format("{0:00}:{1:00}", l_mins, l_seconds)
        end

        lab.LabText = l_timeText
        if l_duration < 1 then
            self:StopTimer()
            if callback then
                callback()
            end

            --战斗开始
            if StageMgr:GetCurStageEnum() == MStageEnum.BattlePre then
                if l_mgr.InQueue then
                    self:StopPipei()
                    self:StartPiPei()
                end
            end
        end
    end, 1, -1, true)
    l_timer:Start()
end

function BattleCtrl:StopTimer()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
end

---========================================战场准备===========================================

function BattleCtrl:IninBattlePre()
    self:StopPipei()
    self.panel.WaitPanel:SetActiveEx(true)
    self.panel.BattlePanel:SetActiveEx(false)
    MgrMgr:GetMgr("DailyTaskMgr").UpdateDailyTaskInfo()
    self.panel.Txt_Time.LabText = "--:--"
    self.panel.Txt_Time.gameObject:SetActiveEx(true)
    self.panel.desText.gameObject:SetActiveEx(true)
    self.panel.RuningTips.gameObject:SetActiveEx(false)
    self:OnTeamInfoUpdate()
    self.panel.MatchBtn:AddClick(function()
        local l_teamState, l_hit = self:GetTeamState()
        if l_teamState == 0 then
            MgrMgr:GetMgr("BattleMgr").BeginMatchForBattle()
        end
    end)

    if l_mgr.InQueue then
        self:StartPiPei()
    end

    --匹配按钮的特效
    if self.PiPeiEffectID then
        self:DestroyUIEffect(self.PiPeiEffectID)
        self.PiPeiEffectID = nil
    end

    self.panel.MatchEffect:SetActiveEx(false)
    self.panel.MatchEffect.RawImg.enabled = false
    local l_fxData = {}
    l_fxData.rawImage = self.panel.MatchEffect.RawImg
    l_fxData.loadedCallback = function(a)
        self.panel.MatchEffect.RawImg.enabled = true
        self:OnTeamInfoUpdate()
    end

    self.PiPeiEffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_RenWuDaoHang_03", l_fxData)

    --- 如果是第一次进入场景，播放战场界面介绍动画
    if self:_isFirstTimeEnter() then
        UIMgr:ActiveUI(UI.CtrlNames.CommonVideo, { type = GameEnum.EPvPLuaType.BattleField })
    end
end

--- 默认进入界面不播放
function BattleCtrl:_isFirstTimeEnter()
    --local battleMgr = MgrMgr:GetMgr("BattleMgr")
    --if battleMgr.IsAccountNeedGuide() then
    --    battleMgr.SaveBattleFieldAccountData()
    --    return true
    --end

    return false
end

function BattleCtrl:OnDailyTaskInfoUpdate()
    if StageMgr:GetCurStageEnum() == MStageEnum.BattlePre then
        local l_time = MgrMgr:GetMgr("DailyTaskMgr").GetBattleTime()
        local sec = MLuaClientHelper.GetTiks2NowSeconds(l_time)
        if sec <= 0 then
            self.panel.Txt_Time.gameObject:SetActiveEx(false)
            self.panel.desText.gameObject:SetActiveEx(false)
            self.panel.RuningTips.gameObject:SetActiveEx(true)
        else
            self:ShowLeftTimer(sec + 1, false, self.panel.Txt_Time, function()
                self.panel.Txt_Time.gameObject:SetActiveEx(false)
                self.panel.desText.gameObject:SetActiveEx(false)
                self.panel.RuningTips.gameObject:SetActiveEx(true)
            end, nil)
        end
    end
end

function BattleCtrl:OnTeamInfoUpdate()
    if StageMgr:GetCurStageEnum() == MStageEnum.Battle then
        return
    end

    local l_teamInfo = DataMgr:GetData("TeamData").myTeamInfo
    local l_teamState, l_hit = self:GetTeamState()
    if l_teamState ~= 0 then
        if l_mgr.SetState(false) then
            self:OnTeamInfoUpdate()
            return
        end
    end

    if l_hit ~= nil and not l_mgr.InQueue then
        self.panel.Alarm:SetActiveEx(true)
        self.panel.Tips.LabText = l_hit
        MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)
        self:ForceUpdate(self.panel.Alarm)
    end

    --不是队长不显示按钮
    local l_isCaptain = l_teamInfo.captainId == MPlayerInfo.UID

    --匹配按钮显示
    self.panel.MatchObj:SetActiveEx(l_isCaptain and l_teamState < 10)
    self.panel.MatchBtn:SetGray(l_teamState > 0 or l_mgr.InQueue)
    self.panel.MatchBtnIcon:SetGray(l_teamState > 0 or l_mgr.InQueue)
    self.panel.MatchEffect:SetActiveEx(not (l_teamState > 0 or l_mgr.InQueue))
end

function BattleCtrl:GetTeamState()
    local l_teamInfo = DataMgr:GetData("TeamData").myTeamInfo
    local l_reqNum = l_mgr.GetTeamRequireNum()
    local l_neddNum = l_reqNum
    if not l_teamInfo.isInTeam then
        return 10, Lang("CREATE_OR_JOIN_TEAM") --请创建或加入一个队伍
    end

    local l_num = table.ro_size(l_teamInfo.memberList)
    l_neddNum = l_reqNum - l_num
    if l_reqNum > l_num then
        return 2, StringEx.Format(Lang("BATTLE_NEED_NUM"), l_neddNum) --队伍还需%s人才能参加匹配
    end

    for i = 1, #l_teamInfo.memberList do
        if not l_mgr.CanInBattlePre(l_teamInfo.memberList[i].sceneId) then
            return 1, Lang("BattleHintWaitingArea") --队伍人员都在等候区才能参与匹配
        end
    end

    return 0, Lang("BattleHintCaptainClick") --已满足匹配队伍人数要求
end

--开始匹配
function BattleCtrl:StartPiPei()
    if self.PipeiTime ~= nil then
        return
    end

    if l_mgr.InBattleTime() then
        self.panel.Tips.LabText = StringEx.Format(Lang("BATTLE_START_PIPEI"), L_PIPEI_TIME)--玩命匹配中...预计时间%s秒
    else
        self.panel.Tips.LabText = Lang("BATTLE_WAIT_START")-- "倒计时结束后开始匹配"
    end

    self.panel.Alarm:SetActiveEx(true)
    MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)
    self:ForceUpdate(self.panel.Alarm)
    local l_duration = L_PIPEI_TIME
    self.PipeiTime = self:NewUITimer(function()
        l_duration = l_duration - 1
        if l_mgr.InBattleTime() then
            self.panel.Tips.LabText = StringEx.Format(Lang("BATTLE_START_PIPEI"), l_duration)--玩命匹配中...预计时间%s秒
            if l_duration < 1 then
                self.panel.Tips.LabText = Lang("BATTLE_START_PIPEIING")--玩命匹配中...
                MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)
                self:ForceUpdate(self.panel.Alarm)
            end
        end
        if l_duration < 1 then
            self:StopPipei()
        end
    end, 1, -1, true)
    self.PipeiTime:Start()
end

--停止匹配
function BattleCtrl:StopPipei()
    if self.PipeiTime then
        self:StopUITimer(self.PipeiTime)
        self.PipeiTime = nil
    end
end

function BattleCtrl:OnStartBattle()
    self:StopPipei()
    UIMgr:HideNormalContainer()
    self.panel.MatchObj:SetActiveEx(false)
    local l_duration = MGlobalConfig:GetInt("ArenaCountDownAfterMatching")
    MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)
    l_uiTimer = self:NewUITimer(function()
        self.panel.Alarm:SetActiveEx(true)
        self.panel.Tips.LabText = StringEx.Format(Common.Utils.Lang("BATTLE_START_PIPEI_SUCCESS"), l_duration)
        self:ForceUpdate(self.panel.Alarm)
        l_duration = l_duration - 1
        if l_duration < 1 then
            if l_uiTimer then
                self:StopUITimer(l_uiTimer)
                l_uiTimer = nil
            end
        end
    end, 1, -1, true)
    l_uiTimer:Start()
end

function BattleCtrl:ForceUpdate(item)
    item.Fitter.enabled = true
    LayoutRebuilder.ForceRebuildLayoutImmediate(item.transform);
end
---========================================进入战场===========================================

function BattleCtrl:IninBattle()
    self:_onKdaUpdate()
    self.panel.WaitPanel:SetActiveEx(false)
    self.panel.BattlePanel:SetActiveEx(true)
    self.panel.MatchObj:SetActiveEx(false)
    l_slider = {}
    self.panel.DoorHP1.Slider.value = 1
    self.panel.CrystalHP1.Slider.value = 1
    self.panel.DoorHP2.Slider.value = 1
    self.panel.CrystalHP2.Slider.value = 1
    self.panel.ChargeBar1.Slider.value = 0
    self.panel.ChargeBar2.Slider.value = 0

    l_mgr.InitTimeInfo()

    if l_mgr.m_type == 2 or l_mgr.m_type == 1 then
        ----改成延时获取
        self:InitDelay(5)
        self:ShowLeftTimer(l_mgr.m_battleTime - l_mgr.m_passTime, true, self.panel.Time, nil, nil)
        return
    end
    local l_sec = 58
    local nowTime = Common.TimeMgr.GetNowTimestamp()
    local doorDispearTime = l_mgr.GetAirDoorDispearTime()
    if l_mgr.m_type == 3 then
        l_mgr.InitEntityInfo()
        self:OnlyInitFightTeam()
        if nowTime >= doorDispearTime then
            ---断线重连
            self:InitDelay(0)
            self.panel.Alarm.gameObject:SetActiveEx(false)
            self:ShowLeftTimer(l_mgr.m_battleTime - l_mgr.m_passTime + l_sec, true, self.panel.Time, nil, nil)
        else
            self:InitDelay(5)
            MLuaClientHelper.PlayFxHelper(self.panel.Alarm.gameObject)
            self.panel.Time.LabText = "--:--"
            local l_maxNum = tonumber(l_mgr.GetAirDoorDispearTime() - Common.TimeMgr.GetNowTimestamp())
            local l_remainTime = math.max(0, l_maxNum)
            self.panel.Alarm.gameObject:SetActiveEx(true)
            self.panel.Tips.LabText = StringEx.Format(Common.Utils.Lang("BATTLE_WARNING_COUNTDOWN"), l_remainTime)
            self:ForceUpdate(self.panel.Alarm)
            --self.panel.Alarm.Fitter.enabled = false
            self:ShowLeftTimer(l_remainTime, true, self.panel.Tips, function()
                l_mgr.InitTimeInfo()
                self.panel.Alarm.gameObject:SetActiveEx(false)
                self:ShowLeftTimer(l_mgr.m_battleTime, true, self.panel.Time, nil, nil)
            end, Common.Utils.Lang("BATTLE_WARNING_COUNTDOWN"))
        end
        return
    end

    self:InitDelay(5)
end

function BattleCtrl:InitDelay(sec)
    if l_initTimer then
        self:StopUITimer(l_initTimer)
        l_initTimer = nil
    end
    local l_tiks = Time.realtimeSinceStartup
    if sec < 1 then
        l_mgr.InitEntityInfo()
        self:InitEntityInfoPanel()
        if not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
            UIMgr:ActiveUI(UI.CtrlNames.BattleTeam)
        end
    else
        l_initTimer = self:NewUITimer(function()
            if Time.realtimeSinceStartup - l_tiks >= sec then
                if l_initTimer then
                    self:StopUITimer(l_initTimer)
                    l_initTimer = nil
                end
                l_mgr.InitEntityInfo()
                self:InitEntityInfoPanel()
                if not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
                    UIMgr:ActiveUI(UI.CtrlNames.BattleTeam)
                end
            end
        end, 1, -1, true)
        l_initTimer:Start()
    end
end

function BattleCtrl:OnlyInitFightTeam()

    local l_image1, l_image2, l_rot
    if l_mgr.l_playerFightGroup == l_mgr.g_fight1 then
        l_image1, l_image2 = "UI_main_Arena_Huiji01.png", "UI_main_Arena_Huiji02.png"
        l_rot = 0
    else
        l_image2, l_image1 = "UI_main_Arena_Huiji01.png", "UI_main_Arena_Huiji02.png"
        l_rot = 180
    end

    self.panel.Image1:SetSpriteAsync("main", l_image1)
    self.panel.Image2:SetSpriteAsync("main", l_image2)
    MLuaCommonHelper.SetRotEulerY(self.panel.Image1.gameObject, l_rot)
    MLuaCommonHelper.SetRotEulerY(self.panel.Image2.gameObject, l_rot)

end

function BattleCtrl:InitEntityInfoPanel()
    if l_mgr.l_myDoorId == nil then
        UIMgr:DeActiveUI(UI.CtrlNames.Battle)
        return
    end
    l_slider[l_mgr.l_myDoorId] = {}
    l_slider[l_mgr.l_myDoorId].Slider = self.panel.DoorHP1.Slider
    self.panel.CrystalHP1.Slider.enabled = true
    l_slider[l_mgr.l_myDoorId].id, l_slider[l_mgr.l_myDoorId].Slider.value = self:GetIdAndHp(l_mgr.l_myDoorId)

    l_slider[l_mgr.l_myStoneId] = {}
    l_slider[l_mgr.l_myStoneId].Slider = self.panel.CrystalHP1.Slider
    self.panel.DoorHP1.Slider.enabled = true
    l_slider[l_mgr.l_myStoneId].id, l_slider[l_mgr.l_myStoneId].Slider.value = self:GetIdAndHp(l_mgr.l_myStoneId)

    l_slider[l_mgr.l_targetDoorId] = {}
    l_slider[l_mgr.l_targetDoorId].Slider = self.panel.DoorHP2.Slider
    self.panel.CrystalHP2.Slider.enabled = true
    l_slider[l_mgr.l_targetDoorId].id, l_slider[l_mgr.l_targetDoorId].Slider.value = self:GetIdAndHp(l_mgr.l_targetDoorId)

    l_slider[l_mgr.l_targetStoneId] = {}
    l_slider[l_mgr.l_targetStoneId].Slider = self.panel.CrystalHP2.Slider
    self.panel.DoorHP2.Slider.enabled = true
    l_slider[l_mgr.l_targetStoneId].id, l_slider[l_mgr.l_targetStoneId].Slider.value = self:GetIdAndHp(l_mgr.l_targetStoneId)

    self.mNumber = 0
    self.sNumber = 0
    self.mSlider = 0
    self.sSlider = 0
    self.panel.Num1.LabText = 0
    self.panel.Num2.LabText = 0

    l_slider[l_mgr.l_myFire] = {}
    l_slider[l_mgr.l_myFire].Slider = self.panel.ChargeBar1.Slider
    self.panel.ChargeBar1.Slider.enabled = true
    self.panel.ChargeBar1.Slider.value = 0
    l_slider[l_mgr.l_myFire].id = self:GetIdAndHp(l_mgr.l_myFire)

    l_slider[l_mgr.l_targetFire] = {}
    l_slider[l_mgr.l_targetFire].Slider = self.panel.ChargeBar2.Slider
    self.panel.ChargeBar2.Slider.enabled = true
    self.panel.ChargeBar2.Slider.value = 0
    l_slider[l_mgr.l_targetFire].id = self:GetIdAndHp(l_mgr.l_targetFire)
    local l_image1, l_image2, l_rot
    if l_mgr.l_playerFightGroup == l_mgr.g_fight1 then
        l_image1, l_image2 = "UI_main_Arena_Huiji01.png", "UI_main_Arena_Huiji02.png"
        l_rot = 0
    else
        l_image2, l_image1 = "UI_main_Arena_Huiji01.png", "UI_main_Arena_Huiji02.png"
        l_rot = 180
    end

    self.panel.Image1:SetSpriteAsync("main", l_image1)
    self.panel.Image2:SetSpriteAsync("main", l_image2)
    MLuaCommonHelper.SetRotEulerY(self.panel.Image1.gameObject, l_rot)
    MLuaCommonHelper.SetRotEulerY(self.panel.Image2.gameObject, l_rot)

    for i = 1, 4 do
        local l_obj1 = self.panel[string_format("Blue{0}", i)].gameObject
        l_obj1:SetActiveEx(false)

        local l_obj2 = self.panel[string_format("Red{0}", i)].gameObject
        l_obj2:SetActiveEx(false)
    end

    self.last_left_num = 0
    self.last_right_num = 0

    self:UpdateNumber()

end

function BattleCtrl:OnUpdateHP(roleId, hpValue, entityId)
    if l_slider[entityId] then
        l_slider[entityId].Slider.value = hpValue
    end
end

function BattleCtrl:UpdateNumber()
    if l_mgr.l_playerFightGroup then
        local l_left_num, l_right_num
        if l_mgr.l_playerFightGroup == l_mgr.g_fight1 then
            l_left_num = l_mgr.m_groupNum[l_mgr.g_fight1] or 0
            l_right_num = l_mgr.m_groupNum[l_mgr.g_fight2] or 0
        else
            l_left_num = l_mgr.m_groupNum[l_mgr.g_fight2] or 0
            l_right_num = l_mgr.m_groupNum[l_mgr.g_fight1] or 0
        end
        local string_format = StringEx.Format
        for i = 1, 4 do
            local l_visible1 = (i <= l_left_num)
            if i <= self.last_left_num then
                if not l_visible1 then
                    self.panel[string_format("Blue{0}", i)].gameObject:SetActiveEx(false)
                end
            else
                if l_visible1 then
                    local l_obj1 = self.panel[string_format("Blue{0}", i)].gameObject
                    l_obj1:SetActiveEx(true)
                    MLuaClientHelper.PlayFxHelper(l_obj1)
                end
            end
            local l_visible2 = (i <= l_right_num)
            if i <= self.last_right_num then
                if not l_visible2 then
                    self.panel[string_format("Red{0}", i)].gameObject:SetActiveEx(false)
                end
            else
                if l_visible2 then
                    local l_obj2 = self.panel[string_format("Red{0}", i)].gameObject
                    l_obj2:SetActiveEx(true)
                    MLuaClientHelper.PlayFxHelper(l_obj2)
                end
            end
        end
        self.last_left_num = l_left_num
        self.last_right_num = l_right_num
    end
end

function BattleCtrl:GetIdAndHp(targetId)
    local l_e = nil
    local l_id = MEntityMgr:GetUUIDByEntityId(targetId)
    local l_hp = 0--已经死亡;
    if tostring(l_id) ~= "0" then
        l_e = MEntityMgr:GetEntity(l_id)
        if l_e then
            l_hp = l_e.AttrComp.HPPercent
        end
    else
        if MEntityMgr.onEntityCreate == nil then
            MEntityMgr.onEntityCreate = function(entity, entityId, uid)
                if l_slider[entityId] then
                    l_slider[entityId].id = uid
                    return
                end
                self:UpdateNumber()
            end
        end
    end
    return l_id, l_hp
end

function BattleCtrl:UpdateSkill()
    local l_v = 0
    if l_mgr.l_targetFire and l_slider[l_mgr.l_targetFire] then
        l_v = MLuaClientHelper.GetSkillAttrPowerPercent(l_slider[l_mgr.l_targetFire].id, l_mgr.l_targetSkill)
        local state1 = (l_slider[l_mgr.l_targetFire].Slider.value - l_v) > 0.8
        if state1 then
            self:PlayFx(false)
        end
        l_slider[l_mgr.l_targetFire].Slider.value = l_v
    end
    l_v = 0
    if l_mgr.l_myFire and l_slider[l_mgr.l_myFire] then
        l_v = MLuaClientHelper.GetSkillAttrPowerPercent(l_slider[l_mgr.l_myFire].id, l_mgr.l_mySkill)
        local state2 = (l_slider[l_mgr.l_myFire].Slider.value - l_v) > 0.8
        if state2 then
            self:PlayFx(true)
        end
        l_slider[l_mgr.l_myFire].Slider.value = l_v
    end
end

local l_dis = 1.2

function BattleCtrl:PlayFx(win)
    if self.panel == nil then
        return
    end
    self:ClearFx()
    self.battleEffect = Time.realtimeSinceStartup
    self.win = win
    self.l_target1 = self.win and self.panel.Effect1.RawImg or self.panel.Effect3.RawImg
    self.l_target2 = self.panel.Effect2.RawImg
    self.l_target3 = self.win and self.panel.Effect3.RawImg or self.panel.Effect1.RawImg
    self.fromPos = self.win and Vector3.New(0 - l_dis, 0, 0) or Vector3.New(l_dis, 0, 0)
    self.toPos = self.win and Vector3.New(l_dis, 0, 0) or Vector3.New(0 - l_dis, 0, 0)
    self.showEffect = true
end

function BattleCtrl:UpdateFx()
    if self.showEffect then
        local l_interval = Time.realtimeSinceStartup - self.battleEffect
        if l_fx[1] == nil then
            local l_fxData1 = {}
            l_fxData1.rawImage = self.l_target1
            l_fxData1.playTime = 1
            l_fx[#l_fx + 1] = self:CreateUIEffect(l_effect1, l_fxData1)
        end
        if l_interval > 1 and l_fx[2] == nil then
            local l_fxData2 = {}
            l_fxData2.rawImage = self.l_target2
            l_fxData2.playTime = 0.9
            l_fxData2.position = self.fromPos
            l_fxData2.loadedCallback = function(go)
                self.tweenId = MUITweenHelper.TweenPos(go, self.fromPos, self.toPos, 0.9)
            end
            l_fx[#l_fx + 1] = self:CreateUIEffect(l_effect2, l_fxData2)
        end
        if l_interval > 1.5 and l_fx[3] == nil then
            local l_fxData3 = {}
            l_fxData3.rawImage = self.l_target3
            l_fx[#l_fx + 1] = self:CreateUIEffect(l_effect3, l_fxData3)
        end
        if l_interval > 2.5 and l_fx[2] ~= nil then
            self:ClearFx()
        end
    end
end

function BattleCtrl:ClearFx()
    self.showEffect = false

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end

    if #l_fx < 1 then
        l_fx = {}
        return
    end

    for i = 1, #l_fx do
        if l_fx[i] ~= nil then
            self:DestroyUIEffect(l_fx[i])
            l_fx[i] = nil
        end
    end
    l_fx = {}
end

function BattleCtrl:_onHintClick()
    UIMgr:ActiveUI(UI.CtrlNames.GameHelp, { type = MStageEnum.Battle })
end

--lua custom scripts end

return BattleCtrl