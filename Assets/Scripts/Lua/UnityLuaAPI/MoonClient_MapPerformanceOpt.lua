---@class MoonClient.MapPerformanceOpt

---@type MoonClient.MapPerformanceOpt
MoonClient.MapPerformanceOpt = { }
---@return MoonClient.MapPerformanceOpt
function MoonClient.MapPerformanceOpt.New() end
---@param minMapUvHalf number
---@param mnMapBgRaw UnityEngine.UI.RawImage
---@param mnPlayerTrans UnityEngine.Transform
function MoonClient.MapPerformanceOpt.MoveMiniMap(minMapUvHalf, mnMapBgRaw, mnPlayerTrans) end
---@param bigPlayerPanelCom MoonClient.MLuaUICom
---@param bigMapOffset UnityEngine.Vector2
---@param bigMapRealScale number
function MoonClient.MapPerformanceOpt.MoveBigMap(bigPlayerPanelCom, bigMapOffset, bigMapRealScale) end
---@param bigPlayerPanelCom MoonClient.MLuaUICom
---@param bigMapBg MoonClient.MLuaUICom
---@param bigMapObj MoonClient.MLuaUICom
---@param bigMapUv number
---@param currentEnlargeScale number
function MoonClient.MapPerformanceOpt.MoveEnlargeBigMap(bigPlayerPanelCom, bigMapBg, bigMapObj, bigMapUv, currentEnlargeScale) end
---@param playerPosTxtCom MoonClient.MLuaUICom
---@param collectPlayerPosCom MoonClient.MLuaUICom
---@param collectPlayerOffsetCom MoonClient.MLuaUICom
---@param selectTargetUID uint64
function MoonClient.MapPerformanceOpt.UpdatePlayerPos(playerPosTxtCom, collectPlayerPosCom, collectPlayerOffsetCom, selectTargetUID) end
---@return UnityEngine.Vector2
---@param realPos UnityEngine.Vector2
function MoonClient.MapPerformanceOpt.GetMnMapPosByRealPos(realPos) end
---@return UnityEngine.Vector2
---@param realPos UnityEngine.Vector2
function MoonClient.MapPerformanceOpt.GetMnMapPos(realPos) end
---@return UnityEngine.Vector2
---@param realPos UnityEngine.Vector2
---@param bigMapRealScale number
---@param currentScale number
function MoonClient.MapPerformanceOpt.GetBigMapPos(realPos, bigMapRealScale, currentScale) end
---@return UnityEngine.Vector2
---@param realPos UnityEngine.Vector2
---@param bigMapOffset UnityEngine.Vector2
---@param bigMapRealScale number
---@param currentScale number
function MoonClient.MapPerformanceOpt.GetBigMapPosByRealPos(realPos, bigMapOffset, bigMapRealScale, currentScale) end
---@param pos UnityEngine.Vector2
---@param mnMapBg MoonClient.MLuaUICom
function MoonClient.MapPerformanceOpt.UpdateTaskNavIcon(pos, mnMapBg) end
---@param pos UnityEngine.Vector2
---@param mnMapBg MoonClient.MLuaUICom
function MoonClient.MapPerformanceOpt.UpdateDungeonTargetNavIcon(pos, mnMapBg) end
return MoonClient.MapPerformanceOpt
