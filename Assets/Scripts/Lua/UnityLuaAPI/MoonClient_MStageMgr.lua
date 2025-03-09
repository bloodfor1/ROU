---@class MoonClient.MStageMgr : MoonCommonLib.MSingleton_MoonClient.MStageMgr
---@field public CurrentStage MoonClient.MStage
---@field public IsSwitchingScene boolean
---@field public IsSwitchingLine boolean
---@field public IsConcrete boolean
---@field public IsSelectChar boolean
---@field public IsLogin boolean
---@field public IsDungeon boolean

---@type MoonClient.MStageMgr
MoonClient.MStageMgr = { }
---@return MoonClient.MStageMgr
function MoonClient.MStageMgr.New() end
---@param toStage number
---@param toSceneID number
---@param toSceneLine number
---@param activedIdx number
---@param cameraFadeType number
---@param isWatchWar boolean
---@param sceneUid number
function MoonClient.MStageMgr:SwitchTo(toStage, toSceneID, toSceneLine, activedIdx, cameraFadeType, isWatchWar, sceneUid) end
return MoonClient.MStageMgr
