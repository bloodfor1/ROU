---@class MFModEventInstance
---@field public instance FMOD.Studio.EventInstance
---@field public Deprecated boolean

---@type MFModEventInstance
MFModEventInstance = { }
---@return MFModEventInstance
---@param instance FMOD.Studio.EventInstance
function MFModEventInstance.New(instance) end
---@return string
function MFModEventInstance:getPath() end
---@return MoonCommonLib.IMFmodEventDescription
function MFModEventInstance:getDescription() end
---@param volume System.Single
---@param finalvolume System.Single
function MFModEventInstance:getVolume(volume, finalvolume) end
---@param volume number
function MFModEventInstance:setVolume(volume) end
---@param pitch System.Single
---@param finalpitch System.Single
function MFModEventInstance:getPitch(pitch, finalpitch) end
---@param pitch number
function MFModEventInstance:setPitch(pitch) end
---@return MoonCommonLib.ATTRIBUTES_3D
function MFModEventInstance:get3DAttributes() end
---@param attributes MoonCommonLib.ATTRIBUTES_3D
function MFModEventInstance:set3DAttributes(attributes) end
---@param mask System.UInt32
function MFModEventInstance:getListenerMask(mask) end
---@param mask number
function MFModEventInstance:setListenerMask(mask) end
---@param index number
---@param level System.Single
function MFModEventInstance:getReverbLevel(index, level) end
---@param index number
---@param level number
function MFModEventInstance:setReverbLevel(index, level) end
---@param paused System.Boolean
function MFModEventInstance:getPaused(paused) end
---@param paused boolean
function MFModEventInstance:setPaused(paused) end
function MFModEventInstance:start() end
---@param immediate boolean
function MFModEventInstance:stop(immediate) end
---@param position System.Int32
function MFModEventInstance:getTimelinePosition(position) end
---@param position number
function MFModEventInstance:setTimelinePosition(position) end
function MFModEventInstance:release() end
---@param virtualState System.Boolean
function MFModEventInstance:isVirtual(virtualState) end
---@param name string
---@param value System.Single
---@param finalvalue System.Single
function MFModEventInstance:getParameterValue(name, value, finalvalue) end
---@param name string
---@param value number
function MFModEventInstance:setParameterValue(name, value) end
function MFModEventInstance:triggerCue() end
return MFModEventInstance
