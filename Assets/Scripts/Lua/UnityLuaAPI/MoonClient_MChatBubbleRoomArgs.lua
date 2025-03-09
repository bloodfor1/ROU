---@class MoonClient.MChatBubbleRoomArgs
---@field public uID uint64
---@field public room_uid uint64
---@field public name string
---@field public have_code boolean
---@field public is_captain boolean
---@field public Deprecated boolean

---@type MoonClient.MChatBubbleRoomArgs
MoonClient.MChatBubbleRoomArgs = { }
---@return MoonClient.MChatBubbleRoomArgs
function MoonClient.MChatBubbleRoomArgs.New() end
---@return MoonClient.IEventArg
function MoonClient.MChatBubbleRoomArgs:Clone() end
function MoonClient.MChatBubbleRoomArgs:Recycle() end
---@param param System.Object[]
function MoonClient.MChatBubbleRoomArgs:Init(param) end
return MoonClient.MChatBubbleRoomArgs
