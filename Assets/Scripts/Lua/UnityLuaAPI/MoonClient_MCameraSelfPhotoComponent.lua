---@class MoonClient.MCameraSelfPhotoComponent : MoonClient.MCameraModeBaseComponent
---@field public ID number
---@field public CameraModeType number
---@field public IsOpenSky boolean
---@field public MaxDistance number
---@field public MinDistance number
---@field public DefaultDistance number

---@type MoonClient.MCameraSelfPhotoComponent
MoonClient.MCameraSelfPhotoComponent = { }
---@return MoonClient.MCameraSelfPhotoComponent
function MoonClient.MCameraSelfPhotoComponent.New() end
---@param hostObj MoonClient.MObject
function MoonClient.MCameraSelfPhotoComponent:OnAttachToHost(hostObj) end
---@param fDeltaT number
function MoonClient.MCameraSelfPhotoComponent:LateUpdate(fDeltaT) end
---@param lastState number
function MoonClient.MCameraSelfPhotoComponent:OnCameraStateEnter(lastState) end
---@param nextState number
function MoonClient.MCameraSelfPhotoComponent:OnCameraStateExit(nextState) end
return MoonClient.MCameraSelfPhotoComponent
