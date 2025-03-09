---@class LuaInterface.LuaTable : LuaInterface.LuaBaseRef
---@field public Item System.Object
---@field public Item System.Object
---@field public Length number

---@type LuaInterface.LuaTable
LuaInterface.LuaTable = { }
---@return table
---@param reference number
---@param state LuaInterface.LuaState
function LuaInterface.LuaTable.New(reference, state) end
---@return (fun():void)
---@param key string
function LuaInterface.LuaTable:RawGetLuaFunction(key) end
---@return (fun():void)
---@param key string
function LuaInterface.LuaTable:GetLuaFunction(key) end
---@param name string
function LuaInterface.LuaTable:Call(name) end
---@return string
---@param name string
function LuaInterface.LuaTable:GetStringField(name) end
---@param name string
function LuaInterface.LuaTable:AddTable(name) end
---@return System.Object[]
function LuaInterface.LuaTable:ToArray() end
---@return string
function LuaInterface.LuaTable:ToString() end
---@return LuaInterface.LuaArrayTable
function LuaInterface.LuaTable:ToArrayTable() end
---@return LuaInterface.LuaDictTable
function LuaInterface.LuaTable:ToDictTable() end
---@return table
function LuaInterface.LuaTable:GetMetaTable() end
return LuaInterface.LuaTable
