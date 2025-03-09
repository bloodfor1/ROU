---@class MoonCommonLib.MLuaCommonHelper

---@type MoonCommonLib.MLuaCommonHelper
MoonCommonLib.MLuaCommonHelper = { }
---@return string
---@param classname string
function MoonCommonLib.MLuaCommonHelper.GetType(classname) end
---@overload fun(className:string): UnityEngine.Component
---@return UnityEngine.Component
---@param className string
function MoonCommonLib.MLuaCommonHelper:GetComp(className) end
---@return number
---@param o System.Object
function MoonCommonLib.MLuaCommonHelper.Int(o) end
---@return number
---@param o System.Object
function MoonCommonLib.MLuaCommonHelper.Float(o) end
---@return uint64
---@param o System.Object
function MoonCommonLib.MLuaCommonHelper.ULong(o) end
---@return int64
---@param o System.Object
function MoonCommonLib.MLuaCommonHelper.Long(o) end
---@return int64
---@param x int64
---@param y int64
function MoonCommonLib.MLuaCommonHelper.MaxLong(x, y) end
---@return int64
---@param x int64
---@param y int64
function MoonCommonLib.MLuaCommonHelper.MinLong(x, y) end
---@overload fun(value:int64): number
---@return number
---@param value uint64
function MoonCommonLib.MLuaCommonHelper.Long2Int(value) end
---@return int64
---@param value int64
function MoonCommonLib.MLuaCommonHelper.AbsLong(value) end
---@overload fun(min:number, max:number): number
---@return number
---@param min number
---@param max number
function MoonCommonLib.MLuaCommonHelper.Random(min, max) end
---@return string
---@param num number
function MoonCommonLib.MLuaCommonHelper.GetBinaryString(num) end
---@param str string
function MoonCommonLib.MLuaCommonHelper.Log(str) end
---@param str string
function MoonCommonLib.MLuaCommonHelper.LogGreen(str) end
---@param str string
function MoonCommonLib.MLuaCommonHelper.LogYellow(str) end
---@param str string
function MoonCommonLib.MLuaCommonHelper.LogRed(str) end
---@param str string
function MoonCommonLib.MLuaCommonHelper.LogWarning(str) end
---@param str string
function MoonCommonLib.MLuaCommonHelper.LogError(str) end
---@return number
---@param a number
---@param b uint64
function MoonCommonLib.MLuaCommonHelper.UIntCompareULong(a, b) end
---@param isActive boolean
function MoonCommonLib.MLuaCommonHelper:SetActiveEx(isActive) end
---@return UnityEngine.GameObject
---@param go UnityEngine.GameObject
function MoonCommonLib.MLuaCommonHelper.GetLastActiveGo(go) end
---@overload fun(pos:UnityEngine.Vector3): void
---@overload fun(pos:UnityEngine.Vector3): void
---@overload fun(x:number, y:number, z:number): void
---@param x number
---@param y number
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetPos(x, y, z) end
---@overload fun(x:number): void
---@param x number
function MoonCommonLib.MLuaCommonHelper:SetPosX(x) end
---@overload fun(y:number): void
---@param y number
function MoonCommonLib.MLuaCommonHelper:SetPosY(y) end
---@overload fun(z:number): void
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetPosZ(z) end
---@overload fun(): void
function MoonCommonLib.MLuaCommonHelper:SetPosZero() end
---@overload fun(other:UnityEngine.GameObject): void
---@overload fun(other:UnityEngine.Transform): void
---@overload fun(other:UnityEngine.GameObject): void
---@param other UnityEngine.Transform
function MoonCommonLib.MLuaCommonHelper:SetPosToOther(other) end
---@overload fun(pos:UnityEngine.Vector3): void
---@overload fun(pos:UnityEngine.Vector3): void
---@overload fun(x:number, y:number, z:number): void
---@param x number
---@param y number
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetLocalPos(x, y, z) end
---@overload fun(x:number): void
---@param x number
function MoonCommonLib.MLuaCommonHelper:SetLocalPosX(x) end
---@overload fun(y:number): void
---@param y number
function MoonCommonLib.MLuaCommonHelper:SetLocalPosY(y) end
---@overload fun(z:number): void
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetLocalPosZ(z) end
---@overload fun(): void
function MoonCommonLib.MLuaCommonHelper:SetLocalPosZero() end
---@overload fun(other:UnityEngine.GameObject): void
---@overload fun(other:UnityEngine.Transform): void
---@overload fun(other:UnityEngine.GameObject): void
---@param other UnityEngine.Transform
function MoonCommonLib.MLuaCommonHelper:SetLocalPosToOther(other) end
---@overload fun(x:number, y:number, z:number): void
---@param x number
---@param y number
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetLocalScale(x, y, z) end
---@overload fun(x:number): void
---@param x number
function MoonCommonLib.MLuaCommonHelper:SetLocalScaleX(x) end
---@overload fun(y:number): void
---@param y number
function MoonCommonLib.MLuaCommonHelper:SetLocalScaleY(y) end
---@overload fun(z:number): void
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetLocalScaleZ(z) end
---@overload fun(): void
function MoonCommonLib.MLuaCommonHelper:SetLocalScaleOne() end
---@overload fun(other:UnityEngine.GameObject): void
---@overload fun(other:UnityEngine.Transform): void
---@overload fun(other:UnityEngine.GameObject): void
---@param other UnityEngine.Transform
function MoonCommonLib.MLuaCommonHelper:SetLocalScaleToOther(other) end
---@param times number
function MoonCommonLib.MLuaCommonHelper:SetLocalScaleDouble(times) end
---@overload fun(x:number, y:number, z:number, w:number): void
---@param x number
---@param y number
---@param z number
---@param w number
function MoonCommonLib.MLuaCommonHelper:SetRot(x, y, z, w) end
---@overload fun(x:number, y:number, z:number, w:number): void
---@param x number
---@param y number
---@param z number
---@param w number
function MoonCommonLib.MLuaCommonHelper:SetLocalRot(x, y, z, w) end
---@overload fun(x:number, y:number, z:number): void
---@param x number
---@param y number
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetRotEuler(x, y, z) end
---@overload fun(x:number): void
---@param x number
function MoonCommonLib.MLuaCommonHelper:SetRotEulerX(x) end
---@overload fun(y:number): void
---@param y number
function MoonCommonLib.MLuaCommonHelper:SetRotEulerY(y) end
---@overload fun(z:number): void
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetRotEulerZ(z) end
---@overload fun(): void
function MoonCommonLib.MLuaCommonHelper:SetRotEulerZero() end
---@overload fun(other:UnityEngine.GameObject): void
---@overload fun(other:UnityEngine.Transform): void
---@overload fun(other:UnityEngine.GameObject): void
---@param other UnityEngine.Transform
function MoonCommonLib.MLuaCommonHelper:SetRotEulerToOther(other) end
---@overload fun(x:number, y:number, z:number): void
---@param x number
---@param y number
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetLocalRotEuler(x, y, z) end
---@overload fun(x:number): void
---@param x number
function MoonCommonLib.MLuaCommonHelper:SetLocalRotEulerX(x) end
---@overload fun(y:number): void
---@param y number
function MoonCommonLib.MLuaCommonHelper:SetLocalRotEulerY(y) end
---@overload fun(z:number): void
---@param z number
function MoonCommonLib.MLuaCommonHelper:SetLocalRotEulerZ(z) end
---@overload fun(): void
function MoonCommonLib.MLuaCommonHelper:SetLocalRotEulerZero() end
---@overload fun(other:UnityEngine.GameObject): void
---@overload fun(other:UnityEngine.Transform): void
---@overload fun(other:UnityEngine.GameObject): void
---@param other UnityEngine.Transform
function MoonCommonLib.MLuaCommonHelper:SetLocalRotEulerToOther(other) end
---@return UnityEngine.Vector2
---@param canvas UnityEngine.Canvas
function MoonCommonLib.MLuaCommonHelper:TransformToCanvasLocalPosition(canvas) end
---@param x number
---@param y number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformPos(x, y) end
---@return UnityEngine.Vector2
---@param localPos UnityEngine.Vector3
---@param targetCamera UnityEngine.Camera
---@param trans UnityEngine.Transform
function MoonCommonLib.MLuaCommonHelper.LocalPositionToScreenPos(localPos, targetCamera, trans) end
---@param screenPosition UnityEngine.Vector2
---@param targetCamera UnityEngine.Camera
---@param targetRectTransform UnityEngine.RectTransform
function MoonCommonLib.MLuaCommonHelper.SetRectTransformPosBySceenPos(screenPosition, targetCamera, targetRectTransform) end
---@param x number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformPosX(x) end
---@param width number
---@param height number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformSize(width, height) end
---@param width number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformWidth(width) end
---@param height number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformHeight(height) end
---@param y number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformPosY(y) end
---@param xMin number
---@param xMax number
---@param yMin number
---@param yMax number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformOffset(xMin, xMax, yMin, yMax) end
---@param anchorMinX number
---@param anchorMinY number
---@param anchorMaxX number
---@param anchorMaxY number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformAnchor(anchorMinX, anchorMinY, anchorMaxX, anchorMaxY) end
---@param pivotX number
---@param pivotY number
function MoonCommonLib.MLuaCommonHelper:SetRectTransformPivot(pivotX, pivotY) end
---@return number
---@param a UnityEngine.Vector3
---@param b UnityEngine.Vector3
function MoonCommonLib.MLuaCommonHelper.GetDistance(a, b) end
---@return number
---@param a UnityEngine.Vector2
---@param b UnityEngine.Vector2
function MoonCommonLib.MLuaCommonHelper.GetDistance2D(a, b) end
---@return number
---@param a UnityEngine.Vector2
---@param b UnityEngine.Vector2
function MoonCommonLib.MLuaCommonHelper.GetAngle2D(a, b) end
---@param go UnityEngine.GameObject
---@param parent UnityEngine.GameObject
---@param worldPositionStays boolean
function MoonCommonLib.MLuaCommonHelper.SetParent(go, parent, worldPositionStays) end
---@return number
---@param transform UnityEngine.Transform
function MoonCommonLib.MLuaCommonHelper.GetTransformActiveIndex(transform) end
---@return boolean
---@param objectA System.Object
function MoonCommonLib.MLuaCommonHelper.IsNull(objectA) end
---@return boolean
---@param data string
---@param value string
function MoonCommonLib.MLuaCommonHelper.IsStringContain(data, value) end
---@param target UnityEngine.GameObject
---@param horizontal boolean
function MoonCommonLib.MLuaCommonHelper.ForceUpdateContentSizeFitter(target, horizontal) end
---@return string
---@param str string
---@param args System.String[]
function MoonCommonLib.MLuaCommonHelper.Format(str, args) end
---@return number
---@param enum System.Enum
function MoonCommonLib.MLuaCommonHelper.Enum2Int(enum) end
---@param target UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonCommonLib.MLuaCommonHelper.ExecuteBeginDragEvent(target, eventData) end
---@param target UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonCommonLib.MLuaCommonHelper.ExecuteDragEvent(target, eventData) end
---@param target UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonCommonLib.MLuaCommonHelper.ExecuteEndDragEvent(target, eventData) end
---@param target UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonCommonLib.MLuaCommonHelper.ExecuteClickEvent(target, eventData) end
---@return boolean
---@param luaFileName string
function MoonCommonLib.MLuaCommonHelper.CheckLuaExists(luaFileName) end
---@return string
---@param method (fun():string)
function MoonCommonLib.MLuaCommonHelper.CallResultStringFunc(method) end
---@return System.String[]
---@param originStr string
function MoonCommonLib.MLuaCommonHelper.GetHrefStr(originStr) end
return MoonCommonLib.MLuaCommonHelper
