---@class MLuaNetworkHelper
---@field public sharedLuaSendBuffer MLuaStringBuffer
---@field public sharedLuaReceivedBuffer MLuaStringBuffer
---@field public Deprecated boolean

---@type MLuaNetworkHelper
MLuaNetworkHelper = { }
---@return MLuaNetworkHelper
function MLuaNetworkHelper.New() end
---@param protoIds table
function MLuaNetworkHelper.SetLuaOverrideDispatchers(protoIds) end
---@return boolean
---@param protoId number
---@param onSendSuccess (fun():void)
function MLuaNetworkHelper.SendPtcByLua(protoId, onSendSuccess) end
---@return boolean
---@param protoId number
---@param onResp (fun():void)
---@param onErr (fun():void)
---@param onTimeout (fun():void)
---@param onSendSuccess (fun():void)
function MLuaNetworkHelper.SendRpcByLua(protoId, onResp, onErr, onTimeout, onSendSuccess) end
---@param protoId number
---@param bytes System.Byte[]
---@param length number
function MLuaNetworkHelper:OnReceivePtc(protoId, bytes, length) end
---@param protoId number
---@param bytes System.Byte[]
---@param length number
function MLuaNetworkHelper:OnReceiveRpc(protoId, bytes, length) end
return MLuaNetworkHelper
