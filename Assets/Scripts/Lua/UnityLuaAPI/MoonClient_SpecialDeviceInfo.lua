---@class MoonClient.SpecialDeviceInfo
---@field public DeviceModelName string
---@field public SafeArea UnityEngine.Rect
---@field public DeviceLevel number

---@type MoonClient.SpecialDeviceInfo
MoonClient.SpecialDeviceInfo = { }
---@return boolean
function MoonClient.SpecialDeviceInfo.SafeAreaIsFullscreen() end
---@param args MoonClient.IEventArg
function MoonClient.SpecialDeviceInfo.onScreenResolutionChange(args) end
---@param panel UnityEngine.RectTransform
---@param customRect System.Nullable_UnityEngine.Rect
function MoonClient.SpecialDeviceInfo.UpdateRect(panel, customRect) end
return MoonClient.SpecialDeviceInfo
