---@class MoonClient.MResGoPool : MoonCommonLib.MSingleton_MoonClient.MResGoPool
---@field public ObjPoolCacheSize number

---@type MoonClient.MResGoPool
MoonClient.MResGoPool = { }
---@return MoonClient.MResGoPool
function MoonClient.MResGoPool.New() end
---@return boolean
function MoonClient.MResGoPool:Init() end
function MoonClient.MResGoPool:Uninit() end
---@return number
---@param onCreate (fun(obj:UnityEngine.GameObject):void)
---@param onRelease (fun(obj:UnityEngine.GameObject):void)
---@param capacity number
function MoonClient.MResGoPool:Register(onCreate, onRelease, capacity) end
---@return UnityEngine.GameObject
---@param adapterId number
function MoonClient.MResGoPool:CreateGo(adapterId) end
---@param go UnityEngine.GameObject
function MoonClient.MResGoPool:DestroyGo(go) end
---@param adapterId number
function MoonClient.MResGoPool:ClearAdapter(adapterId) end
---@return boolean
---@param t UnityEngine.Transform
function MoonClient.MResGoPool:IsInObjPool(t) end
---@return UnityEngine.Object
---@param obj UnityEngine.Object
---@param usePool boolean
function MoonClient.MResGoPool:CreateObj(obj, usePool) end
---@param obj UnityEngine.Object
---@param returnPool boolean
function MoonClient.MResGoPool:DestroyObj(obj, returnPool) end
---@return number
---@param asset UnityEngine.Object
function MoonClient.MResGoPool:GetUnusedObjCountInPool(asset) end
---@param parentGo UnityEngine.GameObject
function MoonClient.MResGoPool:HoldGoPool(parentGo) end
---@param parentGo UnityEngine.GameObject
function MoonClient.MResGoPool:UnholdGoPool(parentGo) end
function MoonClient.MResGoPool:RetireObjs() end
---@param obj UnityEngine.Object
function MoonClient.MResGoPool:ClearObjPool(obj) end
function MoonClient.MResGoPool:ClearAll() end
return MoonClient.MResGoPool
