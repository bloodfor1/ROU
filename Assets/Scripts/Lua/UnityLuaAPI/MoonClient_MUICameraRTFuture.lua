---@class MoonClient.MUICameraRTFuture
---@field public RTCamera UnityEngine.Camera
---@field public NeedUpdate boolean

---@type MoonClient.MUICameraRTFuture
MoonClient.MUICameraRTFuture = { }
---@return MoonClient.MUICameraRTFuture
function MoonClient.MUICameraRTFuture.New() end
function MoonClient.MUICameraRTFuture:Get() end
---@param width number
---@param height number
function MoonClient.MUICameraRTFuture:Init(width, height) end
---@return MoonClient.MUICameraRTFuture
---@param needUpdate boolean
function MoonClient.MUICameraRTFuture:SetNeedUpdate(needUpdate) end
function MoonClient.MUICameraRTFuture:Update() end
function MoonClient.MUICameraRTFuture:Uninit() end
function MoonClient.MUICameraRTFuture:Release() end
function MoonClient.MUICameraRTFuture:Destory() end
return MoonClient.MUICameraRTFuture
