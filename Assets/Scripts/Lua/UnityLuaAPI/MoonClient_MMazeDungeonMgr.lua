---@class MoonClient.MMazeDungeonMgr : MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr
---@field public PlayerPos UnityEngine.Vector2
---@field public OpenDrawMazeMesh boolean

---@type MoonClient.MMazeDungeonMgr
MoonClient.MMazeDungeonMgr = { }
---@return MoonClient.MMazeDungeonMgr
function MoonClient.MMazeDungeonMgr.New() end
---@return boolean
function MoonClient.MMazeDungeonMgr:Init() end
---@return UnityEngine.RenderTexture
function MoonClient.MMazeDungeonMgr:GetMapRt() end
function MoonClient.MMazeDungeonMgr:Uninit() end
---@return boolean
---@param sceneId number
function MoonClient.MMazeDungeonMgr:IsMazeDungeon(sceneId) end
function MoonClient.MMazeDungeonMgr:RmData() end
---@param id number
---@param pos UnityEngine.Vector2
---@param spName string
---@param scale UnityEngine.Vector2
function MoonClient.MMazeDungeonMgr:AddData(id, pos, spName, scale) end
---@param fDeltaT number
function MoonClient.MMazeDungeonMgr:Update(fDeltaT) end
function MoonClient.MMazeDungeonMgr:LateUpdate() end
---@param sceneId number
function MoonClient.MMazeDungeonMgr:OnSceneLoaded(sceneId) end
function MoonClient.MMazeDungeonMgr:OnLeaveScene() end
---@param pos UnityEngine.Vector2
function MoonClient.MMazeDungeonMgr:SetPlayerPos(pos) end
return MoonClient.MMazeDungeonMgr
