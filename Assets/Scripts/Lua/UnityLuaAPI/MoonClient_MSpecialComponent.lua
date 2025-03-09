---@class MoonClient.MSpecialComponent : MoonClient.MActionComponent
---@field public ID number
---@field public StateName string
---@field public WithBattleVehicle boolean
---@field public OnSceneObj boolean
---@field public SpecialType number
---@field public IsActiveMovable boolean
---@field public IsActiveInterrupt boolean

---@type MoonClient.MSpecialComponent
MoonClient.MSpecialComponent = { }
---@return MoonClient.MSpecialComponent
function MoonClient.MSpecialComponent.New() end
function MoonClient.MSpecialComponent:OnDetachFromHost() end
---@return boolean
---@param actionId number
function MoonClient.MSpecialComponent:HaveRideAnim(actionId) end
---@return string
---@param pre string
function MoonClient.MSpecialComponent:PlayAnim(pre) end
function MoonClient.MSpecialComponent:Move() end
---@return boolean
---@param actionId number
function MoonClient.MSpecialComponent:IsDoRightAction(actionId) end
return MoonClient.MSpecialComponent
