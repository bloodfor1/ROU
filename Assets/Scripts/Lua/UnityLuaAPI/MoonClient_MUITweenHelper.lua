---@class MoonClient.MUITweenHelper

---@type MoonClient.MUITweenHelper
MoonClient.MUITweenHelper = { }
---@return MoonClient.MUITweenHelper
function MoonClient.MUITweenHelper.New() end
---@param tweenID number
---@param complete boolean
function MoonClient.MUITweenHelper.KillTween(tweenID, complete) end
---@param tweenID number
function MoonClient.MUITweenHelper.KillTweenDeleteCallBack(tweenID) end
---@return number
---@param go UnityEngine.GameObject
---@param fromPos UnityEngine.Vector3
---@param toPos UnityEngine.Vector3
---@param fromAlpha number
---@param toAlpha number
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenPosAlpha(go, fromPos, toPos, fromAlpha, toAlpha, time, onComplete) end
---@return number
---@param tweenId number
---@param go UnityEngine.GameObject
---@param fromPos UnityEngine.Vector3
---@param toPos UnityEngine.Vector3
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.ReTweenPos(tweenId, go, fromPos, toPos, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromPos UnityEngine.Vector3
---@param toPos UnityEngine.Vector3
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenWorldPos(go, fromPos, toPos, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromPos UnityEngine.Vector3
---@param toPos UnityEngine.Vector3
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenPos(go, fromPos, toPos, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromPos UnityEngine.Vector3
---@param toPos UnityEngine.Vector3
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenAnchoredPos(go, fromPos, toPos, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromAlpha number
---@param toAlpha number
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenAlpha(go, fromAlpha, toAlpha, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromWidth number
---@param toWidth number
---@param fromHeight number
---@param toHeight number
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenRectTrans(go, fromWidth, toWidth, fromHeight, toHeight, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromScale UnityEngine.Vector3
---@param toScale UnityEngine.Vector3
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenScale(go, fromScale, toScale, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromRotation UnityEngine.Vector3
---@param toRotation UnityEngine.Vector3
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenRotationByEuler(go, fromRotation, toRotation, time, onComplete) end
---@return number
---@param go UnityEngine.GameObject
---@param fromWidth number
---@param toWidth number
---@param fromHeight number
---@param toHeight number
---@param time number
---@param onComplete (fun():void)
function MoonClient.MUITweenHelper.TweenElementSize(go, fromWidth, toWidth, fromHeight, toHeight, time, onComplete) end
---@return number
---@param rectT UnityEngine.RectTransform
---@param sourceAnchoredPos UnityEngine.Vector2
---@param targetAnchoredPos UnityEngine.Vector2
---@param refAnchoredPos UnityEngine.Vector2
---@param time number
---@param easeType number
---@param callback (fun():void)
function MoonClient.MUITweenHelper.TweenBeziarMoveAnim(rectT, sourceAnchoredPos, targetAnchoredPos, refAnchoredPos, time, easeType, callback) end
---@return number
---@param rectT UnityEngine.RectTransform
---@param sourceAnchoredPos UnityEngine.Vector2
---@param targetAnchoredPos UnityEngine.Vector2
---@param time number
---@param easeType number
---@param callback (fun():void)
function MoonClient.MUITweenHelper.TweenMoveAnim(rectT, sourceAnchoredPos, targetAnchoredPos, time, easeType, callback) end
return MoonClient.MUITweenHelper
