---@class MoonClient.MStateMachine : MoonClient.MComponent
---@field public ID number
---@field public State number
---@field public Current MoonClient.IMStateTransform
---@field public Previous MoonClient.IMStateTransform
---@field public Default MoonClient.IMStateTransform
---@field public CollisionLayer number

---@type MoonClient.MStateMachine
MoonClient.MStateMachine = { }
---@return MoonClient.MStateMachine
function MoonClient.MStateMachine.New() end
function MoonClient.MStateMachine:Attached() end
---@param def MoonClient.IMStateTransform
function MoonClient.MStateMachine:SetDefaultState(def) end
function MoonClient.MStateMachine:OnDetachFromHost() end
---@param hostObj MoonClient.MObject
function MoonClient.MStateMachine:OnAttachToHost(hostObj) end
---@return boolean
function MoonClient.MStateMachine:CanSkill() end
---@return boolean
---@param nextState number
function MoonClient.MStateMachine:CanTransfer(nextState) end
function MoonClient.MStateMachine:ForceToDefault() end
function MoonClient.MStateMachine:Stop() end
function MoonClient.MStateMachine:Finish() end
---@param fDeltaT number
function MoonClient.MStateMachine:Update(fDeltaT) end
---@param fDeltaT number
function MoonClient.MStateMachine:LateUpdate(fDeltaT) end
function MoonClient.MStateMachine:MarkTriggered() end
---@param speed number
function MoonClient.MStateMachine:SetAnimationSpeed(speed) end
---@param next MoonClient.IMStateTransform
function MoonClient.MStateMachine:TransferToState(next) end
return MoonClient.MStateMachine
