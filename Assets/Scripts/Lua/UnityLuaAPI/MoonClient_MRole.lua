---@class MoonClient.MRole : MoonClient.MEntity
---@field public ChatRoomComp MoonClient.HUDChatRoomComponent
---@field public IsAutoFishing boolean

---@type MoonClient.MRole
MoonClient.MRole = { }
---@return MoonClient.MRole
function MoonClient.MRole.New() end
function MoonClient.MRole:Dead() end
function MoonClient.MRole:Revive() end
---@return boolean
---@param profressionId number
function MoonClient.MRole:ChangeProfressionId(profressionId) end
---@return boolean
---@param profressionId number
function MoonClient.MRole:SetPlayerEquip(profressionId) end
---@return MoonClient.ProfessionTable.RowData
---@param profressionId number
function MoonClient.MRole:SetPlayerInfo(profressionId) end
---@return boolean
---@param profressionId number
function MoonClient.MRole:ChangeProfessionInfo(profressionId) end
---@return boolean
---@param profressionId number
function MoonClient.MRole:JobSelectOver(profressionId) end
function MoonClient.MRole:Recycle() end
return MoonClient.MRole
