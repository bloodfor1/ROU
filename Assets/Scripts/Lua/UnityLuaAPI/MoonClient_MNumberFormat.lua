---@class MoonClient.MNumberFormat : UnityEngine.MonoBehaviour
---@field public GlobalSwitch boolean
---@field public ReplacementStr string
---@field public NumberFormatStr string
---@field public UseNumberFormatWithRegex boolean

---@type MoonClient.MNumberFormat
MoonClient.MNumberFormat = { }
---@return MoonClient.MNumberFormat
function MoonClient.MNumberFormat.New() end
---@overload fun(source:string): string
---@return string
---@param match System.Text.RegularExpressions.Match
function MoonClient.MNumberFormat.GetMatchEvaluatorResult(match) end
---@overload fun(num:number, formatStr:string): string
---@overload fun(num:int64, formatStr:string): string
---@return string
---@param source string
---@param useRegex boolean
---@param formatStr string
function MoonClient.MNumberFormat.GetNumberFormat(source, useRegex, formatStr) end
---@param newRegex string
function MoonClient.MNumberFormat.ResetNumberFormatExtractRegex(newRegex) end
---@param newRegex string
function MoonClient.MNumberFormat.ResetNumberFormatRegex(newRegex) end
return MoonClient.MNumberFormat
