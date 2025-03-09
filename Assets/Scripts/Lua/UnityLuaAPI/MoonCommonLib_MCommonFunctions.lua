---@class MoonCommonLib.MCommonFunctions
---@field public XEps number
---@field public NewId number
---@field public UniqueToken int64

---@type MoonCommonLib.MCommonFunctions
MoonCommonLib.MCommonFunctions = { }
---@return MoonCommonLib.MCommonFunctions
function MoonCommonLib.MCommonFunctions.New() end
---@overload fun(str:System.Text.StringBuilder): number
---@return number
---@param str string
function MoonCommonLib.MCommonFunctions.GetHash(str) end
---@return number
---@param str string
function MoonCommonLib.MCommonFunctions.GetLowerHash(str) end
---@return number
---@param hash number
---@param str string
function MoonCommonLib.MCommonFunctions.GetLowerHashRelpaceDot(hash, str) end
---@overload fun(a:number, b:number): boolean
---@return boolean
---@param a number
---@param b number
function MoonCommonLib.MCommonFunctions.IsEqual(a, b) end
---@overload fun(a:number): boolean
---@return boolean
---@param a number
function MoonCommonLib.MCommonFunctions.IsEqualZero(a) end
---@return boolean
---@param a int64
---@param b int64
function MoonCommonLib.MCommonFunctions.IsLongDataEqual(a, b) end
---@overload fun(a:number, b:number): boolean
---@return boolean
---@param a number
---@param b number
function MoonCommonLib.MCommonFunctions.IsLess(a, b) end
---@overload fun(a:number, b:number): boolean
---@return boolean
---@param a number
---@param b number
function MoonCommonLib.MCommonFunctions.IsGreater(a, b) end
---@overload fun(a:number, b:number): boolean
---@return boolean
---@param a number
---@param b number
function MoonCommonLib.MCommonFunctions.IsEqualLess(a, b) end
---@overload fun(a:number, b:number): boolean
---@return boolean
---@param a number
---@param b number
function MoonCommonLib.MCommonFunctions.IsEqualGreater(a, b) end
---@overload fun(n:number): boolean
---@return boolean
---@param n number
function MoonCommonLib.MCommonFunctions.IsInteger(n) end
---@return number
---@param value number
---@param min number
---@param max number
function MoonCommonLib.MCommonFunctions.Range(value, min, max) end
---@return boolean
---@param obj System.Object
---@param retUint System.UInt32
function MoonCommonLib.MCommonFunctions.TryParseUint(obj, retUint) end
---@return boolean
---@param rectw number
---@param recth number
---@param center UnityEngine.Vector3
---@param radius number
function MoonCommonLib.MCommonFunctions.IsRectCycleCross(rectw, recth, center, radius) end
---@return boolean
---@param begin UnityEngine.Vector2
---@param ed UnityEngine.Vector2
---@param center UnityEngine.Vector2
---@param radius number
---@param t System.Single
function MoonCommonLib.MCommonFunctions.Intersection(begin, ed, center, radius, t) end
---@return boolean
---@param p1 UnityEngine.Vector3
---@param p2 UnityEngine.Vector3
---@param q1 UnityEngine.Vector3
---@param q2 UnityEngine.Vector3
function MoonCommonLib.MCommonFunctions.IsLineSegmentCross(p1, p2, q1, q2) end
---@return UnityEngine.Vector3
---@param v UnityEngine.Vector3
function MoonCommonLib.MCommonFunctions.Horizontal(v) end
---@return UnityEngine.Vector3
---@param v UnityEngine.Vector3
function MoonCommonLib.MCommonFunctions.HorizontalNormal(v) end
---@return number
---@param basic number
---@param degree number
function MoonCommonLib.MCommonFunctions.AngleNormalize(basic, degree) end
---@return UnityEngine.Vector2
---@param v UnityEngine.Vector2
---@param degree number
---@param normalized boolean
function MoonCommonLib.MCommonFunctions.HorizontalRotateVetor2(v, degree, normalized) end
---@return UnityEngine.Vector3
---@param v UnityEngine.Vector3
---@param degree number
---@param normalized boolean
function MoonCommonLib.MCommonFunctions.HorizontalRotateVetor3(v, degree, normalized) end
---@return number
---@param tick int64
function MoonCommonLib.MCommonFunctions.TicksToSeconds(tick) end
---@return int64
---@param time number
function MoonCommonLib.MCommonFunctions.SecondsToTicks(time) end
---@return number
---@param dir UnityEngine.Vector3
function MoonCommonLib.MCommonFunctions.AngleToFloat(dir) end
---@return number
---@param from UnityEngine.Vector3
---@param to UnityEngine.Vector3
function MoonCommonLib.MCommonFunctions.AngleWithSign(from, to) end
---@return UnityEngine.Vector3
---@param angle number
function MoonCommonLib.MCommonFunctions.FloatToAngle(angle) end
---@return UnityEngine.Quaternion
---@param v UnityEngine.Vector3
function MoonCommonLib.MCommonFunctions.VectorToQuaternion(v) end
---@return UnityEngine.Quaternion
---@param angle number
function MoonCommonLib.MCommonFunctions.FloatToQuaternion(angle) end
---@return UnityEngine.Quaternion
---@param pos UnityEngine.Vector3
---@param forward UnityEngine.Vector3
function MoonCommonLib.MCommonFunctions.RotateToGround(pos, forward) end
---@overload fun(fiduciary:UnityEngine.Vector3, relativity:UnityEngine.Vector3): boolean
---@return boolean
---@param fiduciary UnityEngine.Vector2
---@param relativity UnityEngine.Vector2
function MoonCommonLib.MCommonFunctions.Clockwise(fiduciary, relativity) end
---@return boolean
---@param point UnityEngine.Vector3
---@param halfScale UnityEngine.Vector3
---@param center UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
function MoonCommonLib.MCommonFunctions.IsInRect(point, halfScale, center, rotation) end
---@return boolean
---@param point UnityEngine.Vector3
---@param center UnityEngine.Vector3
---@param halfScale UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
function MoonCommonLib.MCommonFunctions.IsInRect3D(point, center, halfScale, rotation) end
---@return boolean
---@param point UnityEngine.Vector3
---@param rect UnityEngine.Rect
---@param center UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
function MoonCommonLib.MCommonFunctions.IsInRectIncludeBorder(point, rect, center, rotation) end
---@return boolean
---@param point UnityEngine.Vector3
---@param scale UnityEngine.Vector3
---@param center UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
function MoonCommonLib.MCommonFunctions.IsInEllipse(point, scale, center, rotation) end
---@return boolean
---@param point UnityEngine.Vector3
---@param scale UnityEngine.Vector3
---@param center UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
function MoonCommonLib.MCommonFunctions.IsInCircle(point, scale, center, rotation) end
---@return UnityEngine.Transform
---@param t UnityEngine.Transform
---@param name string
function MoonCommonLib.MCommonFunctions.FindChildRecursively(t, name) end
---@param t UnityEngine.Transform
---@param layer number
function MoonCommonLib.MCommonFunctions.SetLayerRecursive(t, layer) end
---@return System.String[]
---@param str string
---@param separatorStr string
function MoonCommonLib.MCommonFunctions.StringSplit(str, separatorStr) end
---@return System.Net.IPAddress
---@param hostName string
function MoonCommonLib.MCommonFunctions.GetIpAddrByHostName(hostName) end
---@return string
---@param domain string
function MoonCommonLib.MCommonFunctions.GetIpByHttpDns(domain) end
---@return string
---@param source string
function MoonCommonLib.MCommonFunctions.EncryptWithMD5(source) end
---@param copyValue string
function MoonCommonLib.MCommonFunctions.CopyToClipboard(copyValue) end
---@return string
function MoonCommonLib.MCommonFunctions.GetUtcNowTimeStamp() end
return MoonCommonLib.MCommonFunctions
