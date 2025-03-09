---@class MoonClient.MPlayerSetting.SoundChatData
---@field public CHAT_WORLD_ON string
---@field public CHAT_TEAM_ON string
---@field public CHAT_GUILD_ON string
---@field public CHAT_CURRENT_ON string
---@field public CHAT_WIFI_AUTO_ON string
---@field public ChatWorldState boolean
---@field public ChatTeamState boolean
---@field public ChatGuildState boolean
---@field public ChatCurrentState boolean
---@field public ChatWifiAutoState boolean

---@type MoonClient.MPlayerSetting.SoundChatData
MoonClient.MPlayerSetting.SoundChatData = { }
---@return MoonClient.MPlayerSetting.SoundChatData
function MoonClient.MPlayerSetting.SoundChatData.New() end
---@return boolean
---@param t number
function MoonClient.MPlayerSetting.SoundChatData:GetChatStateByType(t) end
---@param t number
---@param state boolean
function MoonClient.MPlayerSetting.SoundChatData:SetChatStateByType(t, state) end
---@param group string
function MoonClient.MPlayerSetting.SoundChatData:LoadChatData(group) end
return MoonClient.MPlayerSetting.SoundChatData
