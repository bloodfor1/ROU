---@class MoonClient.MFxMgr : MoonCommonLib.MSingleton_MoonClient.MFxMgr
---@field public DEFAULT_TIME number
---@field public FX_PREFAB_PATH string
---@field public CurrentFxLevel number
---@field public CurrentFxParticleCount number
---@field public Deprecated boolean

---@type MoonClient.MFxMgr
MoonClient.MFxMgr = { }
---@return MoonClient.MFxMgr
function MoonClient.MFxMgr.New() end
---@return boolean
function MoonClient.MFxMgr:Init() end
function MoonClient.MFxMgr:Uninit() end
---@return MoonClient.MFxMgr.OriginData
function MoonClient.MFxMgr:GetDataFromPool() end
---@param data MoonClient.MFxMgr.OriginData
function MoonClient.MFxMgr:ReturnDataToPool(data) end
---@overload fun(tableId:number, data:MoonClient.MFxMgr.OriginData): number
---@overload fun(prefabPath:string, data:MoonClient.MFxMgr.OriginData): number
---@return number
---@param tableId number
---@param data MoonClient.MFxMgr.OriginData
---@param fx MoonClient.MFx
function MoonClient.MFxMgr:CreateFx(tableId, data, fx) end
---@return number
---@param tableId number
---@param data MoonClient.MFxMgr.OriginData
function MoonClient.MFxMgr:CreateCameraFx(tableId, data) end
---@param fxId number
---@param image UnityEngine.UI.RawImage
function MoonClient.MFxMgr:SetFxRawImage(fxId, image) end
---@param fxId number
function MoonClient.MFxMgr:DestroyFx(fxId) end
---@param excludeRT boolean
function MoonClient.MFxMgr:ClearAll(excludeRT) end
---@param fDeltaT number
function MoonClient.MFxMgr:Update(fDeltaT) end
---@overload fun(fxId:number): void
---@param fxId number
---@param orgData MoonClient.MFxMgr.OriginData
---@param destroyFirst boolean
function MoonClient.MFxMgr:Replay(fxId, orgData, destroyFirst) end
---@param fxId number
---@param orgData MoonClient.MFxMgr.OriginData
function MoonClient.MFxMgr:ResetTrans(fxId, orgData) end
---@param fxId number
---@param orgData MoonClient.MFxMgr.OriginData
function MoonClient.MFxMgr:UpdateFxTrans(fxId, orgData) end
---@param fxId number
function MoonClient.MFxMgr:RefreshFxLevel(fxId) end
---@param fxId number
---@param layer number
function MoonClient.MFxMgr:SetLayer(fxId, layer) end
---@overload fun(prefabPath:string, data:MoonClient.MFxMgr.OriginData): number
---@overload fun(tableId:number, data:MoonClient.MFxMgr.OriginData): number
---@return number
---@param rawImage UnityEngine.UI.RawImage
---@param fxPath string
---@param loadCallBack (fun(go:UnityEngine.GameObject, fxId:number, userData:System.Object):void)
---@param destroyCallBack (fun(isFxEnd:boolean, fxId:number, userData:System.Object):void)
function MoonClient.MFxMgr:CreateFxForRT(rawImage, fxPath, loadCallBack, destroyCallBack) end
return MoonClient.MFxMgr
