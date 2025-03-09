---@class MFmodVCA
---@field public vca FMOD.Studio.VCA
---@field public Deprecated boolean

---@type MFmodVCA
MFmodVCA = { }
---@return MFmodVCA
---@param vca FMOD.Studio.VCA
function MFmodVCA.New(vca) end
---@return System.Guid
function MFmodVCA:getID() end
---@return string
function MFmodVCA:getPath() end
---@param volume System.Single
---@param finalvolume System.Single
function MFmodVCA:getVolume(volume, finalvolume) end
---@param volume number
function MFmodVCA:setVolume(volume) end
return MFmodVCA
