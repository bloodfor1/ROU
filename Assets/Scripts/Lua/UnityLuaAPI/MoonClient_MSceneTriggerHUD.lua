---@class MoonClient.MSceneTriggerHUD
---@field public ClassType number
---@field public Id number
---@field public TriggerBase MoonClient.MSceneWallTrigger
---@field public ObjRef MoonClient.MSceneTriggerHUD.MSceneObjRef
---@field public SceneObjInfo MoonClient.MSceneObjInfo
---@field public TableRow MoonClient.SceneObjTable.RowData
---@field public InTrigger boolean
---@field public OnPlayerEnter (fun():void)
---@field public OnPlayerExit (fun():void)

---@type MoonClient.MSceneTriggerHUD
MoonClient.MSceneTriggerHUD = { }
---@return MoonClient.MSceneTriggerHUD
function MoonClient.MSceneTriggerHUD.New() end
---@return boolean
---@param triggerBase MoonClient.MSceneWallTrigger
---@param wallData PbLocal.MSceneWallData
function MoonClient.MSceneTriggerHUD:Init(triggerBase, wallData) end
function MoonClient.MSceneTriggerHUD:Uninit() end
function MoonClient.MSceneTriggerHUD:Refresh() end
---@param box MoonClient.MSceneWallBoxCollider
function MoonClient.MSceneTriggerHUD:onPlayerTriggerEnter(box) end
---@param box MoonClient.MSceneWallBoxCollider
function MoonClient.MSceneTriggerHUD:onPlayerTriggerLeave(box) end
---@param uid uint64
function MoonClient.MSceneTriggerHUD:AddUidOnSeat(uid) end
---@param uid uint64
function MoonClient.MSceneTriggerHUD:RemoveUidOnSeat(uid) end
---@param data PbLocal.MSceneWallData
function MoonClient.MSceneTriggerHUD:CopyFrom(data) end
---@param data PbLocal.MSceneWallData
function MoonClient.MSceneTriggerHUD:CopyTo(data) end
---@param serverWallData KKSG.WallData
---@param isInit boolean
function MoonClient.MSceneTriggerHUD:SyncData(serverWallData, isInit) end
return MoonClient.MSceneTriggerHUD
