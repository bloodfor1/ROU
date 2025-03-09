---@class MoonClient.MSceneMgr : MoonCommonLib.MSingleton_MoonClient.MSceneMgr
---@field public GetAllNpcInfo MoonClient.MAllNpcData
---@field public AllLifeSkillGatherPosInfo MoonClient.LifeSkillGatherPosInfo
---@field public AllLifeProfessionWallData MoonClient.MAllLifeProfessionWallData

---@type MoonClient.MSceneMgr
MoonClient.MSceneMgr = { }
---@return MoonClient.MSceneMgr
function MoonClient.MSceneMgr.New() end
function MoonClient.MSceneMgr:Preload() end
---@return boolean
function MoonClient.MSceneMgr:Init() end
function MoonClient.MSceneMgr:Uninit() end
---@return MoonClient.SceneTable.RowData
---@param sceneID number
function MoonClient.MSceneMgr:GetSceneData(sceneID) end
---@return System.String[]
---@param sceneID number
function MoonClient.MSceneMgr:GetSceneUnityFile(sceneID) end
---@return boolean
---@param sceneID number
function MoonClient.MSceneMgr:GetSceneSwitchToSelf(sceneID) end
---@return number
---@param sceneID number
function MoonClient.MSceneMgr:GetSceneDelayTransfer(sceneID) end
---@return boolean
---@param sceneId number
---@param data PbLocal.MCSceneData
function MoonClient.MSceneMgr:TryGetAssetInfo(sceneId, data) end
---@return System.Collections.Generic.List_MoonClient.MSceneNpcData
function MoonClient.MSceneMgr:GetAllNpcInfos() end
---@return PbLocal.MSceneWallData
---@param id number
function MoonClient.MSceneMgr:GetArtWall(id) end
---@param sceneId number
---@param data PbLocal.MCSceneData
function MoonClient.MSceneMgr:LoadAssetInfo(sceneId, data) end
---@return UnityEngine.Vector3
---@param npcId number
---@param sceneId number
---@param taskId number
function MoonClient.MSceneMgr:GetNpcPos(npcId, sceneId, taskId) end
---@return System.Collections.Generic.List_System.Int32
function MoonClient.MSceneMgr:GetSceneAward() end
---@return System.Collections.Generic.List_System.Int32
---@param sceneId number
function MoonClient.MSceneMgr:GetMonsIdsBySceneId(sceneId) end
return MoonClient.MSceneMgr
