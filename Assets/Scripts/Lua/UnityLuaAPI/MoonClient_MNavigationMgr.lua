---@class MoonClient.MNavigationMgr : MoonCommonLib.MSingleton_MoonClient.MNavigationMgr
---@field public _height_per_diff number
---@field public CppMgr ROGameLibs.RONavigationManager
---@field public CppNav ROGameLibs.MNavigation

---@type MoonClient.MNavigationMgr
MoonClient.MNavigationMgr = { }
---@return MoonClient.MNavigationMgr
function MoonClient.MNavigationMgr.New() end
---@return boolean
function MoonClient.MNavigationMgr:Init() end
function MoonClient.MNavigationMgr:Uninit() end
---@return string
---@param sceneId number
---@param sceneIndex number
function MoonClient.MNavigationMgr:getSceneName(sceneId, sceneIndex) end
---@overload fun(): ROGameLibs.Vector3
---@overload fun(v3:UnityEngine.Vector3): ROGameLibs.Vector3
---@return ROGameLibs.Vector3
---@param x number
---@param y number
---@param z number
function MoonClient.MNavigationMgr:getV3Glb(x, y, z) end
---@param v3 ROGameLibs.Vector3
function MoonClient.MNavigationMgr:releaseV3Glb(v3) end
---@param sceneId number
---@param sceneIndex number
function MoonClient.MNavigationMgr:OnSceneLoaded(sceneId, sceneIndex) end
---@return boolean
---@param pt UnityEngine.Vector3
function MoonClient.MNavigationMgr:IsPtValid(pt) end
---@return boolean
---@param pt UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryGetClosetValidPt(pt) end
---@return boolean
---@param pt UnityEngine.Vector3
function MoonClient.MNavigationMgr:TrySetHeight(pt) end
---@return boolean
---@param pt UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryGetNearstValidPt(pt) end
---@return boolean
---@param pt UnityEngine.Vector3
function MoonClient.MNavigationMgr:CheckPointIsValid(pt) end
---@return boolean
---@param start UnityEngine.Vector3
---@param ed UnityEngine.Vector3
---@param dest UnityEngine.Vector3
function MoonClient.MNavigationMgr:KickBlockedTest(start, ed, dest) end
---@return boolean
---@param position UnityEngine.Vector3
function MoonClient.MNavigationMgr:ValidatePositionIncorrect(position) end
---@return boolean
---@param pt UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryGetCastPoint(pt) end
---@overload fun(x:number, z:number, y:System.Single): boolean
---@overload fun(x:number, z:number, target_y:number, y:System.Single): boolean
---@return boolean
---@param x number
---@param z number
---@param y System.Single
---@param sceneId number
function MoonClient.MNavigationMgr:TryGetHeight(x, z, y, sceneId) end
---@return number
---@param pos UnityEngine.Vector3
function MoonClient.MNavigationMgr:GetFloor(pos) end
---@return boolean
---@param dest UnityEngine.Vector3
---@param heights System.Collections.Generic.List_System.Single
function MoonClient.MNavigationMgr:CorrectFindHeight(dest, heights) end
---@return boolean
---@param dest UnityEngine.Vector3
---@param forward UnityEngine.Vector3
function MoonClient.MNavigationMgr:GetHeightAccurate(dest, forward) end
---@overload fun(x:number, z:number, ys:System.Collections.Generic.List_System.Single): boolean
---@return boolean
---@param x number
---@param z number
---@param ys System.Collections.Generic.List_System.Single
---@param sceneId number
function MoonClient.MNavigationMgr:GetHeights(x, z, ys, sceneId) end
---@return boolean
---@param orgPos UnityEngine.Vector3
---@param dis number
---@param nextPos UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryGetNextStep(orgPos, dis, nextPos) end
---@return boolean
---@param orgPos UnityEngine.Vector3
---@param desPos UnityEngine.Vector3
---@param path System.Collections.Generic.List_UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryGetPath(orgPos, desPos, path) end
---@return number
---@param orgPos UnityEngine.Vector3
---@param desPos UnityEngine.Vector3
---@param path System.Collections.Generic.List_UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryGetPathNew(orgPos, desPos, path) end
---@return boolean
---@param pos UnityEngine.Vector3
function MoonClient.MNavigationMgr:IsPointBlock(pos) end
---@return number
---@param pos UnityEngine.Vector3
function MoonClient.MNavigationMgr:CalcNextHeight(pos) end
---@return UnityEngine.Vector3
---@param orgPos UnityEngine.Vector3
---@param desPos UnityEngine.Vector3
function MoonClient.MNavigationMgr:CalcNextStep(orgPos, desPos) end
---@return boolean
---@param orgPos UnityEngine.Vector3
---@param radius number
---@param desPos UnityEngine.Vector3
function MoonClient.MNavigationMgr:GetBoundingBoxRadius(orgPos, radius, desPos) end
---@return boolean
---@param rayHead UnityEngine.Vector3
---@param rayTail UnityEngine.Vector3
---@param res UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryRaycastTerrain(rayHead, rayTail, res) end
---@return boolean
---@param rayHead UnityEngine.Vector3
---@param rayTail UnityEngine.Vector3
---@param res UnityEngine.Vector3
function MoonClient.MNavigationMgr:TryRaycastCollider(rayHead, rayTail, res) end
---@return boolean
---@param pos UnityEngine.Vector3
---@param radius number
---@param out UnityEngine.Vector3
function MoonClient.MNavigationMgr:GetBallCollision(pos, radius, out) end
---@return boolean
---@param vv3Step ROGameLibs.SWIGTYPE_p_ROGameLibs__CorridorStep
---@param vv3Path ROGameLibs.Vector3Vector
---@param orgPos UnityEngine.Vector3
---@param desPos UnityEngine.Vector3
---@param dis number
function MoonClient.MNavigationMgr:TryGetPathByUID(vv3Step, vv3Path, orgPos, desPos, dis) end
return MoonClient.MNavigationMgr
