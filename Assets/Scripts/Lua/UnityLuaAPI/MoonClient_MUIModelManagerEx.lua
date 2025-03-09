---@class MoonClient.MUIModelManagerEx : MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx
---@field public VMATRIX2D UnityEngine.Matrix4x4
---@field public VMATRIX3D UnityEngine.Matrix4x4
---@field public PMATRIX2D UnityEngine.Matrix4x4
---@field public PMATRIX3D UnityEngine.Matrix4x4

---@type MoonClient.MUIModelManagerEx
MoonClient.MUIModelManagerEx = { }
---@return MoonClient.MUIModelManagerEx
function MoonClient.MUIModelManagerEx.New() end
---@return uint64
function MoonClient.MUIModelManagerEx:GetTempUID() end
---@return boolean
function MoonClient.MUIModelManagerEx:Init() end
function MoonClient.MUIModelManagerEx:Uninit() end
function MoonClient.MUIModelManagerEx:Update() end
---@overload fun(data:MoonClient.MUIModelManagerEx.OriginData): MoonClient.MModel
---@return MoonClient.MModel
---@param location string
---@param img UnityEngine.UI.RawImage
---@param defaultAnim string
function MoonClient.MUIModelManagerEx:CreateModel(location, img, defaultAnim) end
---@param model MoonClient.MModel
function MoonClient.MUIModelManagerEx:DestroyModel(model) end
---@return MoonClient.MModel
---@param defaultEquipId number
---@param presentId number
---@param rawImage UnityEngine.UI.RawImage
function MoonClient.MUIModelManagerEx:CreateModelByDefaultEquipId(defaultEquipId, presentId, rawImage) end
---@return MoonClient.MAttrComponent
---@param defaultEquipId number
---@param presentId number
function MoonClient.MUIModelManagerEx:GetAttrByData(defaultEquipId, presentId) end
---@return MoonClient.MModel
---@param itemId number
---@param img UnityEngine.UI.RawImage
function MoonClient.MUIModelManagerEx:CreateModelByItemId(itemId, img) end
---@param model MoonClient.MModel
function MoonClient.MUIModelManagerEx:RefreshModel(model) end
function MoonClient.MUIModelManagerEx:ClearAllModels() end
---@param clearAccountData boolean
function MoonClient.MUIModelManagerEx:OnLogout(clearAccountData) end
---@return MoonClient.MUIModelManagerEx.OriginData
function MoonClient.MUIModelManagerEx:GetDataFromPool() end
---@param data MoonClient.MUIModelManagerEx.OriginData
function MoonClient.MUIModelManagerEx:ReturnDataToPool(data) end
---@return string
---@param id number
function MoonClient.MUIModelManagerEx:GetModelPathByItemId(id) end
---@return UnityEngine.Vector3
---@param viewMatrix UnityEngine.Matrix4x4
function MoonClient.MUIModelManagerEx:GetRotationEulerByViewMatrix(viewMatrix) end
return MoonClient.MUIModelManagerEx
