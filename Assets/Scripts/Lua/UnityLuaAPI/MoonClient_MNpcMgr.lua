---@class MoonClient.MNpcMgr : MoonCommonLib.MSingleton_MoonClient.MNpcMgr

---@type MoonClient.MNpcMgr
MoonClient.MNpcMgr = { }
---@return MoonClient.MNpcMgr
function MoonClient.MNpcMgr.New() end
---@param sceneId number
function MoonClient.MNpcMgr:OnSceneLoaded(sceneId) end
---@overload fun(sceneId:number, npcId:number, position:UnityEngine.Vector3, rotation:number, taskId:number): void
---@param sceneId number
---@param npcId number
---@param position UnityEngine.Vector3
---@param rotation number
---@param location string
---@param currentLine number
function MoonClient.MNpcMgr:AddLocalNpc(sceneId, npcId, position, rotation, location, currentLine) end
---@param sceneId number
---@param npcId number
---@param position UnityEngine.Vector3
---@param rotation number
---@param taskId number
function MoonClient.MNpcMgr:UpdateLocalNpc(sceneId, npcId, position, rotation, taskId) end
---@overload fun(npcId:number, immediately:boolean): void
---@param sceneId number
---@param npcId number
---@param immediately boolean
function MoonClient.MNpcMgr:RemoveLocalNpc(sceneId, npcId, immediately) end
function MoonClient.MNpcMgr:OnLeaveScene() end
---@param npcId number
---@param bVisible boolean
function MoonClient.MNpcMgr:SetNpcVisibility(npcId, bVisible) end
---@return boolean
---@param npcId number
function MoonClient.MNpcMgr:GetNpcVisibility(npcId) end
---@return MoonClient.MNpc
---@param npcId number
---@param showErrorLog boolean
function MoonClient.MNpcMgr:FindNpcInViewport(npcId, showErrorLog) end
---@param npcId number
---@param uid uint64
function MoonClient.MNpcMgr:AddNpcInViewport(npcId, uid) end
---@param npcId number
function MoonClient.MNpcMgr:RemoveNpcInViewport(npcId) end
function MoonClient.MNpcMgr:ClearNpcInViewport() end
function MoonClient.MNpcMgr:UpdateNpcFxInViewport() end
---@param clearAccountData boolean
function MoonClient.MNpcMgr:OnLogout(clearAccountData) end
function MoonClient.MNpcMgr:Uninit() end
return MoonClient.MNpcMgr
