---@class MoonSerializable.MQualityParamData
---@field public Grade number
---@field public MonsterShadow number
---@field public NpcShadow number
---@field public RoleShadow number
---@field public PlayerShadow number
---@field public PostType number
---@field public BlendWeights number
---@field public GlobalMaximumLOD number
---@field public MasterTextureLimit number
---@field public ModelDisplayNumGrade number
---@field public ModelLoadNum number
---@field public FxLevel number
---@field public FxParticleCount number
---@field public RTResolutionHeight number
---@field public IsValidMonsterShadow boolean
---@field public IsValidNpcShadow boolean
---@field public IsValidRoleShadow boolean
---@field public IsValidPlayerShadow boolean
---@field public IsValidPostType boolean
---@field public IsValidBlendWeights boolean
---@field public IsValidGlobalMaximumLOD boolean
---@field public IsValidMasterTextureLimit boolean
---@field public IsValidModelDisplayCompeleteNum boolean
---@field public IsValidModelLoadNum boolean
---@field public IsValidFxParticleCount boolean
---@field public IsValidFxLevel boolean

---@type MoonSerializable.MQualityParamData
MoonSerializable.MQualityParamData = { }
---@return MoonSerializable.MQualityParamData
function MoonSerializable.MQualityParamData.New() end
function MoonSerializable.MQualityParamData:Reset2Default() end
return MoonSerializable.MQualityParamData
