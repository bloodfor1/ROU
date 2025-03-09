---@class MoonClient.ExtraParamInLua
---@field public type number
---@field public param32 System.Collections.Generic.List_System.Int32
---@field public param64 System.Collections.Generic.List_System.Int64
---@field public name System.Collections.Generic.List_System.String

---@type MoonClient.ExtraParamInLua
MoonClient.ExtraParamInLua = { }
---@return MoonClient.ExtraParamInLua
function MoonClient.ExtraParamInLua.New() end
---@param eparam KKSG.ExtraParam
function MoonClient.ExtraParamInLua:Init(eparam) end
return MoonClient.ExtraParamInLua
