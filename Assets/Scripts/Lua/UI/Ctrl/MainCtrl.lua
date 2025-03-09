--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainPanel"
require "Data/Model/PlayerInfoModel"
require "Event/EventConst"
require "Data/Model/BagModel"
require "UI/Template/MainButtonTemplate"
--lua requires end
------------------------eventsystem
local l_pointEventData
local l_eventSystem
local l_pointRes

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MainCtrl = class("MainCtrl", super)
--lua class define end

eFunctionButtonName = {
    BtnFunctionOpen = "BtnFunctionOpen",
    AutoBattleButton = "AutoBattleButton",
    BtnSwitchUI = "BtnSwitchUI",
    BtnExit = "BtnExit",
    BtnInfo = "BtnInfo",
    BagButton = "BagButton",
    BtnShowAction2 = "BtnShowAction2",
    BtnTowerRewardInfo = "BtnTowerRewardInfo"
}

local EBagChildFunc = nil

local l_authMgr = nil
local l_mainUIMgr = nil
local l_openSystemMgr = nil
local l_landingAwardMgr = nil
local l_teamMgr = nil
local l_dailyTaskMgr = nil
local l_roleInfoMgr = nil

-- 功能预览按钮特效是否显示
local l_isPreviewEffectShow = false

--lua functions
function MainCtrl:ctor()
    super.ctor(self, CtrlNames.Main, UILayer.Normal, nil, ActiveType.Normal)
    self.cacheGrade = EUICacheLv.VeryLow
    self.targetUID = 0
    self.C_SHOW_INFO_BTN_STATE_LIST = {
        [MStageEnum.RingPre] = 1,
        [MStageEnum.Ring] = 1,
        [MStageEnum.MatchPre] = 1,
        [MStageEnum.Match] = 1,
    }
end --func end
--next--
function MainCtrl:Init()
    self.panel = UI.MainPanel.Bind(self)
    super.Init(self)

    l_authMgr = game:GetAuthMgr()
    l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")
    l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    l_landingAwardMgr = MgrMgr:GetMgr("LandingAwardMgr")
    l_teamMgr = MgrMgr:GetMgr("TeamMgr")
    l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")

    self.guideSystemId = 0 --当前触发新手指引的系统的ID

    self.l_FunctionButtons = {}
    self.Buttons = {}
    self.l_ExtraUis = {}
    self.systemPreviewEffectId = MGlobalConfig:GetInt("NoticeRewardEffect")

    self:initFunctionButton()

    --用于正在跟随中动画
    self.startAutoFollowPlayAni = false
    --用于正在采摘中动画
    self.startAutoCollectAni = false
    self.remainTime = 1
    self.maxPoint = 0


    --用于动画
    self.startPlayAni = false
    self.remainAutoPairTime = 1
    self.maxAutoPairPoint = 0

    self.l_functionOpenEffectId = 0

    l_eventSystem = EventSystem.current
    l_pointEventData = PointerEventData.New(l_eventSystem)
    l_pointRes = RaycastResultList.New()

    self.panel.MainButtonUpPrefab.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.MainButtonRightPrefab.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.TxtFollow.gameObject:SetActiveEx(false)

    EBagChildFunc = {
        [l_openSystemMgr.eSystemId.Bag] = l_openSystemMgr.eSystemId.Bag,
        [l_openSystemMgr.eSystemId.AutomaticDrinkMedicine] = l_openSystemMgr.eSystemId.Bag,
        [l_openSystemMgr.eSystemId.Beiluz] = l_openSystemMgr.eSystemId.Bag,      -- 背包下的子功能
    }

    self.panel.BtnFunctionOpen:AddClick(function()
        if #l_openSystemMgr.OpenSystemPreviewTable <= 0 then
            return
        end

        l_isPreviewEffectShow = false
        self:FunctionOpenPrompt(false)
        UIMgr:ActiveUI(UI.CtrlNames.FunctionPreview)
    end)

    self.panel.BtnExit:AddClick(function()
        MgrMgr:GetMgr("DungeonMgr").SendLeaveSceneReq()
    end)
    self.panel.BtnTowerRewardInfo:AddClick(function()
        MgrMgr:GetMgr("InfiniteTowerDungeonMgr").ShowInfiniteTowerReward()
    end)

    self.panel.Btn_Removestuck:AddClick(function()
        self.panel.Btn_Removestuck.gameObject:SetActiveEx(false)
        MgrMgr:GetMgr("SettingMgr").FreeStuck(true, function(...)
            MEntityMgr.PlayerEntity.StuckCount = 0
        end)
    end)

    self.panel.Btn_Removestuck.gameObject:SetActiveEx(false)
    local fxAnim = self.panel.BtnInfo.gameObject.transform.parent.gameObject:GetComponent("FxAnimationHelper")
    if fxAnim then
        fxAnim:PlayAll()
    end

    self.panel.BtnInfo:AddClickWithLuaSelf(self._onInfoClick, self)
    local l_canvas = self.panel.Tween.gameObject:GetComponent("Canvas")
    if l_canvas then
        l_canvas.overrideSorting = true
        l_canvas.sortingOrder = self.canvas.sortingOrder + 1
    end

    --自动战斗
    self.panel.BtnAutoBattle.Listener.onShortPress = function()

        --新手指引确认
        self:SystemBtnClickGuideCheck(l_openSystemMgr.eSystemId.AutoBattle)

        local l_functionId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.AutoBattle
        if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_functionId) then
            local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(l_functionId)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("Main_NotOpenAutoBattleText"), l_tableData.BaseLevel))
            return
        end

        if DataMgr:GetData("TeamData").Isfollowing then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_FIGHT_IN_FOLLOW"))
            return
        end

        if not MPlayerInfo.IsAutoBattle then
            UIMgr:ActiveUI(UI.CtrlNames.FightAuto)
        else
            MPlayerInfo.IsAutoBattle = false
            self:UpdateAutoFightPanel(false)
        end

    end

    self.panel.BtnAutoBattle.Listener.onLongPress = function()
        if MPlayerInfo.IsAutoBattle then
            UIMgr:ActiveUI(UI.CtrlNames.FightAuto)
        end
    end

    self.panel.BtnSwitchUI:AddClick(function()
        if not l_mainUIMgr.IsSwitchUILock then
            l_mainUIMgr.SwitchUI()
        end
    end)

    self.panel.BtnShowAction2:AddClick(function()

        local l_zuoxia_action = 1
        if not MEntityMgr.PlayerEntity then
            return
        end

        if MEntityMgr.PlayerEntity:IsDoRightSpecialAction(l_zuoxia_action) then
            MEntityMgr.PlayerEntity:StopState()
        else
            if MgrMgr:GetMgr("ItemWeightMgr").IsWeightRed(GameEnum.EBagContainerType.Bag) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BAG_MAX_WEIGHT"))
            end
            MgrMgr:GetMgr("MultipleActionMgr").ProcessSingleAction(l_zuoxia_action)
        end
    end)

    self.init_x = self.panel.RightPanel.RectTransform.anchoredPosition.x
    self.initB_x = self.panel.RightPanelB.RectTransform.anchoredPosition.x
    self.fadeAction = nil

    self.panel.BagButton:AddClick(
            function()
                UIMgr:ActiveUI(UI.CtrlNames.Bag)
                --MgrMgr:GetMgr("MultiTalentEquipMgr").HideBagRedSign()
                --新手指引确认
                self:SystemBtnClickGuideCheck(l_openSystemMgr.eSystemId.Bag)
            end
    )

    self._bagRedSignProcessor = self:NewRedSign({
        Key = eRedSignKey.Bag,
        ClickButton = self.panel.BagButton
    })

    self.panel.Btn_CloseDps:AddClick(function()
        MgrMgr:GetMgr("GmMgr").DpsOpenAndClose()
        self.panel.GM_DPS.gameObject:SetActiveEx(false)
    end)

    self.panel.Btn_ClearDps:AddClick(function()
        MgrMgr:GetMgr("GmMgr").Dpsclear()
        self.panel.GM_DPS.gameObject:SetActiveEx(false)
    end)
end --func end

function MainCtrl:_onInfoClick()
    for k, v in pairs(self.C_SHOW_INFO_BTN_STATE_LIST) do
        if ModuleMgr.StageMgr:IsStage(k) then
            UIMgr:ActiveUI(UI.CtrlNames.GameHelp, { type = k })
            return
        end
    end

    local l_content = Common.Utils.Lang("BATTLE_INFO_TIPS")
    l_content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(l_content)
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.MiddleRight,
        pos = {
            x = 398,
            y = 242,
        },
        width = 400,
    })
end

function MainCtrl:InitRightPanel()
    local lOffseX = self.init_x
    local lOffseBX = self.initB_x
    local lAlpha = 1
    local lRotateZ = -45

    if MgrMgr:GetMgr("MainUIMgr").IsShowSkill then
        lOffseX = self.init_x + 200
        lOffseBX = self.initB_x + 200
        lAlpha = 0
        lRotateZ = 0
    end
    local l_pos = self.panel.RightPanel.RectTransform.anchoredPosition
    l_pos.x = lOffseX
    self.panel.RightPanel.RectTransform.anchoredPosition = l_pos
    self.panel.RightPanel.gameObject:GetComponent("CanvasGroup").alpha = lAlpha
    self.panel.RightPanel.gameObject:GetComponent("CanvasGroup").blocksRaycasts = not MgrMgr:GetMgr("MainUIMgr").IsShowSkill

    local l_posB = self.panel.RightPanelB.RectTransform.anchoredPosition
    l_posB.x = lOffseBX
    self.panel.RightPanelB.RectTransform.anchoredPosition = l_posB
    self.panel.RightPanelB.gameObject:GetComponent("CanvasGroup").alpha = lAlpha
    self.panel.RightPanelB.gameObject:GetComponent("CanvasGroup").blocksRaycasts = not MgrMgr:GetMgr("MainUIMgr").IsShowSkill
    self.panel.BtnSwitchUI.RectTransform.localEulerAngles = Vector3.New(0, 0, lRotateZ)
end

function MainCtrl:FadeAction(isOut, time)
    self:ClearFadeAction()
    self.fadeAction = DOTween.Sequence()

    local lOffseX = self.init_x
    local lOffseBX = self.initB_x
    local lAlpha = 1
    local lRotateZ = -45
    if isOut then
        lOffseX = self.init_x + 200
        lOffseBX = self.initB_x + 200
        lAlpha = 0
        lRotateZ = 0
        self.panel.RedSignParent.gameObject:SetActiveEx(true)
    else
        self.panel.RedSignParent.gameObject:SetActiveEx(false)
    end

    self.panel.RightPanel.gameObject:GetComponent("CanvasGroup").blocksRaycasts = not isOut
    local l_act_move = self.panel.RightPanel.RectTransform:DOAnchorPosX(lOffseX, time)
    local l_act_fade = self.panel.RightPanel.gameObject:GetComponent("CanvasGroup"):DOFade(lAlpha, time)

    self.panel.RightPanelB.gameObject:GetComponent("CanvasGroup").blocksRaycasts = not isOut
    local l_act_moveB = self.panel.RightPanelB.RectTransform:DOAnchorPosX(lOffseBX, time)
    local l_act_fadeB = self.panel.RightPanelB.gameObject:GetComponent("CanvasGroup"):DOFade(lAlpha, time)
    local l_act_roate = self.panel.BtnSwitchUI.gameObject.transform:DOLocalRotateQuaternion(Quaternion.Euler(0, 0, lRotateZ), time)

    self.fadeAction:Join(l_act_move)
    self.fadeAction:Join(l_act_fade)
    self.fadeAction:Join(l_act_moveB)
    self.fadeAction:Join(l_act_fadeB)
    self.fadeAction:Join(l_act_roate)

end

function MainCtrl:ClearFadeAction()
    if self.fadeAction ~= nil then
        self.fadeAction:Kill(true)
        self.fadeAction = nil
    end
end

--next--
function MainCtrl:Uninit()

    if self.lSwitchAni ~= nil then
        self.lSwitchAni:Kill(true)
        self.lSwitchAni = nil
    end
    self:ClearFadeAction()

    self.startAutoFollowPlayAni = false
    self.startAutoCollectAni = false
    self.remainTime = 1
    self.maxPoint = 0

    self.RedSignProcessor = nil

    self._bagRedSignProcessor = nil

    self.Buttons = {}

    --清理触发的新手指引的开启系统ID
    self.guideSystemId = 0

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function MainCtrl:OnActive()
    for id, template in pairs(self.Buttons) do
        if template.SetData then
            template:SetData({ OpenSystemId = id })
        end
    end

    self:FreshWeight()
    local l_MainUiTableData = MgrMgr:GetMgr("SceneEnterMgr").CurrentMainUiTableData
    local l_h1 = l_MainUiTableData.ExtraUi
    self.l_ExtraUis = Common.Functions.VectorToTable(l_h1)
    self:showFunctionWithScene()
    MgrMgr:GetMgr("SkillLearningMgr").DealWithRedSign()
    local l_dungeonType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
    if l_dungeonType == 1 then
        self:showFunctionButton(eFunctionButtonName.BtnExit, true)
    elseif l_dungeonType == 3 then
        self:showFunctionButton(eFunctionButtonName.BtnTowerRewardInfo, true)
    end

    --战场进行中不允许退出
    if StageMgr:GetCurStageEnum() == MStageEnum.Battle then
        self:showFunctionButton(eFunctionButtonName.BtnExit, false)
    end
    self.panel.TxtTaskNaving.gameObject:SetActiveEx(false)

    --显示已经开放的按钮
    --切换场景的时候会刷新一次显示状态，有些场景不显示一部分按钮
    local buttons = l_openSystemMgr.GetOpenedButton({ 1, 2, 3, 4 }, -1)
    for i = 1, #buttons do
        if buttons[i].ShowButton then
            buttons[i]:ShowButton(true)
        end
    end

    --显示功能开启预告
    self:ShowOpenSystemPreview()
    self:FunctionOpenPrompt(l_isPreviewEffectShow)

    self:CheckSpecialState()
    self:UpdateAutoFightPanel(MPlayerInfo.IsAutoBattle)
    self:InitRightPanel()
    self:RefreshPairBtn()
    MgrMgr:GetMgr("ArrowMgr").FreshMainArrow()
    self:SetFollowState(DataMgr:GetData("TeamData").Isfollowing)
    if not DataMgr:GetData("TeamData").Isfollowing then
        self:setAutoCollectState(MgrMgr:GetMgr("LifeProfessionMgr").GetAutoCollectState())
    end
    MgrProxy:GetQuickUseMgr().ShowQuickUse()

    MgrMgr:GetMgr("TimeLimitPayMgr").ShowOpenFunction()

    self:ShowFunctionOpenPanel()

    --红点相关
    if self.RedSignProcessor == nil then
        self.RedSignProcessor = self:NewRedSign({
            Key = eRedSignKey.Switch,
            ClickButton = self.panel.RedSignParent
        })
    end

    --刷新好友新消息
    MgrMgr:GetMgr("FriendMgr").ResetNewMessage()
    --是否显示月卡Tips
    MgrMgr:GetMgr("MonthCardMgr").ShowExpiredTips()

    --如果存在新手指引挂载型箭头 则在重新展示后 刷新特效播放(防止进出副本后出现特效停止问题)
    if self.guideArrow ~= nil then
        self.guideArrow:RefreshEffect()
    end

end --func end
function MainCtrl:OnHide()
    self:FunctionOpenPrompt(false)
    --刷新好友新消息
    MgrMgr:GetMgr("FriendMgr").ResetNewMessage()
end --func end
function MainCtrl:OnShow()
    self:ShowOpenSystemPreview()
    self:FunctionOpenPrompt(l_isPreviewEffectShow)

    --弹出新功能开启的界面
    self:ShowFunctionOpenPanel()
    MgrMgr:GetMgr("ArrowMgr").FreshMainArrow()

    --刷新好友新消息
    MgrMgr:GetMgr("FriendMgr").ResetNewMessage()
    MgrProxy:GetQuickUseMgr().ShowQuickUse()
end
--next--
function MainCtrl:OnDeActive()
    self:FunctionOpenPrompt(false)
    --刷新好友新消息
    MgrMgr:GetMgr("FriendMgr").ResetNewMessage()

end --func end
--next--
function MainCtrl:Update()
    --主界面中下部正在进行动作提示动画（包含正在跟随中、正在采摘中）
    self:updateAutoBehaviourAni()

    ----正在匹配中动画
    --if self.startPlayAni then
    --    self.remainAutoPairTime = self.remainAutoPairTime - UnityEngine.Time.deltaTime
    --    if self.remainAutoPairTime <= 0 then
    --        if self.maxAutoPairPoint < 3 then
    --            self.maxAutoPairPoint = self.maxAutoPairPoint + 1
    --            self.panel.MainDlgText.LabText = self.panel.MainDlgText.LabText .. "."
    --        else
    --            self.panel.MainDlgText.LabText = Common.Utils.Lang("TEAM_AUTO_PAIRING")
    --            self.maxAutoPairPoint = 0
    --        end
    --        self.remainAutoPairTime = 1
    --    end
    --end
end --func end

--next--
function MainCtrl:UpdateInput(touchItem)

end --func end


--next--
function MainCtrl:OnLogout()
    MgrMgr:GetMgr("MainUIMgr").ResetMainUICache()
    self:CloseAllButton()

    if self.panel and self.panel.RedSignParent and self.panel.RedSignParent.gameObject then
        self.panel.RedSignParent.gameObject:SetActiveEx(true)
    end
end --func end

--next--
function MainCtrl:BindEvents()
    --Global
    self:BindEvent(GlobalEventBus, EventConst.Names.UpdateAutoBattleState, function(self, isbattle)
        self:UpdateAutoFightPanel(isbattle)
    end)
    self:BindEvent(GlobalEventBus, EventConst.Names.PlayerDead, function(self)
        self:UpdateAutoFightPanel(false)
    end)
    -- main
    self:BindEvent(l_mainUIMgr.EventDispatcher, l_mainUIMgr.ON_STOP_AUTO_FIGHT, function(self)
        self:UpdateAutoFightPanel(false)
        UIMgr:DeActiveUI(UI.CtrlNames.FightAuto)
    end)
    self:BindEvent(l_mainUIMgr.EventDispatcher, l_mainUIMgr.FadeMainEvent, function(self, isShowSkill, ANI_TIME)
        self:FadeAction(isShowSkill, ANI_TIME)
    end)
    self:BindEvent(l_mainUIMgr.EventDispatcher, l_mainUIMgr.ON_ENTER_STUCK, function(...)
        self.panel.Btn_Removestuck.gameObject:SetActiveEx(true)
    end)
    self:BindEvent(l_mainUIMgr.EventDispatcher, l_mainUIMgr.ON_EXIT_STUCK, function(...)
        self.panel.Btn_Removestuck.gameObject:SetActiveEx(false)
    end)
    -- openSystem
    self:BindEvent(l_openSystemMgr.EventDispatcher, l_openSystemMgr.OpenSystemPreview, function()
        self:ShowOpenSystemPreview()
    end)
    self:BindEvent(l_openSystemMgr.EventDispatcher, l_openSystemMgr.CloseSystemEvent, function(self, systemId)
        self:ShowExistButtons(false, { systemId })
    end)
    self:BindEvent(l_openSystemMgr.EventDispatcher, l_openSystemMgr.OpenSystemChange, function()
        self:ShowFunctionOpenPanel()
    end)
    self:BindEvent(l_openSystemMgr.EventDispatcher, l_openSystemMgr.ShowOpenFinishEvent, self.ShowFunctionOpenPanel)
    self:BindEvent(l_openSystemMgr.EventDispatcher, l_openSystemMgr.OpenSystemUpdate, function(self, data)
        if data == nil or #data <= 0 then
            return
        end
        for i = 1, #l_openSystemMgr.OpenSystemPreviewTable do
            --开放的功能ID中包含预览功能ID开启特效
            local previewID = l_openSystemMgr.OpenSystemPreviewTable[i]
            for i = 1, #data do
                if previewID == data[i].value then
                    l_isPreviewEffectShow = true
                    self:FunctionOpenPrompt(true)
                    break
                end
            end
        end
    end)

    -- landingAward
    self:BindEvent(l_landingAwardMgr.EventDispatcher, l_landingAwardMgr.ON_LANDING_AWARD_INFO_UPDATE, function()
        self:UpdateLandingAwardState()
    end)

    -- team
    local TeamFollowStateChange = function()
        self:SetFollowState(DataMgr:GetData("TeamData").Isfollowing)
        self:UpdateAutoFightPanel(DataMgr:GetData("TeamData").Isfollowing)
    end
    self:BindEvent(l_teamMgr.EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_FOLLOW_STATE_CHANGE, TeamFollowStateChange)
    local l_lifeProfessionMgr = MgrMgr:GetMgr("LifeProfessionMgr")
    self:BindEvent(l_lifeProfessionMgr.EventDispatcher, l_lifeProfessionMgr.EventType.AutoCollectStateChanged, function()
        self:setAutoCollectState(l_lifeProfessionMgr.GetAutoCollectState())
    end)

    self:BindEvent(l_teamMgr.EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_AUTOPAIR_STATUS, function()
        self:RefreshPairBtn()
    end)
    --监听组队信息变化 队伍解散 关闭自动匹配
    self:BindEvent(l_teamMgr.EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, function()
        self:RefreshPairBtn()
    end)

    -- dailyTask
    self:BindEvent(l_dailyTaskMgr.EventDispatcher, l_dailyTaskMgr.DAILY_ACTIVITY_SHOW_EVENT, function()
        if not UIMgr:IsActiveUI(UI.CtrlNames.DailyTask) then
            UIMgr:ActiveUI(UI.CtrlNames.DailyTask)
        end
    end)
    local arrowMgr = MgrMgr:GetMgr("ArrowMgr")
    self:BindEvent(arrowMgr.EventDispatcher, arrowMgr.UPDATE_MAINARROW, self.OnUpdateMainArrow)

    --新手指引
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").OPEN_SYSTEM_BUTTON_GUIDE_EVENT, function(self, guideStepInfo)
        self:ShowBeginnerGuide(guideStepInfo)
    end)

    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher, l_logoutMgr.OnLogoutEvent, self.OnLogout)
    self:BindEvent(MgrMgr:GetMgr("GmMgr").EventDispatcher, MgrMgr:GetMgr("GmMgr").UPDATE_DPS_EVENT, self.ShowGMDps)
    self:BindEvent(MgrMgr:GetMgr("GmMgr").EventDispatcher, MgrMgr:GetMgr("GmMgr").STOP_DPS_EVENT, self.CloseDps)

    local gameEventMgr = MgrProxy:GetGameEventMgr()
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnW8ChangeConfirm, self.FreshWeight)

    local propMgr = MgrMgr:GetMgr("PropMgr")
    self:BindEvent(propMgr.EventDispatcher, propMgr.LEVEL_CHANGE, function()
        -- 养成按钮刷新数据
        local targetLvls = MGlobalConfig:GetSequenceOrVectorInt("DevelopRecommendLevel")
        for i = 0, targetLvls.Length - 1 do
            if MPlayerInfo.Lv == targetLvls[i] then
                MgrMgr:GetMgr("RoleNurturanceMgr").RefreshData(DataMgr:GetData("RoleNurturanceData").REFRESH_TYPE.LevelUp)
            end
        end
    end)

    self:BindEvent(MgrMgr:GetMgr("ReBackMgr").l_eventDispatcher, MgrMgr:GetMgr("ReBackMgr").SIG_RETURN_WELCOME_STATUS_NTF, self.ShowWelcome)

    self:BindEvent(MgrMgr:GetMgr("RoleTagMgr").EventDispatcher, MgrMgr:GetMgr("RoleTagMgr").RoleTagChangeEvent, self.ShowWelcome)
end --func end
--next--
--lua functions end

--lua custom scripts
function MainCtrl:OnUpdateMainArrow()
    MgrMgr:GetMgr("ArrowMgr").RefreshArrowPanel()
end

function MainCtrl:UpdateAutoFightPanel(isBattle)
    if isBattle then
        --正在自动战斗
        self.panel.Txt_AutoBattle.LabText = Common.Utils.Lang("DLG_BTN_NO")
        --self.panel.Txt_AutoBattle.LabColor = Color.New(1, 1, 1)
        --self.panel.Txt_AutoBattle:SetOutLineColor(Color.New(163 / 255.0, 77 / 255.0, 77 / 255.0))
    else
        if MPlayerInfo.AutoFightType == MoonClient.EAutoFightType.FullAuto then
            -- 全自动
            self.panel.Txt_AutoBattle.LabText = Common.Utils.Lang("FULL_AUTO")
        elseif MPlayerInfo.AutoFightType == MoonClient.EAutoFightType.SemiAuto then
            -- 半自动
            self.panel.Txt_AutoBattle.LabText = Common.Utils.Lang("SEMI_AUTO")
        end
        --self.panel.Txt_AutoBattle.LabColor = Color.New(217 / 255.0, 234 / 255.0, 255 / 255.0)
        --self.panel.Txt_AutoBattle:SetOutLineColor(Color.New(46 / 255.0, 85 / 255.0, 135 / 255.0))
    end
end

function MainCtrl:ShowOpenSystemPreview()
    if not self:IsShowing() then
        return
    end

    local l_showPreviewBtn = 0 < #l_openSystemMgr.OpenSystemPreviewTable
    if l_showPreviewBtn then
        local openTable = TableUtil.GetOpenSystemTable().GetRowById(l_openSystemMgr.OpenSystemPreviewTable[1])
        if openTable and openTable.SystemIcon and not string.ro_isEmpty(openTable.SystemIcon) then
            local l_atlas, l_atlasIcon = Common.CommonUIFunc.GetMainPanelAtlasAndIconByFuncId(l_openSystemMgr.OpenSystemPreviewTable[1])
            self.panel.FunctionOpenImage:SetSpriteAsync(l_atlas, l_atlasIcon)
        end
        local text = ""
        if openTable.NoticeBaseLevel > 0 then
            text = tostring(openTable.BaseLevel)
        end

        text = StringEx.Format(Lang("FunctionPreview_OpenText"), openTable.NoticeDescLv, "\n" .. openTable.Title)
        self.panel.FunctionOpenText.LabText = text
        --self:FunctionOpenPrompt(true)  特效
    end

    self:showFunctionButton(eFunctionButtonName.BtnFunctionOpen, l_showPreviewBtn)
end

function MainCtrl:FunctionOpenPrompt(isShow)
    self.panel.FunctionOpenPrompt.gameObject:SetActiveEx(isShow)
    local l_isFxIdExisted = 0 ~= self.l_functionOpenEffectId
    if isShow and not l_isFxIdExisted then
        local l_fxData = {}
        l_fxData.rawImage = self.panel.FunctionOpenEffectImage.RawImg
        l_fxData.loadedCallback = function(a)
            self.panel.FunctionOpenEffectImage.gameObject:SetActiveEx(true)
        end
        self.l_functionOpenEffectId = self:CreateUIEffect(self.systemPreviewEffectId, l_fxData)

    elseif not isShow and l_isFxIdExisted then
        self:DestroyUIEffect(self.l_functionOpenEffectId)
        self.l_functionOpenEffectId = 0
    end
end

function MainCtrl:RefreshPairBtn()
    --local data = DataMgr:GetData("TeamData").myTeamInfo
    --if data then
    --    --self.panel.MainDlg.gameObject:SetActiveEx(DataMgr:GetData("TeamData").isAutoPair)
    --    --if not DataMgr:GetData("TeamData").isAutoPair then
    --    --    self.panel.MainDlgText.LabText = Common.Utils.Lang("TEAM_AUTO_PAIR")
    --    --    --self.startPlayAni = false
    --    --else
    --    --    self.panel.MainDlgText.LabText = Common.Utils.Lang("TEAM_AUTO_PAIRING")
    --    --    --self.startPlayAni = true
    --    --end
    --end
end

function MainCtrl:ShowFunctionOpenPanel(lastID)
    if not self.panel then
        return
    end

    -- 贝鲁兹开启后触发引导
    if lastID == l_openSystemMgr.eSystemId.Beiluz then
        local l_beginnerGuideChecks = { "WheelGuide1" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end

    self.panel.RightUpButtonA.Grid.enabled = true
    self.panel.RightUpButtonB.Grid.enabled = true
    self.panel.RightPanel.Grid.enabled = true
    self.panel.RightPanelB.Grid.enabled = true

    local sceneID = MScene.SceneID
    local SceneTable = TableUtil.GetSceneTable().GetRowByID(sceneID)
    local isShowFunctionOpenPanel = false
    ---如果当前场景为狩猎场场景，打开狩猎场专属积分面板
    if sceneID == MGlobalConfig:GetInt("HuntingGroundSceneID") then
        UIMgr:ActiveUI(UI.CtrlNames.HuntDayPoint)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.HuntDayPoint)
    end

    if SceneTable.SceneType == 1 or SceneTable.SceneType == 2 then
        -- 大厅和野图
        if #l_openSystemMgr.CacheOpenSystem > 0 then
            local systemId = l_openSystemMgr.CacheOpenSystem[1]
            local openSdata = TableUtil.GetOpenSystemTable().GetRowById(systemId)
            if not openSdata then
                table.remove(l_openSystemMgr.CacheOpenSystem, 1)
                return logError("OpenSystemTable表配置有误：" .. tostring(systemId))
            end
            if openSdata.CanOpenFx == 1 then
                if l_openSystemMgr.IsOpenTypeContain(openSdata, { 1, 2, 4 }) then
                    -- 主界面和二级界面
                    l_openSystemMgr.OpenFunctionOpenPanel()
                    isShowFunctionOpenPanel = true
                end
            else
                if l_openSystemMgr.IsOpenTypeContain(openSdata, { 1 }) then
                    local system = self:GetButton(systemId)
                    system:ShowButton(true)
                end
            end
            if not isShowFunctionOpenPanel then
                table.remove(l_openSystemMgr.CacheOpenSystem, 1)
                l_openSystemMgr.ShowOpenFinish(openSdata.Id)
            end
        end
    end
end

--主界面按钮上显示通知
function MainCtrl:ShowMainButtonNotice(systemId, pushId, args)
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSystemMgr.IsSystemOpen(systemId) then
        return
    end
    local l_mainButtonTemplate = self:GetExistButton(systemId)
    if l_mainButtonTemplate and l_mainButtonTemplate.ShowMainButtonNotice then
        l_mainButtonTemplate:ShowMainButtonNotice(pushId, args)
    end
end

function MainCtrl:OnOpenAction()
    if UIMgr:IsActiveUI(UI.CtrlNames.SelectElement) then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.SelectElement, function(ctrl)
        ctrl:RemoveAllHandler()
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowExpression, Lang("EXPRESSION"))
        ctrl:AddHandler(UI.HandlerNames.SelectElementShowAction, Lang("ACTION"))
    end)
end

function MainCtrl:ShowWelcome()
    MgrMgr:GetMgr("ReBackMgr").CheckLetter()
end

--------------------------检查是否是特殊状态-----------------------------------

function MainCtrl:CheckSpecialState()
    -- 飞行载具 钓鱼中 隐藏自动战斗UI
    local player = MEntityMgr.PlayerEntity
    if self.panel ~= nil and player ~= nil then
        if player.IsFly or player.IsFishing then
            self:showFunctionButton(eFunctionButtonName.AutoBattleButton, false)
        else
            self:showFunctionButton(eFunctionButtonName.AutoBattleButton, true)
        end
    end
end

function MainCtrl:GetButton(openSystemId)
    local openSystemTable = TableUtil.GetOpenSystemTable().GetRowById(openSystemId)
    if not openSystemTable then
        return logError("OpenSystemTable没有这条数据：", openSystemId)
    end
    local tempId = openSystemId
    if EBagChildFunc[openSystemId] then
        tempId = EBagChildFunc[openSystemId]
    end
    if not self.Buttons[tempId] then
        self.Buttons[tempId] = self:_createButton(openSystemTable)
        local l_siblingIndex = self:GetSuitButtonIndex(openSystemTable)
        if l_siblingIndex then
            self.Buttons[tempId]:transform():SetSiblingIndex(l_siblingIndex)
        end
    end
    return self.Buttons[tempId]
end

function MainCtrl:_createButton(openSystemTable)
    local openSystemId = openSystemTable.Id
    local prefab
    local parent
    if openSystemTable.SystemPlace == 1 then
        prefab = self.panel.MainButtonUpPrefab
        parent = self.panel.RightUpButtonA
    elseif openSystemTable.SystemPlace == 2 then
        prefab = self.panel.MainButtonUpPrefab
        parent = self.panel.RightUpButtonB
    elseif openSystemTable.SystemPlace == 3 then
        prefab = self.panel.MainButtonRightPrefab
        parent = self.panel.RightPanel
    else
        prefab = self.panel.MainButtonRightPrefab
        parent = self.panel.RightPanelB
    end
    if l_openSystemMgr.IsSpecialOpenBtn(openSystemId) then
        return self:_createSpecialButton(openSystemTable, parent)
    else
        return self:NewTemplate("MainButtonTemplate", {
            Data = { OpenSystemId = openSystemId },
            TemplatePrefab = prefab.LuaUIGroup.gameObject,
            TemplateParent = parent.transform,
            IsActive = false,
            Method = function(item, systemId)
                self:SystemBtnClickGuideCheck(systemId)
            end
        })
    end
end

function MainCtrl:_createSpecialButton(openSystemTable, parent)
    local openSystemId = openSystemTable.Id
    if openSystemId == l_openSystemMgr.OpenSystemFuncPreviewId then
        local btn = {}
        btn.openSystemId = openSystemId
        btn.SystemPlace = openSystemTable.SystemPlace
        btn.SortIndex = openSystemTable.SortID
        btn.gameObject = function()
            return self.panel.BtnFunctionOpen.UObj
        end
        btn.transform = function()
            return self.panel.BtnFunctionOpen.UObj.transform
        end
        btn.ShowButton = function(_self, isShow)
            if isShow then
                local l_MainUiTableData = MgrMgr:GetMgr("SceneEnterMgr").CurrentMainUiTableData
                local l_h1 = l_MainUiTableData.MainIcon
                local l_MainIcons = Common.Functions.VectorToTable(l_h1)
                isShow = table.ro_contains(l_MainIcons, btn.openSystemId)
            end
            btn.gameObject():SetActiveEx(isShow)
        end
        btn.transform():SetParent(parent.transform, false)
        btn.transform():SetAsLastSibling()
        return btn
    elseif EBagChildFunc[openSystemId] then
        local btn = {}
        btn.openSystemId = l_openSystemMgr.eSystemId.Bag
        local openSdata = TableUtil.GetOpenSystemTable().GetRowById(l_openSystemMgr.eSystemId.Bag)
        btn.SystemPlace = openSdata.SystemPlace
        btn.SortIndex = openSdata.SortID
        btn.gameObject = function()
            return self.panel.BagButton.UObj
        end
        btn.transform = function()
            return self.panel.BagButton.UObj.transform
        end
        btn.ShowButton = function(_self, isShow)
            if isShow then
                for _, uiName in ipairs(self.l_ExtraUis) do
                    if uiName == eFunctionButtonName.BagButton then
                        isShow = true
                        break
                    end
                end
            end
            btn.gameObject():SetActiveEx(isShow)
        end
        return btn
    else
        logError(StringEx.Format("invalid special open id,{0} ", openSystemId))
    end
end

function MainCtrl:GetSuitButtonIndex(openTable)
    if not self:_isContainMainPanelType(openTable) then
        return nil
    end

    local l_openSystemId = openTable.Id

    local l_currentSortIndex = self.Buttons[l_openSystemId].SortIndex
    local l_largeSortIndexButton = nil
    for i, v in pairs(self.Buttons) do
        if v.SystemPlace == self.Buttons[l_openSystemId].SystemPlace and l_currentSortIndex < v.SortIndex then
            if l_largeSortIndexButton == nil then
                l_largeSortIndexButton = v
            else
                if v.SortIndex < l_largeSortIndexButton.SortIndex then
                    l_largeSortIndexButton = v
                end
            end
        end
    end
    if l_largeSortIndexButton == nil then
        return 9999
    else
        local l_index = l_largeSortIndexButton:transform():GetSiblingIndex()
        return l_index
    end
end

function MainCtrl:_isContainMainPanelType(openTable)
    for i = 1, openTable.TypeTab.Length do
        if openTable.TypeTab[i - 1] == l_openSystemMgr.EFunctionType.MainPanel then
            return true
        end
    end
    return false
end

function MainCtrl:GetOpenedButton(openSystemId)
    if l_openSystemMgr.IsSystemOpen(openSystemId) then
        return self:GetButton(openSystemId)
    end
    return nil
end

function MainCtrl:GetExistButton(openSystemId)
    if self.Buttons == nil then
        return nil
    end
    return self.Buttons[openSystemId]
end

function MainCtrl:GetBtnExitPosition()
    return self.panel.BtnExit.transform.position
end

function MainCtrl:ShowExistButtons(isShow, buttonIds)
    if buttonIds then
        for i = 1, #buttonIds do
            local button = self:GetExistButton(buttonIds[i])
            if button ~= nil then
                button:ShowButton(isShow)
            end
        end
    end
end

function MainCtrl:CloseAllButton()
    for i, button in pairs(self.Buttons) do
        button:ShowButton(false)
    end
end

function MainCtrl:showFunctionWithScene()
    for _, button in pairs(self.l_FunctionButtons) do
        if button then
            button:SetActiveEx(false)
        end
    end
    for _, uiName in ipairs(self.l_ExtraUis) do
        self:tryShowFunction(uiName);
    end
    GlobalEventBus:Dispatch(EventConst.Names.MAIN_UI_UPDATE_WITH_SCENE)
end
function MainCtrl:tryShowFunction(uiName)
    if not self.l_FunctionButtons[uiName] then
        return
    end

    if uiName == eFunctionButtonName.BagButton then
        if not l_openSystemMgr.IsSystemOpen(101) then
            return
        end
    end

    self.l_FunctionButtons[uiName]:SetActiveEx(true)
end

function MainCtrl:initFunctionButton()
    self.l_FunctionButtons["BtnFunctionOpen"] = self.panel.BtnFunctionOpen.gameObject
    self.l_FunctionButtons["AutoBattleButton"] = self.panel.ImgAutoBattleButtom.gameObject
    self.l_FunctionButtons["BtnSwitchUI"] = self.panel.BtnSwitchUI.gameObject
    self.l_FunctionButtons["BtnExit"] = self.panel.BtnExit.gameObject
    self.l_FunctionButtons["BtnInfo"] = self.panel.BtnInfo.gameObject
    self.l_FunctionButtons["BagButton"] = self.panel.BagButton.gameObject
    self.l_FunctionButtons["BtnShowAction2"] = self.panel.BtnShowAction2.gameObject
    self.l_FunctionButtons["BtnTowerRewardInfo"] = self.panel.BtnTowerRewardInfo.gameObject
end

function MainCtrl:showFunctionButton(functionName, isShow)
    local l_button = self.l_FunctionButtons[functionName]
    if not l_button then
        logError("无法找到按钮", functionName)
        return
    end
    l_button:SetActiveEx(isShow and (table.ro_contains(self.l_ExtraUis, functionName)))
end

function MainCtrl:SetFollowState(state)
    if state then
        self.startAutoFollowPlayAni = true
        self.panel.TxtFollow.LabText = Common.Utils.Lang("TEAM_FOLLOWING_PEOPLE") --Common.Utils.Lang("TEAM_FOLLOW_PEOPLE",MgrMgr:GetMgr("TeamMgr").myTeamInfo.captainName)
    else
        self.startAutoFollowPlayAni = false
    end
    self.panel.TxtFollow.gameObject:SetActiveEx(state)
end
function MainCtrl:setAutoCollectState(state)
    self.startAutoCollectAni = state
    if state then
        self.panel.TxtFollow.LabText = MgrMgr:GetMgr("LifeProfessionMgr").GetAutoCollectTip()
    end
    self.panel.TxtFollow.gameObject:SetActiveEx(state)
end
function MainCtrl:SetTaskNaving()
    -- body
    local state = MgrMgr:GetMgr("TaskMgr").GetSelectTaskID() ~= -1
    if state then
        self.startTaskNavingPlayAni = true
        self.panel.TxtTaskNaving.LabText = Common.Utils.Lang("TIP_NAVING_TASK") --Common.Utils.Lang("TEAM_FOLLOW_PEOPLE",MgrMgr:GetMgr("TeamMgr").myTeamInfo.captainName)
    else
        self.startTaskNavingPlayAni = false
    end
    self.panel.TxtTaskNaving.gameObject:SetActiveEx(state)
end

function MainCtrl:UpdateLandingAwardState()

    local l_system_id = l_openSystemMgr.eSystemId.LandingAward
    if l_openSystemMgr.IsSystemCached(l_system_id) then
        return
    end

    local l_visible = l_landingAwardMgr:IsSystemOpen() and l_landingAwardMgr:CheckSystemOpen()
    local l_btn = self:GetOpenedButton(l_system_id)
    if l_btn then
        if l_btn.isActive ~= l_visible then
            l_btn:ShowButton(l_visible)
        end
    end
end

function MainCtrl:FreshWeight()
    local overWeighted = MgrMgr:GetMgr("ItemWeightMgr").IsWeightRed(GameEnum.EBagContainerType.Bag)
    self.panel.FxOverWeight.gameObject:SetActiveEx(overWeighted)
end

function MainCtrl:CloseDps()
    if not MGameContext.IsOpenGM then
        return
    end
    self.panel.GM_DPS.gameObject:SetActiveEx(false)
end

function MainCtrl:ShowGMDps(BattleTime, BattleDamage, BattleDps)
    if not MGameContext.IsOpenGM then
        self.panel.GM_DPS.gameObject:SetActiveEx(false)
        return
    end
    self.panel.GM_DPS.gameObject:SetActiveEx(true)
    self.panel.Txt_BattleTimeValue.LabText = tostring(BattleTime)
    self.panel.Txt_BattleDamageValue.LabText = tostring(BattleDamage)
    self.panel.Txt_BattleDpsValue.LabText = tostring(BattleDps)
end

------------------------- 新手指引相关 ---------------------------------

--主界面系统开启按钮的新手指引
function MainCtrl:ShowBeginnerGuide(guideStepInfo)
    --如果主界面上已有系统的指引 则强行关闭
    if self.guideSystemId ~= 0 then
        self:SystemBtnClickGuideCheck(self.guideSystemId)
    end
    --新指引触发
    if guideStepInfo.ValueId == l_openSystemMgr.eSystemId.Bag then
        --背包特判
        local l_aimWorldPos = self.panel.BagButton.transform.position
        MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_aimWorldPos,
                self.panel.BagButton.transform, guideStepInfo)
        --设置主界面置顶 防止新手指引被遮挡
        self.uTrans:SetAsLastSibling()
    elseif guideStepInfo.ValueId == l_openSystemMgr.eSystemId.AutoBattle then
        --自动战斗特判
        local l_aimWorldPos = self.panel.BtnAutoBattle.transform.position
        MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_aimWorldPos,
                self.panel.BtnAutoBattle.transform, guideStepInfo)
        --设置主界面置顶 防止新手指引被遮挡
        self.uTrans:SetAsLastSibling()
    else
        --普通自动生成的系统按钮
        --获取系统按钮
        local l_systemBtn = self.Buttons[guideStepInfo.ValueId]
        --判断目标的系统按钮是否存在和是否显示 不存在则直接返回
        if not l_systemBtn then
            return
        end
        --引导的箭头显示
        local l_aimWorldPos = l_systemBtn:transform().position
        MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_aimWorldPos,
                l_systemBtn:transform(), guideStepInfo)
    end
    --记录触发的系统ID
    self.guideSystemId = guideStepInfo.ValueId
end

--系统按钮点击的新手指引确认
function MainCtrl:SystemBtnClickGuideCheck(systemId)

    if self.guideSystemId == systemId then
        self.guideSystemId = 0
        MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
    end

end

------------------------- End 新手指引相关 ---------------------------------
function MainCtrl:updateAutoBehaviourAni()
    if not self.startAutoFollowPlayAni and not self.startAutoCollectAni then
        return
    end
    self.remainTime = self.remainTime - UnityEngine.Time.deltaTime
    if self.remainTime <= 0 then
        if self.maxPoint < 3 then
            self.maxPoint = self.maxPoint + 1
            self.panel.TxtFollow.LabText = self.panel.TxtFollow.LabText .. "."
        else
            if self.startAutoFollowPlayAni then
                self.panel.TxtFollow.LabText = Common.Utils.Lang("TEAM_FOLLOWING_PEOPLE")
            elseif self.startAutoCollectAni then
                self.panel.TxtFollow.LabText = MgrMgr:GetMgr("LifeProfessionMgr").GetAutoCollectTip()
            end
            self.maxPoint = 0
        end
        self.remainTime = 1
    end
end
--lua custom scripts end

return MainCtrl
