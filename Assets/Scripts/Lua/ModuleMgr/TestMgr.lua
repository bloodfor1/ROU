---@module Test
module("ModuleMgr.Test", package.seeall)


function RequestQueryGateIP()
	local l_msgId = Network.Define.Rpc.QueryGateIP
	---@type QueryGateArg
	local l_sendInfo = GetProtoBufSendTable("QueryGateArg")
	l_sendInfo.token = ""
	l_sendInfo.account = "tmgege"
	l_sendInfo.password = "123"
	l_sendInfo.type = LoginType.LOGIN_PASSWORD
	l_sendInfo.pf = ""
	l_sendInfo.openid = ""
	l_sendInfo.platid = PlatType.PLAT_ANDROID
	l_sendInfo.version = "01.100.00"

	Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnQueryGateIP(msg)
	---@type QueryGateRes
	local l_info = ParseProtoBufToTable("QueryGateRes", msg)

	-- print(tostring(l_info))
end

function RequestGetVersion()
	local l_msgId = Network.Define.Rpc.GetVersion
	---@type GetVersionArg
	local l_sendInfo = GetProtoBufSendTable("GetVersionArg")

	Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetVersion(msg)
	---@type GetVersionRes
	local l_info = ParseProtoBufToTable("GetVersionRes", msg)
	print(ToString(l_info))
end