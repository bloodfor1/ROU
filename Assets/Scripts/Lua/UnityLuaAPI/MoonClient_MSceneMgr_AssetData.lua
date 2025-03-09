---@class MoonClient.MSceneMgr.AssetData
---@field public monsterList System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@field public npcList System.Collections.Generic.List_MoonClient.MSceneMgr.AssetEntity
---@field public wallDict System.Collections.Generic.Dictionary_System.Int32_PbLocal.MSceneWallData
---@field public scriptableObjectAssetPaths System.Collections.Generic.List_System.String
---@field public triggerGroupDict System.Collections.Generic.Dictionary_System.Int32_PbLocal.MCSceneTriggerGroupData
---@field public triggerObjectDict System.Collections.Generic.Dictionary_System.Int32_PbLocal.MSceneTriggerObjectData
---@field public clientObjectList System.Collections.Generic.List_PbLocal.MSceneTriggerObjectData

---@type MoonClient.MSceneMgr.AssetData
MoonClient.MSceneMgr.AssetData = { }
---@return MoonClient.MSceneMgr.AssetData
function MoonClient.MSceneMgr.AssetData.New() end
function MoonClient.MSceneMgr.AssetData:Clear() end
return MoonClient.MSceneMgr.AssetData
