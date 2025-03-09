---@class MoonClient.MFxMgr.OriginData
---@field public userData System.Object
---@field public attachedModel MoonClient.MModel
---@field public loadedCallback (fun(go:UnityEngine.GameObject, fxId:number, userData:System.Object):void)
---@field public destroyHandler (fun(isFxEnd:boolean, fxId:number, userData:System.Object):void)
---@field public speed number
---@field public layer number
---@field public playTime number
---@field public warningTime number
---@field public warningRatio number
---@field public parent UnityEngine.Transform
---@field public scaleFac UnityEngine.Vector3
---@field public position UnityEngine.Vector3
---@field public rotation UnityEngine.Quaternion
---@field public follow MoonClient.MFx.FxFollow
---@field public cameraFxType number
---@field public uiSortOrder number
---@field public rawImage UnityEngine.UI.RawImage
---@field public useVector3OneScale boolean
---@field public mask number

---@type MoonClient.MFxMgr.OriginData
MoonClient.MFxMgr.OriginData = { }
---@return MoonClient.MFxMgr.OriginData
function MoonClient.MFxMgr.OriginData.New() end
return MoonClient.MFxMgr.OriginData
