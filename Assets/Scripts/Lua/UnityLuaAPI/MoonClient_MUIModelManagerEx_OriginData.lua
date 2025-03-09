---@class MoonClient.MUIModelManagerEx.OriginData
---@field public prefabPath string
---@field public rawImage UnityEngine.UI.RawImage
---@field public attr MoonClient.MAttrComponent
---@field public position UnityEngine.Vector3
---@field public scale UnityEngine.Vector3
---@field public rotation UnityEngine.Quaternion
---@field public isMask boolean
---@field public isCustom boolean
---@field public isCameraMatrixCustom boolean
---@field public isOneFrame boolean
---@field public useLight boolean
---@field public useCustomLight boolean
---@field public customLightDirX number
---@field public customLightDirY number
---@field public customLightDirZ number
---@field public vMatrix UnityEngine.Matrix4x4
---@field public pMatrix UnityEngine.Matrix4x4
---@field public useOutLine boolean
---@field public useShadow boolean
---@field public shadowDir UnityEngine.Vector3
---@field public width number
---@field public height number
---@field public enablePostEffect boolean
---@field public defaultAnim string
---@field public cameraPos UnityEngine.Vector3
---@field public cameraRot UnityEngine.Quaternion
---@field public isCameraPosRotCustom boolean

---@type MoonClient.MUIModelManagerEx.OriginData
MoonClient.MUIModelManagerEx.OriginData = { }
---@return MoonClient.MUIModelManagerEx.OriginData
function MoonClient.MUIModelManagerEx.OriginData.New() end
return MoonClient.MUIModelManagerEx.OriginData
