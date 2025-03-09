---@class MoonClient.MTableAnalysis
---@field public SequenceSeparator System.Char[]
---@field public ListSeparator System.Char[]
---@field public AllSeparators System.Char[]

---@type MoonClient.MTableAnalysis
MoonClient.MTableAnalysis = { }
---@return System.String[]
---@param data string
---@param separator System.Char[]
function MoonClient.MTableAnalysis.AnalysisTable(data, separator) end
---@return System.Int32[]
---@param data string
---@param separator System.Char[]
function MoonClient.MTableAnalysis.AnalysisTableToInt(data, separator) end
---@return System.Single[]
---@param data string
---@param separator System.Char[]
function MoonClient.MTableAnalysis.AnalysisTableToFloat(data, separator) end
---@return System.String_Array[]
---@param data string
function MoonClient.MTableAnalysis.GetVectorSequence(data) end
---@return System.Int32[]
---@param data string
function MoonClient.MTableAnalysis.GetSequenceOrVectorInt(data) end
---@return System.Single[]
---@param data string
function MoonClient.MTableAnalysis.GetSequenceOrVectorFloat(data) end
return MoonClient.MTableAnalysis
