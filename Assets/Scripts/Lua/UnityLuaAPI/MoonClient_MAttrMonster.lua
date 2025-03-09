---@class MoonClient.MAttrMonster : MoonClient.MAttrComponent
---@field public OwnerUID uint64
---@field public EntityName string
---@field public EntityTableData MoonClient.EntityTable.RowData
---@field public MonsterAffixIds System.Collections.Generic.List_System.Int32

---@type MoonClient.MAttrMonster
MoonClient.MAttrMonster = { }
---@return MoonClient.MAttrMonster
function MoonClient.MAttrMonster.New() end
---@return number
function MoonClient.MAttrMonster:GetMonsterUnitTypeLevel() end
---@param t number
function MoonClient.MAttrMonster:SetEntitySpecies(t) end
function MoonClient.MAttrMonster:Reset() end
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrMonster:SetOrnament(itemId, fromBag) end
---@param t number
---@param itemId number
---@param fromBag boolean
function MoonClient.MAttrMonster:SetOrnamentByType(t, itemId, fromBag) end
return MoonClient.MAttrMonster
