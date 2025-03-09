---@class ROGameLibs.DoubleSequence

---@type ROGameLibs.DoubleSequence
ROGameLibs.DoubleSequence = { }
---@overload fun(): ROGameLibs.DoubleSequence
---@overload fun(n:number): ROGameLibs.DoubleSequence
---@overload fun(seq:ROGameLibs.SWIGTYPE_p_TableLib__SequenceT_double_t): ROGameLibs.DoubleSequence
---@return ROGameLibs.DoubleSequence
---@param cPtr number
---@param cMemoryOwn boolean
function ROGameLibs.DoubleSequence.New(cPtr, cMemoryOwn) end
function ROGameLibs.DoubleSequence:ReturnPool() end
---@return ROGameLibs.DoubleSequence
---@param swigCPtr System.Runtime.InteropServices.HandleRef
---@param cMemoryOwn boolean
function ROGameLibs.DoubleSequence.GetFromPool(swigCPtr, cMemoryOwn) end
function ROGameLibs.DoubleSequence.ClearPool() end
---@return System.Runtime.InteropServices.HandleRef
function ROGameLibs.DoubleSequence:getPtr() end
function ROGameLibs.DoubleSequence:Dispose() end
---@return number
---@param i number
function ROGameLibs.DoubleSequence:GetItem(i) end
---@return number
function ROGameLibs.DoubleSequence:Size() end
---@return MoonCommonLib.MSeq_System.Double
function ROGameLibs.DoubleSequence:SequenceToMSeq() end
return ROGameLibs.DoubleSequence
