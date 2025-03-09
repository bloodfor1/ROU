---@class ROGameLibs.LuaSkillConditionArgs
---@field public need_tips_ boolean

---@type ROGameLibs.LuaSkillConditionArgs
ROGameLibs.LuaSkillConditionArgs = { }
---@overload fun(): ROGameLibs.LuaSkillConditionArgs
---@return ROGameLibs.LuaSkillConditionArgs
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.LuaSkillConditionArgs.New(cPtr, cMemoryOwn) end
function ROGameLibs.LuaSkillConditionArgs:ReturnPool() end
---@return ROGameLibs.LuaSkillConditionArgs
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.LuaSkillConditionArgs.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.LuaSkillConditionArgs.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.LuaSkillConditionArgs:getPtr() end
function ROGameLibs.LuaSkillConditionArgs:Dispose() end
return ROGameLibs.LuaSkillConditionArgs
