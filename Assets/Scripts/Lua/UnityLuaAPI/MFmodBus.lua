---@class MFmodBus
---@field public bus FMOD.Studio.Bus
---@field public Deprecated boolean

---@type MFmodBus
MFmodBus = { }
---@return MFmodBus
---@param bus FMOD.Studio.Bus
function MFmodBus.New(bus) end
---@return System.Guid
function MFmodBus:getID() end
---@return string
function MFmodBus:getPath() end
---@param volume System.Single
---@param finalvolume System.Single
function MFmodBus:getVolume(volume, finalvolume) end
---@param volume number
function MFmodBus:setVolume(volume) end
---@param paused System.Boolean
function MFmodBus:getPaused(paused) end
---@param paused boolean
function MFmodBus:setPaused(paused) end
---@param mute System.Boolean
function MFmodBus:getMute(mute) end
---@param mute boolean
function MFmodBus:setMute(mute) end
---@param immediate boolean
function MFmodBus:stopAllEvents(immediate) end
function MFmodBus:lockChannelGroup() end
function MFmodBus:unlockChannelGroup() end
return MFmodBus
