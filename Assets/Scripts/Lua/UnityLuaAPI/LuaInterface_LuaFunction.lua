---@class LuaInterface.LuaFunction : LuaInterface.LuaBaseRef

---@type LuaInterface.LuaFunction
LuaInterface.LuaFunction = { }
---@return (fun():void)
---@param reference number
---@param state LuaInterface.LuaState
function LuaInterface.LuaFunction.New(reference, state) end
function LuaInterface.LuaFunction:Dispose() end
---@return number
function LuaInterface.LuaFunction:BeginPCall() end
function LuaInterface.LuaFunction:PCall() end
function LuaInterface.LuaFunction:EndPCall() end
function LuaInterface.LuaFunction:Call() end
---@return System.Object[]
---@param args System.Object[]
function LuaInterface.LuaFunction:LazyCall(args) end
---@return System.Object
---@param tb table
---@param args System.Object[]
function LuaInterface.LuaFunction:CustomCall(tb, args) end
---@param args number
function LuaInterface.LuaFunction:CheckStack(args) end
---@return boolean
function LuaInterface.LuaFunction:IsBegin() end
---@overload fun(num:number): void
---@overload fun(hit:UnityEngine.RaycastHit): void
---@overload fun(bounds:UnityEngine.Bounds): void
---@overload fun(ray:UnityEngine.Ray): void
---@overload fun(clr:UnityEngine.Color): void
---@overload fun(quat:UnityEngine.Quaternion): void
---@overload fun(v4:UnityEngine.Vector4): void
---@overload fun(v2:UnityEngine.Vector2): void
---@overload fun(v3:UnityEngine.Vector3): void
---@overload fun(array:System.Array): void
---@overload fun(t:UnityEngine.Touch): void
---@overload fun(e:System.Enum): void
---@overload fun(o:UnityEngine.Object): void
---@overload fun(o:System.Object): void
---@overload fun(lbr:LuaInterface.LuaBaseRef): void
---@overload fun(ptr:number): void
---@overload fun(b:boolean): void
---@overload fun(un:uint64): void
---@overload fun(num:int64): void
---@overload fun(un:number): void
---@overload fun(n:number): void
---@overload fun(t:string): void
---@param buffer LuaInterface.LuaByteBuffer
function LuaInterface.LuaFunction:Push(buffer) end
---@param n UnityEngine.LayerMask
function LuaInterface.LuaFunction:PushLayerMask(n) end
---@param o System.Object
function LuaInterface.LuaFunction:PushObject(o) end
---@param args System.Object[]
function LuaInterface.LuaFunction:CustomPushArgs(args) end
---@param args System.Object[]
function LuaInterface.LuaFunction:PushArgs(args) end
---@param buffer System.Byte[]
---@param len number
function LuaInterface.LuaFunction:PushByteBuffer(buffer, len) end
---@return number
function LuaInterface.LuaFunction:CheckNumber() end
---@return boolean
function LuaInterface.LuaFunction:CheckBoolean() end
---@return string
function LuaInterface.LuaFunction:CheckString() end
---@return UnityEngine.Vector3
function LuaInterface.LuaFunction:CheckVector3() end
---@return UnityEngine.Quaternion
function LuaInterface.LuaFunction:CheckQuaternion() end
---@return UnityEngine.Vector2
function LuaInterface.LuaFunction:CheckVector2() end
---@return UnityEngine.Vector4
function LuaInterface.LuaFunction:CheckVector4() end
---@return UnityEngine.Color
function LuaInterface.LuaFunction:CheckColor() end
---@return UnityEngine.Ray
function LuaInterface.LuaFunction:CheckRay() end
---@return UnityEngine.Bounds
function LuaInterface.LuaFunction:CheckBounds() end
---@return UnityEngine.LayerMask
function LuaInterface.LuaFunction:CheckLayerMask() end
---@return int64
function LuaInterface.LuaFunction:CheckLong() end
---@return uint64
function LuaInterface.LuaFunction:CheckULong() end
---@return System.Delegate
function LuaInterface.LuaFunction:CheckDelegate() end
---@return System.Object
function LuaInterface.LuaFunction:CheckVariant() end
---@return System.Char[]
function LuaInterface.LuaFunction:CheckCharBuffer() end
---@return System.Byte[]
function LuaInterface.LuaFunction:CheckByteBuffer() end
---@return System.Object
---@param t string
function LuaInterface.LuaFunction:CheckObject(t) end
---@return (fun():void)
function LuaInterface.LuaFunction:CheckLuaFunction() end
---@return table
function LuaInterface.LuaFunction:CheckLuaTable() end
---@return LuaInterface.LuaThread
function LuaInterface.LuaFunction:CheckLuaThread() end
return LuaInterface.LuaFunction
