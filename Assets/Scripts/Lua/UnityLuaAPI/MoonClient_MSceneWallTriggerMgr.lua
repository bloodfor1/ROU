---@class MoonClient.MSceneWallTriggerMgr : MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr
---@field public AllTriggers System.Collections.Generic.ICollection_MoonClient.MSceneWallTrigger
---@field public TriggerHudEnabled boolean

---@type MoonClient.MSceneWallTriggerMgr
MoonClient.MSceneWallTriggerMgr = { }
---@return MoonClient.MSceneWallTriggerMgr
function MoonClient.MSceneWallTriggerMgr.New() end
---@param layer number
---@param enable boolean
function MoonClient.MSceneWallTriggerMgr:SetTriggerEnableMask(layer, enable) end
---@param id number
---@param trigger MoonClient.MSceneWallTrigger
function MoonClient.MSceneWallTriggerMgr:AddStaicWallTrigger(id, trigger) end
---@param includeStatic boolean
function MoonClient.MSceneWallTriggerMgr:ClearWallTriggers(includeStatic) end
---@return MoonClient.MSceneWallTrigger
---@param uuid uint64
function MoonClient.MSceneWallTriggerMgr:GetDynamicWallTrigger(uuid) end
---@param uuid uint64
function MoonClient.MSceneWallTriggerMgr:RemoveDynamicWallTrigger(uuid) end
---@param uuid uint64
---@param serverWallData KKSG.WallData
function MoonClient.MSceneWallTriggerMgr:AddOrUpdateDynamicWallTrigger(uuid, serverWallData) end
function MoonClient.MSceneWallTriggerMgr:ShowStaticWallTriggers() end
function MoonClient.MSceneWallTriggerMgr:RefreshWallTriggers() end
---@param triggerId number
function MoonClient.MSceneWallTriggerMgr:SelectSceneObjHudByTriggerId(triggerId) end
---@param fDelta number
function MoonClient.MSceneWallTriggerMgr:Update(fDelta) end
---@param clearAccountData boolean
function MoonClient.MSceneWallTriggerMgr:OnLogout(clearAccountData) end
return MoonClient.MSceneWallTriggerMgr
