---@class MoonClient.MCameraHelper

---@type MoonClient.MCameraHelper
MoonClient.MCameraHelper = { }
---@return boolean
---@param cam MoonClient.MCamera
---@param cameraPos UnityEngine.Vector3
---@param targetPos UnityEngine.Vector3
---@param fov number
---@param targetOffset UnityEngine.Vector3
function MoonClient.MCameraHelper.CameraLookAtTarget(cam, cameraPos, targetPos, fov, targetOffset) end
---@return UnityEngine.Vector3
---@param rotX number
---@param rotY number
---@param dis number
---@param look UnityEngine.Vector3
---@param canBeNegativeDis boolean
function MoonClient.MCameraHelper.CntPos(rotX, rotY, dis, look, canBeNegativeDis) end
---@return boolean
---@param pos UnityEngine.Vector3
---@param dis System.Single
function MoonClient.MCameraHelper.TryGetTerDis(pos, dis) end
---@return number
---@param rotX number
---@param rotY number
---@param dis number
---@param look UnityEngine.Vector3
---@param downSpeed number
---@param maxRotY number
---@param originRotY number
function MoonClient.MCameraHelper.AdjustRotY(rotX, rotY, dis, look, downSpeed, maxRotY, originRotY) end
---@return number
---@param degree number
function MoonClient.MCameraHelper.NormalizeDegree(degree) end
---@return number
---@param src number
---@param dest number
---@param delta number
---@param bAngle boolean
function MoonClient.MCameraHelper.UniformCloseUpAngle(src, dest, delta, bAngle) end
---@return number
---@param src number
---@param dest number
---@param delta number
---@param bAngle boolean
function MoonClient.MCameraHelper.CloseUp(src, dest, delta, bAngle) end
---@param hostCam MoonClient.MCamera
---@param deltaDis number
---@param deltaRotX number
---@param deltaRotY number
---@param minDis number
---@param maxDis number
function MoonClient.MCameraHelper.Slow(hostCam, deltaDis, deltaRotX, deltaRotY, minDis, maxDis) end
---@param hostCam MoonClient.MCamera
---@param deltaDis number
---@param deltaRotX number
---@param deltaRotY number
---@param minDis number
---@param maxDis number
function MoonClient.MCameraHelper.BackTrackSlow(hostCam, deltaDis, deltaRotX, deltaRotY, minDis, maxDis) end
---@param hostCam MoonClient.MCamera
function MoonClient.MCameraHelper.StopMove(hostCam) end
---@param cameraObj MoonClient.MSceneObject
function MoonClient.MCameraHelper.SetCountDownCamera(cameraObj) end
---@param image UnityEngine.UI.RawImage
function MoonClient.MCameraHelper.CaptureCamera(image) end
---@param image UnityEngine.UI.RawImage
function MoonClient.MCameraHelper.ClearCapture(image) end
return MoonClient.MCameraHelper
