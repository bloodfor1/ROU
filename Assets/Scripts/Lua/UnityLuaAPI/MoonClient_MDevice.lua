---@class MoonClient.MDevice

---@type MoonClient.MDevice
MoonClient.MDevice = { }
---@return boolean
---@param interfacetype string
function MoonClient.MDevice.EnableSDKInterface(interfacetype) end
function MoonClient.MDevice.ResetGame() end
---@param jsondata string
function MoonClient.MDevice.CallNativeVoidFunc(jsondata) end
---@param jsondata string
function MoonClient.MDevice.PlayFullScreenMovie(jsondata) end
---@return number
function MoonClient.MDevice.GetPlatType() end
---@return string
function MoonClient.MDevice.GetDeviceModel() end
---@return string
function MoonClient.MDevice.GetOperatingSystem() end
---@return string
function MoonClient.MDevice.GetMemoryInfo() end
---@return string
function MoonClient.MDevice.GetProvidersName() end
---@return string
function MoonClient.MDevice.GetNetworkType() end
---@return System.Object
---@param jsondata string
function MoonClient.MDevice.AvailableSystemVersion(jsondata) end
---@return string
function MoonClient.MDevice.GetGraphicAPIVersion() end
---@return System.Object
---@param jsondata string
function MoonClient.MDevice.CallNativeReturnFunc(jsondata) end
---@return UnityEngine.Rect
function MoonClient.MDevice.TryGetScreenScale() end
---@overload fun(jsondata:string, callback:(fun():void)): void
---@param jsondata string
---@param action (fun(arg1:string, arg2:string):void)
function MoonClient.MDevice.CheckPermissionByType(jsondata, action) end
---@overload fun(jsondata:string, callback:(fun():void)): void
---@param jsondata string
---@param action (fun(arg1:string, arg2:string):void)
function MoonClient.MDevice.RequestPermissionByType(jsondata, action) end
function MoonClient.MDevice.OpenSettingPermission() end
---@param jsondata string
function MoonClient.MDevice.NativeToast(jsondata) end
function MoonClient.MDevice.QuitApplication() end
---@return System.Object
function MoonClient.MDevice.DumpLogcat() end
---@param parttern System.Int64[]
---@param rept number
function MoonClient.MDevice.Vibrate(parttern, rept) end
function MoonClient.MDevice.CancelVibrate() end
---@param jsondata string
function MoonClient.MDevice.AllocMonoHeap(jsondata) end
---@param jsondata string
function MoonClient.MDevice.AllocJavaHeap(jsondata) end
return MoonClient.MDevice
