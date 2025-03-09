---@class MoonClient.MUICameraRTManager : MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager
---@field public RTFutureList System.Collections.Generic.List_MoonClient.MUICameraRTFuture

---@type MoonClient.MUICameraRTManager
MoonClient.MUICameraRTManager = { }
---@return MoonClient.MUICameraRTManager
function MoonClient.MUICameraRTManager.New() end
---@return MoonClient.MUICameraRTFuture
---@param width number
---@param height number
function MoonClient.MUICameraRTManager:CreateRTCamera(width, height) end
---@return MoonClient.MUICameraNpcRTFuture
---@param width number
---@param height number
---@param npcId number
---@param offset UnityEngine.Vector3
function MoonClient.MUICameraRTManager:CreateNpcRTCamera(width, height, npcId, offset) end
function MoonClient.MUICameraRTManager:Update() end
return MoonClient.MUICameraRTManager
