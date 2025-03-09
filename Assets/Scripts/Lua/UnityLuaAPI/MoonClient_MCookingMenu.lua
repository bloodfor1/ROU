---@class MoonClient.MCookingMenu
---@field public Uid uint64
---@field public Id number
---@field public RemainTime number
---@field public TimeLimit number
---@field public Data MoonClient.CookMenuTable.RowData

---@type MoonClient.MCookingMenu
MoonClient.MCookingMenu = { }
---@return MoonClient.MCookingMenu
function MoonClient.MCookingMenu.New() end
---@param menuId number
---@param uid uint64
---@param remainTime number
function MoonClient.MCookingMenu:Init(menuId, uid, remainTime) end
function MoonClient.MCookingMenu:Uninit() end
---@return boolean
---@param foodIds System.Collections.Generic.List_System.Int32
function MoonClient.MCookingMenu:InMenu(foodIds) end
return MoonClient.MCookingMenu
