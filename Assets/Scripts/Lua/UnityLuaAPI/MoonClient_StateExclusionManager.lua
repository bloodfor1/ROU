---@class MoonClient.StateExclusionManager : MoonCommonLib.MSingleton_MoonClient.StateExclusionManager
---@field public PlayerExclusionStateList System.Collections.Generic.List_MoonClient.MExlusionStates

---@type MoonClient.StateExclusionManager
MoonClient.StateExclusionManager = { }
---@return MoonClient.StateExclusionManager
function MoonClient.StateExclusionManager.New() end
function MoonClient.StateExclusionManager:Uninit() end
---@return System.Collections.Generic.List_MoonClient.MExlusionStates
function MoonClient.StateExclusionManager:GetPlayerCurrentState() end
---@param addState number
function MoonClient.StateExclusionManager:AddStateToList(addState) end
---@return number
---@param mExlusionStates number
function MoonClient.StateExclusionManager:GetExclusionStateIntNum(mExlusionStates) end
---@param fromStateCode System.Int32[]
---@param toStateCode number
function MoonClient.StateExclusionManager:ShowLogMsgByStateCode(fromStateCode, toStateCode) end
---@param fromStateCode number
---@param toStateCode number
function MoonClient.StateExclusionManager:ShowMsgByStateCode(fromStateCode, toStateCode) end
---@param targetState number
---@param currentState number
function MoonClient.StateExclusionManager:ShowMsgByTwoState(targetState, currentState) end
---@param targetState number
---@param currentState number
function MoonClient.StateExclusionManager:ShowMsgByState(targetState, currentState) end
---@return boolean
---@param targetState number
---@param showErrorTips boolean
---@param ingnoreOneLeaveOneEnter boolean
function MoonClient.StateExclusionManager:GetIsCanChangeState(targetState, showErrorTips, ingnoreOneLeaveOneEnter) end
return MoonClient.StateExclusionManager
