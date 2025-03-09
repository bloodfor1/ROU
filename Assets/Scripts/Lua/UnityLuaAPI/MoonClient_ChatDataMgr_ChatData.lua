---@class MoonClient.ChatDataMgr.ChatData
---@field public chatUid uint64
---@field public chatTime uint64
---@field public content string
---@field public chatType number
---@field public contentID number
---@field public whoChat number
---@field public chatSquence number
---@field public audioID string
---@field public audioText string
---@field public audioDuration number
---@field public audioPlayOver boolean
---@field public extra_param string

---@type MoonClient.ChatDataMgr.ChatData
MoonClient.ChatDataMgr.ChatData = { }
---@return MoonClient.ChatDataMgr.ChatData
function MoonClient.ChatDataMgr.ChatData.New() end
return MoonClient.ChatDataMgr.ChatData
