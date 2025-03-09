---@class MoonClient.GM.MProtocolHSGM
---@field public IsStart boolean

---@type MoonClient.GM.MProtocolHSGM
MoonClient.GM.MProtocolHSGM = { }
---@return boolean
---@param port number
function MoonClient.GM.MProtocolHSGM.StartHttpServer(port) end
function MoonClient.GM.MProtocolHSGM.CloseHttpServer() end
---@param protocol MoonClient.MProtocolBase
function MoonClient.GM.MProtocolHSGM.OnServerResponse(protocol) end
---@return string
---@param protoId number
function MoonClient.GM.MProtocolHSGM.GetRespJson(protoId) end
---@param protoId number
function MoonClient.GM.MProtocolHSGM.AddWaitResponse(protoId) end
---@param protoId number
function MoonClient.GM.MProtocolHSGM.DelWaitResponse(protoId) end
function MoonClient.GM.MProtocolHSGM.ClearWaitResponse() end
---@return boolean
---@param protoId number
function MoonClient.GM.MProtocolHSGM.IsProtoIdExist(protoId) end
return MoonClient.GM.MProtocolHSGM
