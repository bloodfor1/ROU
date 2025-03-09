---@class MoonClient.MGlobalConfig : MoonCommonLib.MSingleton_MoonClient.MGlobalConfig
---@field public SequenceSeparator System.Char[]
---@field public ListSeparator System.Char[]
---@field public AllSeparators System.Char[]
---@field public SpaceSeparator System.Char[]
---@field public TabSeparator System.Char[]
---@field public PINGInterval number
---@field public LoginBlockTime number
---@field public SettingEnum number
---@field public ChatRoomBuff number
---@field public CollectAttackDevil number
---@field public OnWaveResetTime number
---@field public MvpShowIconDistance number
---@field public MiniShowIconDistance number
---@field public BossShowIconDistance number
---@field public AlphaChangeTime number
---@field public SkillChangeColor System.String[]
---@field public weathersStartStamp number
---@field public chooseTargetMaxDistance number
---@field public weatherTimeRate number
---@field public weatherPeriods System.Int32[]
---@field public sceneDefaultOriginTemperature number
---@field public sceneDefaultHotTemperature number
---@field public sceneDefaultColdTemperature number
---@field public rangeOfEnemyDisplay number
---@field public fightingRoleContinueTime number
---@field public arrNpcScriptTime System.Single[]
---@field public lowBloodLine number
---@field public veryLowBloodLine number
---@field public hatredFxOffsetPosition System.Single[]
---@field public autoBattleradius System.Single[]
---@field public npcBornTransparentTime number
---@field public btnClickDuration number
---@field public showPlayerAvatarTime number
---@field public netRpcDelay number
---@field public netRpcTimeout number
---@field public netBigRpcTimeout number
---@field public netSyncTimeout number
---@field public netSyncTimeoutCount number
---@field public netPingDuration number
---@field public reconnectCount number
---@field public recvOverflowLen number
---@field public sendBufferLen number
---@field public recvBufferUnzipLen number
---@field public recvBufferZipLen number
---@field public sendBufferSize number
---@field public recvBufferSize number
---@field public AutoCollectLifeSkillGardenBuff number
---@field public AutoCollectLifeSkillMiningBuff number
---@field public AutoGatheringGap number
---@field public FishingMaxCastingDistance number
---@field public FishingMinTimeAfterCasting number
---@field public EagleHeight number
---@field public EagleX number
---@field public EagleZ number
---@field public FollowDistance number

---@type MoonClient.MGlobalConfig
MoonClient.MGlobalConfig = { }
---@return MoonClient.MGlobalConfig
function MoonClient.MGlobalConfig.New() end
function MoonClient.MGlobalConfig:Preload() end
---@return number
function MoonClient.MGlobalConfig:GetCameraFxViewRadius() end
---@return number
---@param fightGroup number
function MoonClient.MGlobalConfig:GetPowerStoneOccupyingEffects(fightGroup) end
---@return number
---@param fightGroup number
function MoonClient.MGlobalConfig:GetPowerStoneIdleEffects(fightGroup) end
---@return number
---@param fightGroup number
function MoonClient.MGlobalConfig:GetPowerStoneSwitchingEffects(fightGroup) end
---@return number
---@param fightGroup number
function MoonClient.MGlobalConfig:GetSummonStoneOccupyingEffects(fightGroup) end
---@return number
---@param fightGroup number
function MoonClient.MGlobalConfig:GetSummonStoneIdleEffects(fightGroup) end
---@return number
---@param fightGroup number
function MoonClient.MGlobalConfig:GetSummonStoneSwitchingEffects(fightGroup) end
---@return System.String[]
---@param key string
---@param separator System.Char[]
function MoonClient.MGlobalConfig:AnalysisTable(key, separator) end
---@return System.Int32[]
---@param key string
---@param separator System.Char[]
function MoonClient.MGlobalConfig:AnalysisTableToInt(key, separator) end
---@return System.Single[]
---@param key string
---@param separator System.Char[]
function MoonClient.MGlobalConfig:AnalysisTableToFloat(key, separator) end
---@return System.String_Array[]
---@param key string
function MoonClient.MGlobalConfig:GetVectorSequence(key) end
---@return System.Int32[]
---@param key string
function MoonClient.MGlobalConfig:GetSequenceOrVectorInt(key) end
---@return System.Single[]
---@param key string
function MoonClient.MGlobalConfig:GetSequenceOrVectorFloat(key) end
---@return System.String[]
---@param key string
function MoonClient.MGlobalConfig:GetSequenceOrVectorString(key) end
---@return number
---@param key string
---@param defaultValue number
function MoonClient.MGlobalConfig:GetInt(key, defaultValue) end
---@return number
---@param key string
---@param defaultValue number
function MoonClient.MGlobalConfig:GetUInt(key, defaultValue) end
---@return string
---@param key string
---@param defaultValue string
function MoonClient.MGlobalConfig:GetString(key, defaultValue) end
---@return number
---@param key string
---@param defaultValue number
function MoonClient.MGlobalConfig:GetFloat(key, defaultValue) end
return MoonClient.MGlobalConfig
