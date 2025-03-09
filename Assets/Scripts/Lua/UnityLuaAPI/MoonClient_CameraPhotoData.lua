---@class MoonClient.CameraPhotoData
---@field public MAX_DIS number
---@field public MIN_DIS number
---@field public ORG_DIS number
---@field public MAX_ROT_Y number
---@field public MIN_ROT_Y number
---@field public ORG_ROT_Y number
---@field public MAX_IS_HORIZONTAL number
---@field public MAX_IS_VERTICAL number
---@field public ORG_OFFSET UnityEngine.Vector3
---@field public ADAPTER_THRESHOLD number

---@type MoonClient.CameraPhotoData
MoonClient.CameraPhotoData = { }
---@return MoonClient.CameraPhotoData
function MoonClient.CameraPhotoData.New() end
function MoonClient.CameraPhotoData.ResetArgs() end
return MoonClient.CameraPhotoData
