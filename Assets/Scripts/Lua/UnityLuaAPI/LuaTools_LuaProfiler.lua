---@class LuaTools.LuaProfiler

---@type LuaTools.LuaProfiler
LuaTools.LuaProfiler = { }
---@overload fun(id:number): void
---@param id number
---@param name string
function LuaTools.LuaProfiler.BeginSample(id, name) end
function LuaTools.LuaProfiler.EndSample() end
return LuaTools.LuaProfiler
