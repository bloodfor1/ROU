---@class MoonCommonLib.MVersion
---@field public ChannelVersion number
---@field public ProgramVersion number
---@field public InnerVersion number
---@field public SourceVersion number

---@type MoonCommonLib.MVersion
MoonCommonLib.MVersion = { }
---@overload fun(): MoonCommonLib.MVersion
---@return MoonCommonLib.MVersion
---@param channelVersion number
---@param programVersion number
---@param innerVersion number
---@param sourceVersion number
function MoonCommonLib.MVersion.New(channelVersion, programVersion, innerVersion, sourceVersion) end
---@return boolean
---@param str string
---@param result MoonCommonLib.MVersion
function MoonCommonLib.MVersion.TryParse(str, result) end
---@return MoonCommonLib.MVersion
---@param str string
---@param split System.Char[]
function MoonCommonLib.MVersion.Parse(str, split) end
---@return string
function MoonCommonLib.MVersion:ToString() end
---@return string
function MoonCommonLib.MVersion:To3String() end
---@return number
function MoonCommonLib.MVersion:GetHashCode() end
---@return boolean
---@param obj System.Object
function MoonCommonLib.MVersion:Equals(obj) end
return MoonCommonLib.MVersion
