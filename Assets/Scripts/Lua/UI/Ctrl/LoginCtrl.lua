--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LoginPanel"
require "Common/ActionQueue"
require "UI/Ctrl/DialogCtrl"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
LoginCtrl = class("LoginCtrl", super)
--lua class define end

local l_timer

local m_fetchServerInfoTimer

--当前服务器不存在,提示选择服务器
local l_selectServerTips = Common.Utils.Lang("SELECT_SERVER_TIPS")

--lua functions
function LoginCtrl:ctor()
    super.ctor(self, CtrlNames.Login, UILayer.Normal, nil, ActiveType.Normal)
    self.versionClickedTime = 0
    self.versionResetTimer = nil
    self.isFullScreen = true
    self.authMgr = game:GetAuthMgr()
end --func end

--next--
function LoginCtrl:Init()
    self.panel = UI.LoginPanel.Bind(self)
    super.Init(self)
    self.tweenId = 0
    self.authMgr:CheckConfigValid() --检测下配置是否合法
end
--func end

function LoginCtrl:InitVersion()
    local l_version = MPlatformConfigManager.GetCacheOrLocal().version
    MgrMgr:GetMgr("CrashReportMgr").SetAppVersion(l_version:To3String(), l_version:ToString())
    self.panel.txtVersion.LabText = "version:" .. l_version:ToString()

    self.panel.txtVersion:AddClick(function()
        if not MSpecialUserManager.MatchUserTag(MUserType.SuperPlayer) then
            --只有超白可以开启预发布更新
            return
        end
        if self.versionResetTimer == nil then
            self.versionResetTimer = self:NewUITimer(function()
                self.versionResetTimer = nil
                self.versionClickedTime = 0
            end, 2)
            self.versionResetTimer:Start()
        end

        self.versionClickedTime = self.versionClickedTime + 1
        if self.versionClickedTime >= 5 then
            if self.versionResetTimer ~= nil then
                self:StopUITimer(self.versionResetTimer)
                self.versionResetTimer = nil
                self.versionClickedTime = 0
            end

            if MGameContext.singleton.IsClientPreRelease then
                PlayerPrefs.SetString("IS_CLIENT_PRE_RELEASE", "false")
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips("cancel super player success")
            else
                PlayerPrefs.SetString("IS_CLIENT_PRE_RELEASE", "true")
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("set super player success"))
            end
            return
        end
    end)
end

function LoginCtrl:ShowLoginPanel()
    self.panel.StartGamePanel.gameObject:SetActiveEx(false)
    if MDevice.EnableSDKInterface("MSDKLogin") then
        self:ProcessMSDK()
    elseif MDevice.EnableSDKInterface("JoyyouLogin") then
        self:ProcessJoyyou()
    else
        self:ProcessPC()
    end
end

--next--
function LoginCtrl:ProcessPC()
    self.panel.PanelLogin.gameObject:SetActiveEx(true)
    self.panel.Panel_SDKLogin.gameObject:SetActiveEx(false)
    self.panel.InAccount.Input.text = DataMgr:GetData("AuthData").GetAccountLocal()

    self.panel.BtnLogin:AddClick(function()
        local l_account = string.ro_trim(self.panel.InAccount.Input.text)
        self.authMgr:SDKAuth(GameEnum.EMPCLoginType.PC, l_account)
    end)

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end
    local l_cg = self.panel.PanelLogin.gameObject:GetComponent("CanvasGroup")
    if l_cg and self.authMgr.loginTimes < 1 then
        l_cg.alpha = 0
        self.tweenId = MUITweenHelper.TweenAlpha(self.panel.PanelLogin.gameObject, 0, 1, 1)
        l_timer = nil
    end
end

function LoginCtrl:ProcessMSDK()
    --自动登录
    if MNetClient.NetLoginStep == ENetLoginStep.Begin then
        if DataMgr:GetData("AuthData").GetInnerTestAgreementProto() == "agree" then
            if MLogin.IsLogin() then
                --自动登录
                log("ProcessMSDK IsLogin true")
                self.authMgr:OnSDKAuth(MLogin.GetLoginData())
            else
                log("ProcessMSDK IsLogin false")
            end
        end
    end

    self.panel.PanelLogin.gameObject:SetActiveEx(false)
    self.panel.InAccount.gameObject:SetActiveEx(false)
    self.panel.Panel_SDKLogin.gameObject:SetActiveEx(true)
    self.panel.PanelTencent.gameObject:SetActiveEx(true)
    self.panel.PanelJoyyou.gameObject:SetActiveEx(false)
    self.panel.Button_Guest.gameObject:SetActiveEx(false)
    --屏蔽微信登陆
    self.panel.Button_WX.gameObject:SetActiveEx(false)

    self.panel.Button_WX:AddClick(function()
        log("MSDK|**** Button_WX:AddClick")
        self.authMgr:SDKAuth(GameEnum.EMSDKLoginType.Weixin)
    end)

    self.panel.Button_QQ:AddClick(function()
        log("MSDK|**** Button_QQ:AddClick")
        self.authMgr:SDKAuth(GameEnum.EMSDKLoginType.QQ)
    end)-- body

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end
    local l_cg = self.panel.Panel_SDKLogin.gameObject:GetComponent("CanvasGroup")
    if l_cg and self.authMgr.loginTimes < 1 then
        l_cg.alpha = 0
        self.tweenId = MUITweenHelper.TweenAlpha(self.panel.Panel_SDKLogin.gameObject, 0, 1, 1)
    end
end

function LoginCtrl:ProcessJoyyou()
    --自动登录
    if MNetClient.NetLoginStep == ENetLoginStep.Begin then
        if MLogin.IsLogin() then
            self.authMgr:SDKAuth(GameEnum.EJoyyouLoginType.AutoLogin)
        end
    end

    self.panel.PanelLogin.gameObject:SetActiveEx(false)
    self.panel.InAccount.gameObject:SetActiveEx(false)
    self.panel.Panel_SDKLogin.gameObject:SetActiveEx(true)
    self.panel.PanelTencent.gameObject:SetActiveEx(false)
    self.panel.PanelJoyyou.gameObject:SetActiveEx(true)
    self.panel.Button_GameCenter:SetActiveEx(false)

    self.panel.Button_GameCenter:AddClick(function()
        log("Joyyou|**** Button_GameCenter:AddClick")
        self.authMgr:SDKAuth(GameEnum.EJoyyouLoginType.GameCenter)
    end)

    self.panel.Button_Google:AddClick(function()
        log("Joyyou|**** Button_Google:AddClick")
        self.authMgr:SDKAuth(GameEnum.EJoyyouLoginType.Google)
    end)

    self.panel.Button_Visitor:AddClick(function()
        log("Joyyou|**** Button_Visitor:AddClick")
        if DataMgr:GetData("AuthData").GetJoyyouVisitorFirstLogin() == "0" then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("JoyyouVisitorFirstLogin"), function()
                DataMgr:GetData("AuthData").SetJoyyouVisitorFirstLogin("1")
                self.authMgr:SDKAuth(GameEnum.EJoyyouLoginType.JoyyouGuest)
            end)
        else
            self.authMgr:SDKAuth(GameEnum.EJoyyouLoginType.JoyyouGuest)
        end

    end)

    self.panel.Button_Facebook:AddClick(function()
        log("Joyyou|**** Button_Facebook:AddClick")
        self.authMgr:SDKAuth(GameEnum.EJoyyouLoginType.Facebook)
    end)

    self.panel.Button_Apple:AddClick(function()
        log("Joyyou|**** Button_Apple:AddClick")
        -- apple登录ios只支持ios13以上
        if MGameContext.IsIOS and not MDevice.AvailableSystemVersion(CJson.encode({ version = 13 })) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NotAvailableiOS13"))
            return
        end
        self.authMgr:SDKAuth(GameEnum.EJoyyouLoginType.Apple)
    end)

    --Andriod: Google>FB>Apple>Guest
    --iOS: Apple>Google>FB>Guest
    if MGameContext.IsAndroid then
        self.panel.Button_Visitor.transform:SetAsFirstSibling()
        self.panel.Button_Apple.transform:SetAsFirstSibling()
        self.panel.Button_Facebook.transform:SetAsFirstSibling()
        self.panel.Button_Google.transform:SetAsFirstSibling()
    else
        self.panel.Button_Visitor.transform:SetAsFirstSibling()
        self.panel.Button_Facebook.transform:SetAsFirstSibling()
        self.panel.Button_Google.transform:SetAsFirstSibling()
        self.panel.Button_Apple.transform:SetAsFirstSibling()
    end

    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end
    local l_cg = self.panel.Panel_SDKLogin.gameObject:GetComponent("CanvasGroup")
    if l_cg and self.authMgr.loginTimes < 1 then
        l_cg.alpha = 0
        self.tweenId = MUITweenHelper.TweenAlpha(self.panel.Panel_SDKLogin.gameObject, 0, 1, 1)
    end
end

function LoginCtrl:Uninit()

    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function LoginCtrl:OnActive()

    MoonClient.MSceneObjectEvent.SendEvent(1)

    self.panel.Bg:SetActiveEx(true)
    self.panel.PanelLogin:SetActiveEx(false)
    self.panel.Panel_SDKLogin:SetActiveEx(false)
    self.panel.StartGamePanel:SetActiveEx(false)

    self:InitVersion()

    --显示公告
    if self.authMgr.loginTimes < 1 then
        MgrMgr:GetMgr("AnnounceMgr").SetIsShow(true)
        MgrMgr:GetMgr("AnnounceMgr").GetAnnounceData(1)
    end

    logGreen("LoginStep = ", tostring(MNetClient.NetLoginStep))
    if MNetClient.NetLoginStep == ENetLoginStep.Begin
            or MNetClient.NetLoginStep == ENetLoginStep.SDKLogged then
        self:ShowLoginPanel()
    elseif MNetClient.NetLoginStep == ENetLoginStep.GateServerFetched then
        self:OnAuthSuccessEvent()
    else
        logError("状态错误！！当前状态为：" .. tostring(MNetClient.NetLoginStep))
    end

    self:InitGM()

    MgrMgr:GetMgr("BindAccountMgr").IsOpenBindAccountUI()
end --func end
--next--
function LoginCtrl:OnDeActive()
    if self.cdButton then
        self.cdButton:ResetCdButton()
    end
    self:StopAutoRefreshGateServer()
end --func end
--next--
function LoginCtrl:Update()
end --func end


--next--
function LoginCtrl:BindEvents()
    self:BindEvent(self.authMgr.EventDispatcher, EventConst.Names.ON_AUTH_SUCCESS, self.OnAuthSuccessEvent)

    self:BindEvent(self.authMgr.EventDispatcher, EventConst.Names.REQ_QUREY_GATE_IP_SUCCESS, self.OnFetchServerInfoSuccess)

    self:BindEvent(self.authMgr.EventDispatcher, EventConst.Names.ON_AUTH_FAILED, self.ShowLoginPanel)

    self:BindEvent(self.authMgr.EventDispatcher, EventConst.Names.REQ_LOGIN_CONNECT_ERROR, self.ShowLoginPanel)

    self:BindEvent(self.authMgr.EventDispatcher, EventConst.Names.ON_ACCOUNT_LOGOUT_EVENT, self.StopAutoRefreshGateServer)

    self:BindEvent(self.authMgr.EventDispatcher, EventConst.Names.UI_SET_TARGET_SERVER, self.OnSetTargetServer)

end --func end
--next--
--lua functions end

--lua custom scripts
function LoginCtrl:OnFetchServerInfoSuccess()
    -- 更新当前服务器
    self:RefreshCurrentServer()
end

function LoginCtrl:RefreshCurrentServer()
    local l_serverInfo = self.authMgr.AuthData.GetCurGateServer()
    self.panel.SelectServerTxt.LabText = l_serverInfo.servername
    self.panel.SelectServerState:SetSprite("CommonIcon", GameEnum.EGameServerState2Sprites[l_serverInfo.state])
end

function LoginCtrl:OnAuthSuccessEvent()
    --event coming
    logGreen("OnAuthSuccessEvent")

    self:InitStartGamePanel()
    self:AutoRefreshGateServer()
    --行为队列处理连续行为
    local l_actionQueue = Common.ActionQueue.new()
    --检查实名
    l_actionQueue:AddAciton(function(cb)
        self:CheckRealNameTips(cb)
    end)

    --检查同意条款
    l_actionQueue:AddAciton(function(cb)
        if g_Globals.IsChina then
            self:ProcessMSDKCheckAgreement(cb)
        elseif g_Globals.IsKorea then
            self:ProcessJoyyouCheckAgreement(cb)
        end
    end)
end

function LoginCtrl:AutoRefreshGateServer()
    --自动刷新服务器列表
    self:StopAutoRefreshGateServer()
    l_loopTime = MGlobalConfig:GetFloat("ServerRefreshInterval", 60)
    m_fetchServerInfoTimer = self:NewUITimer(function()
        logGreen("AutoRefreshGateServer")
        if MNetClient.NetLoginStep == ENetLoginStep.GateServerFetched and not self.authMgr:IsInQueue() then
            self.authMgr:FetchGateServerList(false)
        end
    end, l_loopTime, -1)
    m_fetchServerInfoTimer:Start()
end

function LoginCtrl:StopAutoRefreshGateServer()
    if m_fetchServerInfoTimer ~= nil then
        self:StopUITimer(m_fetchServerInfoTimer)
        m_fetchServerInfoTimer = nil
    end
end

function LoginCtrl:OnSetTargetServer(serverInfo)
    self.authMgr.AuthData.SetCurGateServer(serverInfo)
    self:RefreshCurrentServer()
end

--检查实名
function LoginCtrl:CheckRealNameTips(callback)
    local l_flagShowRealNameMsgBox = false
    -- 腾讯登陆态
    if MLogin.IsLogin() then
        -- 第一次玩游戏
        local l_loginRet = MLogin.GetLoginData()
        if l_loginRet then
            local l_key = StringEx.Format("REAL_NAME_NOTIFY_{0}", l_loginRet.open_id)
            local l_ret = UserDataManager.GetStringDataOrDef(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "0")
            if l_ret == 0 or l_ret == "0" then
                UserDataManager.SetDataFromLua(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, 1)
                l_flagShowRealNameMsgBox = true
            end
        end
    end

    if l_flagShowRealNameMsgBox then
        CommonUI.Dialog.ShowOKDlg(true, nil, Lang("REAL_NAME_CONTENT"), function()
            if callback ~= nil then
                callback()
            end
        end, nil, -1, 0, function(ctrl)
            ctrl:SetAlignmentHorizontal(UnityEngine.TextAnchor.MiddleLeft)
        end)
    else
        if callback ~= nil then
            callback()
        end
    end
end

--检查用户协议
function LoginCtrl:ProcessMSDKCheckAgreement(callback)
    logGreen("ProcessMSDKCheckAgreement")
    if not MPlayerSetting.AllowAgreement then
        CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true,
                nil, Lang("ALLOW_AGREEMENT"), Lang("ALLOW"), Lang("REFUSE"),
                function()
                    self.panel.TogAgreement.Tog.isOn = true
                    if callback ~= nil then
                        callback()
                    end
                end,
                function()
                    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true,
                            nil, Lang("REFUSE_AGREEMENT_TIP"), Lang("DLG_BTN_NO"), Lang("DLG_BTN_YES"), function()
                                self:ProcessMSDKCheckAgreement(callback)
                            end, function()
                                if callback ~= nil then
                                    callback()
                                end
                            end)

                end, nil, nil, nil, function(ctrl)
                    ctrl.panel.TxtMsg:GetRichText().onHrefDown:RemoveAllListeners()
                    ctrl.panel.TxtMsg:GetRichText().onHrefDown:AddListener(function(hrefName, ed)
                        Application.OpenURL(hrefName)
                    end)
                end)
    else
        if callback ~= nil then
            callback()
        end
    end
end

function LoginCtrl:ProcessJoyyouCheckAgreement(callback)
    logGreen("ProcessJoyyouCheckAgreement")
    MgrMgr:GetMgr("UseAgreementProtoMgr").GetUseAgreementTimeStamp(function()
        if not MPlayerSetting.AllowAgreement then
            UIMgr:ActiveUI(UI.CtrlNames.UseAgreementProto, { callback = callback })
        else
            if callback ~= nil then
                callback()
            end
        end
    end)
end
--维护公告
--检查服务器维护信息,维护时,显示公告
function LoginCtrl:CheckMaintenanceInfo()
    local l_curServer = self.authMgr.AuthData.GetCurGateServer()
    if not l_curServer then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_selectServerTips)
        return false
    end
    logGreen("Current server state:{0}", l_curServer.state)
    --0 维护 1 流畅 2 拥挤 3 爆满
    if l_curServer.state == 0 and not MSpecialUserManager.MatchUserTag(MUserType.SuperPlayer) then
        MgrMgr:GetMgr("MaintenanceDialogMgr").ShowMaintenanceDialog(l_curServer.maintaininfo, l_curServer.maintainendtime)
        return false
    end

    return true
end

function LoginCtrl:InitStartGamePanel()
    self.panel.PanelLogin.gameObject:SetActiveEx(false)
    self.panel.Panel_SDKLogin.gameObject:SetActiveEx(false)
    self.panel.StartGamePanel.gameObject:SetActiveEx(true)
    self.panel.Logo.gameObject:SetActiveEx(true)

    -- 更新当前选择的服务器
    self:RefreshCurrentServer()

    self.cdButton = self.panel.StartGameBtn.gameObject:GetComponent("MUICdButton")
    self.panel.StartGameBtn:AddClick(function()
        if MPlayerSetting.AllowAgreement then
            self:OnClickStartGame()
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_ALLOW_AGREEMENT_TIP"))
        end
        if self.cdButton then
            self.panel.StartGameBtn:SetGray(true)
        end
    end)

    if self.cdButton then
        local l_cd = MGlobalConfig:GetInt("StartGameBtnCd") or 5
        local l_cdText = self.panel.StartGameBtn.gameObject.transform:GetChild(0):GetComponent("Text")
        self.cdButton:ResetCdButton()
        self.cdButton:SetCd(l_cd)
        if l_cdText then
            self.cdButton:SetCdText(l_cdText)
        end
        -- self.cdButton.cdAction = function()
        --     local leftTime = self.cdButton:GetLeftTime()
        --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_SEARCH_CD", leftTime))
        -- end
        self.cdButton.finishAction = function ()
            self.panel.StartGameBtn:SetGray(false)
        end
    end

    self.panel.SelecteServerBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.SelectServer)
    end)

    -- 选择服务器层 返回按钮
    self.panel.Btn_back:AddClick(function()
        if g_Globals.IsKorea then
            UIMgr:ActiveUI(UI.CtrlNames.BindAccount)
        else
            log("LOGIN state=>点击退出账号按钮")
            self.authMgr:LogoutToAccount()
        end
    end)

    -- 选择服务器层 公告按钮
    self.panel.Btn_Announce:AddClick(function()
        MgrMgr:GetMgr("AnnounceMgr").SetIsShow(true)
        MgrMgr:GetMgr("AnnounceMgr").GetAnnounceData(2)
    end)

    -- 客服
    self.panel.Btn_Feedback:AddClick(function()
        Application.OpenURL(MgrMgr:GetMgr("UseAgreementProtoMgr").GetCustomerServiceURL())
    end)
    if g_Globals.IsKorea then
        self.panel.Btn_Feedback.gameObject:SetActiveEx(true)
    elseif g_Globals.IsChina then
        self.panel.Btn_Feedback.gameObject:SetActiveEx(true)
    end

    --玩家同意协议toggle更新
    self.panel.TogAgreement:OnToggleChanged(function(v)
        MPlayerSetting.AllowAgreement = v
    end)
    self.panel.TogAgreement.Tog.isOn = MPlayerSetting.AllowAgreement

    self.panel.TxtAgreement:GetRichText().onHrefDown:RemoveAllListeners()
    self.panel.TxtAgreement:GetRichText().onHrefDown:AddListener(function(hrefName, ed)
        Application.OpenURL(hrefName)
    end)

    if g_Globals.IsKorea then
        self.panel.TogAgreement.gameObject:SetActiveEx(false)
    else
        self.panel.TogAgreement.gameObject:SetActiveEx(true)
    end

    self.panel.Btn_Playback:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.FullScreenCG)
    end)
end

--点击开始游戏的回调
function LoginCtrl:OnClickStartGame()
    --当前服务器不存在或处于维护状态
    if not self:CheckMaintenanceInfo() then
        return
    end
    -- 禁止这时候公告弹出
    MgrMgr:GetMgr("AnnounceMgr").SetIsShow(false)
    -- 记录服务器名
    local l_curServer = self.authMgr.AuthData.GetCurGateServer()
    MPlayerInfo.ServerName = l_curServer.servername
    self.authMgr:StartGame(l_curServer)
end

function LoginCtrl:InitGM()
    self.panel.GMPanel.gameObject:SetActiveEx(MGameContext.IsOpenGM)
    if not MGameContext.IsOpenGM then
        return
    end

    self.panel.BtnGM:AddClick(function()
        self.panel.GMDetailPanel.gameObject:SetActiveEx(not self.panel.GMDetailPanel.gameObject.activeSelf)
        self.panel.DeviceInfo.gameObject:SetActiveEx(not self.panel.DeviceInfo.gameObject.activeSelf)
    end)
    self.panel.GMDetailPanel:SetActiveEx(false)
    self.panel.DeviceInfo:SetActiveEx(false)

    self.panel.deviceModel.LabText = StringEx.Format("deviceModel={0}", SystemInfo.deviceModel)
    self.panel.deviceName.LabText = StringEx.Format("deviceName={0}", SystemInfo.deviceName)
    self.panel.deviceType.LabText = StringEx.Format("deviceType={0}", SystemInfo.deviceType)
    self.panel.deviceUniqueIdentifier.LabText = StringEx.Format("deviceUniqueIdentifier={0}", SystemInfo.deviceUniqueIdentifier)

    --动态改loginserver
    self.panel.InputLoginIp.Input.text = UserDataManager.GetStringDataOrDef("GMInputLoginIp", MPlayerSetting.PLAYER_SETTING_GROUP, "")
    self.panel.InputLoginPort.Input.text = UserDataManager.GetStringDataOrDef("GMInputLoginPort", MPlayerSetting.PLAYER_SETTING_GROUP, "")
    self.panel.InputMapleId.Input.text = UserDataManager.GetStringDataOrDef("GMInputMapleId", MPlayerSetting.PLAYER_SETTING_GROUP, "")

    self.panel.BtnRefreshSvr:AddClick(function()
        local l_ip = self.panel.InputLoginIp.Input.text
        local l_port = self.panel.InputLoginPort.Input.text
        local l_maple = self.panel.InputMapleId.Input.text
        UserDataManager.SetDataFromLua("GMInputLoginIp", MPlayerSetting.PLAYER_SETTING_GROUP, l_ip)
        UserDataManager.SetDataFromLua("GMInputLoginPort", MPlayerSetting.PLAYER_SETTING_GROUP, l_port)
        UserDataManager.SetDataFromLua("GMInputMapleId", MPlayerSetting.PLAYER_SETTING_GROUP, l_maple)
        if string.ro_isEmpty(l_ip) or string.ro_isEmpty(l_port) then
            self.authMgr:SetGetLoginDebugFlag("0")
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips("set normal player login success")
        else
            self.authMgr:SetGetLoginDebugFlag("1")
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips("set GM player login server success.")
        end
        if MNetClient.NetLoginStep ~= ENetLoginStep.Begin then
            self.authMgr:LogoutToAccount()
        end
    end)

    local l_dropdownStrs = {}
    local index = 0
    for i = 1, #g_Globals.GMLoginSerCfg do
        table.insert(l_dropdownStrs, g_Globals.GMLoginSerCfg[i].desc .. " " .. g_Globals.GMLoginSerCfg[i].ip)
        if UserDataManager.GetStringDataOrDef("GMInputLoginIp", MPlayerSetting.PLAYER_SETTING_GROUP, "") == g_Globals.GMLoginSerCfg[i].ip
                and UserDataManager.GetStringDataOrDef("GMInputLoginPort", MPlayerSetting.PLAYER_SETTING_GROUP, "") == g_Globals.GMLoginSerCfg[i].port then
            index = i - 1
        end
    end
    self.panel.Dropdown.DropDown:ClearOptions()
    self.panel.Dropdown:SetDropdownOptions(l_dropdownStrs)
    self.panel.Dropdown.DropDown.onValueChanged:AddListener(function(index)
        self.panel.InputLoginIp.Input.text = g_Globals.GMLoginSerCfg[index+1].ip
        self.panel.InputLoginPort.Input.text = g_Globals.GMLoginSerCfg[index+1].port
    end)
    self.panel.Dropdown.DropDown.value = index
end

--lua custom scripts end
return LoginCtrl