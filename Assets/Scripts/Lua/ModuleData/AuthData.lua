module("ModuleData.AuthData", package.seeall)

--初始化
function Init( ... )

end

--登出重置
function Logout( ... )

end

--#region LoginServer
local l_accountInfo = {account="", token=""}
function GetAccountInfo()
	return l_accountInfo
end
function SetAccountInfo(account, token)
	if account ~= nil and account ~= "" then
		l_accountInfo["account"] = account --openId
		SaveAccountLocal(account)
	end
	if token ~= nil and token ~= "" then
		l_accountInfo["token"] = token --第三方颁发的token
	end
end
function ClearAccountInfo()
	l_accountInfo["account"] = ""
	l_accountInfo["token"] = ""
end

local l_loginServer = {ip="", port=0, mapleZoneId=0}
function GetLoginServerLocal()
	return l_loginServer
end
function SetLoginServerLocal(ip, port, mapleZoneId)
	mapleZoneId = tonumber(mapleZoneId) or 0
	ip = tostring(ip)
	port = tonumber(port) or 0
	l_loginServer["ip"] = ip
	l_loginServer["port"] = port
	l_loginServer["mapleZoneId"] = mapleZoneId
end

local l_loginAuthInfo = {loginToken="", loginZoneId=0}
function GetLoginAuthInfo()
	return l_loginAuthInfo
end
function SetLoginAuthInfo(loginToken, loginZoneId)
	loginToken = tostring(loginToken)
	loginZoneId = tonumber(loginZoneId) or 0
	l_loginAuthInfo["loginToken"] = loginToken --LoginServer token
	l_loginAuthInfo["loginZoneId"] = loginZoneId --大区ID
end
function ClearLoginAuthInfo()
	l_loginAuthInfo = {loginToken="", loginZoneId=0}
end

--#endregion LoginServer

--#region GateServer
local l_curGateServer = nil
function GetCurGateServer()
	return l_curGateServer
end
function SetCurGateServer(gateInfo)
	l_curGateServer = gateInfo
end

--#endregion GateServer

-- 海外sdk的账户数据
local l_sdkUserInfo = {} -- json data
-- 获取sdk登录数据
function GetSDKUserInfo()
	return l_sdkUserInfo
end
-- 设置sdk登录数据
function SetSDKUserInfo(jsondata)
	local data = CJson.decode(jsondata)
	if data and data.result then
		if data.result == GameEnum.JoyyouSDKResult.SUCCESS then
			local httpRsp = CJson.decode(data.data)
			l_sdkUserInfo = httpRsp.data
			logGreen(ToString(l_sdkUserInfo))
			MDevice.NativeToast(CJson.encode({text = Common.Utils.Lang("AccountWelcomeBack", l_sdkUserInfo.account_name)}))
		end
	end
end
-- 获取当前sdk登录的渠道
function GetCurLoginType()
	if g_Globals.IsKorea then
		if l_sdkUserInfo and l_sdkUserInfo.channel_id then
			return tostring(l_sdkUserInfo.channel_id)
		end
	end
	return ""
end

--#region 账号

-- 存储账号到本地
function SaveAccountLocal(account)
    MPlayerSetting.LastAccount = account
end
-- 获取本地账号
function GetAccountLocal()
    return MPlayerSetting.LastAccount
end

-- 存储内测协议
function SetInnerTestAgreementProto(value)
	UserDataManager.SetDataFromLua("INNER_TEST_AGREEMENT_PROTO", MPlayerSetting.GLOBAL_SETING_GROUP, value)
end
-- 获取是否同意内测协议
function GetInnerTestAgreementProto()
	return UserDataManager.GetStringDataOrDef("INNER_TEST_AGREEMENT_PROTO", MPlayerSetting.GLOBAL_SETING_GROUP, "none")
end

-- joyyou游客账号第一次登录存储
function SetJoyyouVisitorFirstLogin(value)
	UserDataManager.SetDataFromLua("JOYYOU_VISITOR_FIRST_LOGIN", MPlayerSetting.GLOBAL_SETING_GROUP, value)
end
-- joyyou获取游客账号第一次登录
function GetJoyyouVisitorFirstLogin()
	return UserDataManager.GetStringDataOrDef("JOYYOU_VISITOR_FIRST_LOGIN", MPlayerSetting.GLOBAL_SETING_GROUP, "0")
end

return ModuleData.AuthData