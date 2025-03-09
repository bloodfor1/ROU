---@class MoonClient.MVehicleComponent : MoonClient.MComponent
---@field public ID number
---@field public VehicleID number
---@field public Row MoonClient.VehicleTable.RowData
---@field public IsFlyVehicle boolean
---@field public Vehicle MoonClient.MVehicleControl
---@field public Driver MoonClient.MEntity
---@field public IsFalling boolean
---@field public IsDriver boolean

---@type MoonClient.MVehicleComponent
MoonClient.MVehicleComponent = { }
---@return MoonClient.MVehicleComponent
function MoonClient.MVehicleComponent.New() end
---@param hostObj MoonClient.MObject
function MoonClient.MVehicleComponent:OnAttachToHost(hostObj) end
function MoonClient.MVehicleComponent:OnDetachFromHost() end
---@param fDeltaT number
function MoonClient.MVehicleComponent:Update(fDeltaT) end
---@param itemId number
---@param ornamentId number
---@param dyeId number
function MoonClient.MVehicleComponent:DriverRide(itemId, ornamentId, dyeId) end
---@param driver MoonClient.MEntity
---@param vehicleId number
---@param ornamentId number
---@param dyeId number
function MoonClient.MVehicleComponent:PassengerRide(driver, vehicleId, ornamentId, dyeId) end
---@param isValidPos boolean
---@param pos KKSG.Vec3
function MoonClient.MVehicleComponent:UnRideVehicle(isValidPos, pos) end
---@param isAnim boolean
function MoonClient.MVehicleComponent:FallBreak(isAnim) end
function MoonClient.MVehicleComponent:FallFinish() end
---@return boolean
function MoonClient.MVehicleComponent:IsSingleGroundVehicle() end
---@return boolean
function MoonClient.MVehicleComponent:IsCoupleGroundVehicle() end
---@return boolean
function MoonClient.MVehicleComponent:IsSingleFlyVehicle() end
---@return boolean
function MoonClient.MVehicleComponent:IsCoupleFlyVehicle() end
return MoonClient.MVehicleComponent
