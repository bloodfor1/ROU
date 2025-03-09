---@class ROGameLibs.LongSequence

---@type ROGameLibs.LongSequence
ROGameLibs.LongSequence = { }
---@overload fun(): ROGameLibs.LongSequence
---@overload fun(n:number): ROGameLibs.LongSequence
---@overload fun(seq:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_long_long_t): ROGameLibs.LongSequence
---@return ROGameLibs.LongSequence
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.LongSequence.New(cPtr, cMemoryOwn) end
function ROGameLibs.LongSequence:ReturnPool() end
---@return ROGameLibs.LongSequence
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.LongSequence.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.LongSequence.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.LongSequence:getPtr() end
function ROGameLibs.LongSequence:Dispose() end
---@return int64
---@param i number
function ROGameLibs.LongSequence:GetItem(i) end
---@return number
function ROGameLibs.LongSequence:Size() end
---@return MoonCommonLib.MSeq_System.Int64
function ROGameLibs.LongSequence:SequenceToMSeq() end
return ROGameLibs.LongSequence
