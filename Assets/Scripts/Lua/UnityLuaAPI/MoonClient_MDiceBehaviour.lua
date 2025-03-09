---@class MoonClient.MDiceBehaviour : UnityEngine.MonoBehaviour
---@field public gameObjects UnityEngine.GameObject[]

---@type MoonClient.MDiceBehaviour
MoonClient.MDiceBehaviour = { }
---@return MoonClient.MDiceBehaviour
function MoonClient.MDiceBehaviour.New() end
---@param dir number
---@param spriteName string
---@param atlasName string
function MoonClient.MDiceBehaviour:SetDirSprite(dir, spriteName, atlasName) end
return MoonClient.MDiceBehaviour
