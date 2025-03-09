---@class FaceToCameraObjPrepareData : UnityEngine.MonoBehaviour
---@field public FaceToCameraObjs FaceToCameraObj[]

---@type FaceToCameraObjPrepareData
FaceToCameraObjPrepareData = { }
---@return FaceToCameraObjPrepareData
function FaceToCameraObjPrepareData.New() end
---@param active boolean
function FaceToCameraObjPrepareData:CustomActive(active) end
return FaceToCameraObjPrepareData
