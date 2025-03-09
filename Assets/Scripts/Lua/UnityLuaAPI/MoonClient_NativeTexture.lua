---@class MoonClient.NativeTexture
---@field public Tex UnityEngine.Texture2D
---@field public Width number
---@field public Height number
---@field public FromStreamingAssets boolean

---@type MoonClient.NativeTexture
MoonClient.NativeTexture = { }
---@return MoonClient.NativeTexture
---@param filePath string
---@param fromStreamingAssets boolean
---@param format number
function MoonClient.NativeTexture.New(filePath, fromStreamingAssets, format) end
function MoonClient.NativeTexture:Dispose() end
return MoonClient.NativeTexture
