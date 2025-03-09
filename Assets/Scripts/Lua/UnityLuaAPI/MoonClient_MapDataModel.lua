---@class MoonClient.MapDataModel : MoonCommonLib.MSingleton_MoonClient.MapDataModel
---@field public MapRealScale number
---@field public IsMapActive boolean
---@field public IsBigMapActive boolean
---@field public IsBigMapEnlargeState boolean
---@field public BigMapEnlargeStateScale number
---@field public MnMapRealScale number
---@field public TriggerSceneId number
---@field public MinMapEnlargeScale number
---@field public TriggerSceneMapIndex number
---@field public ShowSceneId number
---@field public BigMapLeftBorderPercentPos number
---@field public BigMapRightBorderPercentPos number

---@type MoonClient.MapDataModel
MoonClient.MapDataModel = { }
---@return MoonClient.MapDataModel
function MoonClient.MapDataModel.New() end
---@return UnityEngine.Vector2
---@param realPos UnityEngine.Vector2
function MoonClient.MapDataModel:GetMnMapPos(realPos) end
---@return UnityEngine.Vector2
---@param realPos UnityEngine.Vector2
function MoonClient.MapDataModel:GetMnMapPosByRealPos(realPos) end
---@return UnityEngine.Vector2
function MoonClient.MapDataModel:GetPlayerPos() end
---@return UnityEngine.Vector3
---@param toPos UnityEngine.Vector2
---@param fromPos UnityEngine.Vector3
function MoonClient.MapDataModel:SeekMovePoint(toPos, fromPos) end
return MoonClient.MapDataModel
