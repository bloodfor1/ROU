---@class MoonClient.MTransferMgr : MoonCommonLib.MSingleton_MoonClient.MTransferMgr
---@field public belongScene System.Collections.Generic.Dictionary_System.Int32_System.Int32
---@field public NowEasyNavArg KKSG.EasyNavigateArg
---@field public WorldMapSelectId number
---@field public IsActiveWorldMap boolean
---@field public Sequence number
---@field public IsTransing boolean
---@field public DesSceneId number
---@field public DesFace number
---@field public Range number
---@field public DestType number
---@field public CurrentTeleportType number
---@field public IsKapula boolean

---@type MoonClient.MTransferMgr
MoonClient.MTransferMgr = { }
---@return MoonClient.MTransferMgr
function MoonClient.MTransferMgr.New() end
---@return boolean
function MoonClient.MTransferMgr:Init() end
function MoonClient.MTransferMgr:OnEnterScene() end
function MoonClient.MTransferMgr:Uninit() end
---@param clearAccountData boolean
function MoonClient.MTransferMgr:OnLogout(clearAccountData) end
---@param fDeltaT number
function MoonClient.MTransferMgr:Update(fDeltaT) end
function MoonClient.MTransferMgr:Arrive() end
function MoonClient.MTransferMgr:Cancel() end
---@param sceneId number
function MoonClient.MTransferMgr:AddMapObj(sceneId) end
---@param sceneId number
function MoonClient.MTransferMgr:ReAddNpcMapObj(sceneId) end
---@param easyArg MoonClient.MEasyPathEventArgs
function MoonClient.MTransferMgr:SendEasyRpc(easyArg) end
---@param sceneId number
---@param onArrive (fun():void)
---@param onCancel (fun():void)
function MoonClient.MTransferMgr:GotoScene(sceneId, onArrive, onCancel) end
---@return boolean
---@param sceneId number
---@param npcId number
---@param onArrive (fun():void)
---@param onCancel (fun():void)
---@param upperRange number
function MoonClient.MTransferMgr:GotoNpc(sceneId, npcId, onArrive, onCancel, upperRange) end
---@param sceneId number
---@param position UnityEngine.Vector3
---@param onArrive (fun():void)
---@param onCancel (fun():void)
---@param desFace number
---@param range number
function MoonClient.MTransferMgr:GotoPosition(sceneId, position, onArrive, onCancel, desFace, range) end
---@param toIdle boolean
function MoonClient.MTransferMgr:Interrupt(toIdle) end
---@return boolean
function MoonClient.MTransferMgr:NeedReTry() end
---@return boolean
function MoonClient.MTransferMgr:NeedIgnore() end
---@return UnityEngine.Vector3
function MoonClient.MTransferMgr:GetNowDesPos() end
---@param systemId number
---@param callback (fun():void)
function MoonClient.MTransferMgr:NavigationDisabledBySystem(systemId, callback) end
---@param systemId number
function MoonClient.MTransferMgr:NavigationEnabledBySystem(systemId) end
---@param uiName string
---@param callback (fun():void)
function MoonClient.MTransferMgr:NavigationDisabledByUI(uiName, callback) end
---@param uiName string
function MoonClient.MTransferMgr:NavigationEnabledByUI(uiName) end
return MoonClient.MTransferMgr
