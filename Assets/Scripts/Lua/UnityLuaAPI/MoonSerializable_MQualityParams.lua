---@class MoonSerializable.MQualityParams : UnityEngine.ScriptableObject

---@type MoonSerializable.MQualityParams
MoonSerializable.MQualityParams = { }
---@return MoonSerializable.MQualityParams
function MoonSerializable.MQualityParams.New() end
---@return MoonSerializable.MQualityParamData
---@param gradeType number
function MoonSerializable.MQualityParams:GetData(gradeType) end
return MoonSerializable.MQualityParams
