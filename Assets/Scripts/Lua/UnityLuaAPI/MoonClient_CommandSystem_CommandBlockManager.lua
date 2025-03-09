---@class MoonClient.CommandSystem.CommandBlockManager : MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager
---@field public CommandLocalBuffList System.Collections.Generic.List_MoonClient.DeleteLocalBuffInfo
---@field public UsingNpc System.Collections.Generic.Dictionary_System.Int32_System.Int32
---@field public InterruptWhenSwitchScene string
---@field public RefWorkingBlock boolean

---@type MoonClient.CommandSystem.CommandBlockManager
MoonClient.CommandSystem.CommandBlockManager = { }
---@return MoonClient.CommandSystem.CommandBlockManager
function MoonClient.CommandSystem.CommandBlockManager.New() end
---@return boolean
---@param npcId number
function MoonClient.CommandSystem.CommandBlockManager.IsNpcUsing(npcId) end
---@param taskId number
---@param block MoonClient.CommandSystem.CommandBlock
function MoonClient.CommandSystem.CommandBlockManager.SetTaskBlock(taskId, block) end
function MoonClient.CommandSystem.CommandBlockManager.SkipAllTaskBlock() end
---@return boolean
---@param taskId number
function MoonClient.CommandSystem.CommandBlockManager.SkipTaskBlock(taskId) end
---@return boolean
function MoonClient.CommandSystem.CommandBlockManager:Init() end
---@param clearAccountData boolean
function MoonClient.CommandSystem.CommandBlockManager:OnLogout(clearAccountData) end
function MoonClient.CommandSystem.CommandBlockManager:Uninit() end
function MoonClient.CommandSystem.CommandBlockManager:OnLeaveScene() end
function MoonClient.CommandSystem.CommandBlockManager:ClearCache() end
---@return boolean
---@param hash number
---@param data MoonClient.CommandSystem.CommandBlockData
function MoonClient.CommandSystem.CommandBlockManager:GetCachedCommandBlockData(hash, data) end
---@param hash number
---@param data MoonClient.CommandSystem.CommandBlockData
function MoonClient.CommandSystem.CommandBlockManager:AddCommandBlockData(hash, data) end
---@return boolean
---@param commandScript string
---@param commandTag string
---@param npcId number
function MoonClient.CommandSystem.CommandBlockManager.CouldNpcUseCommandScript(commandScript, commandTag, npcId) end
---@param block MoonClient.CommandSystem.CommandBlock
---@param npcId number
function MoonClient.CommandSystem.CommandBlockManager.AddUsingNpc(block, npcId) end
---@param block MoonClient.CommandSystem.CommandBlock
function MoonClient.CommandSystem.CommandBlockManager.AddWorkingBlock(block) end
---@param block MoonClient.CommandSystem.CommandBlock
function MoonClient.CommandSystem.CommandBlockManager.RemoveWorkingBlock(block) end
function MoonClient.CommandSystem.CommandBlockManager.ClearWorkingBlock() end
return MoonClient.CommandSystem.CommandBlockManager
