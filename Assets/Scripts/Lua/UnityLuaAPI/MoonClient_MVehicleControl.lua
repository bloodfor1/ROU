---@class MoonClient.MVehicleControl
---@field public VerticalFlySpeed number
---@field public Driver MoonClient.MEntity
---@field public VehicleID number
---@field public VehicleOrnamentID number
---@field public VehicleDyeID number
---@field public Row MoonClient.VehicleTable.RowData
---@field public IsFlyVehicle boolean
---@field public SeatNumLeft number
---@field public IsCollision boolean
---@field public VehicleModel MoonClient.MModel

---@type MoonClient.MVehicleControl
MoonClient.MVehicleControl = { }
---@return MoonClient.MVehicleControl
function MoonClient.MVehicleControl.New() end
---@param vehicleId number
---@param ornamentId number
---@param dyeId number
---@param driver MoonClient.MEntity
function MoonClient.MVehicleControl:Init(vehicleId, ornamentId, dyeId, driver) end
function MoonClient.MVehicleControl:UnInit() end
---@param entity MoonClient.MEntity
function MoonClient.MVehicleControl:AddEntity(entity) end
---@param entity MoonClient.MEntity
function MoonClient.MVehicleControl:RemoveEntity(entity) end
function MoonClient.MVehicleControl:RemoveAllPassenger() end
---@param verticalDir number
function MoonClient.MVehicleControl:Fly(verticalDir) end
---@param fDeltaT number
function MoonClient.MVehicleControl:Update(fDeltaT) end
---@param arrive (fun():void)
---@param cancel (fun():void)
function MoonClient.MVehicleControl:AutoDownStart(arrive, cancel) end
function MoonClient.MVehicleControl:AutoDownCancel() end
return MoonClient.MVehicleControl
