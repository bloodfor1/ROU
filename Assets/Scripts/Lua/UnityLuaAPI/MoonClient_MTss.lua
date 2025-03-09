---@class MoonClient.MTss

---@type MoonClient.MTss
MoonClient.MTss = { }
---@param bytes System.Byte[]
---@param length number
function MoonClient.MTss.OnRcvWhichNeedToSendClientSdk(bytes, length) end
function MoonClient.MTss.OnStartSend() end
---@param jsondata string
function MoonClient.MTss.OnTssSdkLogin(jsondata) end
return MoonClient.MTss
