---@class MoonClient.HUDSpriteData
---@field public spriteName number
---@field public position UnityEngine.Vector3
---@field public offsetX number
---@field public offsetY number
---@field public size UnityEngine.Vector2

---@type MoonClient.HUDSpriteData
MoonClient.HUDSpriteData = { }
---@return MoonClient.HUDSpriteData
function MoonClient.HUDSpriteData.New() end
---@return MoonClient.HUDSpriteData
function MoonClient.HUDSpriteData.Get() end
---@param hudSpriteData MoonClient.HUDSpriteData
function MoonClient.HUDSpriteData.Release(hudSpriteData) end
return MoonClient.HUDSpriteData
