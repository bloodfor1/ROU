---@class MoonClient.MEnvironWeatherGM
---@field public Data_Client number
---@field public Data_Trigger number
---@field public CurTemperature number

---@type MoonClient.MEnvironWeatherGM
MoonClient.MEnvironWeatherGM = { }
---@return boolean
function MoonClient.MEnvironWeatherGM.IsGMControl() end
---@param isUpdateShow boolean
function MoonClient.MEnvironWeatherGM.ClearClientAllData(isUpdateShow) end
---@return boolean
---@param dataID number
---@param isUpdateShow boolean
function MoonClient.MEnvironWeatherGM.ClearClientDataByID(dataID, isUpdateShow) end
---@return boolean
---@param dataID number
---@param periodType_ number
---@param weatherType_ number
---@param isUpdateShow boolean
function MoonClient.MEnvironWeatherGM.SetClientDataByType(dataID, periodType_, weatherType_, isUpdateShow) end
---@return number
function MoonClient.MEnvironWeatherGM.GetPeriodType() end
---@return number
function MoonClient.MEnvironWeatherGM.GetWeatherType() end
---@return MoonClient.MSceneEnvoriment.MTypeDataNames
function MoonClient.MEnvironWeatherGM.GetDataNames() end
function MoonClient.MEnvironWeatherGM.ClearServerWeatherType() end
---@return boolean
---@param sceneID number
---@param periodTypeValue number
---@param weatherTypeValue number
function MoonClient.MEnvironWeatherGM.SetServerWeatherType(sceneID, periodTypeValue, weatherTypeValue) end
function MoonClient.MEnvironWeatherGM.UpdateWeatherData() end
---@return boolean
---@param sceneID number
---@param periodType_ number
---@param weatherType_ number
---@param mTypeDataNames MoonClient.MSceneEnvoriment.MTypeDataNames
---@param temperature System.Int32
function MoonClient.MEnvironWeatherGM.IsExistCombine(sceneID, periodType_, weatherType_, mTypeDataNames, temperature) end
---@return string
function MoonClient.MEnvironWeatherGM.GetCurPeriodTypeName() end
---@return string
function MoonClient.MEnvironWeatherGM.GetCurWeatherTypeName() end
---@return string
function MoonClient.MEnvironWeatherGM.GetCurTemperatureStateName() end
---@return boolean
function MoonClient.MEnvironWeatherGM.IsRainWeather() end
---@return boolean
---@param sceneID number
---@param durationHour number
---@param listWeatherType System.Collections.Generic.List_MoonClient.MSceneEnvoriment.MWeatherType
function MoonClient.MEnvironWeatherGM.GetDurationWeatherTypeList(sceneID, durationHour, listWeatherType) end
---@return System.Collections.Generic.List_System.Int32
---@param sceneID number
---@param durationHour number
function MoonClient.MEnvironWeatherGM.GetDurationWeatherTypeListInLua(sceneID, durationHour) end
return MoonClient.MEnvironWeatherGM
