---@class ExtensionByQX.StringHelper

---@type ExtensionByQX.StringHelper
ExtensionByQX.StringHelper = { }
---@param source System.Text.StringBuilder
---@param data System.String[]
function ExtensionByQX.StringHelper.StringBuilderAppend(source, data) end
---@return boolean
---@param data string
---@param value string
function ExtensionByQX.StringHelper.StartsWith(data, value) end
---@return boolean
---@param data string
---@param value string
function ExtensionByQX.StringHelper.EndsWith(data, value) end
---@return number
---@param data string
---@param containee number
function ExtensionByQX.StringHelper.GetCharCountInString(data, containee) end
---@overload fun(data:string, values:System.String[]): number
---@overload fun(data:string, value:string): number
---@overload fun(data:string, value:number): number
---@overload fun(data:string, startIndex:number, values:System.String[]): number
---@overload fun(data:string, startIndex:number, value:string): number
---@return number
---@param data string
---@param startIndex number
---@param value number
function ExtensionByQX.StringHelper.SafeGetIndex(data, startIndex, value) end
---@return System.Collections.Generic.List_System.Int32
---@param data string
---@param startIndex number
---@param endIndex number
---@param value string
function ExtensionByQX.StringHelper.SafeGetIndexs(data, startIndex, endIndex, value) end
---@return string
---@param data string
---@param startIndex number
---@param value string
function ExtensionByQX.StringHelper.SafeInsert(data, startIndex, value) end
---@return string
---@param data string
---@param startValue string
---@param insertValue string
function ExtensionByQX.StringHelper.InsertWithStartValue(data, startValue, insertValue) end
---@return number
---@param data string
---@param startIndex number
---@param pair1 number
---@param pair2 number
function ExtensionByQX.StringHelper.GetIndexWithCharPair(data, startIndex, pair1, pair2) end
---@return number
---@param data string
---@param value number
function ExtensionByQX.StringHelper.GetIndex(data, value) end
---@return string
---@param data string
---@param maxPerLine number
---@param truncateString System.String[]
function ExtensionByQX.StringHelper.StringLinefeed(data, maxPerLine, truncateString) end
return ExtensionByQX.StringHelper
