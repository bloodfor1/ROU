---@class MoonClient.MCameraPhotoComponent : MoonClient.MCameraModeBaseComponent
---@field public MaxRotY number
---@field public MinRotY number
---@field public IsCamRotYRangeLimit boolean
---@field public ID number
---@field public CameraModeType number
---@field public IsOpenSky boolean
---@field public MaxDistance number
---@field public MinDistance number
---@field public DefaultDistance number

---@type MoonClient.MCameraPhotoComponent
MoonClient.MCameraPhotoComponent = { }
---@return MoonClient.MCameraPhotoComponent
function MoonClient.MCameraPhotoComponent.New() end
---@param hostObj MoonClient.MObject
function MoonClient.MCameraPhotoComponent:OnAttachToHost(hostObj) end
---@param fDeltaT number
function MoonClient.MCameraPhotoComponent:LateUpdate(fDeltaT) end
---@param e MoonClient.IEventArg
function MoonClient.MCameraPhotoComponent:onCamCustomOffset(e) end
---@param lastState number
function MoonClient.MCameraPhotoComponent:OnCameraStateEnter(lastState) end
---@param nextState number
function MoonClient.MCameraPhotoComponent:OnCameraStateExit(nextState) end
---@param status boolean
function MoonClient.MCameraPhotoComponent:SetCamRotYRangeLimitStatus(status) end
---@param maxRotY number
---@param minRotY number
function MoonClient.MCameraPhotoComponent:SetCamRotYRange(maxRotY, minRotY) end
---@return number
function MoonClient.MCameraPhotoComponent:GetMaxCameraRot() end
---@return number
function MoonClient.MCameraPhotoComponent:GetMinCameraRot() end
return MoonClient.MCameraPhotoComponent
