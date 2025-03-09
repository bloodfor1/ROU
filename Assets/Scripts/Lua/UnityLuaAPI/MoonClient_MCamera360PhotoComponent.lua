---@class MoonClient.MCamera360PhotoComponent : MoonClient.MCameraModeBaseComponent
---@field public ID number
---@field public CameraModeType number
---@field public IsOpenSky boolean
---@field public MaxDistance number
---@field public MinDistance number
---@field public DefaultDistance number

---@type MoonClient.MCamera360PhotoComponent
MoonClient.MCamera360PhotoComponent = { }
---@return MoonClient.MCamera360PhotoComponent
function MoonClient.MCamera360PhotoComponent.New() end
---@param hostObj MoonClient.MObject
function MoonClient.MCamera360PhotoComponent:OnAttachToHost(hostObj) end
---@param fDeltaT number
function MoonClient.MCamera360PhotoComponent:Update(fDeltaT) end
---@param fDeltaT number
function MoonClient.MCamera360PhotoComponent:LateUpdate(fDeltaT) end
---@param lastState number
function MoonClient.MCamera360PhotoComponent:OnCameraStateEnter(lastState) end
---@param nextState number
function MoonClient.MCamera360PhotoComponent:OnCameraStateExit(nextState) end
return MoonClient.MCamera360PhotoComponent
