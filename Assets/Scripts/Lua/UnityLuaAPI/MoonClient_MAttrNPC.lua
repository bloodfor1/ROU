---@class MoonClient.MAttrNPC : MoonClient.MAttrComponent
---@field public IsLocalNPC boolean
---@field public NpcID number
---@field public NpcName string
---@field public NpcCheckRange string
---@field public NpcRangeCommandScript string
---@field public NpcRangeCommandTag string
---@field public NpcData MoonClient.NpcTable.RowData
---@field public IsDynamicNpc boolean
---@field public IsNormalType boolean
---@field public IsUnselectable boolean

---@type MoonClient.MAttrNPC
MoonClient.MAttrNPC = { }
---@return MoonClient.MAttrNPC
function MoonClient.MAttrNPC.New() end
function MoonClient.MAttrNPC:Reset() end
return MoonClient.MAttrNPC
