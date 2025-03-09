---@class MoonClient.MResLoader : MoonCommonLib.MSingleton_MoonClient.MResLoader
---@field public FAR_FAR_AWAY UnityEngine.Vector3
---@field public Deprecated boolean
---@field public IsLoadingRes boolean
---@field public CreateTaskCbID number

---@type MoonClient.MResLoader
MoonClient.MResLoader = { }
---@return MoonClient.MResLoader
function MoonClient.MResLoader.New() end
---@return System.Byte[]
---@param location string
---@param suffix string
---@param length System.Int32
function MoonClient.MResLoader:GetBytes(location, suffix, length) end
---@return System.Byte[]
---@param locations System.String[]
---@param suffix string
---@param length System.Int32
function MoonClient.MResLoader:GetBytesFromLocations(locations, suffix, length) end
---@return boolean
---@param location string
---@param suffix string
function MoonClient.MResLoader:ExistBytes(location, suffix) end
---@return System.IO.Stream
---@param location string
---@param suffix string
---@param canNull boolean
function MoonClient.MResLoader:ReadStream(location, suffix, canNull) end
---@return string
---@param location string
---@param suffix string
---@param errNonexist boolean
function MoonClient.MResLoader:ReadString(location, suffix, errNonexist) end
---@return number
---@param location string
---@param ext string
function MoonClient.MResLoader.Hash(location, ext) end
---@return number
---@param location System.String
---@param suffix string
function MoonClient.MResLoader:GetLocationHash(location, suffix) end
function MoonClient.MResLoader.UnloadUnusedAssetsAndSystemGCCollect() end
---@return boolean
function MoonClient.MResLoader:Init() end
function MoonClient.MResLoader:Uninit() end
---@param deltaTime number
function MoonClient.MResLoader:Update(deltaTime) end
---@return boolean
---@param taskCbId number
function MoonClient.MResLoader:HasAsyncTask(taskCbId) end
---@param taskCbId number
function MoonClient.MResLoader:CancelAsyncTask(taskCbId) end
---@param taskCbId number
function MoonClient.MResLoader:RemoveAsyncTaskRef(taskCbId) end
---@param taskCbId number
function MoonClient.MResLoader:RemoveAsyncAtlasTaskRef(taskCbId) end
function MoonClient.MResLoader:ClearResTasks() end
---@return number
---@param atlasName string
---@param spriteName string
---@param callback (fun(sprite:UnityEngine.Sprite, cbObj:System.Object):void)
---@param cbObj System.Object
function MoonClient.MResLoader:GetSpriteAsync(atlasName, spriteName, callback, cbObj) end
---@param sprite UnityEngine.Sprite
function MoonClient.MResLoader:ReleaseSprite(sprite) end
---@return MoonCommonLib.MCurveData
---@param location string
function MoonClient.MResLoader:GetCurve(location) end
---@param data MoonCommonLib.MCurveData
function MoonClient.MResLoader:ReleaseCurve(data) end
---@return UnityEngine.GameObject
---@param go UnityEngine.GameObject
---@param usePool boolean
function MoonClient.MResLoader:CloneObj(go, usePool) end
---@overload fun(go:UnityEngine.GameObject): void
---@param location string
function MoonClient.MResLoader:ClearObjPool(location) end
---@return UnityEngine.GameObject
---@param location string
function MoonClient.MResLoader:CreateObjFromPool(location) end
---@return number
---@param location string
---@param callback (fun(obj:UnityEngine.Object, cbObj:System.Object, taskId:number):void)
---@param cbObj System.Object
---@param usePool boolean
function MoonClient.MResLoader:CreateObjAsync(location, callback, cbObj, usePool) end
---@param location string
---@param count number
function MoonClient.MResLoader:PreInstObjsInPool(location, count) end
---@return number
---@param location string
function MoonClient.MResLoader:GetUnusedObjCountInPool(location) end
---@return number
---@param asset UnityEngine.Object
function MoonClient.MResLoader:GetUnusedObjCountInPoolByAsset(asset) end
---@overload fun(obj:UnityEngine.Object): void
---@param location string
---@param suffix string
function MoonClient.MResLoader:RequestUnloadBundle(location, suffix) end
---@param obj UnityEngine.GameObject
---@param returnPool boolean
function MoonClient.MResLoader:DestroyObj(obj, returnPool) end
---@return UnityEngine.Material
---@param location string
function MoonClient.MResLoader:CreateMatFromPool(location) end
---@param mat UnityEngine.Material
---@param returnPool boolean
function MoonClient.MResLoader:DestroyMat(mat, returnPool) end
---@return UnityEngine.Object
---@param t string
---@param location string
---@param suffix string
function MoonClient.MResLoader:GetSharedAssetFromPool(t, location, suffix) end
---@param location string
---@param callback (fun(obj:UnityEngine.Object, cbObj:System.Object, taskId:number):void)
---@param cbObj System.Object
function MoonClient.MResLoader:LoadStreamedAsset(location, callback, cbObj) end
function MoonClient.MResLoader:ReleaseStreamedAsset() end
---@return number
---@param t string
---@param location string
---@param suffix string
---@param callback (fun(obj:UnityEngine.Object, cbObj:System.Object, taskId:number):void)
---@param cbObj System.Object
function MoonClient.MResLoader:GetSharedAssetAsync(t, location, suffix, callback, cbObj) end
---@param obj UnityEngine.Object
function MoonClient.MResLoader:ReleaseSharedAsset(obj) end
---@param abName number
---@param callback (fun(info:MoonClient.ABInfo):void)
function MoonClient.MResLoader:LoadABInfoAsync(abName, callback) end
return MoonClient.MResLoader
