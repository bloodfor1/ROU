---@class MFmodEventDescription
---@field public description FMOD.Studio.EventDescription
---@field public Deprecated boolean

---@type MFmodEventDescription
MFmodEventDescription = { }
---@return MFmodEventDescription
---@param description FMOD.Studio.EventDescription
function MFmodEventDescription.New(description) end
---@return System.Guid
function MFmodEventDescription:getID() end
---@return string
function MFmodEventDescription:getPath() end
---@return number
function MFmodEventDescription:getUserPropertyCount() end
---@return number
function MFmodEventDescription:getLength() end
---@return number
function MFmodEventDescription:getMinimumDistance() end
---@return number
function MFmodEventDescription:getMaximumDistance() end
---@return number
function MFmodEventDescription:getSoundSize() end
---@return boolean
function MFmodEventDescription:isSnapshot() end
---@return boolean
function MFmodEventDescription:isOneshot() end
---@return boolean
function MFmodEventDescription:isStream() end
---@return boolean
function MFmodEventDescription:is3D() end
---@return boolean
function MFmodEventDescription:isValid() end
---@return boolean
function MFmodEventDescription:hasCue() end
---@return MoonCommonLib.IMFModEventInstance
function MFmodEventDescription:createInstance() end
---@return number
function MFmodEventDescription:getInstanceCount() end
---@return MoonCommonLib.IMFModEventInstance[]
function MFmodEventDescription:getInstanceList() end
function MFmodEventDescription:loadSampleData() end
function MFmodEventDescription:unloadSampleData() end
function MFmodEventDescription:releaseAllInstances() end
---@return number
function MFmodEventDescription:getUserData() end
---@param userdata number
function MFmodEventDescription:setUserData(userdata) end
return MFmodEventDescription
