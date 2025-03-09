---@class MoonClient.MPlayerDungeonsInfo
---@field public LeftLifeCounter System.Collections.Generic.Dictionary_System.UInt64_System.Int32
---@field public dungeonData MoonClient.DungeonsTable.RowData
---@field public DungeonType number
---@field public DungeonID number
---@field public TimeToKick number
---@field public IgnoreCameraCullModel boolean
---@field public PlayerCampDeadCount number
---@field public PlayerSelfDeadCount number
---@field public EnemyCampDeadCount number
---@field public PlatFormFloor number
---@field public IsPlatformStart boolean
---@field public InDungeon boolean
---@field public LeftMonster number

---@type MoonClient.MPlayerDungeonsInfo
MoonClient.MPlayerDungeonsInfo = { }
---@return MoonClient.MPlayerDungeonsInfo
function MoonClient.MPlayerDungeonsInfo.New() end
---@return boolean
---@param t number
function MoonClient.MPlayerDungeonsInfo:IsDungeonType(t) end
function MoonClient.MPlayerDungeonsInfo:Init() end
function MoonClient.MPlayerDungeonsInfo:UnInit() end
---@param deltaTime number
function MoonClient.MPlayerDungeonsInfo:Update(deltaTime) end
---@param clearAccountData boolean
function MoonClient.MPlayerDungeonsInfo:OnLogOut(clearAccountData) end
---@overload fun(): System.Collections.Generic.List_System.Int32
---@return System.Collections.Generic.List_System.Int32
---@param dungeonsId number
function MoonClient.MPlayerDungeonsInfo:GetDungeonsReward(dungeonsId) end
---@return System.Collections.Generic.List_System.Int32
---@param entityId number
function MoonClient.MPlayerDungeonsInfo:GetMonsterReward(entityId) end
---@return System.Collections.Generic.List_System.Int32
---@param rewardId number
function MoonClient.MPlayerDungeonsInfo:GetRewardListByRewardId(rewardId) end
function MoonClient.MPlayerDungeonsInfo:OnEnterDungeons() end
function MoonClient.MPlayerDungeonsInfo:OnExitDungeons() end
return MoonClient.MPlayerDungeonsInfo
