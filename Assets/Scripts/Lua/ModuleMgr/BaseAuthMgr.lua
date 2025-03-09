
module("ModuleMgr", package.seeall)
---@class BaseAuthMgr
BaseAuthMgr = class("BaseAuthMgr")

ReloginReason = {
    None = 0,
    RefreshLoginToken = 1,
    RefreshGateList = 2,
    DealAgreement = 3
}

------------------生命周期BEGIN------------------
function BaseAuthMgr:ctor()
    -- body
    logGreen("[BaseAuthMgr]ctor")
    self.AuthData = DataMgr:GetData("AuthData")
    self.EventDispatcher = EventDispatcher.new()

    self.loginType = nil --登录类型：GameEnum.xxLoginType
    self.pbLoginType = LoginType.LOGIN_PASSWORD --登录类型：pb类型
    self.loginTimes = 0

    self.reconnectCount = 0

    -- 服列表管理器(maple&common)
    if MDevice.EnableSDKInterface("GCloudMaple") then
        self.serverListMgr = MgrMgr:GetMgr("MapleServerInfoMgr")
    else
        self.serverListMgr = MgrMgr:GetMgr("CommonServerInfoMgr")
    end

    -- 统计打开app
    MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.AppOpen)
    -- 设置语种
    MLogin.SetLang(CJson.encode({lang = GameEnum.GameLanguage2TechnologyCenter[tostring(MGameContext.CurrentLanguage)]}))
    -- 设置渠道code
    MLogin.SetClientChannelCode(CJson.encode({channelCode = MPlatformConfigManager.GetLocal().channel}))
    -- 获取推送token 只需要获取一次
    MPushNotification.GetMessagingServiceToken()
end

--@override
function BaseAuthMgr:OnInit()
    logGreen("[BaseAuthMgr]OnInit")
end

function BaseAuthMgr:OnReconnected(reconnectData)
    logGreen("[BaseAuthMgr]OnReconnected")
end

--@override
function BaseAuthMgr:OnUninit()
    logGreen("[BaseAuthMgr]OnUninit")
end

--[Comment]
--SDK认证
--@override
function BaseAuthMgr:SDKAuth(loginType)
    logGreen("[BaseAuthMgr]SDKAuth")
    CommonUI.Dialog.ShowWaiting(g_Globals.NETWORK_DELAYTIME)

    self.loginType = loginType
end

--[Comment]
--SDK认证成功
--@override
function BaseAuthMgr:OnSDKAuthed(openId, token)
    logGreen("[BaseAuthMgr]OnSDKAuthed")
    MNetClient.NetLoginStep = ENetLoginStep.SDKLogged
    self.pbLoginType = self:GetPBLoginType(self.loginType)
    self.AuthData.SetAccountInfo(openId, token)
    self:GetLoginSvrInfo()
end

--[Comment]
--SDK认证失败
--@override
function BaseAuthMgr:OnSDKAuthFailed()
    logGreen("[BaseAuthMgr]OnSDKAuthFailed")
    CommonUI.Dialog.HideWaiting()
end

--@override
function BaseAuthMgr:GetClientInfo()
    return {
        regChannelId = 0,
        channelId = 0,
        picurl = "",
        token = ""
    }
end

--[Comment]
--开始游戏登录gateserver
--@override
function BaseAuthMgr:StartGame(server)
    MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.InAppEnter)

    return true
end

------------------生命周期END------------------

local l_retryTime = 0
function BaseAuthMgr:SetGetLoginDebugFlag(val)
    UserDataManager.SetDataFromLua("LoginServerDebugIpFlag", MPlayerSetting.PLAYER_SETTING_GROUP, val)
end
function BaseAuthMgr:GetGetLoginDebugFlag()
    return UserDataManager.GetStringDataOrDef("LoginServerDebugIpFlag", MPlayerSetting.PLAYER_SETTING_GROUP, "0")
end
local l_getInnerChannel = function(channelId, loginType)
    if channelId ~= "ro_tx" then --@tm pay attention to this
        return ""
    end

    if loginType == GameEnum.EMSDKLoginType.Weixin or loginType == GameEnum.EMSDKLoginType.WXQrCode then
        return "wx"
    end
    if loginType == GameEnum.EMSDKLoginType.QQ then
        return "qq"
    end
    return ""
end
-- 获取LoginServer信息
-- @param string loginType 登录类型
function BaseAuthMgr:GetLoginSvrInfo()
    l_retryTime = 0
    self.reloginReason = ReloginReason.None

    if self:GetGetLoginDebugFlag() == "0" then
        --正式
        local l_channelId = MPlatformConfigManager.GetLocal().channel --客户端渠道
        local l_system = MGameContext.IsIOS and "ios" or "android"
        local l_innerChannel = l_getInnerChannel(l_channelId, self.loginType)
        local l_url = MPlatformConfigManager.GetLocal().apiDomain
        l_url = StringEx.Format(g_Globals.GETLOGIN_API, l_url, l_channelId, l_system, l_innerChannel, g_Globals.IOS_REVIEW)
        self:_doGetLoginSvrInfo(l_url)
    else
        --方便测试
        local l_ip = UserDataManager.GetStringDataOrDef("GMInputLoginIp", MPlayerSetting.PLAYER_SETTING_GROUP, "")
        local l_port = UserDataManager.GetStringDataOrDef("GMInputLoginPort", MPlayerSetting.PLAYER_SETTING_GROUP, "")
        local l_mapleId = UserDataManager.GetStringDataOrDef("GMInputMapleId", MPlayerSetting.PLAYER_SETTING_GROUP, "")
        if string.ro_isEmpty(l_ip) or string.ro_isEmpty(l_port) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips("ip or port can not empty")
            return
        end
        self.AuthData.SetLoginServerLocal(l_ip, l_port, l_mapleId)
        MNetClient.NetLoginStep = ENetLoginStep.LoginServerFetched
        self:ConnectLoginServer()
    end
end

function BaseAuthMgr:_doGetLoginSvrInfo(url)
    local l_sign, l_time, l_url = Common.CommonUIFunc.GetHttpSignAndTimeAndUrl()
    logGreen("[GetLoginSvrInfo]url={0}, timestamp={1}, sign={2}", url, l_time, l_sign)
    HttpTask.Create(url):AddHeader("timestamp", tostring(l_time)):AddHeader("sign", l_sign):TimeOut(5000):GetResponseAynsc(function(res, str)
        logGreen("[GetLoginSvrInfo]res={0}, json={1}", res, str)
        if res == HttpResult.OK then
            local l_jsonData = CJson.decode(str)
            if l_jsonData["code"] == 200 then
                local l_data = l_jsonData["data"]
                if string.ro_isEmpty(l_data.ip) then
                    self:OnGetLoginSvrInfoFailed("Invalid channelId:" .. tostring(MGameContext.Channel))
                    return
                end

                MNetClient.NetLoginStep = ENetLoginStep.LoginServerFetched
                self.AuthData.SetLoginServerLocal(l_data.ip, l_data.port, l_data.maple_zone_id)
                self:ConnectLoginServer()
            else
                self:OnGetLoginSvrInfoFailed("code:" .. tostring(l_jsonData["code"]))
            end
        else
            if l_retryTime < 2 then
                l_retryTime = l_retryTime + 1
                self:_doGetLoginSvrInfo(url)
            else
                local l_msg
                if HttpResult.WebException then
                    l_msg = Lang("NET_RESPONSE_TIMEOUT")
                else
                    l_msg = Lang("NET_RESPONSE_EXCEPTION")
                end
                self:OnGetLoginSvrInfoFailed(l_msg)
            end
        end
    end)
end

function BaseAuthMgr:OnGetLoginSvrInfoFailed(msg)
    logError("OnGetLoginSvrInfoFailed")
    CommonUI.Dialog.HideWaiting()
    self:ShowImportantDialog(Common.Utils.Lang("NET_GETLOGINSVR_FAILED", msg), handler(self, self.LogoutToAccount))
end

--[Comment]
--重新登录
--@param RefreshLoginToken reason 重登原因
function BaseAuthMgr:ReLoginLoginServer(reason)
    logGreen("[ReLoginLoginServer]start")
    self.reloginReason = reason
    MNetClient.NetLoginStep = ENetLoginStep.LoginServerFetched
    self:ConnectLoginServer()
end

function BaseAuthMgr:ConnectLoginServer()
    local l_loginInfo = self.AuthData.GetLoginServerLocal()
    MNetClient:Connect(l_loginInfo.ip, l_loginInfo.port)
    logGreen("[ConnectLoginServer]try to connect loginserver:ip = "..l_loginInfo.ip.." | port = "..l_loginInfo.port)
end

function BaseAuthMgr:OnConnected()
    if MNetClient.NetLoginStep == ENetLoginStep.LoginServerFetched then
        logGreen("[OnConnected]Connect to loginserver success, start to login to loginserver")
        MNetClient.NetLoginStep = ENetLoginStep.LoginServerConnected
        self:LoginLoginServer()
    elseif MNetClient.NetLoginStep == ENetLoginStep.LoginServerLogged
        or MNetClient.NetLoginStep == ENetLoginStep.GateServerFetched then
        logGreen("[OnConnected]Connect to gateserver success, start to GameLogin")
        MNetClient.NetLoginStep = ENetLoginStep.GateServerConnected
        self:LoginGateServer()
    else
        CommonUI.Dialog.HideWaiting()
        logError("[OnConnected]invalid loginstep, NetLoginStep={0}", tostring(MNetClient.NetLoginStep))
    end
end

function BaseAuthMgr:OnConnectFailed()
    logRed("[OnConnectFailed]NetLoginStep=>"..tostring(MNetClient.NetLoginStep))

    CommonUI.Dialog.HideWaiting()
    if MNetClient.NetLoginStep == ENetLoginStep.LoginServerFetched then
        MNetClient.NetLoginStep = ENetLoginStep.Begin
        self:ShowImportantDialog(Common.Utils.Lang("NET_AUTH_FAILED"), nil)
    elseif MNetClient.NetLoginStep == ENetLoginStep.LoginServerLogged
        or MNetClient.NetLoginStep == ENetLoginStep.GateServerFetched then
        MNetClient.NetLoginStep = ENetLoginStep.GateServerFetched
        self:ShowImportantDialog(Common.Utils.Lang("NET_LOGIN_FAILED"), nil)
    else
        logError("[OnConnectFailed]invalid loginstep, NetLoginStep={0}", MNetClient.NetLoginStep)
    end

    --连接失败的事件分发
    self.EventDispatcher:Dispatch(EventConst.Names.REQ_LOGIN_CONNECT_ERROR)
end

--[Comment]
--@param string openId 第三方帐号
--@param string token 第三方key
function BaseAuthMgr:LoginLoginServer(--[[openId, token, loginType]])
    local l_msgId = Network.Define.Rpc.CertifyRequest
    local l_sendInfo = GetProtoBufSendTable("CertifyArg")
    local l_platId = self:GetPlatformId()
    local l_accountInfo = self.AuthData.GetAccountInfo()
    local l_version = MPlatformConfigManager.GetCacheOrLocal().version:ToString()
    l_sendInfo.type = self.pbLoginType
    if self.pbLoginType == LoginType.LOGIN_PASSWORD then
        l_sendInfo.password = l_accountInfo.token
    else
        l_sendInfo.token = l_accountInfo.token
    end
    l_sendInfo.pf = GameEnum.ELoginPlatform[l_platId]
    l_sendInfo.openid = l_accountInfo.account
    l_sendInfo.version = l_version
    l_sendInfo.account = l_accountInfo.account
    l_sendInfo.platid = l_platId
    logGreen("[LoginLoginServer] start to login, args={0}", table.ro_kvConcat(l_sendInfo))
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function BaseAuthMgr:OnLoginLoginServer(msg)
    ---@type CertifyRes
    local l_info = ParseProtoBufToTable("CertifyRes", msg)
    logGreen("[OnLoginLoginServer]result = {0}", l_info.error)
    if l_info.error == ErrorCode.ERR_SUCCESS then
        MNetClient.NetLoginStep = ENetLoginStep.LoginServerLogged
        if l_info.account_info and l_info.account_info.openid then
            if not string.ro_isEmpty(l_info.account_info.openid) then
                self.AuthData.SetAccountInfo(l_info.account_info.openid)
            end
        else
            logError("CertifyRes account_info openid is null")
        end
        self.AuthData.SetLoginAuthInfo(l_info.loginToken, l_info.loginzoneid)
        --初始化白名单用户
        MSpecialUserManager.InitUser(l_info.tag)

        if self.reloginReason == ReloginReason.RefreshLoginToken then
            self:ConnectGateServer()
        elseif self.reloginReason == ReloginReason.RefreshGateList then
            self:FetchGateServerList(false)
        elseif self.reloginReason == ReloginReason.DealAgreement then
            MgrMgr:GetMgr("UseAgreementProtoMgr").ReqAcceptGameAgreement()
        else
            -- 初始化sdk用户信息
            MgrMgr:GetMgr("CrashReportMgr").SetUserId(self.AuthData.GetAccountInfo().account)
            local arg = {
                property = "userId",
                value = self.AuthData.GetAccountInfo().account
            }
            MStatistics.AnalyticsSetUserProperty(CJson.encode({json = CJson.encode(arg)}))

            --拉取服务器信息
            self:FetchGateServerList(true)
        end
    else
        CommonUI.Dialog.HideWaiting()
        MNetClient.NetLoginStep = ENetLoginStep.Begin
        if l_info.error == ErrorCode.ERR_ACCOUNT_INVALID then --帐号没权限
            self:ShowImportantDialog(Common.Utils.Lang("ACCOUNT_INVALID"), nil)
            --验证失败退出sdk登录信息
            MLogin.Logout()
        elseif l_info.error == ErrorCode.ERR_PLAT_BANACC then --帐号被封禁
            if l_info.baninfo ~= nil and l_info.baninfo.endtime ~= nil then
                MgrMgr:GetMgr("PlayerGameStateMgr").ShowPlayerBanInfo(l_info.baninfo, false)
            end
        elseif l_info.error == ErrorCode.ERR_VERSION_FAILED then --客户端版本与服务器版本不匹配
            self:ShowImportantDialog(Common.Utils.Lang("ERR_VERSION_FAILED"), nil)
        elseif l_info.error == ErrorCode.ERR_LOGIN_VERIFY_FAILED then --服务器处理登录失败
            self:ShowImportantDialog(Common.Utils.Lang("ERR_LOGIN_VERIFY_FAILED"), nil)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        end
    end
end

--[Comment]
--获取服列表
--@param bool forLogin true:登录时获取列表 false:刷新列表
function BaseAuthMgr:FetchGateServerList(forLogin)
    if MNetClient.NetLoginStep ~= ENetLoginStep.LoginServerLogged
        and MNetClient.NetLoginStep ~= ENetLoginStep.GateServerFetched then
        logError("[FetchGateServerList] invalid loginstep = {0}", MNetClient.NetLoginStep)
        return
    end

    if not MNetClient:IsConnected() then
        if forLogin then
            logError("[FetchGateServerList] socket is disconnected")
        else --刷新列表时如果loginserver连接断开了，需要重新连接
            self:ReLoginLoginServer(ReloginReason.RefreshGateList)
        end
        return
    end

    logGreen("[FetchGateServerList]step={0}", MNetClient.NetLoginStep)
    local l_platId = self:GetPlatformId()
    local l_version = MPlatformConfigManager.GetCacheOrLocal().version:ToString()
    local l_accountInfo = self.AuthData.GetAccountInfo()
    local l_loginAuthInfo = self.AuthData.GetLoginAuthInfo()
    local l_loginServerInfo = self.AuthData.GetLoginServerLocal()
    self.serverListMgr.FetchServerInfo({
        cb = handler(self, self.OnFetchGateServerList),
        forLogin = forLogin,
        mapleZoneId = l_loginServerInfo.mapleZoneId,
        token = l_loginAuthInfo.loginToken,
        account = l_accountInfo.account,
        type = self.pbLoginType,
        platid = l_platId,
        version = l_version
    })
end

function BaseAuthMgr:OnFetchGateServerList(succ, gateInfo, forLogin)
    --关闭loginserver的链接
    MNetClient:CloseConnection()

    if not succ or gateInfo == nil then
        --fetch失败处理
        if forLogin then
            CommonUI.Dialog.HideWaiting()
            self:LogoutToAccount() --登出
            self.EventDispatcher:Dispatch(EventConst.Names.ON_AUTH_FAILED)
            logRed("[OnFetchGateServerList]ON_AUTH_FAILED")
        else
            self.EventDispatcher:Dispatch(EventConst.Names.REQ_QUREY_GATE_IP_ERROR)
            logRed("[OnFetchGateServerList]REQ_QUREY_GATE_IP_ERROR")
        end

        self:ShowImportantDialog(Common.Utils.Lang("NET_FETCHING_SERVER_FAILED"), nil)
        return
    end

    --存储数据
    MNetClient.NetLoginStep = ENetLoginStep.GateServerFetched
    self.AuthData.SetCurGateServer(gateInfo)
    if forLogin then
        CommonUI.Dialog.HideWaiting()
        self.EventDispatcher:Dispatch(EventConst.Names.ON_AUTH_SUCCESS)
        -- 登录成功loginTimes + 1
        self.loginTimes = self.loginTimes + 1
        logGreen("[OnFetchGateServerList]ON_AUTH_SUCCESS")
    else
        self.EventDispatcher:Dispatch(EventConst.Names.REQ_QUREY_GATE_IP_SUCCESS)
        logGreen("[OnFetchGateServerList]REQ_QUREY_GATE_IP_SUCCESS")
    end
end

function BaseAuthMgr:ConnectGateServer()
    if not self:CheckConfigValid() then
        return
    end

    CommonUI.Dialog.ShowWaiting(g_Globals.NETWORK_DELAYTIME)
    local l_canLogin = self:CheckGateLoginLimit()
    if not l_canLogin then
        CommonUI.Dialog.HideWaiting()
        return
    end

    MoonCommonLib.MHotUpdateHelper.CheckVersion(function (needUpdate)
        logGreen("[ConnectGateServer]检测热更新 = {0}]", needUpdate)
        if needUpdate then
            CommonUI.Dialog.HideWaiting()
            self:ShowImportantDialog(Common.Utils.Lang("HAVENEWUPDATE_RESTART_PLEASE"), function ()
                MDevice.ResetGame()
            end)
        else
            local l_loginAuthInfo = self.AuthData.GetLoginAuthInfo()
            if l_loginAuthInfo.loginToken == "" then
                self:ReLoginLoginServer(ReloginReason.RefreshLoginToken)
                return
            end

            local l_gateInfo = self.AuthData.GetCurGateServer()
            logGreen("[ConnectGateServer]GateServerIP:ip = "..l_gateInfo.ip.." | port = ".. tostring(l_gateInfo.port))

            -- 连接到游戏网关服务器
            MNetClient.GateServerIP = l_gateInfo.ip
            MNetClient.GateServerPort = l_gateInfo.port
            MNetClient:Connect(l_gateInfo.ip, l_gateInfo.port)
        end
    end)
end

function BaseAuthMgr:LoginGateServer()
    local l_msgId = Network.Define.Rpc.ClientLoginRequest
    local l_gateInfo = self.AuthData.GetCurGateServer()
    local l_accountInfo = self.AuthData.GetAccountInfo()
    local l_loginAuthInfo = self.AuthData.GetLoginAuthInfo()
    ---@type LoginArg
    local l_sendInfo = GetProtoBufSendTable("LoginArg")
    l_sendInfo.gameserverid = l_gateInfo.serverid
    l_sendInfo.openid = l_accountInfo.account
    l_sendInfo.loginzoneid = l_loginAuthInfo.loginZoneId
    l_sendInfo.token = l_loginAuthInfo.loginToken

    local diffClientInfo = self:GetClientInfo()
    l_sendInfo.clientInfo.PlatID = MDevice.GetPlatType()--平台Id
    l_sendInfo.clientInfo.ClientVersion = MPlatformConfigManager.GetCacheOrLocal().version:ToString()--版本号
    l_sendInfo.clientInfo.SystemSoftware = SystemInfo.operatingSystem--操作系统
    l_sendInfo.clientInfo.SystemHardware = SystemInfo.deviceModel--硬件
    l_sendInfo.clientInfo.TelecomOper = MDevice.GetProvidersName()--供应商
    l_sendInfo.clientInfo.Network = MDevice.GetNetworkType()--网络类型：wifi 3g 4g
    l_sendInfo.clientInfo.ScreenWidth = Screen.width--显示屏宽度
    l_sendInfo.clientInfo.ScreenHight = Screen.height--显示屏高度
    l_sendInfo.clientInfo.CpuHardware = SystemInfo.processorType.."|"..SystemInfo.processorFrequency.."|"..SystemInfo.processorCount--cpu类型|频率|核数
    l_sendInfo.clientInfo.logintype = self.pbLoginType --登录类型
    l_sendInfo.clientInfo.RegChannel = diffClientInfo.regChannelId
    l_sendInfo.clientInfo.LoginChannel = diffClientInfo.channelId
    l_sendInfo.clientInfo.picurl = diffClientInfo.picurl
    l_sendInfo.clientInfo.token = diffClientInfo.token
    l_sendInfo.clientInfo.Density = Screen.dpi--像素密度
    l_sendInfo.clientInfo.Memory = SystemInfo.systemMemorySize--设备内存
    l_sendInfo.clientInfo.GLRender = SystemInfo.graphicsDeviceName.."|"..tostring(SystemInfo.graphicsDeviceType).."|"..SystemInfo.graphicsDeviceVendor--显卡信息
    l_sendInfo.clientInfo.GLVersion = SystemInfo.graphicsDeviceVersion--Shader等级
    l_sendInfo.clientInfo.DeviceId = SystemInfo.deviceUniqueIdentifier--设备唯一Id
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil)
    logGreen("[LoginGateServer]start to login gateserver, args={0}", table.ro_kvConcat(l_sendInfo))
end

function BaseAuthMgr:OnLoginGateServer(msg)
    local l_info = ParseProtoBufToTable("LoginRes", msg)
    logGreen("[OnLoginGateServer]result = {0}", l_info.result)
    if l_info.result ~= ErrorCode.ERR_SUCCESS and l_info.result ~= ErrorCode.ERR_ACCOUNT_QUEUING then
        self:OnLoginGateServerFailed(l_info)
    else
        CommonUI.Dialog.HideWaiting()
        MNetClient.NetLoginStep = ENetLoginStep.GateServerLogged

        MPlayerSetting.LoginFailedTimes = 0
        MPlayerInfo.SessionId = l_info.session_id

        if l_info.result == ErrorCode.ERR_ACCOUNT_QUEUING then
            --进入排队状态
            self:OnEnterQueuing(l_info.accountData)
        else
            --进入新建角色
            MgrMgr:GetMgr("SelectRoleMgr").EnterCreateRole(l_info.accountData)
        end
    end
end

function BaseAuthMgr:OnLoginGateServerFailed(msg)
    CommonUI.Dialog.HideWaiting()
    MNetClient.NetLoginStep = ENetLoginStep.GateServerFetched

    local l_errCode = msg.result
    if l_errCode == ErrorCode.ERR_LOGIN_VERIFY_FAILED then --token过期了
        self:ShowImportantDialog(Common.Utils.Lang("NET_LOGIN_FAILED"), function()
            self:LogoutToAccount()
        end)
    elseif l_errCode == ErrorCode.ERR_REGISTER_NUM_LIMIT then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_errCode))
    elseif l_errCode == ErrorCode.ERR_PLAT_BANACC then
        MgrMgr:GetMgr("PlayerGameStateMgr").ShowPlayerBanInfo(msg.ban_acc, false)
    elseif l_errCode == ErrorCode.ERR_LOGIN_NOT_IN_WHITE_LIST then --服务器维护状态
        MgrMgr:GetMgr("MaintenanceDialogMgr").ShowMaintenanceDialog(msg.maintaininfo,msg.maintainendtime)
        --刷新gateserver状态
        self:FetchGateServerList(false)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_errCode))
        MPlayerSetting.LoginFailedTimes = MPlayerSetting.LoginFailedTimes + 1
        MPlayerSetting.LastLoginFailedTime = System.DateTime.Now
    end
end

--验证过程中
function BaseAuthMgr:OnAuthingGameDisconnected(errCode)
    logRed("[OnAuthingGameDisconnected]loginstep={0}, errorCode={1}", MNetClient.NetLoginStep, errCode)
    CommonUI.Dialog.HideWaiting()

    local l_txt
    if errCode == ENetErrCode.Net_ConnectTimeout then
        l_txt = Common.Utils.Lang("NET_CONNECTLOGINSVR_FAILED")
    else
        l_txt = Common.Utils.Lang("NET_CLOSE_BY_BADNETWORK")
    end
    self:ShowImportantDialog(l_txt, function()
        self:LogoutToAccount()
    end)
end

function BaseAuthMgr:OnEnteringGameDisconnected(errCode)
    logRed("[OnEnteringGameDisconnected]loginstep={0}", MNetClient.NetLoginStep)
    CommonUI.Dialog.HideWaiting()
    local l_txt = Common.Utils.Lang("NET_CLOSE_BY_BADNETWORK")
    self:ShowImportantDialog(l_txt, function()
        self:LogoutToGame()
    end)
end

--连接被服务端关掉
function BaseAuthMgr:OnGamePlayingDisconnected()
    logRed("[OnGamePlayingDisconnected]loginstep={0}", MNetClient.NetLoginStep)
    CommonUI.Dialog.HideWaiting()
    local l_txt = Common.Utils.Lang("NET_CLOSED_BY_SERVER")
    self:ShowImportantDialog(l_txt, handler(self, self.LogoutToAccount))
end

--#region 排队

local l_accountData
function BaseAuthMgr:ShowQueuing()
    local l_txt = Common.Utils.Lang("QUEUEING_WAITING_INFO")
    local l_confirm = Common.Utils.Lang("DLG_BTN_NO")
    local l_onConfirm = function()
        self:QuitQueuing(false)
    end
    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.OK, true, nil, l_txt, l_confirm, "", l_onConfirm, nil, 0, 0, nil, function(ctrl)
        ctrl:SetOverrideSortLayer(UI.UILayerSort.Top + 1)
    end, nil, true)
end

--进入排队状态
function BaseAuthMgr:OnEnterQueuing(accountData)
    if self.queuing == true then
        return
    end
    self.queuing = true

    MStatistics.DoStatistics(CJson.encode({
        tag = MLuaCommonHelper.Enum2Int(TagPoint.WaitQueue),
        status = true,
        msg = self.loginType,
        authorize = false,
        finish = false
    }))

    self:ShowQueuing()
    l_accountData = accountData

    if self.l_timer ~= nil then
        self.l_timer:Stop()
        self.l_timer = nil
    end
    self.l_timer = Timer.New(function()
        logGreen("请求队列信息")
        ---@type CheckQueuingReq
        local l_sendInfo = GetProtoBufSendTable("CheckQueuingReq")
        local l_msgId = Network.Define.Ptc.CheckQueuingReq
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end, 15, -1)
    self.l_timer:Start()
end

--返回排队信息
function BaseAuthMgr:OnQueuingNtf(msg)
    ---@type CheckQueuingNtf
    local l_info = ParseProtoBufToTable("CheckQueuingNtf", msg)
    local l_errorcode = l_info.errorcode
    -- local l_rolecount = l_info.rolecount
    -- local l_timeleft = l_info.timeleft
    -- local l_leftmin = math.modf(l_timeleft / 60)
    -- local l_leftsec = math.fmod(l_timeleft,60)

    if l_errorcode == ErrorCode.ERR_SUCCESS then
        logGreen("等待完成，自动登录！")
        self:QuitQueuing(true)
    else
        logGreen("展示排队信息: code="..tostring(l_errorcode))
        self:ShowQueuing()
    end
end

--退出排队
--isQueueOK 是否排队成功
function BaseAuthMgr:QuitQueuing(isQueueOK)
    self.queuing = false
    if self.l_timer ~= nil then
        self.l_timer:Stop()
        self.l_timer = nil
    end

    if UIMgr:IsActiveUI(UI.CtrlNames.Dialog) then
        UIMgr:DeActiveUI(UI.CtrlNames.Dialog)
    end

    if isQueueOK then
        --进入新建角色
        MgrMgr:GetMgr("SelectRoleMgr").EnterCreateRole(l_accountData)
    else
        self:LogoutToGame()
    end
end

function BaseAuthMgr:IsInQueue()
    return self.queuing
end
--#endregion 排队

-- #region 公用接口

--[Comment]
--防止登录Gate过于频繁
function BaseAuthMgr:CheckGateLoginLimit()
    local l_lefttime = 0
    if MPlayerSetting.LoginFailedTimes >= 6 then
        l_lefttime = (MPlayerSetting.LastLoginFailedTime:AddSeconds(20) - System.DateTime.Now).TotalSeconds
    elseif MPlayerSetting.LoginFailedTimes >= 3 then
        l_lefttime = (MPlayerSetting.LastLoginFailedTime:AddSeconds(10) - System.DateTime.Now).TotalSeconds
    end
    if l_lefttime > 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_WAIT_TIME_TO_LOGIN", math.ceil(l_lefttime)))
        return false
    else
        return true
    end
end

function BaseAuthMgr:_doLogout(cb)
    --调用登出协议
    if MNetClient:IsConnected() then
        local l_msgId = Network.Define.Ptc.ClientLogout
        local l_sendInfo = GetProtoBufSendTable("NullArg")
        Network.Handler.SendPtc(l_msgId, l_sendInfo, function(msgId)
            --断开连接
            MNetClient:CloseConnection()
            if type(cb) == "function" then
                cb()
            end
            --回到初始登录界面
            game:SwitchStage(MStageEnum.Login, 46)
        end)
    else
        if type(cb) == "function" then
            cb()
        end
        --回到初始登录界面
        game:SwitchStage(MStageEnum.Login, 46)
    end

    self.queuing = false
end

--@override
--返回到未登录帐号
function BaseAuthMgr:LogoutToAccount()
    MNetClient.NetLoginStep = ENetLoginStep.Begin
    self:_doLogout(function()
        -- 清除数据
        self.AuthData.ClearAccountInfo()
        MPlayerInfo.SessionId = 0
        --sdk登出
        MLogin.Logout()

        -- 生命周期
        self:OnLogoutToAccount()
        self.EventDispatcher:Dispatch(EventConst.Names.ON_ACCOUNT_LOGOUT_EVENT)
    end)
end

--返回到已登录帐号，未登录游戏服
function BaseAuthMgr:LogoutToGame()
    MNetClient.NetLoginStep = ENetLoginStep.GateServerFetched
    self:_doLogout(function()
        -- 生命周期
        self:OnLogoutToGame()
        self.EventDispatcher:Dispatch(EventConst.Names.ON_GAME_LOGOUT_EVENT)
    end)
end

--返回到已登录游戏服，未选角
function BaseAuthMgr:LogoutToSelectRole()
    MgrMgr:GetMgr("SelectRoleMgr").BackToSelectRole()
end

function BaseAuthMgr:OnLogoutToAccount()
    self:OnLogoutToGame()
end

function BaseAuthMgr:OnLogoutToGame()

    -- Lua周期
    MgrMgr:OnLogout()

    UIMgr:DeActiveAllPanels()
    -- C#周期
    MGame:OnLogout()
end

--处理同意协议
function BaseAuthMgr:DealAgreement()
    -- 当前socket断开，需要重新连接
    logGreen("[BaseAuthMgr]DealAgreement")
    self:ReLoginLoginServer(ReloginReason.DealAgreement)
end

function BaseAuthMgr:ShowImportantDialog(txt, callback)
    CommonUI.Dialog.ShowOKDlg(true, nil, txt, callback, 0, 0, nil, function(ctrl)
        ctrl:SetOverrideSortLayer(UI.UILayerSort.Top + 1)
    end)
end

function BaseAuthMgr:GetPlatformId()
    if MGameContext.IsAndroid then
        return PlatType.PLAT_ANDROID
    elseif MGameContext.IsIOS then
        return PlatType.PLAT_IOS
    else
        return PlatType.PLAT_PC
    end
end

function BaseAuthMgr:GetServerList()
    return self.serverListMgr:GetServerList()
end

function BaseAuthMgr:CheckConfigValid()
    local l_config = MPlatformConfigManager.GetCacheOrLocal()
    if MGameContext.IsPublish and not MPlatformConfigManager.Validation(l_config) then
        MoonCommonLib.MUpdater.singleton:ClearCaches()
        CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.OK, true, nil, Lang("CONFIG_VERIFY_ERROR"), Lang("DLG_BTN_OK"), "", function() 
            MDevice.QuitApplication()
        end)
        return false
    end

    return true
end

return BaseAuthMgr