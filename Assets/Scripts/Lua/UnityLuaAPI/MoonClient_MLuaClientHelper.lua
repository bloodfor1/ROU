---@class MoonClient.MLuaClientHelper

---@type MoonClient.MLuaClientHelper
MoonClient.MLuaClientHelper = { }
---@param str string
function MoonClient.MLuaClientHelper.DoLuaString(str) end
---@return string
function MoonClient.MLuaClientHelper.GetLuaStackTrace() end
---@param npcId number
---@param animationName string
function MoonClient.MLuaClientHelper.PlaySpecialAnimation(npcId, animationName) end
---@param path string
function MoonClient.MLuaClientHelper.PlayFullMovie(path) end
---@param npcId number
---@param key string
---@param animationName string
function MoonClient.MLuaClientHelper.PlayAnimation(npcId, key, animationName) end
---@param npcId number
function MoonClient.MLuaClientHelper.StopSpecialAnimation(npcId) end
---@param go UnityEngine.GameObject
function MoonClient.MLuaClientHelper.PlayFxHelper(go) end
---@param go UnityEngine.GameObject
function MoonClient.MLuaClientHelper.StopFxHelper(go) end
---@param go UnityEngine.GameObject
function MoonClient.MLuaClientHelper.PlayAllFxHelper(go) end
---@param go UnityEngine.GameObject
function MoonClient.MLuaClientHelper.StopAllFxHelper(go) end
---@overload fun(uid:uint64, skillId:number): number
---@return number
---@param en MoonClient.MEntity
---@param skillId number
function MoonClient.MLuaClientHelper.GetSkillAttrPowerPercent(en, skillId) end
---@param point UnityEngine.Vector2
---@param tag string
function MoonClient.MLuaClientHelper.ExecuteClickEvents(point, tag) end
---@param go UnityEngine.GameObject
---@param tag string
function MoonClient.MLuaClientHelper.ExecutePointUpDownEventsByGameObject(go, tag) end
---@param go UnityEngine.GameObject
---@param tag string
function MoonClient.MLuaClientHelper.ExecuteClickEventsToGameObject(go, tag) end
---@param point UnityEngine.Vector2
function MoonClient.MLuaClientHelper.ExcuteBeginDragEvent(point) end
---@param point UnityEngine.Vector2
---@param target UnityEngine.GameObject
function MoonClient.MLuaClientHelper.ExcuteEndDragEvent(point, target) end
---@param uid uint64
function MoonClient.MLuaClientHelper.SelectTargetById(uid) end
---@return number
---@param utcSeconds int64
function MoonClient.MLuaClientHelper.GetTiks2NowSeconds(utcSeconds) end
---@return number
---@param startUtcSeconds int64
---@param endUtcSeconds int64
function MoonClient.MLuaClientHelper.GetTiksSeconds(startUtcSeconds, endUtcSeconds) end
---@return number
---@param utcSeconds int64
function MoonClient.MLuaClientHelper.GetTiks2Zero(utcSeconds) end
---@return int64
function MoonClient.MLuaClientHelper.GetNowTicks() end
---@return string
---@param ms number
function MoonClient.MLuaClientHelper.MilliSecondToTimeString(ms) end
---@return boolean
---@param lastUtcMillis int64
---@param nowUtcMillis int64
function MoonClient.MLuaClientHelper.CheckAcrossDay(lastUtcMillis, nowUtcMillis) end
---@return boolean
---@param a string
---@param b string
function MoonClient.MLuaClientHelper.CompareStringByCurrentCulture(a, b) end
---@param go UnityEngine.GameObject
function MoonClient.MLuaClientHelper.AddEntityColliderAdapter(go) end
---@param go UnityEngine.GameObject
function MoonClient.MLuaClientHelper.RemoveEntityColliderAdapter(go) end
---@return number
---@param value System.Object
function MoonClient.MLuaClientHelper.GetROGameLibsEnumValue(value) end
---@return boolean
---@param coms MoonClient.MLuaUICom[]
function MoonClient.MLuaClientHelper.ClearLuaUIComs(coms) end
---@return boolean
---@param luaPath string
function MoonClient.MLuaClientHelper.ExistLuaFile(luaPath) end
---@param uid uint64
---@param isShow boolean
---@param position UnityEngine.Vector3
---@param hudSpriteDatas MoonClient.HUDSpriteData[]
---@param textData MoonClient.HUDTextData
function MoonClient.MLuaClientHelper.ShowTextAndSpriteHUD(uid, isShow, position, hudSpriteDatas, textData) end
---@param texture UnityEngine.RenderTexture
function MoonClient.MLuaClientHelper.ReleaseTexture(texture) end
---@return UnityEngine.RenderTexture
---@param size number
---@param renderes UnityEngine.Renderer[]
function MoonClient.MLuaClientHelper.DrawRenderTexture(size, renderes) end
---@param go UnityEngine.GameObject
---@param sacleX number
---@param sacleY number
---@param offsetX number
---@param offsetY number
function MoonClient.MLuaClientHelper.SetMaterialMainTexST(go, sacleX, sacleY, offsetX, offsetY) end
---@return System.String[]
---@param str string
---@param delimiter string
function MoonClient.MLuaClientHelper.Split(str, delimiter) end
---@overload fun(go:UnityEngine.GameObject): MoonClient.MLuaUICom
---@return MoonClient.MLuaUICom
---@param trans UnityEngine.Transform
function MoonClient.MLuaClientHelper.GetOrCreateMLuaUICom(trans) end
return MoonClient.MLuaClientHelper
