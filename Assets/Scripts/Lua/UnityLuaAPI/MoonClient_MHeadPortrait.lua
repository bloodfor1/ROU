---@class MoonClient.MHeadPortrait : MoonCommonLib.MSingleton_MoonClient.MHeadPortrait
---@field public FaceIndex number
---@field public HairFrontIndex number
---@field public HairBackIndex number
---@field public AllHeadData System.Collections.Generic.Dictionary_System.String_MoonClient.MHeadData

---@type MoonClient.MHeadPortrait
MoonClient.MHeadPortrait = { }
---@return MoonClient.MHeadPortrait
function MoonClient.MHeadPortrait.New() end
---@return boolean
function MoonClient.MHeadPortrait:Init() end
return MoonClient.MHeadPortrait
