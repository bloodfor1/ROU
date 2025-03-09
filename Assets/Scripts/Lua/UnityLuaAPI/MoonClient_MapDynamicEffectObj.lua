---@class MoonClient.MapDynamicEffectObj
---@field public effectType number
---@field public playMode number
---@field public sourceScale UnityEngine.Vector3
---@field public targetScale UnityEngine.Vector3
---@field public sourcePos UnityEngine.Vector2
---@field public targetPos UnityEngine.Vector2
---@field public playCount number
---@field public loopTime number

---@type MoonClient.MapDynamicEffectObj
MoonClient.MapDynamicEffectObj = { }
---@return MoonClient.MapDynamicEffectObj
function MoonClient.MapDynamicEffectObj.New() end
function MoonClient.MapDynamicEffectObj:Init() end
---@param data MoonClient.MapObjData
function MoonClient.MapDynamicEffectObj:Reset(data) end
---@param data MoonClient.MapObjData
function MoonClient.MapDynamicEffectObj:Recover(data) end
---@param data MoonClient.MapObjData
---@param fDeltaT number
function MoonClient.MapDynamicEffectObj:UpdateDynamicEffect(data, fDeltaT) end
return MoonClient.MapDynamicEffectObj
