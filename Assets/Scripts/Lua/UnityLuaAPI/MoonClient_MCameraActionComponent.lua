---@class MoonClient.MCameraActionComponent : MoonClient.MCameraModeBaseComponent
---@field public ID number
---@field public CameraModeType number
---@field public IsOpenSky boolean
---@field public LastDis number
---@field public LastRotY number
---@field public LastRotX number
---@field public Enabled boolean

---@type MoonClient.MCameraActionComponent
MoonClient.MCameraActionComponent = { }
---@return MoonClient.MCameraActionComponent
function MoonClient.MCameraActionComponent.New() end
---@param hostObj MoonClient.MObject
function MoonClient.MCameraActionComponent:OnAttachToHost(hostObj) end
---@param fDeltaT number
function MoonClient.MCameraActionComponent:Update(fDeltaT) end
---@return boolean
---@param fDeltaT number
function MoonClient.MCameraActionComponent:BackTrackUpdate(fDeltaT) end
---@param fDeltaT number
function MoonClient.MCameraActionComponent:LateUpdate(fDeltaT) end
---@param lastState number
function MoonClient.MCameraActionComponent:OnCameraStateEnter(lastState) end
---@param nextState number
function MoonClient.MCameraActionComponent:OnCameraStateExit(nextState) end
return MoonClient.MCameraActionComponent
