---@class MoonClient.MLuaItemInterfaces
---@field public C_STR_BASE_EXP string
---@field public C_STR_JOB_EXP string
---@field public _delayJumpWord (fun(token:number, args:System.Object[]):void)

---@type MoonClient.MLuaItemInterfaces
MoonClient.MLuaItemInterfaces = { }
---@return MoonClient.MLuaItemInterfaces
function MoonClient.MLuaItemInterfaces.New() end
function MoonClient.MLuaItemInterfaces.SendCollectionEvent() end
---@param bigFish boolean
function MoonClient.MLuaItemInterfaces.SendBigFishEvent(bigFish) end
---@param itemTId number
---@param diffValue number
function MoonClient.MLuaItemInterfaces.CreateDropItemEntities(itemTId, diffValue) end
---@param diffValue int64
function MoonClient.MLuaItemInterfaces.JumpWordOnJobExp(diffValue) end
---@param diffValue int64
function MoonClient.MLuaItemInterfaces.JumpWordOnBaseValue(diffValue) end
---@param token number
---@param arg System.Object[]
function MoonClient.MLuaItemInterfaces.delayJumpWord(token, arg) end
---@param wordType number
---@param str string
function MoonClient.MLuaItemInterfaces._jumpWord(wordType, str) end
return MoonClient.MLuaItemInterfaces
