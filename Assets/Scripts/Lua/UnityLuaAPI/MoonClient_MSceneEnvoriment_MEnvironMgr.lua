---@class MoonClient.MSceneEnvoriment.MEnvironMgr
---@field public DATA_PATH_FORMAT string
---@field public CurTemperature number
---@field public CurWeatherType number
---@field public CurPeriodType number

---@type MoonClient.MSceneEnvoriment.MEnvironMgr
MoonClient.MSceneEnvoriment.MEnvironMgr = { }
---@return MoonClient.MSceneEnvoriment.MEnvironMgr
function MoonClient.MSceneEnvoriment.MEnvironMgr.New() end
---@overload fun(weatherHour:number): string
---@return string
---@param periodType number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetNameByPeriodType(periodType) end
---@return string
---@param weatherType number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetNameByWeatherType(weatherType) end
---@return string
---@param curTemperature number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetNameByTemperature(curTemperature) end
---@return string
function MoonClient.MSceneEnvoriment.MEnvironMgr:GetCurPeriodTypeName() end
---@return string
function MoonClient.MSceneEnvoriment.MEnvironMgr:GetCurWeatherTypeName() end
---@return string
function MoonClient.MSceneEnvoriment.MEnvironMgr:GetCurTemperatureStateName() end
---@return boolean
function MoonClient.MSceneEnvoriment.MEnvironMgr:IsHasDayData() end
---@param sceneID number
function MoonClient.MSceneEnvoriment.MEnvironMgr:OnSceneLoaded(sceneID) end
function MoonClient.MSceneEnvoriment.MEnvironMgr:OnLeaveScene() end
---@return number
---@param weatherHour number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetPeriodType(weatherHour) end
---@return MoonCommonLib.MSeqList_System.Int32
---@param curDayData MoonClient.EnvironmentWeatherTable.RowData
---@param t number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetCurDayPeriodData(curDayData, t) end
---@return number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetCurDay() end
---@return string
---@param offsetHour number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetHourDisplay(offsetHour) end
---@return number
---@param offsetHour number
function MoonClient.MSceneEnvoriment.MEnvironMgr.GetCurHour(offsetHour) end
---@param isInit boolean
function MoonClient.MSceneEnvoriment.MEnvironMgr:UpdateTypeData(isInit) end
function MoonClient.MSceneEnvoriment.MEnvironMgr:RemoveUpdateCallback() end
return MoonClient.MSceneEnvoriment.MEnvironMgr
