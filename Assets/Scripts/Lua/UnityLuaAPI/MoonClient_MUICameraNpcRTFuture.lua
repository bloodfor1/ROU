---@class MoonClient.MUICameraNpcRTFuture : MoonClient.MUICameraRTFuture
---@field public Npc MoonClient.MNpc
---@field public Offset UnityEngine.Vector3

---@type MoonClient.MUICameraNpcRTFuture
MoonClient.MUICameraNpcRTFuture = { }
---@return MoonClient.MUICameraNpcRTFuture
function MoonClient.MUICameraNpcRTFuture.New() end
---@param width number
---@param height number
---@param npcId number
---@param offset UnityEngine.Vector3
---@param limitRotate boolean
function MoonClient.MUICameraNpcRTFuture:Init(width, height, npcId, offset, limitRotate) end
function MoonClient.MUICameraNpcRTFuture:Update() end
function MoonClient.MUICameraNpcRTFuture:Uninit() end
function MoonClient.MUICameraNpcRTFuture:Release() end
return MoonClient.MUICameraNpcRTFuture
