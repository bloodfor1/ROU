---@class MoonClient.ModelBoneName
---@field public WEAPON_R string
---@field public WEAPON_L string
---@field public WEAPON_FX_R string
---@field public WEAPON_FX_L string
---@field public HELMET_POINT string
---@field public BACK_POINT string
---@field public TAIL_POINT string
---@field public MOUNT_POINT string
---@field public CART_POINT string
---@field public FINGER_R string

---@type MoonClient.ModelBoneName
MoonClient.ModelBoneName = { }
---@return MoonClient.ModelBoneName
function MoonClient.ModelBoneName.New() end
---@return number
---@param boneName string
function MoonClient.ModelBoneName.GetBoneEnum(boneName) end
return MoonClient.ModelBoneName
