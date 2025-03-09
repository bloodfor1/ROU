---@class MoonClient.MDanceComponent : MoonClient.MActionComponent
---@field public ID number
---@field public StateName string
---@field public WithBattleVehicle boolean
---@field public IsWildDance boolean
---@field public IsActiveMovable boolean
---@field public IsActiveInterrupt boolean

---@type MoonClient.MDanceComponent
MoonClient.MDanceComponent = { }
---@return MoonClient.MDanceComponent
function MoonClient.MDanceComponent.New() end
function MoonClient.MDanceComponent:OnDetachFromHost() end
---@return number
function MoonClient.MDanceComponent:GetDancePercent() end
---@return number
function MoonClient.MDanceComponent:GetDanceId() end
---@return string
---@param pre string
function MoonClient.MDanceComponent:PlayAnim(pre) end
function MoonClient.MDanceComponent:Move() end
return MoonClient.MDanceComponent
