---@class MoonClient.MNetClient : MoonCommonLib.MSingleton_MoonClient.MNetClient
---@field public LastNetLoginStep number
---@field public NetLoginStep number
---@field public GateServerIP string
---@field public GateServerPort number
---@field public ConnectionObj MoonClient.MConnection

---@type MoonClient.MNetClient
MoonClient.MNetClient = { }
---@return MoonClient.MNetClient
function MoonClient.MNetClient.New() end
---@return MoonClient.MProtocolBase
---@param protoId number
---@param isRpc boolean
---@param reqBuff System.Byte[]
---@param buffLen number
---@param onSendSuccess (fun():void)
---@param onResp (fun():void)
---@param onErr (fun():void)
---@param onTimeout (fun():void)
function MoonClient.MNetClient:SendByLua(protoId, isRpc, reqBuff, buffLen, onSendSuccess, onResp, onErr, onTimeout) end
---@return boolean
---@param protoId number
---@param buff System.Byte[]
---@param buffLen number
---@param onSendSuccess (fun():void)
---@param onResp (fun():void)
---@param onErr (fun():void)
---@param onTimeout (fun():void)
function MoonClient.MNetClient:SendRpcByLua(protoId, buff, buffLen, onSendSuccess, onResp, onErr, onTimeout) end
---@param types System.Collections.Generic.Dictionary_System.UInt32_System.Boolean
function MoonClient.MNetClient:setLuaProtoDict(types) end
---@return boolean
---@param protoId number
function MoonClient.MNetClient:IsNeedProcessByLua(protoId) end
---@return boolean
---@param protoId number
function MoonClient.MNetClient:IsOnlyProcessByLua(protoId) end
---@return boolean
function MoonClient.MNetClient:Init() end
function MoonClient.MNetClient:Uninit() end
function MoonClient.MNetClient:Update() end
---@return boolean
---@param ip string
---@param port number
function MoonClient.MNetClient:Connect(ip, port) end
function MoonClient.MNetClient:Reconnect() end
---@param err number
---@param args System.Object
function MoonClient.MNetClient:CloseConnection(err, args) end
---@param errorCode number
function MoonClient.MNetClient:KickedByServer(errorCode) end
---@return boolean
function MoonClient.MNetClient:IsConnected() end
---@return boolean
---@param protocol MoonClient.MProtocolBase
function MoonClient.MNetClient:Send(protocol) end
---@param pause boolean
function MoonClient.MNetClient:OnGamePaused(pause) end
---@param clearAccountData boolean
function MoonClient.MNetClient:OnLogout(clearAccountData) end
---@return boolean
function MoonClient.MNetClient:IsWifiEnable() end
return MoonClient.MNetClient
