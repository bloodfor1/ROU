---@class MoonClient.HUDTextData
---@field public Text string
---@field public OffsetY number
---@field public TextColor UnityEngine.Color

---@type MoonClient.HUDTextData
MoonClient.HUDTextData = { }
---@return MoonClient.HUDTextData
function MoonClient.HUDTextData.New() end
---@return MoonClient.HUDTextData
function MoonClient.HUDTextData.Get() end
---@param hudTextData MoonClient.HUDTextData
function MoonClient.HUDTextData.Release(hudTextData) end
return MoonClient.HUDTextData
