---@class MoonClient.MPlayerSetting.SoundVolumeData
---@field public SOUND_MAIN_ON string
---@field public SOUND_CHAT_ON string
---@field public SOUND_BGM_ON string
---@field public SOUND_SE_ON string
---@field public SOUND_MAIN_STATE_ON string
---@field public SOUND_CHAT_STATE_ON string
---@field public SOUND_BGM_STATE_ON string
---@field public SOUND_SE_STATE_ON string
---@field public SoundMainVolume number
---@field public SoundChatVolume number
---@field public SoundBgmVolume number
---@field public SoundSeVolume number
---@field public SoundMainVolumeState boolean
---@field public SoundChatVolumeState boolean
---@field public SoundBgmVolumeState boolean
---@field public SoundSeVolumeState boolean

---@type MoonClient.MPlayerSetting.SoundVolumeData
MoonClient.MPlayerSetting.SoundVolumeData = { }
---@return MoonClient.MPlayerSetting.SoundVolumeData
function MoonClient.MPlayerSetting.SoundVolumeData.New() end
---@return number
---@param t number
function MoonClient.MPlayerSetting.SoundVolumeData:GetVolumeByType(t) end
---@param t number
---@param value number
function MoonClient.MPlayerSetting.SoundVolumeData:SetVolumeByType(t, value) end
---@return boolean
---@param t number
function MoonClient.MPlayerSetting.SoundVolumeData:GetVolumeStateByType(t) end
---@param t number
---@param state boolean
function MoonClient.MPlayerSetting.SoundVolumeData:SetVolumeStateByType(t, state) end
---@param t number
function MoonClient.MPlayerSetting.SoundVolumeData:UpdateVolume(t) end
---@param group string
function MoonClient.MPlayerSetting.SoundVolumeData:LoadVolumeData(group) end
return MoonClient.MPlayerSetting.SoundVolumeData
