---@class MoonClient.MSkyboxBuffer : UnityEngine.MonoBehaviour
---@field public skyMesh UnityEngine.Mesh
---@field public ToggleHeightFog boolean
---@field public Instance MoonClient.MSkyboxBuffer
---@field public CanModifySkybox boolean
---@field public SkyboxMaterial UnityEngine.Material

---@type MoonClient.MSkyboxBuffer
MoonClient.MSkyboxBuffer = { }
---@return MoonClient.MSkyboxBuffer
function MoonClient.MSkyboxBuffer.New() end
---@param enableMoon boolean
function MoonClient.MSkyboxBuffer:UpdateSkyBoxByTime(enableMoon) end
function MoonClient.MSkyboxBuffer:EnableSkybox() end
---@param disableComponent boolean
function MoonClient.MSkyboxBuffer:DisableSkybox(disableComponent) end
return MoonClient.MSkyboxBuffer
