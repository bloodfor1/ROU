---@class MoonCommonLib.LoginGateData
---@field public ip string
---@field public zonename string
---@field public servername string
---@field public port number
---@field public serverid number
---@field public state number
---@field public flag number
---@field public customData MoonCommonLib.LoginGateCustomData

---@type MoonCommonLib.LoginGateData
MoonCommonLib.LoginGateData = { }
---@return MoonCommonLib.LoginGateData
function MoonCommonLib.LoginGateData.New() end
return MoonCommonLib.LoginGateData
