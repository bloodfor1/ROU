--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SettingPlayerPanel"
require "UI/Template/SettingPlayerTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
SettingPlayerHandler = class("SettingPlayerHandler", super)
--lua class define end

--lua functions
function SettingPlayerHandler:ctor()

    super.ctor(self, HandlerNames.SettingPlayer, 0)
    -- 防止刷新或者初始化的时候触发Tog的改变
    self._isTogGroupEvent = true
    self._isShowChangeRole = false

end --func end
--next--
function SettingPlayerHandler:Init()

    local teamMgr = MgrMgr:GetMgr("TeamMgr")
    local settingMgr = MgrMgr:GetMgr("SettingMgr")
    self.panel = UI.SettingPlayerPanel.Bind(self)
    super.Init(self)
    -- 攻击优先级
    self.panel.TogTargetRNG:OnToggleChanged(function(value)
        --距离优先
        if value and self._isTogGroupEvent then
            settingMgr.RequestTargetSelectType(ETargetTabType.TAB_BY_RNG)
        end
    end)
    self.panel.TogTargetHP:OnToggleChanged(function(value)
        --血量优先
        if value and self._isTogGroupEvent then
            settingMgr.RequestTargetSelectType(ETargetTabType.TAB_BY_HP)
        end
    end)
    -- 游戏操作模式
    self.panel.TogControlTouch:OnToggleChanged(function(value)
        --触屏模式
        if value and self._isTogGroupEvent then
            MPlayerSetting.SkillCtrlType = ESkillControllerType.Classic
        end
    end)
    self.panel.TogControlWheel:OnToggleChanged(function(value)
        --轮盘模式
        if value and self._isTogGroupEvent then
            MPlayerSetting.SkillCtrlType = ESkillControllerType.DoubleDisk
        end
    end)
    -- 视角选择
    self.panel.TogControl2D:OnToggleChanged(function(value)
        --2.5D视角
        if value and self._isTogGroupEvent then
            MEventMgr:LuaFireEvent(MEventType.MEvent_RecoverDefaultView, MScene.GameCamera, false);
            local chatMgr = MgrMgr:GetMgr("ChatMgr")
            local l_chatDataMgr = DataMgr:GetData("ChatData")
            chatMgr.EventDispatcher:Dispatch(l_chatDataMgr.EEventType.ViewModeChange)
        end
    end)
    self.panel.TogControl3D:OnToggleChanged(function(value)
        --3D视角
        if value and self._isTogGroupEvent then
            MEventMgr:LuaFireEvent(MEventType.MEvent_RecoverDefaultView, MScene.GameCamera, true);
            local chatMgr = MgrMgr:GetMgr("ChatMgr")
            local l_chatDataMgr = DataMgr:GetData("ChatData")
            chatMgr.EventDispatcher:Dispatch(l_chatDataMgr.EEventType.ViewModeChange);
        end
    end)
    self.panel.TogPathFindingFixedView:OnToggleChanged(function(value)
        MPlayerSetting.RecoverViewWhenPathFinding = value;
    end)
    -- 自动播放语音设置
    self.panel.TogChatWorld:OnToggleChanged(function(value)
        --世界
        if self._isTogGroupEvent then
            MPlayerSetting.soundChatData.ChatWorldState = value
        end
    end)
    self.panel.TogChatTeam:OnToggleChanged(function(value)
        --队伍
        if self._isTogGroupEvent then
            MPlayerSetting.soundChatData.ChatTeamState = value
        end
    end)
    self.panel.TogChatGuild:OnToggleChanged(function(value)
        --公会
        if self._isTogGroupEvent then
            MPlayerSetting.soundChatData.ChatGuildState = value
        end
    end)
    self.panel.TogChatCurrent:OnToggleChanged(function(value)
        --当前
        if self._isTogGroupEvent then
            MPlayerSetting.soundChatData.ChatCurrentState = value
        end
    end)
    self.panel.TogChatWifiAuto:OnToggleChanged(function(value)
        --WIFI自动播放
        if self._isTogGroupEvent then
            MPlayerSetting.soundChatData.ChatWifiAutoState = value
        end
    end)
    --隐私
    self.panel.TogPrivateChatLevel:OnToggleChanged(function(value)
        --等级以下陌生人消息不接收
        if self._isTogGroupEvent then
            settingMgr.RequestIsPrivateChatLevel(value)
        end
    end)
    --隐私
    self.panel.ChatRoomNameBtn:OnToggleChanged(function(value)
        --等级以下陌生人消息不接收
        MPlayerSetting.ChatRoomNameShow = value
        MgrMgr:GetMgr("ChatRoomBubbleMgr").ResetCurData()
    end)
    self.panel.AssistBtn:OnToggleChanged(function(value)
        MPlayerSetting.AssistMvpShow = value
        GlobalEventBus:Dispatch(EventConst.Names.BossAimSettingChange)
    end)

    self.panel.WatchSettingBtn:OnToggleChanged(function(value)
        --等级以下陌生人消息不接收
        MgrMgr:GetMgr("WatchWarMgr").RequestSetSpectatorStatus(value)
    end)

    self.panel.WatchChatSettingBtn:OnToggleChanged(function(value)
        --等级以下陌生人消息不接收
        MgrMgr:GetMgr("WatchWarMgr").RequestSetSpectatorChatStatus(value)
    end)
    -- 是否开启截图分享
    self.panel.TogScreenCapture:OnToggleChanged(function(value)
        MPlayerSetting.OpenScreenCaptureShare = value
    end)
    self.panel.TogScreenCapture.gameObject:SetActiveEx(MgrMgr:GetMgr("ShareMgr").CanShare_merge())
    -- 震屏设置
    self.panel.TogCameraShake:OnToggleChanged(function(value)
        MPlayerSetting.IsCameraShakeEnable = not value
    end)

    -- 普攻自动攻击设置
    self.panel.TogCommonAttack:OnToggleChanged(function(value)
        MPlayerSetting.IfAttckWhenSelect = value
    end)

    self.panel.WatchTishiBtn:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = Lang("WATCH_MISTERY_TIPS"),
            alignment = UnityEngine.TextAnchor.MiddleRight,
            pos = {
                x = 231,
                y = 44,
            },
            width = 400,
        })
    end)

    local privateCheatLevel = tonumber(TableUtil.GetSocialGlobalTable().GetRowByName("FilterChatLimitLevel").Value)
    self.panel.LabelPrivateChatLevel.LabText = Common.Utils.Lang("SETTING_PLAYER_PRIVATE_CHAT_LEVEL", privateCheatLevel)

    self.panel.LabelScreenCapture.LabText = Common.Utils.Lang("QiuckScreenCaptureShare")
    -- 玩家属性

    self.panel.ChangeRoleViewBtn:AddClick(function()
        if self._isShowChangeRole then
            self._isShowChangeRole = false
        else
            self._isShowChangeRole = true
        end
        self:UpdateBtnsPosition()
    end
    )

    -- 退出登录
    self.panel.ExitLoginBtn:AddClick(function()
        local l_str = Common.Utils.Lang("LOGOUT_COMFIRM")
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_str, function()
            game:GetAuthMgr():LogoutToGame()
        end)
    end)
    --返回选角
    self.panel.BackToSelectCharBtn:AddClick(function()
        game:GetAuthMgr():LogoutToSelectRole()
    end)
    -- 更新公告
    self.panel.UpdateNoticeBtn:AddClick(function()
        local l_announceMgr = MgrMgr:GetMgr("AnnounceMgr")
        l_announceMgr.SetIsShow(true)
        l_announceMgr.GetAnnounceData(2)
    end)

    -- 客服
    self.panel.FeedbackBtn:AddClick(function()
        Application.OpenURL(MgrMgr:GetMgr("UseAgreementProtoMgr").GetCustomerServiceURL())
    end)
    if g_Globals.IsKorea then
        self.panel.FeedbackBtn.gameObject:SetActiveEx(true)
    elseif g_Globals.IsChina then
        self.panel.FeedbackBtn.gameObject:SetActiveEx(true)
    end

    --脱机卡死
    self.panel.Btn_Freefromstuck:AddClick(function()
        MgrMgr:GetMgr("SettingMgr").FreeStuck(false)
    end)
    --锁定屏幕
    self.panel.Btn_Lockscreen:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Setting)
        MgrMgr:GetMgr("SettingMgr").EnterLockScreen()
    end)

    --利用条款
    self.panel.Btn_UseOriginal:AddClick(function()
        MLogin.OpenURL(CJson.encode({ url = MgrMgr:GetMgr("UseAgreementProtoMgr").TermsOfUseURL }))
    end)
    self.panel.Btn_UseOriginal.gameObject:SetActiveEx(g_Globals.IsKorea)
    --个人信息隐私政策
    self.panel.Btn_PersonalPrivacy:AddClick(function()
        MLogin.OpenURL(CJson.encode({ url = MgrMgr:GetMgr("UseAgreementProtoMgr").PersonalPrivacyTermsURL }))
    end)
    self.panel.Btn_PersonalPrivacy.gameObject:SetActiveEx(g_Globals.IsKorea)
    --运营政策
    self.panel.Btn_OperationStrategy:AddClick(function()
        MLogin.OpenURL(CJson.encode({ url = MgrMgr:GetMgr("UseAgreementProtoMgr").OperationStrategy }))
    end)
    self.panel.Btn_OperationStrategy.gameObject:SetActiveEx(g_Globals.IsKorea)
    --绑定账号
    self.panel.Btn_BindAccout:AddClick(function()
        local loginType = game:GetAuthMgr().AuthData.GetCurLoginType()
        if loginType == GameEnum.EJoyyouLoginType.JoyyouGuest then
            MgrMgr:GetMgr("BindAccountMgr").LogoutToGameOpenBindAccountUI()
        else
            local str = ""
            if loginType == GameEnum.EJoyyouLoginType.Google then
                str = "Google"
            elseif loginType == GameEnum.EJoyyouLoginType.Facebook then
                str = "Facebook"
            elseif loginType == GameEnum.EJoyyouLoginType.Apple then
                str = "Apple"
            end
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BindAccountAlready", str))
        end
    end)
    self.panel.Btn_BindAccout.gameObject:SetActiveEx(l_isKorea)

    -- 实名
    if MDevice.EnableSDKInterface("MSDKLogin") then
        self.panel.RealName.gameObject:SetActiveEx(true)
    else
        self.panel.RealName.gameObject:SetActiveEx(false)
    end

    self.curPortraitTemplate = self:NewTemplate("SettingPlayerTemplate", {
        TemplatePrefab = self.panel.SettingPlayerTemplate.gameObject,
        TemplateParent = self.panel.Heads.transform,
    })

    self.playersPortraitTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SettingPlayerTemplate,
        TemplatePrefab = self.panel.SettingPlayerTemplate.gameObject,
        TemplateParent = self.panel.Grid.transform,
    })
end --func end
--next--
function SettingPlayerHandler:Uninit()

    self.curPortraitTemplate = nil
    self.playersPortraitTemplatePool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SettingPlayerHandler:OnActive()

    local settingMgr = MgrMgr:GetMgr("SettingMgr")
    self._isTogGroupEvent = false
    -- 攻击优先级
    self.panel.TogTargetRNG.Tog.isOn = (MPlayerSetting.TargetTabType == ETargetTabType.TAB_BY_RNG)
    self.panel.TogTargetHP.Tog.isOn = (MPlayerSetting.TargetTabType == ETargetTabType.TAB_BY_HP)
    -- 游戏操作模式
    self.panel.TogControlTouch.Tog.isOn = MPlayerSetting.SkillCtrlType == ESkillControllerType.Classic
    self.panel.TogControlWheel.Tog.isOn = MPlayerSetting.SkillCtrlType == ESkillControllerType.DoubleDisk
    -- 视角模式
    self.panel.TogControl2D.Tog.isOn = not MPlayerSetting.Is3DViewMode;
    self.panel.TogControl3D.Tog.isOn = MPlayerSetting.Is3DViewMode;
    self.panel.TogPathFindingFixedView.Tog.isOn = MPlayerSetting.RecoverViewWhenPathFinding;
    -- 自动播放语音设置
    self.panel.TogChatWorld.Tog.isOn = MPlayerSetting.soundChatData.ChatWorldState
    self.panel.TogChatTeam.Tog.isOn = MPlayerSetting.soundChatData.ChatTeamState
    self.panel.TogChatGuild.Tog.isOn = MPlayerSetting.soundChatData.ChatGuildState
    self.panel.TogChatCurrent.Tog.isOn = MPlayerSetting.soundChatData.ChatCurrentState
    self.panel.TogChatWifiAuto.Tog.isOn = MPlayerSetting.soundChatData.ChatWifiAutoState
    self.panel.ChatRoomNameBtn.Tog.isOn = MPlayerSetting.ChatRoomNameShow
    self.panel.AssistBtn.Tog.isOn = MPlayerSetting.AssistMvpShow
    self.panel.WatchSettingBtn.Tog.isOn = settingMgr.GetIsHideOutlookWhenBeWatched()
    self.panel.WatchChatSettingBtn.Tog.isOn = MgrMgr:GetMgr("WatchWarMgr").GetSpectatorCharStatus()
    -- 震屏设置
    self.panel.TogCameraShake.Tog.isOn = not MPlayerSetting.IsCameraShakeEnable
    --等级以下陌生人消息不接收
    self.panel.TogPrivateChatLevel.Tog.isOn = settingMgr.GetIsPrivateChatLevel()
    self._isTogGroupEvent = true

    --是否开启截图分享
    self.panel.TogScreenCapture.Tog.isOn = MPlayerSetting.OpenScreenCaptureShare
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.SetContent.RectTransform)
    ----定位到隐私部分
    --if settingMgr.GetIsOpenToPlayerPrivate() then
    --    settingMgr.SetIsOpenToPlayerPrivate(false)
    --    self.panel.SetContent.transform:SetLocalPos(0, 84, 0)
    --    self.panel.TogPrivateChatLevel.Tog.isOn = true
    --    return
    --end

    self:SetPlayerHeadInfo()

    if g_Globals.IsChina then
        self.panel.AndroidAgreement.gameObject:SetActiveEx(MGameContext.IsAndroid)
        self.panel.iOSAgreement.gameObject:SetActiveEx(MGameContext.IsIOS)
    elseif g_Globals.IsKorea then
        self.panel.AndroidAgreement.gameObject:SetActiveEx(false)
        self.panel.iOSAgreement.gameObject:SetActiveEx(false)
    end

    self.panel.AndroidAgreementText:GetRichText().onHrefDown:RemoveAllListeners()
    self.panel.AndroidAgreementText:GetRichText().onHrefDown:AddListener(function(hrefName, ed)
        Application.OpenURL(hrefName)
    end)

    self.panel.iOSAgreementText:GetRichText().onHrefDown:RemoveAllListeners()
    self.panel.iOSAgreementText:GetRichText().onHrefDown:AddListener(function(hrefName, ed)
        Application.OpenURL(hrefName)
    end)
    self:refreshVoiceSettingState()
    self:refreshCommonAttackSetting()
end --func end
--next--
function SettingPlayerHandler:OnDeActive()

end --func end
--next--
function SettingPlayerHandler:Update()


end --func end


--next--
function SettingPlayerHandler:BindEvents()

    --dont override this function
    self:BindEvent(MgrMgr:GetMgr("SelectRoleMgr").EventDispatcher, MgrMgr:GetMgr("SelectRoleMgr").ON_DATA_CHANGED, function(self, ...)
        self:SetPlayerHeadInfo(...)
    end)
    local l_openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self:BindEvent(l_openMgr.EventDispatcher, l_openMgr.OpenSystemUpdate, function(self)
        self:refreshVoiceSettingState()
    end)
end --func end

--next--
--lua functions end

--lua custom scripts

function SettingPlayerHandler:OnClickChangeRole(posID)

    -- local l_rolesInfo = MgrMgr:GetMgr("SelectRoleMgr").roleInfo
    --  local l_info = l_rolesInfo[posID];
    --  logGreen("--OnClickChangeRole->posID:"..posID)
    --  logGreen("--->l_info.type:"..l_info.type)
    --  logGreen("--->l_info.roleID:"..l_info.roleID)
    -- logGreen("--->l_info.level:"..l_info.level)

    local l_roleInfo = DataMgr:GetData("SelectRoleData").RoleInfos[posID]
    if not l_roleInfo then
        return
    end

    if l_roleInfo.status and l_roleInfo.status ~= RoleStatusType.Role_Status_None then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ROLE_STATUS_DELETING"))
        return
    end

    local l_str = Common.Utils.Lang("CONFIRM_EXIT_CUR_ENTER_SELECTED_ROLE", Common.Utils.PlayerName(l_roleInfo.name))
    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_str, function()
        UIMgr:DeActiveUI(UI.CtrlNames.Setting)
        MgrMgr:GetMgr("SelectRoleMgr").SwitchRoleInGame(posID)
    end, nil, -1, 0, nil,
            function(ctrl)
                ctrl:SetAlignmentHorizontal(UnityEngine.TextAnchor.MiddleLeft)
            end)
end

function SettingPlayerHandler:OnClickChangeRoleView()
    if self._isShowChangeRole then
        self._isShowChangeRole = false
    else
        self._isShowChangeRole = true
    end
end

function SettingPlayerHandler:SetPlayerHeadInfo()
    local l_panel = self.panel

    local l_rolesInfo = DataMgr:GetData("SelectRoleData").RoleInfos
    if l_rolesInfo == nil then
        logError("l_rolesInfo is nil")
        return
    end

    if table.maxn(l_rolesInfo) == 0 then
        logError("l_rolesInfoLen is 0")
        return
    end

    local l_data = DataMgr:GetData("SelectRoleData").GetCurRoleInfo()

    if l_data ~= nil then
        self.curPortraitTemplate:SetData({ roleInfo = l_data, ignoreName = true })

        l_panel.CurPlayerNameTxt.LabText = MPlayerInfo.Name
        l_panel.CurPlayerServerTxt.LabText = MPlayerInfo.ServerName
        l_panel.CurPlayerIDTxt.LabText = StringEx.Format("ID：{0}", MLuaCommonHelper.Int(MPlayerInfo.UID))
    else
        logError("MEntityMgr.PlayerEntity is nil")
        return
    end

    self:UpdateBtnsPosition()
end --func end

function SettingPlayerHandler:UpdateBtnsPosition()

    self.panel.Grid.gameObject:SetActiveEx(self._isShowChangeRole)

    local posY = 248
    if self._isShowChangeRole then
        posY = -85

        local l_curPlayerUID = tostring(MPlayerInfo.UID)
        local l_datas = {}
        local l_rolesInfo = DataMgr:GetData("SelectRoleData").RoleInfos
        for i = 1, table.maxn(l_rolesInfo) do
            local l_role = l_rolesInfo[i]
            if l_role then
                if tostring(l_role.roleID) ~= l_curPlayerUID then
                    table.insert(l_datas, {
                        index = i,
                        roleInfo = l_role,
                    })
                end
            end
        end

        self.playersPortraitTemplatePool:ShowTemplates({ Datas = l_datas, Method = function(i)
            self:OnClickChangeRole(i)
        end })
    else
        posY = -5
    end
    MLuaCommonHelper.SetLocalPosY(self.panel.BtnGrid.gameObject, posY)

    local l_roleCount = 0
    for k, v in pairs(DataMgr:GetData("SelectRoleData").RoleInfos) do
        l_roleCount = l_roleCount + 1
        if l_roleCount >= 2 then
            break
        end
    end

    if self._isShowChangeRole and l_roleCount <= 1 then
        self.panel.NoOthersPlayerTxt:SetActiveEx(true)
    else
        self.panel.NoOthersPlayerTxt:SetActiveEx(false)
    end

end --func end

function SettingPlayerHandler:ScrollToArea(name)

    local l_com = self.panel[name]
    if not l_com then
        return
    end

    local l_viewportHeight = self.panel.SetContent.RectTransform.rect.height

    local l_parentTrans = self.panel.SetContent.transform
    local l_childs = l_parentTrans:GetAllChildren()
    local l_height = 0
    for i = 0, l_childs.Count - 1 do
        local l_child = l_childs[i]
        local l_rect = l_child:GetComponent("RectTransform")
        l_height = l_height + l_rect.sizeDelta.y
        if l_child.gameObject.name == name then
            break
        end
    end

    local l_needMoveOffset = l_height - l_viewportHeight
    if l_needMoveOffset <= 0 then
        return
    end

    MLuaCommonHelper.SetRectTransformPosY(self.panel.SetContent.gameObject, l_needMoveOffset)

end
function SettingPlayerHandler:refreshVoiceSettingState()
    local l_openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_chatVoiceOpen = l_openMgr.IsSystemOpen(l_openMgr.eSystemId.ChatVoice)
    self.panel.Panel_AudioSet:SetActiveEx(l_chatVoiceOpen)
end

function SettingPlayerHandler:refreshCommonAttackSetting()

    if MPlayerInfo.ProfessionId ~= 1000 then
        self.panel.CommonAttack:SetActiveEx(true)
        self.panel.TogCommonAttack.Tog.isOn = MPlayerSetting.IfAttckWhenSelect
    else
        self.panel.CommonAttack:SetActiveEx(false)
    end
end
--lua custom scripts end
return SettingPlayerHandler