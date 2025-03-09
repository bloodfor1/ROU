---@class MoonClient.CommandSystem.CommandBlockTriggerManager

---@type MoonClient.CommandSystem.CommandBlockTriggerManager
MoonClient.CommandSystem.CommandBlockTriggerManager = { }
---@return MoonClient.CommandSystem.CommandBlockTriggerManager
function MoonClient.CommandSystem.CommandBlockTriggerManager.New() end
---@param eventName string
---@param args System.Collections.Generic.Dictionary_System.String_System.Object
function MoonClient.CommandSystem.CommandBlockTriggerManager.Trigger(eventName, args) end
---@param eventName string
---@param tb table
function MoonClient.CommandSystem.CommandBlockTriggerManager.LuaTrigger(eventName, tb) end
return MoonClient.CommandSystem.CommandBlockTriggerManager
