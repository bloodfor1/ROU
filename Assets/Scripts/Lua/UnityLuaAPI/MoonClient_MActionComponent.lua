---@class MoonClient.MActionComponent : MoonClient.MComponent
---@field public Deprecated boolean
---@field public IsPreperformance boolean
---@field public SyncPredicted boolean
---@field public SelfState number
---@field public IsFinished boolean
---@field public Speed number
---@field public CollisionLayer number
---@field public IsUsingCurve boolean
---@field public StateName string
---@field public IsActiveMovable boolean
---@field public IsActiveInterrupt boolean
---@field public WithBattleVehicle boolean

---@type MoonClient.MActionComponent
MoonClient.MActionComponent = { }
---@return MoonClient.MActionComponent
function MoonClient.MActionComponent.New() end
function MoonClient.MActionComponent:OnDetachFromHost() end
function MoonClient.MActionComponent:OnGetPermission() end
---@param toDefault boolean
---@param selfTrans boolean
function MoonClient.MActionComponent:Stop(toDefault, selfTrans) end
function MoonClient.MActionComponent:Finish() end
---@param deltaTime number
function MoonClient.MActionComponent:StateUpdate(deltaTime) end
---@return string
---@param preState string
function MoonClient.MActionComponent:PlayAnim(preState) end
function MoonClient.MActionComponent:Move() end
return MoonClient.MActionComponent
