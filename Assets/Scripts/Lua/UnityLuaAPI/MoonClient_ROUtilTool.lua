---@class MoonClient.ROUtilTool : MoonCommonLib.MSingleton_MoonClient.ROUtilTool

---@type MoonClient.ROUtilTool
MoonClient.ROUtilTool = { }
---@return MoonClient.ROUtilTool
function MoonClient.ROUtilTool.New() end
---@param entity MoonClient.MEntity
---@param t number
---@param s string
function MoonClient.ROUtilTool:LuaShowTips(entity, t, s) end
---@param s string
function MoonClient.ROUtilTool:LuaLog(s) end
---@return int64
---@param number number
function MoonClient.ROUtilTool:ToLong(number) end
return MoonClient.ROUtilTool
