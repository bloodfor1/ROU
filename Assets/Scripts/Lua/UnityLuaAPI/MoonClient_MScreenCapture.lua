---@class MoonClient.MScreenCapture

---@type MoonClient.MScreenCapture
MoonClient.MScreenCapture = { }
---@param callback (fun(obj:UnityEngine.Texture2D):void)
function MoonClient.MScreenCapture.TakeScreenShotFromScreenSize(callback) end
---@param rect UnityEngine.Rect
---@param callback (fun(obj:UnityEngine.Texture2D):void)
function MoonClient.MScreenCapture.TakeScreenShot(rect, callback) end
---@param ratio number
---@param borderRect UnityEngine.RectTransform
---@param callback (fun(obj:UnityEngine.Texture2D):void)
function MoonClient.MScreenCapture.TakeScreenShotWithRatio(ratio, borderRect, callback) end
---@param texture UnityEngine.Texture2D
---@param jsondata string
---@param callback (fun():void)
---@param quality number
function MoonClient.MScreenCapture.ShareSDKImg(texture, jsondata, callback, quality) end
return MoonClient.MScreenCapture
