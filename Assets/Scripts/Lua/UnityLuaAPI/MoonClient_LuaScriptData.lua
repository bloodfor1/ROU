---@class MoonClient.LuaScriptData
---@field public FuncName string

---@type MoonClient.LuaScriptData
MoonClient.LuaScriptData = { }
---@return MoonClient.LuaScriptData
function MoonClient.LuaScriptData.New() end
---@param script string
function MoonClient.LuaScriptData:Init(script) end
---@return number
---@param id string
function MoonClient.LuaScriptData:GetParam(id) end
return MoonClient.LuaScriptData
