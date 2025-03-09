---@class MoonCommonLib.StringEx
---@field public Spriter1 number
---@field public Spriter2 number
---@field public FBracket1 number
---@field public BBracket1 number
---@field public convertableTypes System.Collections.Generic.List_System.Type

---@type MoonCommonLib.StringEx
MoonCommonLib.StringEx = { }
---@return System.Object
---@param t string
function MoonCommonLib.StringEx:GetValue(t) end
---@overload fun(t:string, defultValue:System.Object): System.Object
---@return System.Object
---@param t string
---@param result System.Object
---@param defaultValue System.Object
function MoonCommonLib.StringEx:TryGetValue(t, result, defaultValue) end
---@return boolean
---@param _inputString string
---@param result UnityEngine.Color
---@param colorSpriter number
function MoonCommonLib.StringEx.ParseColor(_inputString, result, colorSpriter) end
---@return System.Collections.Generic.List_System.String
---@param listSpriter number
function MoonCommonLib.StringEx:ParseList(listSpriter) end
---@return System.Collections.Generic.Dictionary_System.String_System.String
---@param keyValueSpriter number
---@param mapSpriter number
function MoonCommonLib.StringEx:ParseMap(keyValueSpriter, mapSpriter) end
---@return boolean
---@param _inputString string
---@param result UnityEngine.Vector4
---@param vectorSpriter number
function MoonCommonLib.StringEx.ParseVector4(_inputString, result, vectorSpriter) end
---@return boolean
---@param _inputString string
---@param result UnityEngine.Quaternion
---@param spriter number
function MoonCommonLib.StringEx.ParseQuaternion(_inputString, result, spriter) end
---@return boolean
---@param _inputString string
---@param result UnityEngine.Vector3
---@param spriter number
function MoonCommonLib.StringEx.ParseVector3(_inputString, result, spriter) end
---@return boolean
---@param _inputString string
---@param result UnityEngine.Vector2
---@param spriter number
function MoonCommonLib.StringEx.ParseVector2(_inputString, result, spriter) end
---@return System.Object
---@param str string
---@param t string
function MoonCommonLib.StringEx.ParseFromStringableObject(str, t) end
---@return number
function MoonCommonLib.StringEx:GetRandom() end
---@return string
---@param format string
function MoonCommonLib.StringEx:ConverToString(format) end
---@return string
---@param value UnityEngine.Vector2
function MoonCommonLib.StringEx.Vector2ToString(value) end
---@return string
---@param value UnityEngine.Vector3
function MoonCommonLib.StringEx.Vector3ToString(value) end
---@return string
---@param value UnityEngine.Vector4
function MoonCommonLib.StringEx.Vector4ToString(value) end
---@return string
---@param value UnityEngine.Color
function MoonCommonLib.StringEx.ColorToString(value) end
---@return string
---@param value UnityEngine.Quaternion
function MoonCommonLib.StringEx.QuaternionToString(value) end
---@return string
---@param split1 number
function MoonCommonLib.StringEx:ArrConvertToString(split1) end
---@return string
---@param t string
function MoonCommonLib.StringEx:ToStringableObjectConvertToString(t) end
---@return string
function MoonCommonLib.StringEx:GetTypeByString() end
---@return boolean
function MoonCommonLib.StringEx:IsConvertableType() end
---@return boolean
function MoonCommonLib.StringEx:CanConvertFromString() end
---@return boolean
function MoonCommonLib.StringEx:CanConvertToString() end
---@return string
---@param oldValue string
---@param newValue string
---@param startAt number
function MoonCommonLib.StringEx:ReplaceFirst(oldValue, newValue, startAt) end
---@return boolean
function MoonCommonLib.StringEx:HasChinese() end
---@return boolean
function MoonCommonLib.StringEx:HasSpace() end
---@return boolean
function MoonCommonLib.StringEx:IsNullOrEmptyR() end
---@return string
---@param targets System.String[]
function MoonCommonLib.StringEx:RemoveString(targets) end
---@return System.String[]
---@param separator System.Char[]
function MoonCommonLib.StringEx:SplitAndTrim(separator) end
---@return string
function MoonCommonLib.StringEx:DeleteEmoji() end
---@return string
function MoonCommonLib.StringEx:DeleteRichText() end
---@return string
---@param front string
---@param behined string
function MoonCommonLib.StringEx:FindBetween(front, behined) end
---@return string
---@param front string
function MoonCommonLib.StringEx:FindAfter(front) end
---@overload fun(str:string, args:System.String[]): string
---@return string
---@param str string
---@param args System.Object[]
function MoonCommonLib.StringEx.Format(str, args) end
---@return string
---@param str string
---@param startIndex number
---@param length number
function MoonCommonLib.StringEx.SubString(str, startIndex, length) end
---@return number
---@param str string
function MoonCommonLib.StringEx.Length(str) end
---@return string
function MoonCommonLib.StringEx.GetDateString() end
---@param value string
function MoonCommonLib.StringEx.PrintBadChar(value) end
---@return boolean
---@param v1 string
---@param v2 string
function MoonCommonLib.StringEx.StringEquals(v1, v2) end
---@return string
---@param value string
function MoonCommonLib.StringEx.StringTrim(value) end
---@return string
---@param value string
function MoonCommonLib.StringEx.ReplaceSpace(value) end
---@return string
---@param source string
function MoonCommonLib.StringEx.ReplaceLuaFormatToCSFormat(source) end
---@return boolean
---@param str string
function MoonCommonLib.StringEx.IsInt(str) end
---@return boolean
---@param str string
function MoonCommonLib.StringEx.IsFloat(str) end
---@return string
---@param scheme number
function MoonCommonLib.StringEx:ReplaceColorName2ColorHex(scheme) end
return MoonCommonLib.StringEx
