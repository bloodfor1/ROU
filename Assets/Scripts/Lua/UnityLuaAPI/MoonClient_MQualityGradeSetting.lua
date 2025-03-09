---@class MoonClient.MQualityGradeSetting
---@field public GRADE_DATA_CUR number
---@field public GRADE_DATA_CUSTOMIZE number
---@field public GRADE_DATA_SPECIASCENE number
---@field public IsInitQualityGrade boolean
---@field public RTResolution UnityEngine.Vector2Int

---@type MoonClient.MQualityGradeSetting
MoonClient.MQualityGradeSetting = { }
---@return MoonClient.MQualityGradeSetting
function MoonClient.MQualityGradeSetting.New() end
---@return boolean
---@param t number
function MoonClient.MQualityGradeSetting.IsExistShadowType(t) end
function MoonClient.MQualityGradeSetting.InitGradeDatas() end
---@return MoonSerializable.MQualityParamData
---@param qualityGradeType number
function MoonClient.MQualityGradeSetting.GetParamData(qualityGradeType) end
---@param hardwareQualityLevel number
---@param deviceScore number
function MoonClient.MQualityGradeSetting.InitLevel(hardwareQualityLevel, deviceScore) end
function MoonClient.MQualityGradeSetting.ResetGradeToHardware() end
---@param level number
---@param needSave boolean
function MoonClient.MQualityGradeSetting.SetCustomLevel(level, needSave) end
---@param curLevel number
function MoonClient.MQualityGradeSetting.SetCurLevel(curLevel) end
---@param customDisplayLevel number
---@param needSave boolean
function MoonClient.MQualityGradeSetting.SetCustomDisplayLevel(customDisplayLevel, needSave) end
function MoonClient.MQualityGradeSetting.ResetRTResolution() end
---@param height number
function MoonClient.MQualityGradeSetting.SetRTResolution(height) end
---@return number
function MoonClient.MQualityGradeSetting.GetCurGradeType() end
---@return number
function MoonClient.MQualityGradeSetting.GetCurLevel() end
---@return number
function MoonClient.MQualityGradeSetting.GetDeviceScore() end
---@return number
function MoonClient.MQualityGradeSetting.GetHardwareGradeType() end
---@param hardwareGradeLevel number
function MoonClient.MQualityGradeSetting.SetHardwareGradeType(hardwareGradeLevel) end
---@return number
function MoonClient.MQualityGradeSetting.GetHardwareLevel() end
---@return number
function MoonClient.MQualityGradeSetting.GetCurDisplayGrade() end
---@return number
function MoonClient.MQualityGradeSetting.GetMonsterShadow() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetMonsterShadow(dataID, value) end
---@return number
function MoonClient.MQualityGradeSetting.GetNpcShadow() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetNpcShadow(dataID, value) end
---@return number
function MoonClient.MQualityGradeSetting.GetRoleShadow() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetRoleShadow(dataID, value) end
---@return number
function MoonClient.MQualityGradeSetting.GetPlayerShadow() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetPlayerShadow(dataID, value) end
---@return number
function MoonClient.MQualityGradeSetting.GetPostType() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetPostType(dataID, value) end
---@return number
function MoonClient.MQualityGradeSetting.GetHardwareGradeModelGrade() end
---@return number
function MoonClient.MQualityGradeSetting.GetModelDisplayCompeleteNum() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetModelDisplayCompeleteNum(dataID, value) end
---@return number
---@param grade number
function MoonClient.MQualityGradeSetting.GetModelDisplayNum(grade) end
---@return number
function MoonClient.MQualityGradeSetting.GetModelLoadNum() end
---@return number
function MoonClient.MQualityGradeSetting.GetFxLevel() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetFxLevel(dataID, value) end
---@return number
function MoonClient.MQualityGradeSetting.GetFxParticleCount() end
---@param dataID number
---@param value number
function MoonClient.MQualityGradeSetting.SetFxParticleCount(dataID, value) end
---@return boolean
---@param t number
function MoonClient.MQualityGradeSetting.IsGreaterOrEqual(t) end
---@return boolean
function MoonClient.MQualityGradeSetting.IsExistCurGradeData() end
---@param enable boolean
function MoonClient.MQualityGradeSetting.EnableMipmapStreaming(enable) end
return MoonClient.MQualityGradeSetting
