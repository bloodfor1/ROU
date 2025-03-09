---@class MoonClient.MCameraModeBaseComponent : MoonClient.MCameraBaseComponent
---@field public CameraModeType number
---@field public IsOpenSky boolean
---@field public Enabled boolean

---@type MoonClient.MCameraModeBaseComponent
MoonClient.MCameraModeBaseComponent = { }
---@param lastState number
function MoonClient.MCameraModeBaseComponent:OnCameraStateEnter(lastState) end
---@param nextState number
function MoonClient.MCameraModeBaseComponent:OnCameraStateExit(nextState) end
return MoonClient.MCameraModeBaseComponent
